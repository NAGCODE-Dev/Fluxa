// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AppPreferencesTableTable extends AppPreferencesTable
    with TableInfo<$AppPreferencesTableTable, AppPreferencesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppPreferencesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _appearanceMeta =
      const VerificationMeta('appearance');
  @override
  late final GeneratedColumn<String> appearance = GeneratedColumn<String>(
      'appearance', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('calm'));
  static const VerificationMeta _completedWelcomeMeta =
      const VerificationMeta('completedWelcome');
  @override
  late final GeneratedColumn<bool> completedWelcome = GeneratedColumn<bool>(
      'completed_welcome', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("completed_welcome" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, displayName, appearance, completedWelcome];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_preferences_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<AppPreferencesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    }
    if (data.containsKey('appearance')) {
      context.handle(
          _appearanceMeta,
          appearance.isAcceptableOrUnknown(
              data['appearance']!, _appearanceMeta));
    }
    if (data.containsKey('completed_welcome')) {
      context.handle(
          _completedWelcomeMeta,
          completedWelcome.isAcceptableOrUnknown(
              data['completed_welcome']!, _completedWelcomeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppPreferencesTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppPreferencesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      appearance: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}appearance'])!,
      completedWelcome: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}completed_welcome'])!,
    );
  }

  @override
  $AppPreferencesTableTable createAlias(String alias) {
    return $AppPreferencesTableTable(attachedDatabase, alias);
  }
}

class AppPreferencesTableData extends DataClass
    implements Insertable<AppPreferencesTableData> {
  final int id;
  final String displayName;
  final String appearance;
  final bool completedWelcome;
  const AppPreferencesTableData(
      {required this.id,
      required this.displayName,
      required this.appearance,
      required this.completedWelcome});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['display_name'] = Variable<String>(displayName);
    map['appearance'] = Variable<String>(appearance);
    map['completed_welcome'] = Variable<bool>(completedWelcome);
    return map;
  }

  AppPreferencesTableCompanion toCompanion(bool nullToAbsent) {
    return AppPreferencesTableCompanion(
      id: Value(id),
      displayName: Value(displayName),
      appearance: Value(appearance),
      completedWelcome: Value(completedWelcome),
    );
  }

  factory AppPreferencesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppPreferencesTableData(
      id: serializer.fromJson<int>(json['id']),
      displayName: serializer.fromJson<String>(json['displayName']),
      appearance: serializer.fromJson<String>(json['appearance']),
      completedWelcome: serializer.fromJson<bool>(json['completedWelcome']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'displayName': serializer.toJson<String>(displayName),
      'appearance': serializer.toJson<String>(appearance),
      'completedWelcome': serializer.toJson<bool>(completedWelcome),
    };
  }

  AppPreferencesTableData copyWith(
          {int? id,
          String? displayName,
          String? appearance,
          bool? completedWelcome}) =>
      AppPreferencesTableData(
        id: id ?? this.id,
        displayName: displayName ?? this.displayName,
        appearance: appearance ?? this.appearance,
        completedWelcome: completedWelcome ?? this.completedWelcome,
      );
  AppPreferencesTableData copyWithCompanion(AppPreferencesTableCompanion data) {
    return AppPreferencesTableData(
      id: data.id.present ? data.id.value : this.id,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      appearance:
          data.appearance.present ? data.appearance.value : this.appearance,
      completedWelcome: data.completedWelcome.present
          ? data.completedWelcome.value
          : this.completedWelcome,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppPreferencesTableData(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('appearance: $appearance, ')
          ..write('completedWelcome: $completedWelcome')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, displayName, appearance, completedWelcome);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppPreferencesTableData &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.appearance == this.appearance &&
          other.completedWelcome == this.completedWelcome);
}

class AppPreferencesTableCompanion
    extends UpdateCompanion<AppPreferencesTableData> {
  final Value<int> id;
  final Value<String> displayName;
  final Value<String> appearance;
  final Value<bool> completedWelcome;
  const AppPreferencesTableCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.appearance = const Value.absent(),
    this.completedWelcome = const Value.absent(),
  });
  AppPreferencesTableCompanion.insert({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.appearance = const Value.absent(),
    this.completedWelcome = const Value.absent(),
  });
  static Insertable<AppPreferencesTableData> custom({
    Expression<int>? id,
    Expression<String>? displayName,
    Expression<String>? appearance,
    Expression<bool>? completedWelcome,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (appearance != null) 'appearance': appearance,
      if (completedWelcome != null) 'completed_welcome': completedWelcome,
    });
  }

  AppPreferencesTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? displayName,
      Value<String>? appearance,
      Value<bool>? completedWelcome}) {
    return AppPreferencesTableCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      appearance: appearance ?? this.appearance,
      completedWelcome: completedWelcome ?? this.completedWelcome,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (appearance.present) {
      map['appearance'] = Variable<String>(appearance.value);
    }
    if (completedWelcome.present) {
      map['completed_welcome'] = Variable<bool>(completedWelcome.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppPreferencesTableCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('appearance: $appearance, ')
          ..write('completedWelcome: $completedWelcome')
          ..write(')'))
        .toString();
  }
}

class $AccountsTableTable extends AccountsTable
    with TableInfo<$AccountsTableTable, AccountsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _balanceMeta =
      const VerificationMeta('balance');
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
      'balance', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, type, balance];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts_table';
  @override
  VerificationContext validateIntegrity(Insertable<AccountsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('balance')) {
      context.handle(_balanceMeta,
          balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta));
    } else if (isInserting) {
      context.missing(_balanceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      balance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}balance'])!,
    );
  }

  @override
  $AccountsTableTable createAlias(String alias) {
    return $AccountsTableTable(attachedDatabase, alias);
  }
}

class AccountsTableData extends DataClass
    implements Insertable<AccountsTableData> {
  final String id;
  final String name;
  final String type;
  final double balance;
  const AccountsTableData(
      {required this.id,
      required this.name,
      required this.type,
      required this.balance});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['balance'] = Variable<double>(balance);
    return map;
  }

  AccountsTableCompanion toCompanion(bool nullToAbsent) {
    return AccountsTableCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      balance: Value(balance),
    );
  }

  factory AccountsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      balance: serializer.fromJson<double>(json['balance']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'balance': serializer.toJson<double>(balance),
    };
  }

  AccountsTableData copyWith(
          {String? id, String? name, String? type, double? balance}) =>
      AccountsTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        balance: balance ?? this.balance,
      );
  AccountsTableData copyWithCompanion(AccountsTableCompanion data) {
    return AccountsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      balance: data.balance.present ? data.balance.value : this.balance,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('balance: $balance')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, balance);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.balance == this.balance);
}

class AccountsTableCompanion extends UpdateCompanion<AccountsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<double> balance;
  final Value<int> rowid;
  const AccountsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.balance = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsTableCompanion.insert({
    required String id,
    required String name,
    required String type,
    required double balance,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        type = Value(type),
        balance = Value(balance);
  static Insertable<AccountsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<double>? balance,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (balance != null) 'balance': balance,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? type,
      Value<double>? balance,
      Value<int>? rowid}) {
    return AccountsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('balance: $balance, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CardsTableTable extends CardsTable
    with TableInfo<$CardsTableTable, CardsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bankNameMeta =
      const VerificationMeta('bankName');
  @override
  late final GeneratedColumn<String> bankName = GeneratedColumn<String>(
      'bank_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _maskedNumberMeta =
      const VerificationMeta('maskedNumber');
  @override
  late final GeneratedColumn<String> maskedNumber = GeneratedColumn<String>(
      'masked_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _limitAmountMeta =
      const VerificationMeta('limitAmount');
  @override
  late final GeneratedColumn<double> limitAmount = GeneratedColumn<double>(
      'limit_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _availableAmountMeta =
      const VerificationMeta('availableAmount');
  @override
  late final GeneratedColumn<double> availableAmount = GeneratedColumn<double>(
      'available_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _currentInvoiceMeta =
      const VerificationMeta('currentInvoice');
  @override
  late final GeneratedColumn<double> currentInvoice = GeneratedColumn<double>(
      'current_invoice', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _closingLabelMeta =
      const VerificationMeta('closingLabel');
  @override
  late final GeneratedColumn<String> closingLabel = GeneratedColumn<String>(
      'closing_label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dueLabelMeta =
      const VerificationMeta('dueLabel');
  @override
  late final GeneratedColumn<String> dueLabel = GeneratedColumn<String>(
      'due_label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _backgroundColorMeta =
      const VerificationMeta('backgroundColor');
  @override
  late final GeneratedColumn<int> backgroundColor = GeneratedColumn<int>(
      'background_color', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _accentColorMeta =
      const VerificationMeta('accentColor');
  @override
  late final GeneratedColumn<int> accentColor = GeneratedColumn<int>(
      'accent_color', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        bankName,
        name,
        maskedNumber,
        limitAmount,
        availableAmount,
        currentInvoice,
        closingLabel,
        dueLabel,
        backgroundColor,
        accentColor
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cards_table';
  @override
  VerificationContext validateIntegrity(Insertable<CardsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bank_name')) {
      context.handle(_bankNameMeta,
          bankName.isAcceptableOrUnknown(data['bank_name']!, _bankNameMeta));
    } else if (isInserting) {
      context.missing(_bankNameMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('masked_number')) {
      context.handle(
          _maskedNumberMeta,
          maskedNumber.isAcceptableOrUnknown(
              data['masked_number']!, _maskedNumberMeta));
    } else if (isInserting) {
      context.missing(_maskedNumberMeta);
    }
    if (data.containsKey('limit_amount')) {
      context.handle(
          _limitAmountMeta,
          limitAmount.isAcceptableOrUnknown(
              data['limit_amount']!, _limitAmountMeta));
    } else if (isInserting) {
      context.missing(_limitAmountMeta);
    }
    if (data.containsKey('available_amount')) {
      context.handle(
          _availableAmountMeta,
          availableAmount.isAcceptableOrUnknown(
              data['available_amount']!, _availableAmountMeta));
    } else if (isInserting) {
      context.missing(_availableAmountMeta);
    }
    if (data.containsKey('current_invoice')) {
      context.handle(
          _currentInvoiceMeta,
          currentInvoice.isAcceptableOrUnknown(
              data['current_invoice']!, _currentInvoiceMeta));
    } else if (isInserting) {
      context.missing(_currentInvoiceMeta);
    }
    if (data.containsKey('closing_label')) {
      context.handle(
          _closingLabelMeta,
          closingLabel.isAcceptableOrUnknown(
              data['closing_label']!, _closingLabelMeta));
    } else if (isInserting) {
      context.missing(_closingLabelMeta);
    }
    if (data.containsKey('due_label')) {
      context.handle(_dueLabelMeta,
          dueLabel.isAcceptableOrUnknown(data['due_label']!, _dueLabelMeta));
    } else if (isInserting) {
      context.missing(_dueLabelMeta);
    }
    if (data.containsKey('background_color')) {
      context.handle(
          _backgroundColorMeta,
          backgroundColor.isAcceptableOrUnknown(
              data['background_color']!, _backgroundColorMeta));
    } else if (isInserting) {
      context.missing(_backgroundColorMeta);
    }
    if (data.containsKey('accent_color')) {
      context.handle(
          _accentColorMeta,
          accentColor.isAcceptableOrUnknown(
              data['accent_color']!, _accentColorMeta));
    } else if (isInserting) {
      context.missing(_accentColorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      bankName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bank_name'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      maskedNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}masked_number'])!,
      limitAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}limit_amount'])!,
      availableAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}available_amount'])!,
      currentInvoice: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}current_invoice'])!,
      closingLabel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}closing_label'])!,
      dueLabel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}due_label'])!,
      backgroundColor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}background_color'])!,
      accentColor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}accent_color'])!,
    );
  }

  @override
  $CardsTableTable createAlias(String alias) {
    return $CardsTableTable(attachedDatabase, alias);
  }
}

class CardsTableData extends DataClass implements Insertable<CardsTableData> {
  final String id;
  final String bankName;
  final String name;
  final String maskedNumber;
  final double limitAmount;
  final double availableAmount;
  final double currentInvoice;
  final String closingLabel;
  final String dueLabel;
  final int backgroundColor;
  final int accentColor;
  const CardsTableData(
      {required this.id,
      required this.bankName,
      required this.name,
      required this.maskedNumber,
      required this.limitAmount,
      required this.availableAmount,
      required this.currentInvoice,
      required this.closingLabel,
      required this.dueLabel,
      required this.backgroundColor,
      required this.accentColor});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['bank_name'] = Variable<String>(bankName);
    map['name'] = Variable<String>(name);
    map['masked_number'] = Variable<String>(maskedNumber);
    map['limit_amount'] = Variable<double>(limitAmount);
    map['available_amount'] = Variable<double>(availableAmount);
    map['current_invoice'] = Variable<double>(currentInvoice);
    map['closing_label'] = Variable<String>(closingLabel);
    map['due_label'] = Variable<String>(dueLabel);
    map['background_color'] = Variable<int>(backgroundColor);
    map['accent_color'] = Variable<int>(accentColor);
    return map;
  }

  CardsTableCompanion toCompanion(bool nullToAbsent) {
    return CardsTableCompanion(
      id: Value(id),
      bankName: Value(bankName),
      name: Value(name),
      maskedNumber: Value(maskedNumber),
      limitAmount: Value(limitAmount),
      availableAmount: Value(availableAmount),
      currentInvoice: Value(currentInvoice),
      closingLabel: Value(closingLabel),
      dueLabel: Value(dueLabel),
      backgroundColor: Value(backgroundColor),
      accentColor: Value(accentColor),
    );
  }

  factory CardsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardsTableData(
      id: serializer.fromJson<String>(json['id']),
      bankName: serializer.fromJson<String>(json['bankName']),
      name: serializer.fromJson<String>(json['name']),
      maskedNumber: serializer.fromJson<String>(json['maskedNumber']),
      limitAmount: serializer.fromJson<double>(json['limitAmount']),
      availableAmount: serializer.fromJson<double>(json['availableAmount']),
      currentInvoice: serializer.fromJson<double>(json['currentInvoice']),
      closingLabel: serializer.fromJson<String>(json['closingLabel']),
      dueLabel: serializer.fromJson<String>(json['dueLabel']),
      backgroundColor: serializer.fromJson<int>(json['backgroundColor']),
      accentColor: serializer.fromJson<int>(json['accentColor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bankName': serializer.toJson<String>(bankName),
      'name': serializer.toJson<String>(name),
      'maskedNumber': serializer.toJson<String>(maskedNumber),
      'limitAmount': serializer.toJson<double>(limitAmount),
      'availableAmount': serializer.toJson<double>(availableAmount),
      'currentInvoice': serializer.toJson<double>(currentInvoice),
      'closingLabel': serializer.toJson<String>(closingLabel),
      'dueLabel': serializer.toJson<String>(dueLabel),
      'backgroundColor': serializer.toJson<int>(backgroundColor),
      'accentColor': serializer.toJson<int>(accentColor),
    };
  }

  CardsTableData copyWith(
          {String? id,
          String? bankName,
          String? name,
          String? maskedNumber,
          double? limitAmount,
          double? availableAmount,
          double? currentInvoice,
          String? closingLabel,
          String? dueLabel,
          int? backgroundColor,
          int? accentColor}) =>
      CardsTableData(
        id: id ?? this.id,
        bankName: bankName ?? this.bankName,
        name: name ?? this.name,
        maskedNumber: maskedNumber ?? this.maskedNumber,
        limitAmount: limitAmount ?? this.limitAmount,
        availableAmount: availableAmount ?? this.availableAmount,
        currentInvoice: currentInvoice ?? this.currentInvoice,
        closingLabel: closingLabel ?? this.closingLabel,
        dueLabel: dueLabel ?? this.dueLabel,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        accentColor: accentColor ?? this.accentColor,
      );
  CardsTableData copyWithCompanion(CardsTableCompanion data) {
    return CardsTableData(
      id: data.id.present ? data.id.value : this.id,
      bankName: data.bankName.present ? data.bankName.value : this.bankName,
      name: data.name.present ? data.name.value : this.name,
      maskedNumber: data.maskedNumber.present
          ? data.maskedNumber.value
          : this.maskedNumber,
      limitAmount:
          data.limitAmount.present ? data.limitAmount.value : this.limitAmount,
      availableAmount: data.availableAmount.present
          ? data.availableAmount.value
          : this.availableAmount,
      currentInvoice: data.currentInvoice.present
          ? data.currentInvoice.value
          : this.currentInvoice,
      closingLabel: data.closingLabel.present
          ? data.closingLabel.value
          : this.closingLabel,
      dueLabel: data.dueLabel.present ? data.dueLabel.value : this.dueLabel,
      backgroundColor: data.backgroundColor.present
          ? data.backgroundColor.value
          : this.backgroundColor,
      accentColor:
          data.accentColor.present ? data.accentColor.value : this.accentColor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardsTableData(')
          ..write('id: $id, ')
          ..write('bankName: $bankName, ')
          ..write('name: $name, ')
          ..write('maskedNumber: $maskedNumber, ')
          ..write('limitAmount: $limitAmount, ')
          ..write('availableAmount: $availableAmount, ')
          ..write('currentInvoice: $currentInvoice, ')
          ..write('closingLabel: $closingLabel, ')
          ..write('dueLabel: $dueLabel, ')
          ..write('backgroundColor: $backgroundColor, ')
          ..write('accentColor: $accentColor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      bankName,
      name,
      maskedNumber,
      limitAmount,
      availableAmount,
      currentInvoice,
      closingLabel,
      dueLabel,
      backgroundColor,
      accentColor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardsTableData &&
          other.id == this.id &&
          other.bankName == this.bankName &&
          other.name == this.name &&
          other.maskedNumber == this.maskedNumber &&
          other.limitAmount == this.limitAmount &&
          other.availableAmount == this.availableAmount &&
          other.currentInvoice == this.currentInvoice &&
          other.closingLabel == this.closingLabel &&
          other.dueLabel == this.dueLabel &&
          other.backgroundColor == this.backgroundColor &&
          other.accentColor == this.accentColor);
}

class CardsTableCompanion extends UpdateCompanion<CardsTableData> {
  final Value<String> id;
  final Value<String> bankName;
  final Value<String> name;
  final Value<String> maskedNumber;
  final Value<double> limitAmount;
  final Value<double> availableAmount;
  final Value<double> currentInvoice;
  final Value<String> closingLabel;
  final Value<String> dueLabel;
  final Value<int> backgroundColor;
  final Value<int> accentColor;
  final Value<int> rowid;
  const CardsTableCompanion({
    this.id = const Value.absent(),
    this.bankName = const Value.absent(),
    this.name = const Value.absent(),
    this.maskedNumber = const Value.absent(),
    this.limitAmount = const Value.absent(),
    this.availableAmount = const Value.absent(),
    this.currentInvoice = const Value.absent(),
    this.closingLabel = const Value.absent(),
    this.dueLabel = const Value.absent(),
    this.backgroundColor = const Value.absent(),
    this.accentColor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardsTableCompanion.insert({
    required String id,
    required String bankName,
    required String name,
    required String maskedNumber,
    required double limitAmount,
    required double availableAmount,
    required double currentInvoice,
    required String closingLabel,
    required String dueLabel,
    required int backgroundColor,
    required int accentColor,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        bankName = Value(bankName),
        name = Value(name),
        maskedNumber = Value(maskedNumber),
        limitAmount = Value(limitAmount),
        availableAmount = Value(availableAmount),
        currentInvoice = Value(currentInvoice),
        closingLabel = Value(closingLabel),
        dueLabel = Value(dueLabel),
        backgroundColor = Value(backgroundColor),
        accentColor = Value(accentColor);
  static Insertable<CardsTableData> custom({
    Expression<String>? id,
    Expression<String>? bankName,
    Expression<String>? name,
    Expression<String>? maskedNumber,
    Expression<double>? limitAmount,
    Expression<double>? availableAmount,
    Expression<double>? currentInvoice,
    Expression<String>? closingLabel,
    Expression<String>? dueLabel,
    Expression<int>? backgroundColor,
    Expression<int>? accentColor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bankName != null) 'bank_name': bankName,
      if (name != null) 'name': name,
      if (maskedNumber != null) 'masked_number': maskedNumber,
      if (limitAmount != null) 'limit_amount': limitAmount,
      if (availableAmount != null) 'available_amount': availableAmount,
      if (currentInvoice != null) 'current_invoice': currentInvoice,
      if (closingLabel != null) 'closing_label': closingLabel,
      if (dueLabel != null) 'due_label': dueLabel,
      if (backgroundColor != null) 'background_color': backgroundColor,
      if (accentColor != null) 'accent_color': accentColor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? bankName,
      Value<String>? name,
      Value<String>? maskedNumber,
      Value<double>? limitAmount,
      Value<double>? availableAmount,
      Value<double>? currentInvoice,
      Value<String>? closingLabel,
      Value<String>? dueLabel,
      Value<int>? backgroundColor,
      Value<int>? accentColor,
      Value<int>? rowid}) {
    return CardsTableCompanion(
      id: id ?? this.id,
      bankName: bankName ?? this.bankName,
      name: name ?? this.name,
      maskedNumber: maskedNumber ?? this.maskedNumber,
      limitAmount: limitAmount ?? this.limitAmount,
      availableAmount: availableAmount ?? this.availableAmount,
      currentInvoice: currentInvoice ?? this.currentInvoice,
      closingLabel: closingLabel ?? this.closingLabel,
      dueLabel: dueLabel ?? this.dueLabel,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      accentColor: accentColor ?? this.accentColor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bankName.present) {
      map['bank_name'] = Variable<String>(bankName.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (maskedNumber.present) {
      map['masked_number'] = Variable<String>(maskedNumber.value);
    }
    if (limitAmount.present) {
      map['limit_amount'] = Variable<double>(limitAmount.value);
    }
    if (availableAmount.present) {
      map['available_amount'] = Variable<double>(availableAmount.value);
    }
    if (currentInvoice.present) {
      map['current_invoice'] = Variable<double>(currentInvoice.value);
    }
    if (closingLabel.present) {
      map['closing_label'] = Variable<String>(closingLabel.value);
    }
    if (dueLabel.present) {
      map['due_label'] = Variable<String>(dueLabel.value);
    }
    if (backgroundColor.present) {
      map['background_color'] = Variable<int>(backgroundColor.value);
    }
    if (accentColor.present) {
      map['accent_color'] = Variable<int>(accentColor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardsTableCompanion(')
          ..write('id: $id, ')
          ..write('bankName: $bankName, ')
          ..write('name: $name, ')
          ..write('maskedNumber: $maskedNumber, ')
          ..write('limitAmount: $limitAmount, ')
          ..write('availableAmount: $availableAmount, ')
          ..write('currentInvoice: $currentInvoice, ')
          ..write('closingLabel: $closingLabel, ')
          ..write('dueLabel: $dueLabel, ')
          ..write('backgroundColor: $backgroundColor, ')
          ..write('accentColor: $accentColor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTableTable extends CategoriesTable
    with TableInfo<$CategoriesTableTable, CategoriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<CategoriesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {name};
  @override
  CategoriesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoriesTableData(
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $CategoriesTableTable createAlias(String alias) {
    return $CategoriesTableTable(attachedDatabase, alias);
  }
}

class CategoriesTableData extends DataClass
    implements Insertable<CategoriesTableData> {
  final String name;
  const CategoriesTableData({required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    return map;
  }

  CategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return CategoriesTableCompanion(
      name: Value(name),
    );
  }

  factory CategoriesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoriesTableData(
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
    };
  }

  CategoriesTableData copyWith({String? name}) => CategoriesTableData(
        name: name ?? this.name,
      );
  CategoriesTableData copyWithCompanion(CategoriesTableCompanion data) {
    return CategoriesTableData(
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableData(')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => name.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoriesTableData && other.name == this.name);
}

class CategoriesTableCompanion extends UpdateCompanion<CategoriesTableData> {
  final Value<String> name;
  final Value<int> rowid;
  const CategoriesTableCompanion({
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesTableCompanion.insert({
    required String name,
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<CategoriesTableData> custom({
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesTableCompanion copyWith({Value<String>? name, Value<int>? rowid}) {
    return CategoriesTableCompanion(
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableCompanion(')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTableTable extends TransactionsTable
    with TableInfo<$TransactionsTableTable, TransactionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _occuredAtMeta =
      const VerificationMeta('occuredAt');
  @override
  late final GeneratedColumn<DateTime> occuredAt = GeneratedColumn<DateTime>(
      'occured_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _sourceLabelMeta =
      const VerificationMeta('sourceLabel');
  @override
  late final GeneratedColumn<String> sourceLabel = GeneratedColumn<String>(
      'source_label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, description, amount, type, occuredAt, sourceLabel, category];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<TransactionsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('occured_at')) {
      context.handle(_occuredAtMeta,
          occuredAt.isAcceptableOrUnknown(data['occured_at']!, _occuredAtMeta));
    } else if (isInserting) {
      context.missing(_occuredAtMeta);
    }
    if (data.containsKey('source_label')) {
      context.handle(
          _sourceLabelMeta,
          sourceLabel.isAcceptableOrUnknown(
              data['source_label']!, _sourceLabelMeta));
    } else if (isInserting) {
      context.missing(_sourceLabelMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      occuredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}occured_at'])!,
      sourceLabel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_label'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
    );
  }

  @override
  $TransactionsTableTable createAlias(String alias) {
    return $TransactionsTableTable(attachedDatabase, alias);
  }
}

class TransactionsTableData extends DataClass
    implements Insertable<TransactionsTableData> {
  final String id;
  final String title;
  final String description;
  final double amount;
  final String type;
  final DateTime occuredAt;
  final String sourceLabel;
  final String category;
  const TransactionsTableData(
      {required this.id,
      required this.title,
      required this.description,
      required this.amount,
      required this.type,
      required this.occuredAt,
      required this.sourceLabel,
      required this.category});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['amount'] = Variable<double>(amount);
    map['type'] = Variable<String>(type);
    map['occured_at'] = Variable<DateTime>(occuredAt);
    map['source_label'] = Variable<String>(sourceLabel);
    map['category'] = Variable<String>(category);
    return map;
  }

  TransactionsTableCompanion toCompanion(bool nullToAbsent) {
    return TransactionsTableCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      amount: Value(amount),
      type: Value(type),
      occuredAt: Value(occuredAt),
      sourceLabel: Value(sourceLabel),
      category: Value(category),
    );
  }

  factory TransactionsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionsTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      amount: serializer.fromJson<double>(json['amount']),
      type: serializer.fromJson<String>(json['type']),
      occuredAt: serializer.fromJson<DateTime>(json['occuredAt']),
      sourceLabel: serializer.fromJson<String>(json['sourceLabel']),
      category: serializer.fromJson<String>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'amount': serializer.toJson<double>(amount),
      'type': serializer.toJson<String>(type),
      'occuredAt': serializer.toJson<DateTime>(occuredAt),
      'sourceLabel': serializer.toJson<String>(sourceLabel),
      'category': serializer.toJson<String>(category),
    };
  }

  TransactionsTableData copyWith(
          {String? id,
          String? title,
          String? description,
          double? amount,
          String? type,
          DateTime? occuredAt,
          String? sourceLabel,
          String? category}) =>
      TransactionsTableData(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        amount: amount ?? this.amount,
        type: type ?? this.type,
        occuredAt: occuredAt ?? this.occuredAt,
        sourceLabel: sourceLabel ?? this.sourceLabel,
        category: category ?? this.category,
      );
  TransactionsTableData copyWithCompanion(TransactionsTableCompanion data) {
    return TransactionsTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      amount: data.amount.present ? data.amount.value : this.amount,
      type: data.type.present ? data.type.value : this.type,
      occuredAt: data.occuredAt.present ? data.occuredAt.value : this.occuredAt,
      sourceLabel:
          data.sourceLabel.present ? data.sourceLabel.value : this.sourceLabel,
      category: data.category.present ? data.category.value : this.category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('occuredAt: $occuredAt, ')
          ..write('sourceLabel: $sourceLabel, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, description, amount, type, occuredAt, sourceLabel, category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionsTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.amount == this.amount &&
          other.type == this.type &&
          other.occuredAt == this.occuredAt &&
          other.sourceLabel == this.sourceLabel &&
          other.category == this.category);
}

class TransactionsTableCompanion
    extends UpdateCompanion<TransactionsTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<double> amount;
  final Value<String> type;
  final Value<DateTime> occuredAt;
  final Value<String> sourceLabel;
  final Value<String> category;
  final Value<int> rowid;
  const TransactionsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.amount = const Value.absent(),
    this.type = const Value.absent(),
    this.occuredAt = const Value.absent(),
    this.sourceLabel = const Value.absent(),
    this.category = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsTableCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    required double amount,
    required String type,
    required DateTime occuredAt,
    required String sourceLabel,
    required String category,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        amount = Value(amount),
        type = Value(type),
        occuredAt = Value(occuredAt),
        sourceLabel = Value(sourceLabel),
        category = Value(category);
  static Insertable<TransactionsTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<double>? amount,
    Expression<String>? type,
    Expression<DateTime>? occuredAt,
    Expression<String>? sourceLabel,
    Expression<String>? category,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (amount != null) 'amount': amount,
      if (type != null) 'type': type,
      if (occuredAt != null) 'occured_at': occuredAt,
      if (sourceLabel != null) 'source_label': sourceLabel,
      if (category != null) 'category': category,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? description,
      Value<double>? amount,
      Value<String>? type,
      Value<DateTime>? occuredAt,
      Value<String>? sourceLabel,
      Value<String>? category,
      Value<int>? rowid}) {
    return TransactionsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      occuredAt: occuredAt ?? this.occuredAt,
      sourceLabel: sourceLabel ?? this.sourceLabel,
      category: category ?? this.category,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (occuredAt.present) {
      map['occured_at'] = Variable<DateTime>(occuredAt.value);
    }
    if (sourceLabel.present) {
      map['source_label'] = Variable<String>(sourceLabel.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('occuredAt: $occuredAt, ')
          ..write('sourceLabel: $sourceLabel, ')
          ..write('category: $category, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalsTableTable extends GoalsTable
    with TableInfo<$GoalsTableTable, GoalsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetAmountMeta =
      const VerificationMeta('targetAmount');
  @override
  late final GeneratedColumn<double> targetAmount = GeneratedColumn<double>(
      'target_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _currentAmountMeta =
      const VerificationMeta('currentAmount');
  @override
  late final GeneratedColumn<double> currentAmount = GeneratedColumn<double>(
      'current_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _estimatedLabelMeta =
      const VerificationMeta('estimatedLabel');
  @override
  late final GeneratedColumn<String> estimatedLabel = GeneratedColumn<String>(
      'estimated_label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, targetAmount, currentAmount, estimatedLabel];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals_table';
  @override
  VerificationContext validateIntegrity(Insertable<GoalsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_amount')) {
      context.handle(
          _targetAmountMeta,
          targetAmount.isAcceptableOrUnknown(
              data['target_amount']!, _targetAmountMeta));
    } else if (isInserting) {
      context.missing(_targetAmountMeta);
    }
    if (data.containsKey('current_amount')) {
      context.handle(
          _currentAmountMeta,
          currentAmount.isAcceptableOrUnknown(
              data['current_amount']!, _currentAmountMeta));
    } else if (isInserting) {
      context.missing(_currentAmountMeta);
    }
    if (data.containsKey('estimated_label')) {
      context.handle(
          _estimatedLabelMeta,
          estimatedLabel.isAcceptableOrUnknown(
              data['estimated_label']!, _estimatedLabelMeta));
    } else if (isInserting) {
      context.missing(_estimatedLabelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      targetAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}target_amount'])!,
      currentAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}current_amount'])!,
      estimatedLabel: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}estimated_label'])!,
    );
  }

  @override
  $GoalsTableTable createAlias(String alias) {
    return $GoalsTableTable(attachedDatabase, alias);
  }
}

class GoalsTableData extends DataClass implements Insertable<GoalsTableData> {
  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final String estimatedLabel;
  const GoalsTableData(
      {required this.id,
      required this.name,
      required this.targetAmount,
      required this.currentAmount,
      required this.estimatedLabel});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['target_amount'] = Variable<double>(targetAmount);
    map['current_amount'] = Variable<double>(currentAmount);
    map['estimated_label'] = Variable<String>(estimatedLabel);
    return map;
  }

  GoalsTableCompanion toCompanion(bool nullToAbsent) {
    return GoalsTableCompanion(
      id: Value(id),
      name: Value(name),
      targetAmount: Value(targetAmount),
      currentAmount: Value(currentAmount),
      estimatedLabel: Value(estimatedLabel),
    );
  }

  factory GoalsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      targetAmount: serializer.fromJson<double>(json['targetAmount']),
      currentAmount: serializer.fromJson<double>(json['currentAmount']),
      estimatedLabel: serializer.fromJson<String>(json['estimatedLabel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'targetAmount': serializer.toJson<double>(targetAmount),
      'currentAmount': serializer.toJson<double>(currentAmount),
      'estimatedLabel': serializer.toJson<String>(estimatedLabel),
    };
  }

  GoalsTableData copyWith(
          {String? id,
          String? name,
          double? targetAmount,
          double? currentAmount,
          String? estimatedLabel}) =>
      GoalsTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        targetAmount: targetAmount ?? this.targetAmount,
        currentAmount: currentAmount ?? this.currentAmount,
        estimatedLabel: estimatedLabel ?? this.estimatedLabel,
      );
  GoalsTableData copyWithCompanion(GoalsTableCompanion data) {
    return GoalsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      targetAmount: data.targetAmount.present
          ? data.targetAmount.value
          : this.targetAmount,
      currentAmount: data.currentAmount.present
          ? data.currentAmount.value
          : this.currentAmount,
      estimatedLabel: data.estimatedLabel.present
          ? data.estimatedLabel.value
          : this.estimatedLabel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('estimatedLabel: $estimatedLabel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, targetAmount, currentAmount, estimatedLabel);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.targetAmount == this.targetAmount &&
          other.currentAmount == this.currentAmount &&
          other.estimatedLabel == this.estimatedLabel);
}

class GoalsTableCompanion extends UpdateCompanion<GoalsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<double> targetAmount;
  final Value<double> currentAmount;
  final Value<String> estimatedLabel;
  final Value<int> rowid;
  const GoalsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.targetAmount = const Value.absent(),
    this.currentAmount = const Value.absent(),
    this.estimatedLabel = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsTableCompanion.insert({
    required String id,
    required String name,
    required double targetAmount,
    required double currentAmount,
    required String estimatedLabel,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        targetAmount = Value(targetAmount),
        currentAmount = Value(currentAmount),
        estimatedLabel = Value(estimatedLabel);
  static Insertable<GoalsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? targetAmount,
    Expression<double>? currentAmount,
    Expression<String>? estimatedLabel,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (targetAmount != null) 'target_amount': targetAmount,
      if (currentAmount != null) 'current_amount': currentAmount,
      if (estimatedLabel != null) 'estimated_label': estimatedLabel,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<double>? targetAmount,
      Value<double>? currentAmount,
      Value<String>? estimatedLabel,
      Value<int>? rowid}) {
    return GoalsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      estimatedLabel: estimatedLabel ?? this.estimatedLabel,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetAmount.present) {
      map['target_amount'] = Variable<double>(targetAmount.value);
    }
    if (currentAmount.present) {
      map['current_amount'] = Variable<double>(currentAmount.value);
    }
    if (estimatedLabel.present) {
      map['estimated_label'] = Variable<String>(estimatedLabel.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('estimatedLabel: $estimatedLabel, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTableTable extends BudgetsTable
    with TableInfo<$BudgetsTableTable, BudgetsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _periodMonthMeta =
      const VerificationMeta('periodMonth');
  @override
  late final GeneratedColumn<int> periodMonth = GeneratedColumn<int>(
      'period_month', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _periodYearMeta =
      const VerificationMeta('periodYear');
  @override
  late final GeneratedColumn<int> periodYear = GeneratedColumn<int>(
      'period_year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _budgetAmountMeta =
      const VerificationMeta('budgetAmount');
  @override
  late final GeneratedColumn<double> budgetAmount = GeneratedColumn<double>(
      'budget_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _alertThresholdPercentMeta =
      const VerificationMeta('alertThresholdPercent');
  @override
  late final GeneratedColumn<double> alertThresholdPercent =
      GeneratedColumn<double>('alert_threshold_percent', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(80));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        category,
        periodMonth,
        periodYear,
        budgetAmount,
        alertThresholdPercent
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets_table';
  @override
  VerificationContext validateIntegrity(Insertable<BudgetsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('period_month')) {
      context.handle(
          _periodMonthMeta,
          periodMonth.isAcceptableOrUnknown(
              data['period_month']!, _periodMonthMeta));
    } else if (isInserting) {
      context.missing(_periodMonthMeta);
    }
    if (data.containsKey('period_year')) {
      context.handle(
          _periodYearMeta,
          periodYear.isAcceptableOrUnknown(
              data['period_year']!, _periodYearMeta));
    } else if (isInserting) {
      context.missing(_periodYearMeta);
    }
    if (data.containsKey('budget_amount')) {
      context.handle(
          _budgetAmountMeta,
          budgetAmount.isAcceptableOrUnknown(
              data['budget_amount']!, _budgetAmountMeta));
    } else if (isInserting) {
      context.missing(_budgetAmountMeta);
    }
    if (data.containsKey('alert_threshold_percent')) {
      context.handle(
          _alertThresholdPercentMeta,
          alertThresholdPercent.isAcceptableOrUnknown(
              data['alert_threshold_percent']!, _alertThresholdPercentMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      periodMonth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}period_month'])!,
      periodYear: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}period_year'])!,
      budgetAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}budget_amount'])!,
      alertThresholdPercent: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}alert_threshold_percent'])!,
    );
  }

  @override
  $BudgetsTableTable createAlias(String alias) {
    return $BudgetsTableTable(attachedDatabase, alias);
  }
}

class BudgetsTableData extends DataClass
    implements Insertable<BudgetsTableData> {
  final String id;
  final String category;
  final int periodMonth;
  final int periodYear;
  final double budgetAmount;
  final double alertThresholdPercent;
  const BudgetsTableData(
      {required this.id,
      required this.category,
      required this.periodMonth,
      required this.periodYear,
      required this.budgetAmount,
      required this.alertThresholdPercent});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category'] = Variable<String>(category);
    map['period_month'] = Variable<int>(periodMonth);
    map['period_year'] = Variable<int>(periodYear);
    map['budget_amount'] = Variable<double>(budgetAmount);
    map['alert_threshold_percent'] = Variable<double>(alertThresholdPercent);
    return map;
  }

  BudgetsTableCompanion toCompanion(bool nullToAbsent) {
    return BudgetsTableCompanion(
      id: Value(id),
      category: Value(category),
      periodMonth: Value(periodMonth),
      periodYear: Value(periodYear),
      budgetAmount: Value(budgetAmount),
      alertThresholdPercent: Value(alertThresholdPercent),
    );
  }

  factory BudgetsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetsTableData(
      id: serializer.fromJson<String>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      periodMonth: serializer.fromJson<int>(json['periodMonth']),
      periodYear: serializer.fromJson<int>(json['periodYear']),
      budgetAmount: serializer.fromJson<double>(json['budgetAmount']),
      alertThresholdPercent:
          serializer.fromJson<double>(json['alertThresholdPercent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'category': serializer.toJson<String>(category),
      'periodMonth': serializer.toJson<int>(periodMonth),
      'periodYear': serializer.toJson<int>(periodYear),
      'budgetAmount': serializer.toJson<double>(budgetAmount),
      'alertThresholdPercent': serializer.toJson<double>(alertThresholdPercent),
    };
  }

  BudgetsTableData copyWith(
          {String? id,
          String? category,
          int? periodMonth,
          int? periodYear,
          double? budgetAmount,
          double? alertThresholdPercent}) =>
      BudgetsTableData(
        id: id ?? this.id,
        category: category ?? this.category,
        periodMonth: periodMonth ?? this.periodMonth,
        periodYear: periodYear ?? this.periodYear,
        budgetAmount: budgetAmount ?? this.budgetAmount,
        alertThresholdPercent:
            alertThresholdPercent ?? this.alertThresholdPercent,
      );
  BudgetsTableData copyWithCompanion(BudgetsTableCompanion data) {
    return BudgetsTableData(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      periodMonth:
          data.periodMonth.present ? data.periodMonth.value : this.periodMonth,
      periodYear:
          data.periodYear.present ? data.periodYear.value : this.periodYear,
      budgetAmount: data.budgetAmount.present
          ? data.budgetAmount.value
          : this.budgetAmount,
      alertThresholdPercent: data.alertThresholdPercent.present
          ? data.alertThresholdPercent.value
          : this.alertThresholdPercent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsTableData(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('periodMonth: $periodMonth, ')
          ..write('periodYear: $periodYear, ')
          ..write('budgetAmount: $budgetAmount, ')
          ..write('alertThresholdPercent: $alertThresholdPercent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, category, periodMonth, periodYear,
      budgetAmount, alertThresholdPercent);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetsTableData &&
          other.id == this.id &&
          other.category == this.category &&
          other.periodMonth == this.periodMonth &&
          other.periodYear == this.periodYear &&
          other.budgetAmount == this.budgetAmount &&
          other.alertThresholdPercent == this.alertThresholdPercent);
}

class BudgetsTableCompanion extends UpdateCompanion<BudgetsTableData> {
  final Value<String> id;
  final Value<String> category;
  final Value<int> periodMonth;
  final Value<int> periodYear;
  final Value<double> budgetAmount;
  final Value<double> alertThresholdPercent;
  final Value<int> rowid;
  const BudgetsTableCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.periodMonth = const Value.absent(),
    this.periodYear = const Value.absent(),
    this.budgetAmount = const Value.absent(),
    this.alertThresholdPercent = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetsTableCompanion.insert({
    required String id,
    required String category,
    required int periodMonth,
    required int periodYear,
    required double budgetAmount,
    this.alertThresholdPercent = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        category = Value(category),
        periodMonth = Value(periodMonth),
        periodYear = Value(periodYear),
        budgetAmount = Value(budgetAmount);
  static Insertable<BudgetsTableData> custom({
    Expression<String>? id,
    Expression<String>? category,
    Expression<int>? periodMonth,
    Expression<int>? periodYear,
    Expression<double>? budgetAmount,
    Expression<double>? alertThresholdPercent,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (periodMonth != null) 'period_month': periodMonth,
      if (periodYear != null) 'period_year': periodYear,
      if (budgetAmount != null) 'budget_amount': budgetAmount,
      if (alertThresholdPercent != null)
        'alert_threshold_percent': alertThresholdPercent,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? category,
      Value<int>? periodMonth,
      Value<int>? periodYear,
      Value<double>? budgetAmount,
      Value<double>? alertThresholdPercent,
      Value<int>? rowid}) {
    return BudgetsTableCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      periodMonth: periodMonth ?? this.periodMonth,
      periodYear: periodYear ?? this.periodYear,
      budgetAmount: budgetAmount ?? this.budgetAmount,
      alertThresholdPercent:
          alertThresholdPercent ?? this.alertThresholdPercent,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (periodMonth.present) {
      map['period_month'] = Variable<int>(periodMonth.value);
    }
    if (periodYear.present) {
      map['period_year'] = Variable<int>(periodYear.value);
    }
    if (budgetAmount.present) {
      map['budget_amount'] = Variable<double>(budgetAmount.value);
    }
    if (alertThresholdPercent.present) {
      map['alert_threshold_percent'] =
          Variable<double>(alertThresholdPercent.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsTableCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('periodMonth: $periodMonth, ')
          ..write('periodYear: $periodYear, ')
          ..write('budgetAmount: $budgetAmount, ')
          ..write('alertThresholdPercent: $alertThresholdPercent, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubscriptionsTableTable extends SubscriptionsTable
    with TableInfo<$SubscriptionsTableTable, SubscriptionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubscriptionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _billingCycleMeta =
      const VerificationMeta('billingCycle');
  @override
  late final GeneratedColumn<String> billingCycle = GeneratedColumn<String>(
      'billing_cycle', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nextChargeDateMeta =
      const VerificationMeta('nextChargeDate');
  @override
  late final GeneratedColumn<DateTime> nextChargeDate =
      GeneratedColumn<DateTime>('next_charge_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _detectionSourceMeta =
      const VerificationMeta('detectionSource');
  @override
  late final GeneratedColumn<String> detectionSource = GeneratedColumn<String>(
      'detection_source', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        amount,
        billingCycle,
        nextChargeDate,
        isActive,
        detectionSource
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscriptions_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<SubscriptionsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('billing_cycle')) {
      context.handle(
          _billingCycleMeta,
          billingCycle.isAcceptableOrUnknown(
              data['billing_cycle']!, _billingCycleMeta));
    } else if (isInserting) {
      context.missing(_billingCycleMeta);
    }
    if (data.containsKey('next_charge_date')) {
      context.handle(
          _nextChargeDateMeta,
          nextChargeDate.isAcceptableOrUnknown(
              data['next_charge_date']!, _nextChargeDateMeta));
    } else if (isInserting) {
      context.missing(_nextChargeDateMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('detection_source')) {
      context.handle(
          _detectionSourceMeta,
          detectionSource.isAcceptableOrUnknown(
              data['detection_source']!, _detectionSourceMeta));
    } else if (isInserting) {
      context.missing(_detectionSourceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubscriptionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubscriptionsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      billingCycle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}billing_cycle'])!,
      nextChargeDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}next_charge_date'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      detectionSource: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}detection_source'])!,
    );
  }

  @override
  $SubscriptionsTableTable createAlias(String alias) {
    return $SubscriptionsTableTable(attachedDatabase, alias);
  }
}

class SubscriptionsTableData extends DataClass
    implements Insertable<SubscriptionsTableData> {
  final String id;
  final String name;
  final double amount;
  final String billingCycle;
  final DateTime nextChargeDate;
  final bool isActive;
  final String detectionSource;
  const SubscriptionsTableData(
      {required this.id,
      required this.name,
      required this.amount,
      required this.billingCycle,
      required this.nextChargeDate,
      required this.isActive,
      required this.detectionSource});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['amount'] = Variable<double>(amount);
    map['billing_cycle'] = Variable<String>(billingCycle);
    map['next_charge_date'] = Variable<DateTime>(nextChargeDate);
    map['is_active'] = Variable<bool>(isActive);
    map['detection_source'] = Variable<String>(detectionSource);
    return map;
  }

  SubscriptionsTableCompanion toCompanion(bool nullToAbsent) {
    return SubscriptionsTableCompanion(
      id: Value(id),
      name: Value(name),
      amount: Value(amount),
      billingCycle: Value(billingCycle),
      nextChargeDate: Value(nextChargeDate),
      isActive: Value(isActive),
      detectionSource: Value(detectionSource),
    );
  }

  factory SubscriptionsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubscriptionsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double>(json['amount']),
      billingCycle: serializer.fromJson<String>(json['billingCycle']),
      nextChargeDate: serializer.fromJson<DateTime>(json['nextChargeDate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      detectionSource: serializer.fromJson<String>(json['detectionSource']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double>(amount),
      'billingCycle': serializer.toJson<String>(billingCycle),
      'nextChargeDate': serializer.toJson<DateTime>(nextChargeDate),
      'isActive': serializer.toJson<bool>(isActive),
      'detectionSource': serializer.toJson<String>(detectionSource),
    };
  }

  SubscriptionsTableData copyWith(
          {String? id,
          String? name,
          double? amount,
          String? billingCycle,
          DateTime? nextChargeDate,
          bool? isActive,
          String? detectionSource}) =>
      SubscriptionsTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        billingCycle: billingCycle ?? this.billingCycle,
        nextChargeDate: nextChargeDate ?? this.nextChargeDate,
        isActive: isActive ?? this.isActive,
        detectionSource: detectionSource ?? this.detectionSource,
      );
  SubscriptionsTableData copyWithCompanion(SubscriptionsTableCompanion data) {
    return SubscriptionsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      amount: data.amount.present ? data.amount.value : this.amount,
      billingCycle: data.billingCycle.present
          ? data.billingCycle.value
          : this.billingCycle,
      nextChargeDate: data.nextChargeDate.present
          ? data.nextChargeDate.value
          : this.nextChargeDate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      detectionSource: data.detectionSource.present
          ? data.detectionSource.value
          : this.detectionSource,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('billingCycle: $billingCycle, ')
          ..write('nextChargeDate: $nextChargeDate, ')
          ..write('isActive: $isActive, ')
          ..write('detectionSource: $detectionSource')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, amount, billingCycle,
      nextChargeDate, isActive, detectionSource);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubscriptionsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.billingCycle == this.billingCycle &&
          other.nextChargeDate == this.nextChargeDate &&
          other.isActive == this.isActive &&
          other.detectionSource == this.detectionSource);
}

class SubscriptionsTableCompanion
    extends UpdateCompanion<SubscriptionsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<double> amount;
  final Value<String> billingCycle;
  final Value<DateTime> nextChargeDate;
  final Value<bool> isActive;
  final Value<String> detectionSource;
  final Value<int> rowid;
  const SubscriptionsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.billingCycle = const Value.absent(),
    this.nextChargeDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.detectionSource = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubscriptionsTableCompanion.insert({
    required String id,
    required String name,
    required double amount,
    required String billingCycle,
    required DateTime nextChargeDate,
    this.isActive = const Value.absent(),
    required String detectionSource,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        amount = Value(amount),
        billingCycle = Value(billingCycle),
        nextChargeDate = Value(nextChargeDate),
        detectionSource = Value(detectionSource);
  static Insertable<SubscriptionsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? amount,
    Expression<String>? billingCycle,
    Expression<DateTime>? nextChargeDate,
    Expression<bool>? isActive,
    Expression<String>? detectionSource,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (billingCycle != null) 'billing_cycle': billingCycle,
      if (nextChargeDate != null) 'next_charge_date': nextChargeDate,
      if (isActive != null) 'is_active': isActive,
      if (detectionSource != null) 'detection_source': detectionSource,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubscriptionsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<double>? amount,
      Value<String>? billingCycle,
      Value<DateTime>? nextChargeDate,
      Value<bool>? isActive,
      Value<String>? detectionSource,
      Value<int>? rowid}) {
    return SubscriptionsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      billingCycle: billingCycle ?? this.billingCycle,
      nextChargeDate: nextChargeDate ?? this.nextChargeDate,
      isActive: isActive ?? this.isActive,
      detectionSource: detectionSource ?? this.detectionSource,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (billingCycle.present) {
      map['billing_cycle'] = Variable<String>(billingCycle.value);
    }
    if (nextChargeDate.present) {
      map['next_charge_date'] = Variable<DateTime>(nextChargeDate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (detectionSource.present) {
      map['detection_source'] = Variable<String>(detectionSource.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('billingCycle: $billingCycle, ')
          ..write('nextChargeDate: $nextChargeDate, ')
          ..write('isActive: $isActive, ')
          ..write('detectionSource: $detectionSource, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CalendarEventsTableTable extends CalendarEventsTable
    with TableInfo<$CalendarEventsTableTable, CalendarEventsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalendarEventsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _eventDateMeta =
      const VerificationMeta('eventDate');
  @override
  late final GeneratedColumn<DateTime> eventDate = GeneratedColumn<DateTime>(
      'event_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, type, title, description, eventDate, amount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calendar_events_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<CalendarEventsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('event_date')) {
      context.handle(_eventDateMeta,
          eventDate.isAcceptableOrUnknown(data['event_date']!, _eventDateMeta));
    } else if (isInserting) {
      context.missing(_eventDateMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CalendarEventsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalendarEventsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      eventDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}event_date'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount']),
    );
  }

  @override
  $CalendarEventsTableTable createAlias(String alias) {
    return $CalendarEventsTableTable(attachedDatabase, alias);
  }
}

class CalendarEventsTableData extends DataClass
    implements Insertable<CalendarEventsTableData> {
  final String id;
  final String type;
  final String title;
  final String? description;
  final DateTime eventDate;
  final double? amount;
  const CalendarEventsTableData(
      {required this.id,
      required this.type,
      required this.title,
      this.description,
      required this.eventDate,
      this.amount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['event_date'] = Variable<DateTime>(eventDate);
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    return map;
  }

  CalendarEventsTableCompanion toCompanion(bool nullToAbsent) {
    return CalendarEventsTableCompanion(
      id: Value(id),
      type: Value(type),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      eventDate: Value(eventDate),
      amount:
          amount == null && nullToAbsent ? const Value.absent() : Value(amount),
    );
  }

  factory CalendarEventsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalendarEventsTableData(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      eventDate: serializer.fromJson<DateTime>(json['eventDate']),
      amount: serializer.fromJson<double?>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'eventDate': serializer.toJson<DateTime>(eventDate),
      'amount': serializer.toJson<double?>(amount),
    };
  }

  CalendarEventsTableData copyWith(
          {String? id,
          String? type,
          String? title,
          Value<String?> description = const Value.absent(),
          DateTime? eventDate,
          Value<double?> amount = const Value.absent()}) =>
      CalendarEventsTableData(
        id: id ?? this.id,
        type: type ?? this.type,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        eventDate: eventDate ?? this.eventDate,
        amount: amount.present ? amount.value : this.amount,
      );
  CalendarEventsTableData copyWithCompanion(CalendarEventsTableCompanion data) {
    return CalendarEventsTableData(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      eventDate: data.eventDate.present ? data.eventDate.value : this.eventDate,
      amount: data.amount.present ? data.amount.value : this.amount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalendarEventsTableData(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('eventDate: $eventDate, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, type, title, description, eventDate, amount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalendarEventsTableData &&
          other.id == this.id &&
          other.type == this.type &&
          other.title == this.title &&
          other.description == this.description &&
          other.eventDate == this.eventDate &&
          other.amount == this.amount);
}

class CalendarEventsTableCompanion
    extends UpdateCompanion<CalendarEventsTableData> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> title;
  final Value<String?> description;
  final Value<DateTime> eventDate;
  final Value<double?> amount;
  final Value<int> rowid;
  const CalendarEventsTableCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.eventDate = const Value.absent(),
    this.amount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CalendarEventsTableCompanion.insert({
    required String id,
    required String type,
    required String title,
    this.description = const Value.absent(),
    required DateTime eventDate,
    this.amount = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        type = Value(type),
        title = Value(title),
        eventDate = Value(eventDate);
  static Insertable<CalendarEventsTableData> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? eventDate,
    Expression<double>? amount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (eventDate != null) 'event_date': eventDate,
      if (amount != null) 'amount': amount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CalendarEventsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? type,
      Value<String>? title,
      Value<String?>? description,
      Value<DateTime>? eventDate,
      Value<double?>? amount,
      Value<int>? rowid}) {
    return CalendarEventsTableCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      eventDate: eventDate ?? this.eventDate,
      amount: amount ?? this.amount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (eventDate.present) {
      map['event_date'] = Variable<DateTime>(eventDate.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalendarEventsTableCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('eventDate: $eventDate, ')
          ..write('amount: $amount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTableTable extends SyncQueueTable
    with TableInfo<$SyncQueueTableTable, SyncQueueTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _localEntityTypeMeta =
      const VerificationMeta('localEntityType');
  @override
  late final GeneratedColumn<String> localEntityType = GeneratedColumn<String>(
      'local_entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _localEntityIdMeta =
      const VerificationMeta('localEntityId');
  @override
  late final GeneratedColumn<String> localEntityId = GeneratedColumn<String>(
      'local_entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operationMeta =
      const VerificationMeta('operation');
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
      'operation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _clientMutationIdMeta =
      const VerificationMeta('clientMutationId');
  @override
  late final GeneratedColumn<String> clientMutationId = GeneratedColumn<String>(
      'client_mutation_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _payloadJsonMeta =
      const VerificationMeta('payloadJson');
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
      'payload_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastErrorMeta =
      const VerificationMeta('lastError');
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
      'last_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        localEntityType,
        localEntityId,
        operation,
        clientMutationId,
        payloadJson,
        status,
        retryCount,
        lastError,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue_table';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('local_entity_type')) {
      context.handle(
          _localEntityTypeMeta,
          localEntityType.isAcceptableOrUnknown(
              data['local_entity_type']!, _localEntityTypeMeta));
    } else if (isInserting) {
      context.missing(_localEntityTypeMeta);
    }
    if (data.containsKey('local_entity_id')) {
      context.handle(
          _localEntityIdMeta,
          localEntityId.isAcceptableOrUnknown(
              data['local_entity_id']!, _localEntityIdMeta));
    } else if (isInserting) {
      context.missing(_localEntityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(_operationMeta,
          operation.isAcceptableOrUnknown(data['operation']!, _operationMeta));
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('client_mutation_id')) {
      context.handle(
          _clientMutationIdMeta,
          clientMutationId.isAcceptableOrUnknown(
              data['client_mutation_id']!, _clientMutationIdMeta));
    }
    if (data.containsKey('payload_json')) {
      context.handle(
          _payloadJsonMeta,
          payloadJson.isAcceptableOrUnknown(
              data['payload_json']!, _payloadJsonMeta));
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    if (data.containsKey('last_error')) {
      context.handle(_lastErrorMeta,
          lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      localEntityType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}local_entity_type'])!,
      localEntityId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}local_entity_id'])!,
      operation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation'])!,
      clientMutationId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}client_mutation_id']),
      payloadJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_json'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
      lastError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_error']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SyncQueueTableTable createAlias(String alias) {
    return $SyncQueueTableTable(attachedDatabase, alias);
  }
}

class SyncQueueTableData extends DataClass
    implements Insertable<SyncQueueTableData> {
  final String id;
  final String? userId;
  final String localEntityType;
  final String localEntityId;
  final String operation;
  final String? clientMutationId;
  final String payloadJson;
  final String status;
  final int retryCount;
  final String? lastError;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SyncQueueTableData(
      {required this.id,
      this.userId,
      required this.localEntityType,
      required this.localEntityId,
      required this.operation,
      this.clientMutationId,
      required this.payloadJson,
      required this.status,
      required this.retryCount,
      this.lastError,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['local_entity_type'] = Variable<String>(localEntityType);
    map['local_entity_id'] = Variable<String>(localEntityId);
    map['operation'] = Variable<String>(operation);
    if (!nullToAbsent || clientMutationId != null) {
      map['client_mutation_id'] = Variable<String>(clientMutationId);
    }
    map['payload_json'] = Variable<String>(payloadJson);
    map['status'] = Variable<String>(status);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncQueueTableCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueTableCompanion(
      id: Value(id),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      localEntityType: Value(localEntityType),
      localEntityId: Value(localEntityId),
      operation: Value(operation),
      clientMutationId: clientMutationId == null && nullToAbsent
          ? const Value.absent()
          : Value(clientMutationId),
      payloadJson: Value(payloadJson),
      status: Value(status),
      retryCount: Value(retryCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncQueueTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      localEntityType: serializer.fromJson<String>(json['localEntityType']),
      localEntityId: serializer.fromJson<String>(json['localEntityId']),
      operation: serializer.fromJson<String>(json['operation']),
      clientMutationId: serializer.fromJson<String?>(json['clientMutationId']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      status: serializer.fromJson<String>(json['status']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'localEntityType': serializer.toJson<String>(localEntityType),
      'localEntityId': serializer.toJson<String>(localEntityId),
      'operation': serializer.toJson<String>(operation),
      'clientMutationId': serializer.toJson<String?>(clientMutationId),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'status': serializer.toJson<String>(status),
      'retryCount': serializer.toJson<int>(retryCount),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncQueueTableData copyWith(
          {String? id,
          Value<String?> userId = const Value.absent(),
          String? localEntityType,
          String? localEntityId,
          String? operation,
          Value<String?> clientMutationId = const Value.absent(),
          String? payloadJson,
          String? status,
          int? retryCount,
          Value<String?> lastError = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      SyncQueueTableData(
        id: id ?? this.id,
        userId: userId.present ? userId.value : this.userId,
        localEntityType: localEntityType ?? this.localEntityType,
        localEntityId: localEntityId ?? this.localEntityId,
        operation: operation ?? this.operation,
        clientMutationId: clientMutationId.present
            ? clientMutationId.value
            : this.clientMutationId,
        payloadJson: payloadJson ?? this.payloadJson,
        status: status ?? this.status,
        retryCount: retryCount ?? this.retryCount,
        lastError: lastError.present ? lastError.value : this.lastError,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SyncQueueTableData copyWithCompanion(SyncQueueTableCompanion data) {
    return SyncQueueTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      localEntityType: data.localEntityType.present
          ? data.localEntityType.value
          : this.localEntityType,
      localEntityId: data.localEntityId.present
          ? data.localEntityId.value
          : this.localEntityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      clientMutationId: data.clientMutationId.present
          ? data.clientMutationId.value
          : this.clientMutationId,
      payloadJson:
          data.payloadJson.present ? data.payloadJson.value : this.payloadJson,
      status: data.status.present ? data.status.value : this.status,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('localEntityType: $localEntityType, ')
          ..write('localEntityId: $localEntityId, ')
          ..write('operation: $operation, ')
          ..write('clientMutationId: $clientMutationId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      localEntityType,
      localEntityId,
      operation,
      clientMutationId,
      payloadJson,
      status,
      retryCount,
      lastError,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.localEntityType == this.localEntityType &&
          other.localEntityId == this.localEntityId &&
          other.operation == this.operation &&
          other.clientMutationId == this.clientMutationId &&
          other.payloadJson == this.payloadJson &&
          other.status == this.status &&
          other.retryCount == this.retryCount &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SyncQueueTableCompanion extends UpdateCompanion<SyncQueueTableData> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<String> localEntityType;
  final Value<String> localEntityId;
  final Value<String> operation;
  final Value<String?> clientMutationId;
  final Value<String> payloadJson;
  final Value<String> status;
  final Value<int> retryCount;
  final Value<String?> lastError;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SyncQueueTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.localEntityType = const Value.absent(),
    this.localEntityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.clientMutationId = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueTableCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    required String localEntityType,
    required String localEntityId,
    required String operation,
    this.clientMutationId = const Value.absent(),
    required String payloadJson,
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        localEntityType = Value(localEntityType),
        localEntityId = Value(localEntityId),
        operation = Value(operation),
        payloadJson = Value(payloadJson),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<SyncQueueTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? localEntityType,
    Expression<String>? localEntityId,
    Expression<String>? operation,
    Expression<String>? clientMutationId,
    Expression<String>? payloadJson,
    Expression<String>? status,
    Expression<int>? retryCount,
    Expression<String>? lastError,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (localEntityType != null) 'local_entity_type': localEntityType,
      if (localEntityId != null) 'local_entity_id': localEntityId,
      if (operation != null) 'operation': operation,
      if (clientMutationId != null) 'client_mutation_id': clientMutationId,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (status != null) 'status': status,
      if (retryCount != null) 'retry_count': retryCount,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueTableCompanion copyWith(
      {Value<String>? id,
      Value<String?>? userId,
      Value<String>? localEntityType,
      Value<String>? localEntityId,
      Value<String>? operation,
      Value<String?>? clientMutationId,
      Value<String>? payloadJson,
      Value<String>? status,
      Value<int>? retryCount,
      Value<String?>? lastError,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return SyncQueueTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      localEntityType: localEntityType ?? this.localEntityType,
      localEntityId: localEntityId ?? this.localEntityId,
      operation: operation ?? this.operation,
      clientMutationId: clientMutationId ?? this.clientMutationId,
      payloadJson: payloadJson ?? this.payloadJson,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (localEntityType.present) {
      map['local_entity_type'] = Variable<String>(localEntityType.value);
    }
    if (localEntityId.present) {
      map['local_entity_id'] = Variable<String>(localEntityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (clientMutationId.present) {
      map['client_mutation_id'] = Variable<String>(clientMutationId.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('localEntityType: $localEntityType, ')
          ..write('localEntityId: $localEntityId, ')
          ..write('operation: $operation, ')
          ..write('clientMutationId: $clientMutationId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppPreferencesTableTable appPreferencesTable =
      $AppPreferencesTableTable(this);
  late final $AccountsTableTable accountsTable = $AccountsTableTable(this);
  late final $CardsTableTable cardsTable = $CardsTableTable(this);
  late final $CategoriesTableTable categoriesTable =
      $CategoriesTableTable(this);
  late final $TransactionsTableTable transactionsTable =
      $TransactionsTableTable(this);
  late final $GoalsTableTable goalsTable = $GoalsTableTable(this);
  late final $BudgetsTableTable budgetsTable = $BudgetsTableTable(this);
  late final $SubscriptionsTableTable subscriptionsTable =
      $SubscriptionsTableTable(this);
  late final $CalendarEventsTableTable calendarEventsTable =
      $CalendarEventsTableTable(this);
  late final $SyncQueueTableTable syncQueueTable = $SyncQueueTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        appPreferencesTable,
        accountsTable,
        cardsTable,
        categoriesTable,
        transactionsTable,
        goalsTable,
        budgetsTable,
        subscriptionsTable,
        calendarEventsTable,
        syncQueueTable
      ];
}

typedef $$AppPreferencesTableTableCreateCompanionBuilder
    = AppPreferencesTableCompanion Function({
  Value<int> id,
  Value<String> displayName,
  Value<String> appearance,
  Value<bool> completedWelcome,
});
typedef $$AppPreferencesTableTableUpdateCompanionBuilder
    = AppPreferencesTableCompanion Function({
  Value<int> id,
  Value<String> displayName,
  Value<String> appearance,
  Value<bool> completedWelcome,
});

class $$AppPreferencesTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppPreferencesTableTable> {
  $$AppPreferencesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get appearance => $composableBuilder(
      column: $table.appearance, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completedWelcome => $composableBuilder(
      column: $table.completedWelcome,
      builder: (column) => ColumnFilters(column));
}

class $$AppPreferencesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppPreferencesTableTable> {
  $$AppPreferencesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get appearance => $composableBuilder(
      column: $table.appearance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completedWelcome => $composableBuilder(
      column: $table.completedWelcome,
      builder: (column) => ColumnOrderings(column));
}

class $$AppPreferencesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppPreferencesTableTable> {
  $$AppPreferencesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => column);

  GeneratedColumn<String> get appearance => $composableBuilder(
      column: $table.appearance, builder: (column) => column);

  GeneratedColumn<bool> get completedWelcome => $composableBuilder(
      column: $table.completedWelcome, builder: (column) => column);
}

class $$AppPreferencesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppPreferencesTableTable,
    AppPreferencesTableData,
    $$AppPreferencesTableTableFilterComposer,
    $$AppPreferencesTableTableOrderingComposer,
    $$AppPreferencesTableTableAnnotationComposer,
    $$AppPreferencesTableTableCreateCompanionBuilder,
    $$AppPreferencesTableTableUpdateCompanionBuilder,
    (
      AppPreferencesTableData,
      BaseReferences<_$AppDatabase, $AppPreferencesTableTable,
          AppPreferencesTableData>
    ),
    AppPreferencesTableData,
    PrefetchHooks Function()> {
  $$AppPreferencesTableTableTableManager(
      _$AppDatabase db, $AppPreferencesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppPreferencesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppPreferencesTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppPreferencesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> displayName = const Value.absent(),
            Value<String> appearance = const Value.absent(),
            Value<bool> completedWelcome = const Value.absent(),
          }) =>
              AppPreferencesTableCompanion(
            id: id,
            displayName: displayName,
            appearance: appearance,
            completedWelcome: completedWelcome,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> displayName = const Value.absent(),
            Value<String> appearance = const Value.absent(),
            Value<bool> completedWelcome = const Value.absent(),
          }) =>
              AppPreferencesTableCompanion.insert(
            id: id,
            displayName: displayName,
            appearance: appearance,
            completedWelcome: completedWelcome,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppPreferencesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppPreferencesTableTable,
    AppPreferencesTableData,
    $$AppPreferencesTableTableFilterComposer,
    $$AppPreferencesTableTableOrderingComposer,
    $$AppPreferencesTableTableAnnotationComposer,
    $$AppPreferencesTableTableCreateCompanionBuilder,
    $$AppPreferencesTableTableUpdateCompanionBuilder,
    (
      AppPreferencesTableData,
      BaseReferences<_$AppDatabase, $AppPreferencesTableTable,
          AppPreferencesTableData>
    ),
    AppPreferencesTableData,
    PrefetchHooks Function()>;
typedef $$AccountsTableTableCreateCompanionBuilder = AccountsTableCompanion
    Function({
  required String id,
  required String name,
  required String type,
  required double balance,
  Value<int> rowid,
});
typedef $$AccountsTableTableUpdateCompanionBuilder = AccountsTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> type,
  Value<double> balance,
  Value<int> rowid,
});

class $$AccountsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTableTable> {
  $$AccountsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnFilters(column));
}

class $$AccountsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTableTable> {
  $$AccountsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnOrderings(column));
}

class $$AccountsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTableTable> {
  $$AccountsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);
}

class $$AccountsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AccountsTableTable,
    AccountsTableData,
    $$AccountsTableTableFilterComposer,
    $$AccountsTableTableOrderingComposer,
    $$AccountsTableTableAnnotationComposer,
    $$AccountsTableTableCreateCompanionBuilder,
    $$AccountsTableTableUpdateCompanionBuilder,
    (
      AccountsTableData,
      BaseReferences<_$AppDatabase, $AccountsTableTable, AccountsTableData>
    ),
    AccountsTableData,
    PrefetchHooks Function()> {
  $$AccountsTableTableTableManager(_$AppDatabase db, $AccountsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double> balance = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountsTableCompanion(
            id: id,
            name: name,
            type: type,
            balance: balance,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String type,
            required double balance,
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountsTableCompanion.insert(
            id: id,
            name: name,
            type: type,
            balance: balance,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AccountsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AccountsTableTable,
    AccountsTableData,
    $$AccountsTableTableFilterComposer,
    $$AccountsTableTableOrderingComposer,
    $$AccountsTableTableAnnotationComposer,
    $$AccountsTableTableCreateCompanionBuilder,
    $$AccountsTableTableUpdateCompanionBuilder,
    (
      AccountsTableData,
      BaseReferences<_$AppDatabase, $AccountsTableTable, AccountsTableData>
    ),
    AccountsTableData,
    PrefetchHooks Function()>;
typedef $$CardsTableTableCreateCompanionBuilder = CardsTableCompanion Function({
  required String id,
  required String bankName,
  required String name,
  required String maskedNumber,
  required double limitAmount,
  required double availableAmount,
  required double currentInvoice,
  required String closingLabel,
  required String dueLabel,
  required int backgroundColor,
  required int accentColor,
  Value<int> rowid,
});
typedef $$CardsTableTableUpdateCompanionBuilder = CardsTableCompanion Function({
  Value<String> id,
  Value<String> bankName,
  Value<String> name,
  Value<String> maskedNumber,
  Value<double> limitAmount,
  Value<double> availableAmount,
  Value<double> currentInvoice,
  Value<String> closingLabel,
  Value<String> dueLabel,
  Value<int> backgroundColor,
  Value<int> accentColor,
  Value<int> rowid,
});

class $$CardsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CardsTableTable> {
  $$CardsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bankName => $composableBuilder(
      column: $table.bankName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get maskedNumber => $composableBuilder(
      column: $table.maskedNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get limitAmount => $composableBuilder(
      column: $table.limitAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get availableAmount => $composableBuilder(
      column: $table.availableAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get currentInvoice => $composableBuilder(
      column: $table.currentInvoice,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get closingLabel => $composableBuilder(
      column: $table.closingLabel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dueLabel => $composableBuilder(
      column: $table.dueLabel, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get backgroundColor => $composableBuilder(
      column: $table.backgroundColor,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get accentColor => $composableBuilder(
      column: $table.accentColor, builder: (column) => ColumnFilters(column));
}

class $$CardsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CardsTableTable> {
  $$CardsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bankName => $composableBuilder(
      column: $table.bankName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get maskedNumber => $composableBuilder(
      column: $table.maskedNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get limitAmount => $composableBuilder(
      column: $table.limitAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get availableAmount => $composableBuilder(
      column: $table.availableAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get currentInvoice => $composableBuilder(
      column: $table.currentInvoice,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get closingLabel => $composableBuilder(
      column: $table.closingLabel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dueLabel => $composableBuilder(
      column: $table.dueLabel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get backgroundColor => $composableBuilder(
      column: $table.backgroundColor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get accentColor => $composableBuilder(
      column: $table.accentColor, builder: (column) => ColumnOrderings(column));
}

class $$CardsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardsTableTable> {
  $$CardsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bankName =>
      $composableBuilder(column: $table.bankName, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get maskedNumber => $composableBuilder(
      column: $table.maskedNumber, builder: (column) => column);

  GeneratedColumn<double> get limitAmount => $composableBuilder(
      column: $table.limitAmount, builder: (column) => column);

  GeneratedColumn<double> get availableAmount => $composableBuilder(
      column: $table.availableAmount, builder: (column) => column);

  GeneratedColumn<double> get currentInvoice => $composableBuilder(
      column: $table.currentInvoice, builder: (column) => column);

  GeneratedColumn<String> get closingLabel => $composableBuilder(
      column: $table.closingLabel, builder: (column) => column);

  GeneratedColumn<String> get dueLabel =>
      $composableBuilder(column: $table.dueLabel, builder: (column) => column);

  GeneratedColumn<int> get backgroundColor => $composableBuilder(
      column: $table.backgroundColor, builder: (column) => column);

  GeneratedColumn<int> get accentColor => $composableBuilder(
      column: $table.accentColor, builder: (column) => column);
}

class $$CardsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CardsTableTable,
    CardsTableData,
    $$CardsTableTableFilterComposer,
    $$CardsTableTableOrderingComposer,
    $$CardsTableTableAnnotationComposer,
    $$CardsTableTableCreateCompanionBuilder,
    $$CardsTableTableUpdateCompanionBuilder,
    (
      CardsTableData,
      BaseReferences<_$AppDatabase, $CardsTableTable, CardsTableData>
    ),
    CardsTableData,
    PrefetchHooks Function()> {
  $$CardsTableTableTableManager(_$AppDatabase db, $CardsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> bankName = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> maskedNumber = const Value.absent(),
            Value<double> limitAmount = const Value.absent(),
            Value<double> availableAmount = const Value.absent(),
            Value<double> currentInvoice = const Value.absent(),
            Value<String> closingLabel = const Value.absent(),
            Value<String> dueLabel = const Value.absent(),
            Value<int> backgroundColor = const Value.absent(),
            Value<int> accentColor = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CardsTableCompanion(
            id: id,
            bankName: bankName,
            name: name,
            maskedNumber: maskedNumber,
            limitAmount: limitAmount,
            availableAmount: availableAmount,
            currentInvoice: currentInvoice,
            closingLabel: closingLabel,
            dueLabel: dueLabel,
            backgroundColor: backgroundColor,
            accentColor: accentColor,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String bankName,
            required String name,
            required String maskedNumber,
            required double limitAmount,
            required double availableAmount,
            required double currentInvoice,
            required String closingLabel,
            required String dueLabel,
            required int backgroundColor,
            required int accentColor,
            Value<int> rowid = const Value.absent(),
          }) =>
              CardsTableCompanion.insert(
            id: id,
            bankName: bankName,
            name: name,
            maskedNumber: maskedNumber,
            limitAmount: limitAmount,
            availableAmount: availableAmount,
            currentInvoice: currentInvoice,
            closingLabel: closingLabel,
            dueLabel: dueLabel,
            backgroundColor: backgroundColor,
            accentColor: accentColor,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CardsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CardsTableTable,
    CardsTableData,
    $$CardsTableTableFilterComposer,
    $$CardsTableTableOrderingComposer,
    $$CardsTableTableAnnotationComposer,
    $$CardsTableTableCreateCompanionBuilder,
    $$CardsTableTableUpdateCompanionBuilder,
    (
      CardsTableData,
      BaseReferences<_$AppDatabase, $CardsTableTable, CardsTableData>
    ),
    CardsTableData,
    PrefetchHooks Function()>;
typedef $$CategoriesTableTableCreateCompanionBuilder = CategoriesTableCompanion
    Function({
  required String name,
  Value<int> rowid,
});
typedef $$CategoriesTableTableUpdateCompanionBuilder = CategoriesTableCompanion
    Function({
  Value<String> name,
  Value<int> rowid,
});

class $$CategoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));
}

class $$CategoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));
}

class $$CategoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$CategoriesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTableTable,
    CategoriesTableData,
    $$CategoriesTableTableFilterComposer,
    $$CategoriesTableTableOrderingComposer,
    $$CategoriesTableTableAnnotationComposer,
    $$CategoriesTableTableCreateCompanionBuilder,
    $$CategoriesTableTableUpdateCompanionBuilder,
    (
      CategoriesTableData,
      BaseReferences<_$AppDatabase, $CategoriesTableTable, CategoriesTableData>
    ),
    CategoriesTableData,
    PrefetchHooks Function()> {
  $$CategoriesTableTableTableManager(
      _$AppDatabase db, $CategoriesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> name = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesTableCompanion(
            name: name,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String name,
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesTableCompanion.insert(
            name: name,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CategoriesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTableTable,
    CategoriesTableData,
    $$CategoriesTableTableFilterComposer,
    $$CategoriesTableTableOrderingComposer,
    $$CategoriesTableTableAnnotationComposer,
    $$CategoriesTableTableCreateCompanionBuilder,
    $$CategoriesTableTableUpdateCompanionBuilder,
    (
      CategoriesTableData,
      BaseReferences<_$AppDatabase, $CategoriesTableTable, CategoriesTableData>
    ),
    CategoriesTableData,
    PrefetchHooks Function()>;
typedef $$TransactionsTableTableCreateCompanionBuilder
    = TransactionsTableCompanion Function({
  required String id,
  required String title,
  Value<String> description,
  required double amount,
  required String type,
  required DateTime occuredAt,
  required String sourceLabel,
  required String category,
  Value<int> rowid,
});
typedef $$TransactionsTableTableUpdateCompanionBuilder
    = TransactionsTableCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> description,
  Value<double> amount,
  Value<String> type,
  Value<DateTime> occuredAt,
  Value<String> sourceLabel,
  Value<String> category,
  Value<int> rowid,
});

class $$TransactionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get occuredAt => $composableBuilder(
      column: $table.occuredAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceLabel => $composableBuilder(
      column: $table.sourceLabel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));
}

class $$TransactionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get occuredAt => $composableBuilder(
      column: $table.occuredAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceLabel => $composableBuilder(
      column: $table.sourceLabel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));
}

class $$TransactionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get occuredAt =>
      $composableBuilder(column: $table.occuredAt, builder: (column) => column);

  GeneratedColumn<String> get sourceLabel => $composableBuilder(
      column: $table.sourceLabel, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);
}

class $$TransactionsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsTableTable,
    TransactionsTableData,
    $$TransactionsTableTableFilterComposer,
    $$TransactionsTableTableOrderingComposer,
    $$TransactionsTableTableAnnotationComposer,
    $$TransactionsTableTableCreateCompanionBuilder,
    $$TransactionsTableTableUpdateCompanionBuilder,
    (
      TransactionsTableData,
      BaseReferences<_$AppDatabase, $TransactionsTableTable,
          TransactionsTableData>
    ),
    TransactionsTableData,
    PrefetchHooks Function()> {
  $$TransactionsTableTableTableManager(
      _$AppDatabase db, $TransactionsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<DateTime> occuredAt = const Value.absent(),
            Value<String> sourceLabel = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsTableCompanion(
            id: id,
            title: title,
            description: description,
            amount: amount,
            type: type,
            occuredAt: occuredAt,
            sourceLabel: sourceLabel,
            category: category,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            Value<String> description = const Value.absent(),
            required double amount,
            required String type,
            required DateTime occuredAt,
            required String sourceLabel,
            required String category,
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsTableCompanion.insert(
            id: id,
            title: title,
            description: description,
            amount: amount,
            type: type,
            occuredAt: occuredAt,
            sourceLabel: sourceLabel,
            category: category,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TransactionsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionsTableTable,
    TransactionsTableData,
    $$TransactionsTableTableFilterComposer,
    $$TransactionsTableTableOrderingComposer,
    $$TransactionsTableTableAnnotationComposer,
    $$TransactionsTableTableCreateCompanionBuilder,
    $$TransactionsTableTableUpdateCompanionBuilder,
    (
      TransactionsTableData,
      BaseReferences<_$AppDatabase, $TransactionsTableTable,
          TransactionsTableData>
    ),
    TransactionsTableData,
    PrefetchHooks Function()>;
typedef $$GoalsTableTableCreateCompanionBuilder = GoalsTableCompanion Function({
  required String id,
  required String name,
  required double targetAmount,
  required double currentAmount,
  required String estimatedLabel,
  Value<int> rowid,
});
typedef $$GoalsTableTableUpdateCompanionBuilder = GoalsTableCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<double> targetAmount,
  Value<double> currentAmount,
  Value<String> estimatedLabel,
  Value<int> rowid,
});

class $$GoalsTableTableFilterComposer
    extends Composer<_$AppDatabase, $GoalsTableTable> {
  $$GoalsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get targetAmount => $composableBuilder(
      column: $table.targetAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get currentAmount => $composableBuilder(
      column: $table.currentAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get estimatedLabel => $composableBuilder(
      column: $table.estimatedLabel,
      builder: (column) => ColumnFilters(column));
}

class $$GoalsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalsTableTable> {
  $$GoalsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get targetAmount => $composableBuilder(
      column: $table.targetAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get currentAmount => $composableBuilder(
      column: $table.currentAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get estimatedLabel => $composableBuilder(
      column: $table.estimatedLabel,
      builder: (column) => ColumnOrderings(column));
}

class $$GoalsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalsTableTable> {
  $$GoalsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get targetAmount => $composableBuilder(
      column: $table.targetAmount, builder: (column) => column);

  GeneratedColumn<double> get currentAmount => $composableBuilder(
      column: $table.currentAmount, builder: (column) => column);

  GeneratedColumn<String> get estimatedLabel => $composableBuilder(
      column: $table.estimatedLabel, builder: (column) => column);
}

class $$GoalsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GoalsTableTable,
    GoalsTableData,
    $$GoalsTableTableFilterComposer,
    $$GoalsTableTableOrderingComposer,
    $$GoalsTableTableAnnotationComposer,
    $$GoalsTableTableCreateCompanionBuilder,
    $$GoalsTableTableUpdateCompanionBuilder,
    (
      GoalsTableData,
      BaseReferences<_$AppDatabase, $GoalsTableTable, GoalsTableData>
    ),
    GoalsTableData,
    PrefetchHooks Function()> {
  $$GoalsTableTableTableManager(_$AppDatabase db, $GoalsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> targetAmount = const Value.absent(),
            Value<double> currentAmount = const Value.absent(),
            Value<String> estimatedLabel = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalsTableCompanion(
            id: id,
            name: name,
            targetAmount: targetAmount,
            currentAmount: currentAmount,
            estimatedLabel: estimatedLabel,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required double targetAmount,
            required double currentAmount,
            required String estimatedLabel,
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalsTableCompanion.insert(
            id: id,
            name: name,
            targetAmount: targetAmount,
            currentAmount: currentAmount,
            estimatedLabel: estimatedLabel,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GoalsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GoalsTableTable,
    GoalsTableData,
    $$GoalsTableTableFilterComposer,
    $$GoalsTableTableOrderingComposer,
    $$GoalsTableTableAnnotationComposer,
    $$GoalsTableTableCreateCompanionBuilder,
    $$GoalsTableTableUpdateCompanionBuilder,
    (
      GoalsTableData,
      BaseReferences<_$AppDatabase, $GoalsTableTable, GoalsTableData>
    ),
    GoalsTableData,
    PrefetchHooks Function()>;
typedef $$BudgetsTableTableCreateCompanionBuilder = BudgetsTableCompanion
    Function({
  required String id,
  required String category,
  required int periodMonth,
  required int periodYear,
  required double budgetAmount,
  Value<double> alertThresholdPercent,
  Value<int> rowid,
});
typedef $$BudgetsTableTableUpdateCompanionBuilder = BudgetsTableCompanion
    Function({
  Value<String> id,
  Value<String> category,
  Value<int> periodMonth,
  Value<int> periodYear,
  Value<double> budgetAmount,
  Value<double> alertThresholdPercent,
  Value<int> rowid,
});

class $$BudgetsTableTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTableTable> {
  $$BudgetsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get periodMonth => $composableBuilder(
      column: $table.periodMonth, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get periodYear => $composableBuilder(
      column: $table.periodYear, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get budgetAmount => $composableBuilder(
      column: $table.budgetAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get alertThresholdPercent => $composableBuilder(
      column: $table.alertThresholdPercent,
      builder: (column) => ColumnFilters(column));
}

class $$BudgetsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTableTable> {
  $$BudgetsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get periodMonth => $composableBuilder(
      column: $table.periodMonth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get periodYear => $composableBuilder(
      column: $table.periodYear, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get budgetAmount => $composableBuilder(
      column: $table.budgetAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get alertThresholdPercent => $composableBuilder(
      column: $table.alertThresholdPercent,
      builder: (column) => ColumnOrderings(column));
}

class $$BudgetsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTableTable> {
  $$BudgetsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get periodMonth => $composableBuilder(
      column: $table.periodMonth, builder: (column) => column);

  GeneratedColumn<int> get periodYear => $composableBuilder(
      column: $table.periodYear, builder: (column) => column);

  GeneratedColumn<double> get budgetAmount => $composableBuilder(
      column: $table.budgetAmount, builder: (column) => column);

  GeneratedColumn<double> get alertThresholdPercent => $composableBuilder(
      column: $table.alertThresholdPercent, builder: (column) => column);
}

class $$BudgetsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BudgetsTableTable,
    BudgetsTableData,
    $$BudgetsTableTableFilterComposer,
    $$BudgetsTableTableOrderingComposer,
    $$BudgetsTableTableAnnotationComposer,
    $$BudgetsTableTableCreateCompanionBuilder,
    $$BudgetsTableTableUpdateCompanionBuilder,
    (
      BudgetsTableData,
      BaseReferences<_$AppDatabase, $BudgetsTableTable, BudgetsTableData>
    ),
    BudgetsTableData,
    PrefetchHooks Function()> {
  $$BudgetsTableTableTableManager(_$AppDatabase db, $BudgetsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<int> periodMonth = const Value.absent(),
            Value<int> periodYear = const Value.absent(),
            Value<double> budgetAmount = const Value.absent(),
            Value<double> alertThresholdPercent = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BudgetsTableCompanion(
            id: id,
            category: category,
            periodMonth: periodMonth,
            periodYear: periodYear,
            budgetAmount: budgetAmount,
            alertThresholdPercent: alertThresholdPercent,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String category,
            required int periodMonth,
            required int periodYear,
            required double budgetAmount,
            Value<double> alertThresholdPercent = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BudgetsTableCompanion.insert(
            id: id,
            category: category,
            periodMonth: periodMonth,
            periodYear: periodYear,
            budgetAmount: budgetAmount,
            alertThresholdPercent: alertThresholdPercent,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BudgetsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BudgetsTableTable,
    BudgetsTableData,
    $$BudgetsTableTableFilterComposer,
    $$BudgetsTableTableOrderingComposer,
    $$BudgetsTableTableAnnotationComposer,
    $$BudgetsTableTableCreateCompanionBuilder,
    $$BudgetsTableTableUpdateCompanionBuilder,
    (
      BudgetsTableData,
      BaseReferences<_$AppDatabase, $BudgetsTableTable, BudgetsTableData>
    ),
    BudgetsTableData,
    PrefetchHooks Function()>;
typedef $$SubscriptionsTableTableCreateCompanionBuilder
    = SubscriptionsTableCompanion Function({
  required String id,
  required String name,
  required double amount,
  required String billingCycle,
  required DateTime nextChargeDate,
  Value<bool> isActive,
  required String detectionSource,
  Value<int> rowid,
});
typedef $$SubscriptionsTableTableUpdateCompanionBuilder
    = SubscriptionsTableCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<double> amount,
  Value<String> billingCycle,
  Value<DateTime> nextChargeDate,
  Value<bool> isActive,
  Value<String> detectionSource,
  Value<int> rowid,
});

class $$SubscriptionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SubscriptionsTableTable> {
  $$SubscriptionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get billingCycle => $composableBuilder(
      column: $table.billingCycle, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextChargeDate => $composableBuilder(
      column: $table.nextChargeDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get detectionSource => $composableBuilder(
      column: $table.detectionSource,
      builder: (column) => ColumnFilters(column));
}

class $$SubscriptionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SubscriptionsTableTable> {
  $$SubscriptionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get billingCycle => $composableBuilder(
      column: $table.billingCycle,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextChargeDate => $composableBuilder(
      column: $table.nextChargeDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get detectionSource => $composableBuilder(
      column: $table.detectionSource,
      builder: (column) => ColumnOrderings(column));
}

class $$SubscriptionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubscriptionsTableTable> {
  $$SubscriptionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get billingCycle => $composableBuilder(
      column: $table.billingCycle, builder: (column) => column);

  GeneratedColumn<DateTime> get nextChargeDate => $composableBuilder(
      column: $table.nextChargeDate, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get detectionSource => $composableBuilder(
      column: $table.detectionSource, builder: (column) => column);
}

class $$SubscriptionsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SubscriptionsTableTable,
    SubscriptionsTableData,
    $$SubscriptionsTableTableFilterComposer,
    $$SubscriptionsTableTableOrderingComposer,
    $$SubscriptionsTableTableAnnotationComposer,
    $$SubscriptionsTableTableCreateCompanionBuilder,
    $$SubscriptionsTableTableUpdateCompanionBuilder,
    (
      SubscriptionsTableData,
      BaseReferences<_$AppDatabase, $SubscriptionsTableTable,
          SubscriptionsTableData>
    ),
    SubscriptionsTableData,
    PrefetchHooks Function()> {
  $$SubscriptionsTableTableTableManager(
      _$AppDatabase db, $SubscriptionsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubscriptionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubscriptionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubscriptionsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> billingCycle = const Value.absent(),
            Value<DateTime> nextChargeDate = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String> detectionSource = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SubscriptionsTableCompanion(
            id: id,
            name: name,
            amount: amount,
            billingCycle: billingCycle,
            nextChargeDate: nextChargeDate,
            isActive: isActive,
            detectionSource: detectionSource,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required double amount,
            required String billingCycle,
            required DateTime nextChargeDate,
            Value<bool> isActive = const Value.absent(),
            required String detectionSource,
            Value<int> rowid = const Value.absent(),
          }) =>
              SubscriptionsTableCompanion.insert(
            id: id,
            name: name,
            amount: amount,
            billingCycle: billingCycle,
            nextChargeDate: nextChargeDate,
            isActive: isActive,
            detectionSource: detectionSource,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SubscriptionsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SubscriptionsTableTable,
    SubscriptionsTableData,
    $$SubscriptionsTableTableFilterComposer,
    $$SubscriptionsTableTableOrderingComposer,
    $$SubscriptionsTableTableAnnotationComposer,
    $$SubscriptionsTableTableCreateCompanionBuilder,
    $$SubscriptionsTableTableUpdateCompanionBuilder,
    (
      SubscriptionsTableData,
      BaseReferences<_$AppDatabase, $SubscriptionsTableTable,
          SubscriptionsTableData>
    ),
    SubscriptionsTableData,
    PrefetchHooks Function()>;
typedef $$CalendarEventsTableTableCreateCompanionBuilder
    = CalendarEventsTableCompanion Function({
  required String id,
  required String type,
  required String title,
  Value<String?> description,
  required DateTime eventDate,
  Value<double?> amount,
  Value<int> rowid,
});
typedef $$CalendarEventsTableTableUpdateCompanionBuilder
    = CalendarEventsTableCompanion Function({
  Value<String> id,
  Value<String> type,
  Value<String> title,
  Value<String?> description,
  Value<DateTime> eventDate,
  Value<double?> amount,
  Value<int> rowid,
});

class $$CalendarEventsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CalendarEventsTableTable> {
  $$CalendarEventsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get eventDate => $composableBuilder(
      column: $table.eventDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));
}

class $$CalendarEventsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CalendarEventsTableTable> {
  $$CalendarEventsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get eventDate => $composableBuilder(
      column: $table.eventDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));
}

class $$CalendarEventsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CalendarEventsTableTable> {
  $$CalendarEventsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get eventDate =>
      $composableBuilder(column: $table.eventDate, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);
}

class $$CalendarEventsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CalendarEventsTableTable,
    CalendarEventsTableData,
    $$CalendarEventsTableTableFilterComposer,
    $$CalendarEventsTableTableOrderingComposer,
    $$CalendarEventsTableTableAnnotationComposer,
    $$CalendarEventsTableTableCreateCompanionBuilder,
    $$CalendarEventsTableTableUpdateCompanionBuilder,
    (
      CalendarEventsTableData,
      BaseReferences<_$AppDatabase, $CalendarEventsTableTable,
          CalendarEventsTableData>
    ),
    CalendarEventsTableData,
    PrefetchHooks Function()> {
  $$CalendarEventsTableTableTableManager(
      _$AppDatabase db, $CalendarEventsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalendarEventsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalendarEventsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CalendarEventsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> eventDate = const Value.absent(),
            Value<double?> amount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CalendarEventsTableCompanion(
            id: id,
            type: type,
            title: title,
            description: description,
            eventDate: eventDate,
            amount: amount,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String type,
            required String title,
            Value<String?> description = const Value.absent(),
            required DateTime eventDate,
            Value<double?> amount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CalendarEventsTableCompanion.insert(
            id: id,
            type: type,
            title: title,
            description: description,
            eventDate: eventDate,
            amount: amount,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CalendarEventsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CalendarEventsTableTable,
    CalendarEventsTableData,
    $$CalendarEventsTableTableFilterComposer,
    $$CalendarEventsTableTableOrderingComposer,
    $$CalendarEventsTableTableAnnotationComposer,
    $$CalendarEventsTableTableCreateCompanionBuilder,
    $$CalendarEventsTableTableUpdateCompanionBuilder,
    (
      CalendarEventsTableData,
      BaseReferences<_$AppDatabase, $CalendarEventsTableTable,
          CalendarEventsTableData>
    ),
    CalendarEventsTableData,
    PrefetchHooks Function()>;
typedef $$SyncQueueTableTableCreateCompanionBuilder = SyncQueueTableCompanion
    Function({
  required String id,
  Value<String?> userId,
  required String localEntityType,
  required String localEntityId,
  required String operation,
  Value<String?> clientMutationId,
  required String payloadJson,
  Value<String> status,
  Value<int> retryCount,
  Value<String?> lastError,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$SyncQueueTableTableUpdateCompanionBuilder = SyncQueueTableCompanion
    Function({
  Value<String> id,
  Value<String?> userId,
  Value<String> localEntityType,
  Value<String> localEntityId,
  Value<String> operation,
  Value<String?> clientMutationId,
  Value<String> payloadJson,
  Value<String> status,
  Value<int> retryCount,
  Value<String?> lastError,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$SyncQueueTableTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localEntityType => $composableBuilder(
      column: $table.localEntityType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localEntityId => $composableBuilder(
      column: $table.localEntityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clientMutationId => $composableBuilder(
      column: $table.clientMutationId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SyncQueueTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localEntityType => $composableBuilder(
      column: $table.localEntityType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localEntityId => $composableBuilder(
      column: $table.localEntityId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clientMutationId => $composableBuilder(
      column: $table.clientMutationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncQueueTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get localEntityType => $composableBuilder(
      column: $table.localEntityType, builder: (column) => column);

  GeneratedColumn<String> get localEntityId => $composableBuilder(
      column: $table.localEntityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get clientMutationId => $composableBuilder(
      column: $table.clientMutationId, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncQueueTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTableTable,
    SyncQueueTableData,
    $$SyncQueueTableTableFilterComposer,
    $$SyncQueueTableTableOrderingComposer,
    $$SyncQueueTableTableAnnotationComposer,
    $$SyncQueueTableTableCreateCompanionBuilder,
    $$SyncQueueTableTableUpdateCompanionBuilder,
    (
      SyncQueueTableData,
      BaseReferences<_$AppDatabase, $SyncQueueTableTable, SyncQueueTableData>
    ),
    SyncQueueTableData,
    PrefetchHooks Function()> {
  $$SyncQueueTableTableTableManager(
      _$AppDatabase db, $SyncQueueTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<String> localEntityType = const Value.absent(),
            Value<String> localEntityId = const Value.absent(),
            Value<String> operation = const Value.absent(),
            Value<String?> clientMutationId = const Value.absent(),
            Value<String> payloadJson = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueTableCompanion(
            id: id,
            userId: userId,
            localEntityType: localEntityType,
            localEntityId: localEntityId,
            operation: operation,
            clientMutationId: clientMutationId,
            payloadJson: payloadJson,
            status: status,
            retryCount: retryCount,
            lastError: lastError,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> userId = const Value.absent(),
            required String localEntityType,
            required String localEntityId,
            required String operation,
            Value<String?> clientMutationId = const Value.absent(),
            required String payloadJson,
            Value<String> status = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueTableCompanion.insert(
            id: id,
            userId: userId,
            localEntityType: localEntityType,
            localEntityId: localEntityId,
            operation: operation,
            clientMutationId: clientMutationId,
            payloadJson: payloadJson,
            status: status,
            retryCount: retryCount,
            lastError: lastError,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncQueueTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueTableTable,
    SyncQueueTableData,
    $$SyncQueueTableTableFilterComposer,
    $$SyncQueueTableTableOrderingComposer,
    $$SyncQueueTableTableAnnotationComposer,
    $$SyncQueueTableTableCreateCompanionBuilder,
    $$SyncQueueTableTableUpdateCompanionBuilder,
    (
      SyncQueueTableData,
      BaseReferences<_$AppDatabase, $SyncQueueTableTable, SyncQueueTableData>
    ),
    SyncQueueTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppPreferencesTableTableTableManager get appPreferencesTable =>
      $$AppPreferencesTableTableTableManager(_db, _db.appPreferencesTable);
  $$AccountsTableTableTableManager get accountsTable =>
      $$AccountsTableTableTableManager(_db, _db.accountsTable);
  $$CardsTableTableTableManager get cardsTable =>
      $$CardsTableTableTableManager(_db, _db.cardsTable);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(_db, _db.categoriesTable);
  $$TransactionsTableTableTableManager get transactionsTable =>
      $$TransactionsTableTableTableManager(_db, _db.transactionsTable);
  $$GoalsTableTableTableManager get goalsTable =>
      $$GoalsTableTableTableManager(_db, _db.goalsTable);
  $$BudgetsTableTableTableManager get budgetsTable =>
      $$BudgetsTableTableTableManager(_db, _db.budgetsTable);
  $$SubscriptionsTableTableTableManager get subscriptionsTable =>
      $$SubscriptionsTableTableTableManager(_db, _db.subscriptionsTable);
  $$CalendarEventsTableTableTableManager get calendarEventsTable =>
      $$CalendarEventsTableTableTableManager(_db, _db.calendarEventsTable);
  $$SyncQueueTableTableTableManager get syncQueueTable =>
      $$SyncQueueTableTableTableManager(_db, _db.syncQueueTable);
}
