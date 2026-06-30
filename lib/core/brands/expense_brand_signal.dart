import 'package:flutter/material.dart';

class ExpenseBrandSignal {
  const ExpenseBrandSignal({
    required this.key,
    required this.label,
    required this.color,
    required this.icon,
  });

  final String key;
  final String label;
  final Color color;
  final IconData icon;
}

class ExpenseBrandCatalog {
  const ExpenseBrandCatalog._();

  static const genericBank = ExpenseBrandSignal(
    key: 'bank',
    label: 'Banco',
    color: Color(0xFF2563EB),
    icon: Icons.account_balance_rounded,
  );

  static ExpenseBrandSignal resolve({
    required String text,
    required String appName,
    required String packageName,
  }) {
    final haystack = '$packageName $appName $text'
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), ' ');

    for (final entry in _entries) {
      if (entry.matches(haystack)) {
        return entry.signal;
      }
    }

    return genericBank;
  }

  static const _entries = [
    _BrandEntry(
      needles: ['ifood', 'i-food'],
      signal: ExpenseBrandSignal(
        key: 'ifood',
        label: 'iFood',
        color: Color(0xFFEA1D2C),
        icon: Icons.delivery_dining_rounded,
      ),
    ),
    _BrandEntry(
      needles: ['uber'],
      signal: ExpenseBrandSignal(
        key: 'uber',
        label: 'Uber',
        color: Color(0xFF111827),
        icon: Icons.local_taxi_rounded,
      ),
    ),
    _BrandEntry(
      needles: ['99app', ' 99 ', '99pop', '99 food'],
      signal: ExpenseBrandSignal(
        key: '99',
        label: '99',
        color: Color(0xFFFFD000),
        icon: Icons.local_taxi_rounded,
      ),
    ),
    _BrandEntry(
      needles: ['spotify'],
      signal: ExpenseBrandSignal(
        key: 'spotify',
        label: 'Spotify',
        color: Color(0xFF1DB954),
        icon: Icons.music_note_rounded,
      ),
    ),
    _BrandEntry(
      needles: ['netflix'],
      signal: ExpenseBrandSignal(
        key: 'netflix',
        label: 'Netflix',
        color: Color(0xFFE50914),
        icon: Icons.movie_filter_rounded,
      ),
    ),
    _BrandEntry(
      needles: ['google one', 'google play', 'google'],
      signal: ExpenseBrandSignal(
        key: 'google',
        label: 'Google',
        color: Color(0xFF4285F4),
        icon: Icons.cloud_done_rounded,
      ),
    ),
    _BrandEntry(
      needles: ['nubank', 'nu pagamentos', 'nu '],
      signal: ExpenseBrandSignal(
        key: 'nubank',
        label: 'Nubank',
        color: Color(0xFF820AD1),
        icon: Icons.credit_card_rounded,
      ),
    ),
    _BrandEntry(
      needles: ['banco inter', ' inter ', 'inter&co'],
      signal: ExpenseBrandSignal(
        key: 'inter',
        label: 'Inter',
        color: Color(0xFFFF7A00),
        icon: Icons.account_balance_wallet_rounded,
      ),
    ),
    _BrandEntry(
      needles: ['santander'],
      signal: ExpenseBrandSignal(
        key: 'santander',
        label: 'Santander',
        color: Color(0xFFEC0000),
        icon: Icons.account_balance_rounded,
      ),
    ),
    _BrandEntry(
      needles: ['itau', 'itaú'],
      signal: ExpenseBrandSignal(
        key: 'itau',
        label: 'Itaú',
        color: Color(0xFFFF7900),
        icon: Icons.account_balance_rounded,
      ),
    ),
    _BrandEntry(
      needles: ['bradesco'],
      signal: ExpenseBrandSignal(
        key: 'bradesco',
        label: 'Bradesco',
        color: Color(0xFFCC092F),
        icon: Icons.account_balance_rounded,
      ),
    ),
    _BrandEntry(
      needles: ['banco do brasil', ' bb '],
      signal: ExpenseBrandSignal(
        key: 'bb',
        label: 'Banco do Brasil',
        color: Color(0xFFF7D117),
        icon: Icons.account_balance_rounded,
      ),
    ),
    _BrandEntry(
      needles: ['caixa'],
      signal: ExpenseBrandSignal(
        key: 'caixa',
        label: 'Caixa',
        color: Color(0xFF005CA9),
        icon: Icons.account_balance_rounded,
      ),
    ),
    _BrandEntry(
      needles: ['c6 bank', 'c6bank', ' c6 '],
      signal: ExpenseBrandSignal(
        key: 'c6',
        label: 'C6 Bank',
        color: Color(0xFF111827),
        icon: Icons.account_balance_rounded,
      ),
    ),
    _BrandEntry(
      needles: ['mercado pago', 'mercadopago'],
      signal: ExpenseBrandSignal(
        key: 'mercado_pago',
        label: 'Mercado Pago',
        color: Color(0xFF00AEEF),
        icon: Icons.payments_rounded,
      ),
    ),
    _BrandEntry(
      needles: ['picpay'],
      signal: ExpenseBrandSignal(
        key: 'picpay',
        label: 'PicPay',
        color: Color(0xFF11C76F),
        icon: Icons.payments_rounded,
      ),
    ),
  ];
}

class _BrandEntry {
  const _BrandEntry({
    required this.needles,
    required this.signal,
  });

  final List<String> needles;
  final ExpenseBrandSignal signal;

  bool matches(String text) {
    return needles.any(text.contains);
  }
}
