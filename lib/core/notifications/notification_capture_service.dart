import 'dart:async';

import 'package:fluxa/core/brands/expense_brand_signal.dart';
import 'package:fluxa/models/expense_draft.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class NotificationCaptureService {
  NotificationCaptureService();

  static const _channel = MethodChannel('fluxa/notification_capture');
  static const _events = EventChannel('fluxa/notification_capture/events');

  bool get isSupported => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  Stream<CapturedExpenseSuggestion> get suggestions {
    if (!isSupported) {
      return const Stream.empty();
    }

    return _events.receiveBroadcastStream().asyncExpand((payload) async* {
      final suggestion = _parsePayload(payload);
      if (suggestion != null) {
        yield suggestion;
      }
    });
  }

  Future<bool> isEnabled() async {
    if (!isSupported) {
      return false;
    }

    try {
      return await _channel.invokeMethod<bool>('isEnabled') ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  Future<void> openSettings() async {
    if (!isSupported) {
      return;
    }

    try {
      await _channel.invokeMethod<void>('openSettings');
    } on PlatformException {
      return;
    } on MissingPluginException {
      return;
    }
  }

  Future<CapturedExpenseSuggestion?> getLastSuggestion() async {
    if (!isSupported) {
      return null;
    }

    try {
      final payload = await _channel.invokeMethod<Object?>('getLastNotification');
      return _parsePayload(payload);
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }

  CapturedExpenseSuggestion? _parsePayload(Object? payload) {
    if (payload is! Map) {
      return null;
    }

    final raw = BankNotificationPayload.fromMap(payload);
    final text = raw.combinedText;
    final amount = _parseAmount(text);
    if (amount == null || amount <= 0 || _looksLikeIncomingMoney(text)) {
      return null;
    }

    final title = _parseMerchant(text, raw);
    final category = _inferCategory(text);
    final brand = ExpenseBrandCatalog.resolve(
      text: text,
      appName: raw.appName,
      packageName: raw.packageName,
    );
    final source = raw.appName.trim().isEmpty ? brand.label : raw.appName.trim();

    return CapturedExpenseSuggestion(
      id: raw.id,
      title: title,
      amount: amount,
      category: category,
      sourceLabel: source,
      brand: brand,
      description: '$title • $source',
      occurredAt: raw.postTime == null
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(raw.postTime!),
      rawText: text,
    );
  }

  double? _parseAmount(String text) {
    final match = RegExp(
      r'(?:R\$\s?|RS\$?\s?|BRL\s?)(\d[\d.]*)[,](\d{2})',
      caseSensitive: false,
    ).firstMatch(text);
    if (match == null) {
      return null;
    }

    final normalized = '${match.group(1)!.replaceAll('.', '')}.${match.group(2)}';
    return double.tryParse(normalized);
  }

  bool _looksLikeIncomingMoney(String text) {
    final normalized = text.toLowerCase();
    return [
      'recebeu',
      'recebido',
      'transferência recebida',
      'transferencia recebida',
      'pix recebido',
      'depósito',
      'deposito',
      'salário',
      'salario',
    ].any(normalized.contains);
  }

  String _parseMerchant(String text, BankNotificationPayload raw) {
    final withoutAmount = text
        .replaceAll(
          RegExp(r'(?:R\$\s?|RS\$?\s?|BRL\s?)\d[\d.]*,\d{2}', caseSensitive: false),
          ' ',
        )
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final afterKnownConnector = RegExp(
      r'(?:em|no|na|para|compra aprovada em|compra realizada em)\s+([^.;,]+)',
      caseSensitive: false,
    ).firstMatch(withoutAmount);
    if (afterKnownConnector != null) {
      return _cleanTitle(afterKnownConnector.group(1)!);
    }

    if (raw.title.trim().isNotEmpty) {
      return _cleanTitle(raw.title);
    }

    return 'Compra detectada';
  }

  String _cleanTitle(String value) {
    final cleaned = value
        .replaceAll(RegExp(r'\b(aprovada|realizada|compra|cartão|cartao|pix)\b', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (cleaned.isEmpty) {
      return 'Compra detectada';
    }
    return cleaned.length > 42 ? cleaned.substring(0, 42).trim() : cleaned;
  }

  String _inferCategory(String text) {
    final normalized = text.toLowerCase();
    if (_hasAny(normalized, ['mercado', 'supermercado', 'atacad', 'extra', 'carrefour', 'assai'])) {
      return 'Mercado';
    }
    if (_hasAny(normalized, ['uber', '99', 'posto', 'combustível', 'combustivel', 'ônibus', 'onibus'])) {
      return 'Transporte';
    }
    if (_hasAny(normalized, ['ifood', 'restaurante', 'lanche', 'pizza', 'burger', 'padaria'])) {
      return 'Alimentação';
    }
    if (_hasAny(normalized, ['netflix', 'spotify', 'google one', 'prime', 'assinatura'])) {
      return 'Assinaturas';
    }
    if (_hasAny(normalized, ['farmácia', 'farmacia', 'drogaria', 'consulta', 'saúde', 'saude'])) {
      return 'Saúde';
    }
    return 'Outros';
  }

  bool _hasAny(String text, List<String> needles) {
    return needles.any(text.contains);
  }
}

class BankNotificationPayload {
  const BankNotificationPayload({
    required this.id,
    required this.packageName,
    required this.appName,
    required this.title,
    required this.text,
    required this.bigText,
    required this.postTime,
  });

  factory BankNotificationPayload.fromMap(Map<dynamic, dynamic> map) {
    return BankNotificationPayload(
      id: map['id'] as String? ?? '',
      packageName: map['packageName'] as String? ?? '',
      appName: map['appName'] as String? ?? '',
      title: map['title'] as String? ?? '',
      text: map['text'] as String? ?? '',
      bigText: map['bigText'] as String? ?? '',
      postTime: map['postTime'] is int ? map['postTime'] as int : null,
    );
  }

  final String id;
  final String packageName;
  final String appName;
  final String title;
  final String text;
  final String bigText;
  final int? postTime;

  String get combinedText => [
        appName,
        title,
        text,
        bigText,
      ].where((item) => item.trim().isNotEmpty).join(' ');
}

class CapturedExpenseSuggestion {
  const CapturedExpenseSuggestion({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.sourceLabel,
    required this.brand,
    required this.description,
    required this.occurredAt,
    required this.rawText,
  });

  final String id;
  final String title;
  final double amount;
  final String category;
  final String sourceLabel;
  final ExpenseBrandSignal brand;
  final String description;
  final DateTime occurredAt;
  final String rawText;

  ExpenseDraft toDraft({required String source}) {
    return ExpenseDraft(
      amount: amount,
      category: category,
      source: source,
      description: description,
    );
  }
}
