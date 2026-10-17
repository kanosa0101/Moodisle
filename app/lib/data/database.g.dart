// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $EmotionCatalogTable extends EmotionCatalog
    with TableInfo<$EmotionCatalogTable, EmotionCatalogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmotionCatalogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [code];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emotion_catalog';
  @override
  VerificationContext validateIntegrity(Insertable<EmotionCatalogData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  EmotionCatalogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmotionCatalogData(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
    );
  }

  @override
  $EmotionCatalogTable createAlias(String alias) {
    return $EmotionCatalogTable(attachedDatabase, alias);
  }
}

class EmotionCatalogData extends DataClass
    implements Insertable<EmotionCatalogData> {
  final String code;
  const EmotionCatalogData({required this.code});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    return map;
  }

  EmotionCatalogCompanion toCompanion(bool nullToAbsent) {
    return EmotionCatalogCompanion(
      code: Value(code),
    );
  }

  factory EmotionCatalogData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmotionCatalogData(
      code: serializer.fromJson<String>(json['code']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
    };
  }

  EmotionCatalogData copyWith({String? code}) => EmotionCatalogData(
        code: code ?? this.code,
      );
  EmotionCatalogData copyWithCompanion(EmotionCatalogCompanion data) {
    return EmotionCatalogData(
      code: data.code.present ? data.code.value : this.code,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmotionCatalogData(')
          ..write('code: $code')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => code.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmotionCatalogData && other.code == this.code);
}

class EmotionCatalogCompanion extends UpdateCompanion<EmotionCatalogData> {
  final Value<String> code;
  final Value<int> rowid;
  const EmotionCatalogCompanion({
    this.code = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmotionCatalogCompanion.insert({
    required String code,
    this.rowid = const Value.absent(),
  }) : code = Value(code);
  static Insertable<EmotionCatalogData> custom({
    Expression<String>? code,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmotionCatalogCompanion copyWith({Value<String>? code, Value<int>? rowid}) {
    return EmotionCatalogCompanion(
      code: code ?? this.code,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmotionCatalogCompanion(')
          ..write('code: $code, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ItemCatalogTable extends ItemCatalog
    with TableInfo<$ItemCatalogTable, ItemCatalogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemCatalogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [code];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_catalog';
  @override
  VerificationContext validateIntegrity(Insertable<ItemCatalogData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  ItemCatalogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemCatalogData(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
    );
  }

  @override
  $ItemCatalogTable createAlias(String alias) {
    return $ItemCatalogTable(attachedDatabase, alias);
  }
}

class ItemCatalogData extends DataClass implements Insertable<ItemCatalogData> {
  final String code;
  const ItemCatalogData({required this.code});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    return map;
  }

  ItemCatalogCompanion toCompanion(bool nullToAbsent) {
    return ItemCatalogCompanion(
      code: Value(code),
    );
  }

  factory ItemCatalogData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemCatalogData(
      code: serializer.fromJson<String>(json['code']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
    };
  }

  ItemCatalogData copyWith({String? code}) => ItemCatalogData(
        code: code ?? this.code,
      );
  ItemCatalogData copyWithCompanion(ItemCatalogCompanion data) {
    return ItemCatalogData(
      code: data.code.present ? data.code.value : this.code,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemCatalogData(')
          ..write('code: $code')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => code.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemCatalogData && other.code == this.code);
}

class ItemCatalogCompanion extends UpdateCompanion<ItemCatalogData> {
  final Value<String> code;
  final Value<int> rowid;
  const ItemCatalogCompanion({
    this.code = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemCatalogCompanion.insert({
    required String code,
    this.rowid = const Value.absent(),
  }) : code = Value(code);
  static Insertable<ItemCatalogData> custom({
    Expression<String>? code,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemCatalogCompanion copyWith({Value<String>? code, Value<int>? rowid}) {
    return ItemCatalogCompanion(
      code: code ?? this.code,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemCatalogCompanion(')
          ..write('code: $code, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyQuestCatalogTable extends DailyQuestCatalog
    with TableInfo<$DailyQuestCatalogTable, DailyQuestCatalogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyQuestCatalogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [code];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_quest_catalog';
  @override
  VerificationContext validateIntegrity(
      Insertable<DailyQuestCatalogData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  DailyQuestCatalogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyQuestCatalogData(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
    );
  }

  @override
  $DailyQuestCatalogTable createAlias(String alias) {
    return $DailyQuestCatalogTable(attachedDatabase, alias);
  }
}

class DailyQuestCatalogData extends DataClass
    implements Insertable<DailyQuestCatalogData> {
  final String code;
  const DailyQuestCatalogData({required this.code});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    return map;
  }

  DailyQuestCatalogCompanion toCompanion(bool nullToAbsent) {
    return DailyQuestCatalogCompanion(
      code: Value(code),
    );
  }

  factory DailyQuestCatalogData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyQuestCatalogData(
      code: serializer.fromJson<String>(json['code']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
    };
  }

  DailyQuestCatalogData copyWith({String? code}) => DailyQuestCatalogData(
        code: code ?? this.code,
      );
  DailyQuestCatalogData copyWithCompanion(DailyQuestCatalogCompanion data) {
    return DailyQuestCatalogData(
      code: data.code.present ? data.code.value : this.code,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyQuestCatalogData(')
          ..write('code: $code')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => code.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyQuestCatalogData && other.code == this.code);
}

class DailyQuestCatalogCompanion
    extends UpdateCompanion<DailyQuestCatalogData> {
  final Value<String> code;
  final Value<int> rowid;
  const DailyQuestCatalogCompanion({
    this.code = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyQuestCatalogCompanion.insert({
    required String code,
    this.rowid = const Value.absent(),
  }) : code = Value(code);
  static Insertable<DailyQuestCatalogData> custom({
    Expression<String>? code,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyQuestCatalogCompanion copyWith(
      {Value<String>? code, Value<int>? rowid}) {
    return DailyQuestCatalogCompanion(
      code: code ?? this.code,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyQuestCatalogCompanion(')
          ..write('code: $code, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SouvenirCatalogTable extends SouvenirCatalog
    with TableInfo<$SouvenirCatalogTable, SouvenirCatalogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SouvenirCatalogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pendantMeta =
      const VerificationMeta('pendant');
  @override
  late final GeneratedColumn<bool> pendant = GeneratedColumn<bool>(
      'pendant', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("pendant" IN (0, 1))'));
  static const VerificationMeta _rarityMeta = const VerificationMeta('rarity');
  @override
  late final GeneratedColumn<int> rarity = GeneratedColumn<int>(
      'rarity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [code, pendant, rarity];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'souvenir_catalog';
  @override
  VerificationContext validateIntegrity(
      Insertable<SouvenirCatalogData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('pendant')) {
      context.handle(_pendantMeta,
          pendant.isAcceptableOrUnknown(data['pendant']!, _pendantMeta));
    } else if (isInserting) {
      context.missing(_pendantMeta);
    }
    if (data.containsKey('rarity')) {
      context.handle(_rarityMeta,
          rarity.isAcceptableOrUnknown(data['rarity']!, _rarityMeta));
    } else if (isInserting) {
      context.missing(_rarityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  SouvenirCatalogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SouvenirCatalogData(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      pendant: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}pendant'])!,
      rarity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rarity'])!,
    );
  }

  @override
  $SouvenirCatalogTable createAlias(String alias) {
    return $SouvenirCatalogTable(attachedDatabase, alias);
  }
}

class SouvenirCatalogData extends DataClass
    implements Insertable<SouvenirCatalogData> {
  final String code;
  final bool pendant;
  final int rarity;
  const SouvenirCatalogData(
      {required this.code, required this.pendant, required this.rarity});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['pendant'] = Variable<bool>(pendant);
    map['rarity'] = Variable<int>(rarity);
    return map;
  }

  SouvenirCatalogCompanion toCompanion(bool nullToAbsent) {
    return SouvenirCatalogCompanion(
      code: Value(code),
      pendant: Value(pendant),
      rarity: Value(rarity),
    );
  }

  factory SouvenirCatalogData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SouvenirCatalogData(
      code: serializer.fromJson<String>(json['code']),
      pendant: serializer.fromJson<bool>(json['pendant']),
      rarity: serializer.fromJson<int>(json['rarity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'pendant': serializer.toJson<bool>(pendant),
      'rarity': serializer.toJson<int>(rarity),
    };
  }

  SouvenirCatalogData copyWith({String? code, bool? pendant, int? rarity}) =>
      SouvenirCatalogData(
        code: code ?? this.code,
        pendant: pendant ?? this.pendant,
        rarity: rarity ?? this.rarity,
      );
  SouvenirCatalogData copyWithCompanion(SouvenirCatalogCompanion data) {
    return SouvenirCatalogData(
      code: data.code.present ? data.code.value : this.code,
      pendant: data.pendant.present ? data.pendant.value : this.pendant,
      rarity: data.rarity.present ? data.rarity.value : this.rarity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SouvenirCatalogData(')
          ..write('code: $code, ')
          ..write('pendant: $pendant, ')
          ..write('rarity: $rarity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, pendant, rarity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SouvenirCatalogData &&
          other.code == this.code &&
          other.pendant == this.pendant &&
          other.rarity == this.rarity);
}

class SouvenirCatalogCompanion extends UpdateCompanion<SouvenirCatalogData> {
  final Value<String> code;
  final Value<bool> pendant;
  final Value<int> rarity;
  final Value<int> rowid;
  const SouvenirCatalogCompanion({
    this.code = const Value.absent(),
    this.pendant = const Value.absent(),
    this.rarity = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SouvenirCatalogCompanion.insert({
    required String code,
    required bool pendant,
    required int rarity,
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        pendant = Value(pendant),
        rarity = Value(rarity);
  static Insertable<SouvenirCatalogData> custom({
    Expression<String>? code,
    Expression<bool>? pendant,
    Expression<int>? rarity,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (pendant != null) 'pendant': pendant,
      if (rarity != null) 'rarity': rarity,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SouvenirCatalogCompanion copyWith(
      {Value<String>? code,
      Value<bool>? pendant,
      Value<int>? rarity,
      Value<int>? rowid}) {
    return SouvenirCatalogCompanion(
      code: code ?? this.code,
      pendant: pendant ?? this.pendant,
      rarity: rarity ?? this.rarity,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (pendant.present) {
      map['pendant'] = Variable<bool>(pendant.value);
    }
    if (rarity.present) {
      map['rarity'] = Variable<int>(rarity.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SouvenirCatalogCompanion(')
          ..write('code: $code, ')
          ..write('pendant: $pendant, ')
          ..write('rarity: $rarity, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlayerProfilesTable extends PlayerProfiles
    with TableInfo<$PlayerProfilesTable, PlayerProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayerProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _saveFormatVersionMeta =
      const VerificationMeta('saveFormatVersion');
  @override
  late final GeneratedColumn<int> saveFormatVersion = GeneratedColumn<int>(
      'save_format_version', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nextTaskIdMeta =
      const VerificationMeta('nextTaskId');
  @override
  late final GeneratedColumn<int> nextTaskId = GeneratedColumn<int>(
      'next_task_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _clearingMeta =
      const VerificationMeta('clearing');
  @override
  late final GeneratedColumn<double> clearing = GeneratedColumn<double>(
      'clearing', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _energyMeta = const VerificationMeta('energy');
  @override
  late final GeneratedColumn<int> energy = GeneratedColumn<int>(
      'energy', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _warmFrontTurnsMeta =
      const VerificationMeta('warmFrontTurns');
  @override
  late final GeneratedColumn<int> warmFrontTurns = GeneratedColumn<int>(
      'warm_front_turns', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tailwindTurnsMeta =
      const VerificationMeta('tailwindTurns');
  @override
  late final GeneratedColumn<int> tailwindTurns = GeneratedColumn<int>(
      'tailwind_turns', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _companionMeta =
      const VerificationMeta('companion');
  @override
  late final GeneratedColumn<String> companion = GeneratedColumn<String>(
      'companion', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES emotion_catalog (code)'));
  static const VerificationMeta _onboardedMeta =
      const VerificationMeta('onboarded');
  @override
  late final GeneratedColumn<bool> onboarded = GeneratedColumn<bool>(
      'onboarded', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("onboarded" IN (0, 1))'));
  static const VerificationMeta _lastReportWeekMeta =
      const VerificationMeta('lastReportWeek');
  @override
  late final GeneratedColumn<String> lastReportWeek = GeneratedColumn<String>(
      'last_report_week', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        saveFormatVersion,
        nextTaskId,
        clearing,
        energy,
        warmFrontTurns,
        tailwindTurns,
        companion,
        onboarded,
        lastReportWeek
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'player_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<PlayerProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('save_format_version')) {
      context.handle(
          _saveFormatVersionMeta,
          saveFormatVersion.isAcceptableOrUnknown(
              data['save_format_version']!, _saveFormatVersionMeta));
    } else if (isInserting) {
      context.missing(_saveFormatVersionMeta);
    }
    if (data.containsKey('next_task_id')) {
      context.handle(
          _nextTaskIdMeta,
          nextTaskId.isAcceptableOrUnknown(
              data['next_task_id']!, _nextTaskIdMeta));
    } else if (isInserting) {
      context.missing(_nextTaskIdMeta);
    }
    if (data.containsKey('clearing')) {
      context.handle(_clearingMeta,
          clearing.isAcceptableOrUnknown(data['clearing']!, _clearingMeta));
    } else if (isInserting) {
      context.missing(_clearingMeta);
    }
    if (data.containsKey('energy')) {
      context.handle(_energyMeta,
          energy.isAcceptableOrUnknown(data['energy']!, _energyMeta));
    } else if (isInserting) {
      context.missing(_energyMeta);
    }
    if (data.containsKey('warm_front_turns')) {
      context.handle(
          _warmFrontTurnsMeta,
          warmFrontTurns.isAcceptableOrUnknown(
              data['warm_front_turns']!, _warmFrontTurnsMeta));
    } else if (isInserting) {
      context.missing(_warmFrontTurnsMeta);
    }
    if (data.containsKey('tailwind_turns')) {
      context.handle(
          _tailwindTurnsMeta,
          tailwindTurns.isAcceptableOrUnknown(
              data['tailwind_turns']!, _tailwindTurnsMeta));
    } else if (isInserting) {
      context.missing(_tailwindTurnsMeta);
    }
    if (data.containsKey('companion')) {
      context.handle(_companionMeta,
          companion.isAcceptableOrUnknown(data['companion']!, _companionMeta));
    }
    if (data.containsKey('onboarded')) {
      context.handle(_onboardedMeta,
          onboarded.isAcceptableOrUnknown(data['onboarded']!, _onboardedMeta));
    } else if (isInserting) {
      context.missing(_onboardedMeta);
    }
    if (data.containsKey('last_report_week')) {
      context.handle(
          _lastReportWeekMeta,
          lastReportWeek.isAcceptableOrUnknown(
              data['last_report_week']!, _lastReportWeekMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayerProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayerProfile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      saveFormatVersion: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}save_format_version'])!,
      nextTaskId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}next_task_id'])!,
      clearing: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}clearing'])!,
      energy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}energy'])!,
      warmFrontTurns: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}warm_front_turns'])!,
      tailwindTurns: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tailwind_turns'])!,
      companion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}companion']),
      onboarded: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}onboarded'])!,
      lastReportWeek: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_report_week']),
    );
  }

  @override
  $PlayerProfilesTable createAlias(String alias) {
    return $PlayerProfilesTable(attachedDatabase, alias);
  }
}

class PlayerProfile extends DataClass implements Insertable<PlayerProfile> {
  final int id;
  final int saveFormatVersion;
  final int nextTaskId;
  final double clearing;
  final int energy;
  final int warmFrontTurns;
  final int tailwindTurns;
  final String? companion;
  final bool onboarded;
  final String? lastReportWeek;
  const PlayerProfile(
      {required this.id,
      required this.saveFormatVersion,
      required this.nextTaskId,
      required this.clearing,
      required this.energy,
      required this.warmFrontTurns,
      required this.tailwindTurns,
      this.companion,
      required this.onboarded,
      this.lastReportWeek});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['save_format_version'] = Variable<int>(saveFormatVersion);
    map['next_task_id'] = Variable<int>(nextTaskId);
    map['clearing'] = Variable<double>(clearing);
    map['energy'] = Variable<int>(energy);
    map['warm_front_turns'] = Variable<int>(warmFrontTurns);
    map['tailwind_turns'] = Variable<int>(tailwindTurns);
    if (!nullToAbsent || companion != null) {
      map['companion'] = Variable<String>(companion);
    }
    map['onboarded'] = Variable<bool>(onboarded);
    if (!nullToAbsent || lastReportWeek != null) {
      map['last_report_week'] = Variable<String>(lastReportWeek);
    }
    return map;
  }

  PlayerProfilesCompanion toCompanion(bool nullToAbsent) {
    return PlayerProfilesCompanion(
      id: Value(id),
      saveFormatVersion: Value(saveFormatVersion),
      nextTaskId: Value(nextTaskId),
      clearing: Value(clearing),
      energy: Value(energy),
      warmFrontTurns: Value(warmFrontTurns),
      tailwindTurns: Value(tailwindTurns),
      companion: companion == null && nullToAbsent
          ? const Value.absent()
          : Value(companion),
      onboarded: Value(onboarded),
      lastReportWeek: lastReportWeek == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReportWeek),
    );
  }

  factory PlayerProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayerProfile(
      id: serializer.fromJson<int>(json['id']),
      saveFormatVersion: serializer.fromJson<int>(json['saveFormatVersion']),
      nextTaskId: serializer.fromJson<int>(json['nextTaskId']),
      clearing: serializer.fromJson<double>(json['clearing']),
      energy: serializer.fromJson<int>(json['energy']),
      warmFrontTurns: serializer.fromJson<int>(json['warmFrontTurns']),
      tailwindTurns: serializer.fromJson<int>(json['tailwindTurns']),
      companion: serializer.fromJson<String?>(json['companion']),
      onboarded: serializer.fromJson<bool>(json['onboarded']),
      lastReportWeek: serializer.fromJson<String?>(json['lastReportWeek']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'saveFormatVersion': serializer.toJson<int>(saveFormatVersion),
      'nextTaskId': serializer.toJson<int>(nextTaskId),
      'clearing': serializer.toJson<double>(clearing),
      'energy': serializer.toJson<int>(energy),
      'warmFrontTurns': serializer.toJson<int>(warmFrontTurns),
      'tailwindTurns': serializer.toJson<int>(tailwindTurns),
      'companion': serializer.toJson<String?>(companion),
      'onboarded': serializer.toJson<bool>(onboarded),
      'lastReportWeek': serializer.toJson<String?>(lastReportWeek),
    };
  }

  PlayerProfile copyWith(
          {int? id,
          int? saveFormatVersion,
          int? nextTaskId,
          double? clearing,
          int? energy,
          int? warmFrontTurns,
          int? tailwindTurns,
          Value<String?> companion = const Value.absent(),
          bool? onboarded,
          Value<String?> lastReportWeek = const Value.absent()}) =>
      PlayerProfile(
        id: id ?? this.id,
        saveFormatVersion: saveFormatVersion ?? this.saveFormatVersion,
        nextTaskId: nextTaskId ?? this.nextTaskId,
        clearing: clearing ?? this.clearing,
        energy: energy ?? this.energy,
        warmFrontTurns: warmFrontTurns ?? this.warmFrontTurns,
        tailwindTurns: tailwindTurns ?? this.tailwindTurns,
        companion: companion.present ? companion.value : this.companion,
        onboarded: onboarded ?? this.onboarded,
        lastReportWeek:
            lastReportWeek.present ? lastReportWeek.value : this.lastReportWeek,
      );
  PlayerProfile copyWithCompanion(PlayerProfilesCompanion data) {
    return PlayerProfile(
      id: data.id.present ? data.id.value : this.id,
      saveFormatVersion: data.saveFormatVersion.present
          ? data.saveFormatVersion.value
          : this.saveFormatVersion,
      nextTaskId:
          data.nextTaskId.present ? data.nextTaskId.value : this.nextTaskId,
      clearing: data.clearing.present ? data.clearing.value : this.clearing,
      energy: data.energy.present ? data.energy.value : this.energy,
      warmFrontTurns: data.warmFrontTurns.present
          ? data.warmFrontTurns.value
          : this.warmFrontTurns,
      tailwindTurns: data.tailwindTurns.present
          ? data.tailwindTurns.value
          : this.tailwindTurns,
      companion: data.companion.present ? data.companion.value : this.companion,
      onboarded: data.onboarded.present ? data.onboarded.value : this.onboarded,
      lastReportWeek: data.lastReportWeek.present
          ? data.lastReportWeek.value
          : this.lastReportWeek,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayerProfile(')
          ..write('id: $id, ')
          ..write('saveFormatVersion: $saveFormatVersion, ')
          ..write('nextTaskId: $nextTaskId, ')
          ..write('clearing: $clearing, ')
          ..write('energy: $energy, ')
          ..write('warmFrontTurns: $warmFrontTurns, ')
          ..write('tailwindTurns: $tailwindTurns, ')
          ..write('companion: $companion, ')
          ..write('onboarded: $onboarded, ')
          ..write('lastReportWeek: $lastReportWeek')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      saveFormatVersion,
      nextTaskId,
      clearing,
      energy,
      warmFrontTurns,
      tailwindTurns,
      companion,
      onboarded,
      lastReportWeek);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayerProfile &&
          other.id == this.id &&
          other.saveFormatVersion == this.saveFormatVersion &&
          other.nextTaskId == this.nextTaskId &&
          other.clearing == this.clearing &&
          other.energy == this.energy &&
          other.warmFrontTurns == this.warmFrontTurns &&
          other.tailwindTurns == this.tailwindTurns &&
          other.companion == this.companion &&
          other.onboarded == this.onboarded &&
          other.lastReportWeek == this.lastReportWeek);
}

class PlayerProfilesCompanion extends UpdateCompanion<PlayerProfile> {
  final Value<int> id;
  final Value<int> saveFormatVersion;
  final Value<int> nextTaskId;
  final Value<double> clearing;
  final Value<int> energy;
  final Value<int> warmFrontTurns;
  final Value<int> tailwindTurns;
  final Value<String?> companion;
  final Value<bool> onboarded;
  final Value<String?> lastReportWeek;
  const PlayerProfilesCompanion({
    this.id = const Value.absent(),
    this.saveFormatVersion = const Value.absent(),
    this.nextTaskId = const Value.absent(),
    this.clearing = const Value.absent(),
    this.energy = const Value.absent(),
    this.warmFrontTurns = const Value.absent(),
    this.tailwindTurns = const Value.absent(),
    this.companion = const Value.absent(),
    this.onboarded = const Value.absent(),
    this.lastReportWeek = const Value.absent(),
  });
  PlayerProfilesCompanion.insert({
    this.id = const Value.absent(),
    required int saveFormatVersion,
    required int nextTaskId,
    required double clearing,
    required int energy,
    required int warmFrontTurns,
    required int tailwindTurns,
    this.companion = const Value.absent(),
    required bool onboarded,
    this.lastReportWeek = const Value.absent(),
  })  : saveFormatVersion = Value(saveFormatVersion),
        nextTaskId = Value(nextTaskId),
        clearing = Value(clearing),
        energy = Value(energy),
        warmFrontTurns = Value(warmFrontTurns),
        tailwindTurns = Value(tailwindTurns),
        onboarded = Value(onboarded);
  static Insertable<PlayerProfile> custom({
    Expression<int>? id,
    Expression<int>? saveFormatVersion,
    Expression<int>? nextTaskId,
    Expression<double>? clearing,
    Expression<int>? energy,
    Expression<int>? warmFrontTurns,
    Expression<int>? tailwindTurns,
    Expression<String>? companion,
    Expression<bool>? onboarded,
    Expression<String>? lastReportWeek,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saveFormatVersion != null) 'save_format_version': saveFormatVersion,
      if (nextTaskId != null) 'next_task_id': nextTaskId,
      if (clearing != null) 'clearing': clearing,
      if (energy != null) 'energy': energy,
      if (warmFrontTurns != null) 'warm_front_turns': warmFrontTurns,
      if (tailwindTurns != null) 'tailwind_turns': tailwindTurns,
      if (companion != null) 'companion': companion,
      if (onboarded != null) 'onboarded': onboarded,
      if (lastReportWeek != null) 'last_report_week': lastReportWeek,
    });
  }

  PlayerProfilesCompanion copyWith(
      {Value<int>? id,
      Value<int>? saveFormatVersion,
      Value<int>? nextTaskId,
      Value<double>? clearing,
      Value<int>? energy,
      Value<int>? warmFrontTurns,
      Value<int>? tailwindTurns,
      Value<String?>? companion,
      Value<bool>? onboarded,
      Value<String?>? lastReportWeek}) {
    return PlayerProfilesCompanion(
      id: id ?? this.id,
      saveFormatVersion: saveFormatVersion ?? this.saveFormatVersion,
      nextTaskId: nextTaskId ?? this.nextTaskId,
      clearing: clearing ?? this.clearing,
      energy: energy ?? this.energy,
      warmFrontTurns: warmFrontTurns ?? this.warmFrontTurns,
      tailwindTurns: tailwindTurns ?? this.tailwindTurns,
      companion: companion ?? this.companion,
      onboarded: onboarded ?? this.onboarded,
      lastReportWeek: lastReportWeek ?? this.lastReportWeek,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (saveFormatVersion.present) {
      map['save_format_version'] = Variable<int>(saveFormatVersion.value);
    }
    if (nextTaskId.present) {
      map['next_task_id'] = Variable<int>(nextTaskId.value);
    }
    if (clearing.present) {
      map['clearing'] = Variable<double>(clearing.value);
    }
    if (energy.present) {
      map['energy'] = Variable<int>(energy.value);
    }
    if (warmFrontTurns.present) {
      map['warm_front_turns'] = Variable<int>(warmFrontTurns.value);
    }
    if (tailwindTurns.present) {
      map['tailwind_turns'] = Variable<int>(tailwindTurns.value);
    }
    if (companion.present) {
      map['companion'] = Variable<String>(companion.value);
    }
    if (onboarded.present) {
      map['onboarded'] = Variable<bool>(onboarded.value);
    }
    if (lastReportWeek.present) {
      map['last_report_week'] = Variable<String>(lastReportWeek.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayerProfilesCompanion(')
          ..write('id: $id, ')
          ..write('saveFormatVersion: $saveFormatVersion, ')
          ..write('nextTaskId: $nextTaskId, ')
          ..write('clearing: $clearing, ')
          ..write('energy: $energy, ')
          ..write('warmFrontTurns: $warmFrontTurns, ')
          ..write('tailwindTurns: $tailwindTurns, ')
          ..write('companion: $companion, ')
          ..write('onboarded: $onboarded, ')
          ..write('lastReportWeek: $lastReportWeek')
          ..write(')'))
        .toString();
  }
}

class $TaskRowsTable extends TaskRows with TableInfo<$TaskRowsTable, TaskRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL CHECK (position >= 0)');
  static const VerificationMeta _taskTextMeta =
      const VerificationMeta('taskText');
  @override
  late final GeneratedColumn<String> taskText = GeneratedColumn<String>(
      'task_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emotionMeta =
      const VerificationMeta('emotion');
  @override
  late final GeneratedColumn<String> emotion = GeneratedColumn<String>(
      'emotion', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES emotion_catalog (code)'));
  static const VerificationMeta _difficultyMeta =
      const VerificationMeta('difficulty');
  @override
  late final GeneratedColumn<int> difficulty = GeneratedColumn<int>(
      'difficulty', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL CHECK (difficulty BETWEEN 1 AND 3)');
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL CHECK (status IN (\'pending\', \'done\'))');
  static const VerificationMeta _createdOnMeta =
      const VerificationMeta('createdOn');
  @override
  late final GeneratedColumn<String> createdOn = GeneratedColumn<String>(
      'created_on', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pinnedMeta = const VerificationMeta('pinned');
  @override
  late final GeneratedColumn<bool> pinned = GeneratedColumn<bool>(
      'pinned', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("pinned" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, position, taskText, emotion, difficulty, status, createdOn, pinned];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(Insertable<TaskRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('task_text')) {
      context.handle(_taskTextMeta,
          taskText.isAcceptableOrUnknown(data['task_text']!, _taskTextMeta));
    } else if (isInserting) {
      context.missing(_taskTextMeta);
    }
    if (data.containsKey('emotion')) {
      context.handle(_emotionMeta,
          emotion.isAcceptableOrUnknown(data['emotion']!, _emotionMeta));
    } else if (isInserting) {
      context.missing(_emotionMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
          _difficultyMeta,
          difficulty.isAcceptableOrUnknown(
              data['difficulty']!, _difficultyMeta));
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_on')) {
      context.handle(_createdOnMeta,
          createdOn.isAcceptableOrUnknown(data['created_on']!, _createdOnMeta));
    } else if (isInserting) {
      context.missing(_createdOnMeta);
    }
    if (data.containsKey('pinned')) {
      context.handle(_pinnedMeta,
          pinned.isAcceptableOrUnknown(data['pinned']!, _pinnedMeta));
    } else if (isInserting) {
      context.missing(_pinnedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      taskText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_text'])!,
      emotion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}emotion'])!,
      difficulty: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}difficulty'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdOn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_on'])!,
      pinned: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}pinned'])!,
    );
  }

  @override
  $TaskRowsTable createAlias(String alias) {
    return $TaskRowsTable(attachedDatabase, alias);
  }
}

class TaskRow extends DataClass implements Insertable<TaskRow> {
  final int id;
  final int position;
  final String taskText;
  final String emotion;
  final int difficulty;
  final String status;
  final String createdOn;
  final bool pinned;
  const TaskRow(
      {required this.id,
      required this.position,
      required this.taskText,
      required this.emotion,
      required this.difficulty,
      required this.status,
      required this.createdOn,
      required this.pinned});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['position'] = Variable<int>(position);
    map['task_text'] = Variable<String>(taskText);
    map['emotion'] = Variable<String>(emotion);
    map['difficulty'] = Variable<int>(difficulty);
    map['status'] = Variable<String>(status);
    map['created_on'] = Variable<String>(createdOn);
    map['pinned'] = Variable<bool>(pinned);
    return map;
  }

  TaskRowsCompanion toCompanion(bool nullToAbsent) {
    return TaskRowsCompanion(
      id: Value(id),
      position: Value(position),
      taskText: Value(taskText),
      emotion: Value(emotion),
      difficulty: Value(difficulty),
      status: Value(status),
      createdOn: Value(createdOn),
      pinned: Value(pinned),
    );
  }

  factory TaskRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskRow(
      id: serializer.fromJson<int>(json['id']),
      position: serializer.fromJson<int>(json['position']),
      taskText: serializer.fromJson<String>(json['taskText']),
      emotion: serializer.fromJson<String>(json['emotion']),
      difficulty: serializer.fromJson<int>(json['difficulty']),
      status: serializer.fromJson<String>(json['status']),
      createdOn: serializer.fromJson<String>(json['createdOn']),
      pinned: serializer.fromJson<bool>(json['pinned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'position': serializer.toJson<int>(position),
      'taskText': serializer.toJson<String>(taskText),
      'emotion': serializer.toJson<String>(emotion),
      'difficulty': serializer.toJson<int>(difficulty),
      'status': serializer.toJson<String>(status),
      'createdOn': serializer.toJson<String>(createdOn),
      'pinned': serializer.toJson<bool>(pinned),
    };
  }

  TaskRow copyWith(
          {int? id,
          int? position,
          String? taskText,
          String? emotion,
          int? difficulty,
          String? status,
          String? createdOn,
          bool? pinned}) =>
      TaskRow(
        id: id ?? this.id,
        position: position ?? this.position,
        taskText: taskText ?? this.taskText,
        emotion: emotion ?? this.emotion,
        difficulty: difficulty ?? this.difficulty,
        status: status ?? this.status,
        createdOn: createdOn ?? this.createdOn,
        pinned: pinned ?? this.pinned,
      );
  TaskRow copyWithCompanion(TaskRowsCompanion data) {
    return TaskRow(
      id: data.id.present ? data.id.value : this.id,
      position: data.position.present ? data.position.value : this.position,
      taskText: data.taskText.present ? data.taskText.value : this.taskText,
      emotion: data.emotion.present ? data.emotion.value : this.emotion,
      difficulty:
          data.difficulty.present ? data.difficulty.value : this.difficulty,
      status: data.status.present ? data.status.value : this.status,
      createdOn: data.createdOn.present ? data.createdOn.value : this.createdOn,
      pinned: data.pinned.present ? data.pinned.value : this.pinned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskRow(')
          ..write('id: $id, ')
          ..write('position: $position, ')
          ..write('taskText: $taskText, ')
          ..write('emotion: $emotion, ')
          ..write('difficulty: $difficulty, ')
          ..write('status: $status, ')
          ..write('createdOn: $createdOn, ')
          ..write('pinned: $pinned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, position, taskText, emotion, difficulty, status, createdOn, pinned);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskRow &&
          other.id == this.id &&
          other.position == this.position &&
          other.taskText == this.taskText &&
          other.emotion == this.emotion &&
          other.difficulty == this.difficulty &&
          other.status == this.status &&
          other.createdOn == this.createdOn &&
          other.pinned == this.pinned);
}

class TaskRowsCompanion extends UpdateCompanion<TaskRow> {
  final Value<int> id;
  final Value<int> position;
  final Value<String> taskText;
  final Value<String> emotion;
  final Value<int> difficulty;
  final Value<String> status;
  final Value<String> createdOn;
  final Value<bool> pinned;
  const TaskRowsCompanion({
    this.id = const Value.absent(),
    this.position = const Value.absent(),
    this.taskText = const Value.absent(),
    this.emotion = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.status = const Value.absent(),
    this.createdOn = const Value.absent(),
    this.pinned = const Value.absent(),
  });
  TaskRowsCompanion.insert({
    this.id = const Value.absent(),
    required int position,
    required String taskText,
    required String emotion,
    required int difficulty,
    required String status,
    required String createdOn,
    required bool pinned,
  })  : position = Value(position),
        taskText = Value(taskText),
        emotion = Value(emotion),
        difficulty = Value(difficulty),
        status = Value(status),
        createdOn = Value(createdOn),
        pinned = Value(pinned);
  static Insertable<TaskRow> custom({
    Expression<int>? id,
    Expression<int>? position,
    Expression<String>? taskText,
    Expression<String>? emotion,
    Expression<int>? difficulty,
    Expression<String>? status,
    Expression<String>? createdOn,
    Expression<bool>? pinned,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (position != null) 'position': position,
      if (taskText != null) 'task_text': taskText,
      if (emotion != null) 'emotion': emotion,
      if (difficulty != null) 'difficulty': difficulty,
      if (status != null) 'status': status,
      if (createdOn != null) 'created_on': createdOn,
      if (pinned != null) 'pinned': pinned,
    });
  }

  TaskRowsCompanion copyWith(
      {Value<int>? id,
      Value<int>? position,
      Value<String>? taskText,
      Value<String>? emotion,
      Value<int>? difficulty,
      Value<String>? status,
      Value<String>? createdOn,
      Value<bool>? pinned}) {
    return TaskRowsCompanion(
      id: id ?? this.id,
      position: position ?? this.position,
      taskText: taskText ?? this.taskText,
      emotion: emotion ?? this.emotion,
      difficulty: difficulty ?? this.difficulty,
      status: status ?? this.status,
      createdOn: createdOn ?? this.createdOn,
      pinned: pinned ?? this.pinned,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (taskText.present) {
      map['task_text'] = Variable<String>(taskText.value);
    }
    if (emotion.present) {
      map['emotion'] = Variable<String>(emotion.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<int>(difficulty.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdOn.present) {
      map['created_on'] = Variable<String>(createdOn.value);
    }
    if (pinned.present) {
      map['pinned'] = Variable<bool>(pinned.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskRowsCompanion(')
          ..write('id: $id, ')
          ..write('position: $position, ')
          ..write('taskText: $taskText, ')
          ..write('emotion: $emotion, ')
          ..write('difficulty: $difficulty, ')
          ..write('status: $status, ')
          ..write('createdOn: $createdOn, ')
          ..write('pinned: $pinned')
          ..write(')'))
        .toString();
  }
}

class $PetRecordsTable extends PetRecords
    with TableInfo<$PetRecordsTable, DbPetRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PetRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _emotionMeta =
      const VerificationMeta('emotion');
  @override
  late final GeneratedColumn<String> emotion = GeneratedColumn<String>(
      'emotion', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES emotion_catalog (code)'));
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
      'count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL CHECK (count >= 0)');
  static const VerificationMeta _branchMeta = const VerificationMeta('branch');
  @override
  late final GeneratedColumn<String> branch = GeneratedColumn<String>(
      'branch', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _bondMinutesMeta =
      const VerificationMeta('bondMinutes');
  @override
  late final GeneratedColumn<int> bondMinutes = GeneratedColumn<int>(
      'bond_minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL CHECK (bond_minutes >= 0)');
  @override
  List<GeneratedColumn> get $columns => [emotion, count, branch, bondMinutes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pet_records';
  @override
  VerificationContext validateIntegrity(Insertable<DbPetRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('emotion')) {
      context.handle(_emotionMeta,
          emotion.isAcceptableOrUnknown(data['emotion']!, _emotionMeta));
    } else if (isInserting) {
      context.missing(_emotionMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
          _countMeta, count.isAcceptableOrUnknown(data['count']!, _countMeta));
    } else if (isInserting) {
      context.missing(_countMeta);
    }
    if (data.containsKey('branch')) {
      context.handle(_branchMeta,
          branch.isAcceptableOrUnknown(data['branch']!, _branchMeta));
    }
    if (data.containsKey('bond_minutes')) {
      context.handle(
          _bondMinutesMeta,
          bondMinutes.isAcceptableOrUnknown(
              data['bond_minutes']!, _bondMinutesMeta));
    } else if (isInserting) {
      context.missing(_bondMinutesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {emotion};
  @override
  DbPetRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbPetRecord(
      emotion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}emotion'])!,
      count: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}count'])!,
      branch: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}branch']),
      bondMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bond_minutes'])!,
    );
  }

  @override
  $PetRecordsTable createAlias(String alias) {
    return $PetRecordsTable(attachedDatabase, alias);
  }
}

class DbPetRecord extends DataClass implements Insertable<DbPetRecord> {
  final String emotion;
  final int count;
  final String? branch;
  final int bondMinutes;
  const DbPetRecord(
      {required this.emotion,
      required this.count,
      this.branch,
      required this.bondMinutes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['emotion'] = Variable<String>(emotion);
    map['count'] = Variable<int>(count);
    if (!nullToAbsent || branch != null) {
      map['branch'] = Variable<String>(branch);
    }
    map['bond_minutes'] = Variable<int>(bondMinutes);
    return map;
  }

  PetRecordsCompanion toCompanion(bool nullToAbsent) {
    return PetRecordsCompanion(
      emotion: Value(emotion),
      count: Value(count),
      branch:
          branch == null && nullToAbsent ? const Value.absent() : Value(branch),
      bondMinutes: Value(bondMinutes),
    );
  }

  factory DbPetRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbPetRecord(
      emotion: serializer.fromJson<String>(json['emotion']),
      count: serializer.fromJson<int>(json['count']),
      branch: serializer.fromJson<String?>(json['branch']),
      bondMinutes: serializer.fromJson<int>(json['bondMinutes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'emotion': serializer.toJson<String>(emotion),
      'count': serializer.toJson<int>(count),
      'branch': serializer.toJson<String?>(branch),
      'bondMinutes': serializer.toJson<int>(bondMinutes),
    };
  }

  DbPetRecord copyWith(
          {String? emotion,
          int? count,
          Value<String?> branch = const Value.absent(),
          int? bondMinutes}) =>
      DbPetRecord(
        emotion: emotion ?? this.emotion,
        count: count ?? this.count,
        branch: branch.present ? branch.value : this.branch,
        bondMinutes: bondMinutes ?? this.bondMinutes,
      );
  DbPetRecord copyWithCompanion(PetRecordsCompanion data) {
    return DbPetRecord(
      emotion: data.emotion.present ? data.emotion.value : this.emotion,
      count: data.count.present ? data.count.value : this.count,
      branch: data.branch.present ? data.branch.value : this.branch,
      bondMinutes:
          data.bondMinutes.present ? data.bondMinutes.value : this.bondMinutes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbPetRecord(')
          ..write('emotion: $emotion, ')
          ..write('count: $count, ')
          ..write('branch: $branch, ')
          ..write('bondMinutes: $bondMinutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(emotion, count, branch, bondMinutes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbPetRecord &&
          other.emotion == this.emotion &&
          other.count == this.count &&
          other.branch == this.branch &&
          other.bondMinutes == this.bondMinutes);
}

class PetRecordsCompanion extends UpdateCompanion<DbPetRecord> {
  final Value<String> emotion;
  final Value<int> count;
  final Value<String?> branch;
  final Value<int> bondMinutes;
  final Value<int> rowid;
  const PetRecordsCompanion({
    this.emotion = const Value.absent(),
    this.count = const Value.absent(),
    this.branch = const Value.absent(),
    this.bondMinutes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PetRecordsCompanion.insert({
    required String emotion,
    required int count,
    this.branch = const Value.absent(),
    required int bondMinutes,
    this.rowid = const Value.absent(),
  })  : emotion = Value(emotion),
        count = Value(count),
        bondMinutes = Value(bondMinutes);
  static Insertable<DbPetRecord> custom({
    Expression<String>? emotion,
    Expression<int>? count,
    Expression<String>? branch,
    Expression<int>? bondMinutes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (emotion != null) 'emotion': emotion,
      if (count != null) 'count': count,
      if (branch != null) 'branch': branch,
      if (bondMinutes != null) 'bond_minutes': bondMinutes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PetRecordsCompanion copyWith(
      {Value<String>? emotion,
      Value<int>? count,
      Value<String?>? branch,
      Value<int>? bondMinutes,
      Value<int>? rowid}) {
    return PetRecordsCompanion(
      emotion: emotion ?? this.emotion,
      count: count ?? this.count,
      branch: branch ?? this.branch,
      bondMinutes: bondMinutes ?? this.bondMinutes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (emotion.present) {
      map['emotion'] = Variable<String>(emotion.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (branch.present) {
      map['branch'] = Variable<String>(branch.value);
    }
    if (bondMinutes.present) {
      map['bond_minutes'] = Variable<int>(bondMinutes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PetRecordsCompanion(')
          ..write('emotion: $emotion, ')
          ..write('count: $count, ')
          ..write('branch: $branch, ')
          ..write('bondMinutes: $bondMinutes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InventoryRowsTable extends InventoryRows
    with TableInfo<$InventoryRowsTable, InventoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemCodeMeta =
      const VerificationMeta('itemCode');
  @override
  late final GeneratedColumn<String> itemCode = GeneratedColumn<String>(
      'item_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES item_catalog (code)'));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL CHECK (quantity >= 0)');
  @override
  List<GeneratedColumn> get $columns => [itemCode, quantity];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory';
  @override
  VerificationContext validateIntegrity(Insertable<InventoryRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_code')) {
      context.handle(_itemCodeMeta,
          itemCode.isAcceptableOrUnknown(data['item_code']!, _itemCodeMeta));
    } else if (isInserting) {
      context.missing(_itemCodeMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemCode};
  @override
  InventoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryRow(
      itemCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_code'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
    );
  }

  @override
  $InventoryRowsTable createAlias(String alias) {
    return $InventoryRowsTable(attachedDatabase, alias);
  }
}

class InventoryRow extends DataClass implements Insertable<InventoryRow> {
  final String itemCode;
  final int quantity;
  const InventoryRow({required this.itemCode, required this.quantity});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_code'] = Variable<String>(itemCode);
    map['quantity'] = Variable<int>(quantity);
    return map;
  }

  InventoryRowsCompanion toCompanion(bool nullToAbsent) {
    return InventoryRowsCompanion(
      itemCode: Value(itemCode),
      quantity: Value(quantity),
    );
  }

  factory InventoryRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryRow(
      itemCode: serializer.fromJson<String>(json['itemCode']),
      quantity: serializer.fromJson<int>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemCode': serializer.toJson<String>(itemCode),
      'quantity': serializer.toJson<int>(quantity),
    };
  }

  InventoryRow copyWith({String? itemCode, int? quantity}) => InventoryRow(
        itemCode: itemCode ?? this.itemCode,
        quantity: quantity ?? this.quantity,
      );
  InventoryRow copyWithCompanion(InventoryRowsCompanion data) {
    return InventoryRow(
      itemCode: data.itemCode.present ? data.itemCode.value : this.itemCode,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryRow(')
          ..write('itemCode: $itemCode, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(itemCode, quantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryRow &&
          other.itemCode == this.itemCode &&
          other.quantity == this.quantity);
}

class InventoryRowsCompanion extends UpdateCompanion<InventoryRow> {
  final Value<String> itemCode;
  final Value<int> quantity;
  final Value<int> rowid;
  const InventoryRowsCompanion({
    this.itemCode = const Value.absent(),
    this.quantity = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InventoryRowsCompanion.insert({
    required String itemCode,
    required int quantity,
    this.rowid = const Value.absent(),
  })  : itemCode = Value(itemCode),
        quantity = Value(quantity);
  static Insertable<InventoryRow> custom({
    Expression<String>? itemCode,
    Expression<int>? quantity,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemCode != null) 'item_code': itemCode,
      if (quantity != null) 'quantity': quantity,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InventoryRowsCompanion copyWith(
      {Value<String>? itemCode, Value<int>? quantity, Value<int>? rowid}) {
    return InventoryRowsCompanion(
      itemCode: itemCode ?? this.itemCode,
      quantity: quantity ?? this.quantity,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemCode.present) {
      map['item_code'] = Variable<String>(itemCode.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryRowsCompanion(')
          ..write('itemCode: $itemCode, ')
          ..write('quantity: $quantity, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GameStatisticsTable extends GameStatistics
    with TableInfo<$GameStatisticsTable, GameStatistic> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GameStatisticsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _totalDoneMeta =
      const VerificationMeta('totalDone');
  @override
  late final GeneratedColumn<int> totalDone = GeneratedColumn<int>(
      'total_done', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _totalFocusSessionsMeta =
      const VerificationMeta('totalFocusSessions');
  @override
  late final GeneratedColumn<int> totalFocusSessions = GeneratedColumn<int>(
      'total_focus_sessions', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _totalFocusMinutesMeta =
      const VerificationMeta('totalFocusMinutes');
  @override
  late final GeneratedColumn<int> totalFocusMinutes = GeneratedColumn<int>(
      'total_focus_minutes', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _mazeRunsMeta =
      const VerificationMeta('mazeRuns');
  @override
  late final GeneratedColumn<int> mazeRuns = GeneratedColumn<int>(
      'maze_runs', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _mistDewCollectedMeta =
      const VerificationMeta('mistDewCollected');
  @override
  late final GeneratedColumn<int> mistDewCollected = GeneratedColumn<int>(
      'mist_dew_collected', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deepDivesMeta =
      const VerificationMeta('deepDives');
  @override
  late final GeneratedColumn<int> deepDives = GeneratedColumn<int>(
      'deep_dives', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        totalDone,
        totalFocusSessions,
        totalFocusMinutes,
        mazeRuns,
        mistDewCollected,
        deepDives
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_statistics';
  @override
  VerificationContext validateIntegrity(Insertable<GameStatistic> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('total_done')) {
      context.handle(_totalDoneMeta,
          totalDone.isAcceptableOrUnknown(data['total_done']!, _totalDoneMeta));
    } else if (isInserting) {
      context.missing(_totalDoneMeta);
    }
    if (data.containsKey('total_focus_sessions')) {
      context.handle(
          _totalFocusSessionsMeta,
          totalFocusSessions.isAcceptableOrUnknown(
              data['total_focus_sessions']!, _totalFocusSessionsMeta));
    } else if (isInserting) {
      context.missing(_totalFocusSessionsMeta);
    }
    if (data.containsKey('total_focus_minutes')) {
      context.handle(
          _totalFocusMinutesMeta,
          totalFocusMinutes.isAcceptableOrUnknown(
              data['total_focus_minutes']!, _totalFocusMinutesMeta));
    } else if (isInserting) {
      context.missing(_totalFocusMinutesMeta);
    }
    if (data.containsKey('maze_runs')) {
      context.handle(_mazeRunsMeta,
          mazeRuns.isAcceptableOrUnknown(data['maze_runs']!, _mazeRunsMeta));
    } else if (isInserting) {
      context.missing(_mazeRunsMeta);
    }
    if (data.containsKey('mist_dew_collected')) {
      context.handle(
          _mistDewCollectedMeta,
          mistDewCollected.isAcceptableOrUnknown(
              data['mist_dew_collected']!, _mistDewCollectedMeta));
    } else if (isInserting) {
      context.missing(_mistDewCollectedMeta);
    }
    if (data.containsKey('deep_dives')) {
      context.handle(_deepDivesMeta,
          deepDives.isAcceptableOrUnknown(data['deep_dives']!, _deepDivesMeta));
    } else if (isInserting) {
      context.missing(_deepDivesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GameStatistic map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameStatistic(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      totalDone: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_done'])!,
      totalFocusSessions: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_focus_sessions'])!,
      totalFocusMinutes: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_focus_minutes'])!,
      mazeRuns: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}maze_runs'])!,
      mistDewCollected: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}mist_dew_collected'])!,
      deepDives: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}deep_dives'])!,
    );
  }

  @override
  $GameStatisticsTable createAlias(String alias) {
    return $GameStatisticsTable(attachedDatabase, alias);
  }
}

class GameStatistic extends DataClass implements Insertable<GameStatistic> {
  final int id;
  final int totalDone;
  final int totalFocusSessions;
  final int totalFocusMinutes;
  final int mazeRuns;
  final int mistDewCollected;
  final int deepDives;
  const GameStatistic(
      {required this.id,
      required this.totalDone,
      required this.totalFocusSessions,
      required this.totalFocusMinutes,
      required this.mazeRuns,
      required this.mistDewCollected,
      required this.deepDives});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['total_done'] = Variable<int>(totalDone);
    map['total_focus_sessions'] = Variable<int>(totalFocusSessions);
    map['total_focus_minutes'] = Variable<int>(totalFocusMinutes);
    map['maze_runs'] = Variable<int>(mazeRuns);
    map['mist_dew_collected'] = Variable<int>(mistDewCollected);
    map['deep_dives'] = Variable<int>(deepDives);
    return map;
  }

  GameStatisticsCompanion toCompanion(bool nullToAbsent) {
    return GameStatisticsCompanion(
      id: Value(id),
      totalDone: Value(totalDone),
      totalFocusSessions: Value(totalFocusSessions),
      totalFocusMinutes: Value(totalFocusMinutes),
      mazeRuns: Value(mazeRuns),
      mistDewCollected: Value(mistDewCollected),
      deepDives: Value(deepDives),
    );
  }

  factory GameStatistic.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GameStatistic(
      id: serializer.fromJson<int>(json['id']),
      totalDone: serializer.fromJson<int>(json['totalDone']),
      totalFocusSessions: serializer.fromJson<int>(json['totalFocusSessions']),
      totalFocusMinutes: serializer.fromJson<int>(json['totalFocusMinutes']),
      mazeRuns: serializer.fromJson<int>(json['mazeRuns']),
      mistDewCollected: serializer.fromJson<int>(json['mistDewCollected']),
      deepDives: serializer.fromJson<int>(json['deepDives']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'totalDone': serializer.toJson<int>(totalDone),
      'totalFocusSessions': serializer.toJson<int>(totalFocusSessions),
      'totalFocusMinutes': serializer.toJson<int>(totalFocusMinutes),
      'mazeRuns': serializer.toJson<int>(mazeRuns),
      'mistDewCollected': serializer.toJson<int>(mistDewCollected),
      'deepDives': serializer.toJson<int>(deepDives),
    };
  }

  GameStatistic copyWith(
          {int? id,
          int? totalDone,
          int? totalFocusSessions,
          int? totalFocusMinutes,
          int? mazeRuns,
          int? mistDewCollected,
          int? deepDives}) =>
      GameStatistic(
        id: id ?? this.id,
        totalDone: totalDone ?? this.totalDone,
        totalFocusSessions: totalFocusSessions ?? this.totalFocusSessions,
        totalFocusMinutes: totalFocusMinutes ?? this.totalFocusMinutes,
        mazeRuns: mazeRuns ?? this.mazeRuns,
        mistDewCollected: mistDewCollected ?? this.mistDewCollected,
        deepDives: deepDives ?? this.deepDives,
      );
  GameStatistic copyWithCompanion(GameStatisticsCompanion data) {
    return GameStatistic(
      id: data.id.present ? data.id.value : this.id,
      totalDone: data.totalDone.present ? data.totalDone.value : this.totalDone,
      totalFocusSessions: data.totalFocusSessions.present
          ? data.totalFocusSessions.value
          : this.totalFocusSessions,
      totalFocusMinutes: data.totalFocusMinutes.present
          ? data.totalFocusMinutes.value
          : this.totalFocusMinutes,
      mazeRuns: data.mazeRuns.present ? data.mazeRuns.value : this.mazeRuns,
      mistDewCollected: data.mistDewCollected.present
          ? data.mistDewCollected.value
          : this.mistDewCollected,
      deepDives: data.deepDives.present ? data.deepDives.value : this.deepDives,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GameStatistic(')
          ..write('id: $id, ')
          ..write('totalDone: $totalDone, ')
          ..write('totalFocusSessions: $totalFocusSessions, ')
          ..write('totalFocusMinutes: $totalFocusMinutes, ')
          ..write('mazeRuns: $mazeRuns, ')
          ..write('mistDewCollected: $mistDewCollected, ')
          ..write('deepDives: $deepDives')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, totalDone, totalFocusSessions,
      totalFocusMinutes, mazeRuns, mistDewCollected, deepDives);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GameStatistic &&
          other.id == this.id &&
          other.totalDone == this.totalDone &&
          other.totalFocusSessions == this.totalFocusSessions &&
          other.totalFocusMinutes == this.totalFocusMinutes &&
          other.mazeRuns == this.mazeRuns &&
          other.mistDewCollected == this.mistDewCollected &&
          other.deepDives == this.deepDives);
}

class GameStatisticsCompanion extends UpdateCompanion<GameStatistic> {
  final Value<int> id;
  final Value<int> totalDone;
  final Value<int> totalFocusSessions;
  final Value<int> totalFocusMinutes;
  final Value<int> mazeRuns;
  final Value<int> mistDewCollected;
  final Value<int> deepDives;
  const GameStatisticsCompanion({
    this.id = const Value.absent(),
    this.totalDone = const Value.absent(),
    this.totalFocusSessions = const Value.absent(),
    this.totalFocusMinutes = const Value.absent(),
    this.mazeRuns = const Value.absent(),
    this.mistDewCollected = const Value.absent(),
    this.deepDives = const Value.absent(),
  });
  GameStatisticsCompanion.insert({
    this.id = const Value.absent(),
    required int totalDone,
    required int totalFocusSessions,
    required int totalFocusMinutes,
    required int mazeRuns,
    required int mistDewCollected,
    required int deepDives,
  })  : totalDone = Value(totalDone),
        totalFocusSessions = Value(totalFocusSessions),
        totalFocusMinutes = Value(totalFocusMinutes),
        mazeRuns = Value(mazeRuns),
        mistDewCollected = Value(mistDewCollected),
        deepDives = Value(deepDives);
  static Insertable<GameStatistic> custom({
    Expression<int>? id,
    Expression<int>? totalDone,
    Expression<int>? totalFocusSessions,
    Expression<int>? totalFocusMinutes,
    Expression<int>? mazeRuns,
    Expression<int>? mistDewCollected,
    Expression<int>? deepDives,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (totalDone != null) 'total_done': totalDone,
      if (totalFocusSessions != null)
        'total_focus_sessions': totalFocusSessions,
      if (totalFocusMinutes != null) 'total_focus_minutes': totalFocusMinutes,
      if (mazeRuns != null) 'maze_runs': mazeRuns,
      if (mistDewCollected != null) 'mist_dew_collected': mistDewCollected,
      if (deepDives != null) 'deep_dives': deepDives,
    });
  }

  GameStatisticsCompanion copyWith(
      {Value<int>? id,
      Value<int>? totalDone,
      Value<int>? totalFocusSessions,
      Value<int>? totalFocusMinutes,
      Value<int>? mazeRuns,
      Value<int>? mistDewCollected,
      Value<int>? deepDives}) {
    return GameStatisticsCompanion(
      id: id ?? this.id,
      totalDone: totalDone ?? this.totalDone,
      totalFocusSessions: totalFocusSessions ?? this.totalFocusSessions,
      totalFocusMinutes: totalFocusMinutes ?? this.totalFocusMinutes,
      mazeRuns: mazeRuns ?? this.mazeRuns,
      mistDewCollected: mistDewCollected ?? this.mistDewCollected,
      deepDives: deepDives ?? this.deepDives,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (totalDone.present) {
      map['total_done'] = Variable<int>(totalDone.value);
    }
    if (totalFocusSessions.present) {
      map['total_focus_sessions'] = Variable<int>(totalFocusSessions.value);
    }
    if (totalFocusMinutes.present) {
      map['total_focus_minutes'] = Variable<int>(totalFocusMinutes.value);
    }
    if (mazeRuns.present) {
      map['maze_runs'] = Variable<int>(mazeRuns.value);
    }
    if (mistDewCollected.present) {
      map['mist_dew_collected'] = Variable<int>(mistDewCollected.value);
    }
    if (deepDives.present) {
      map['deep_dives'] = Variable<int>(deepDives.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GameStatisticsCompanion(')
          ..write('id: $id, ')
          ..write('totalDone: $totalDone, ')
          ..write('totalFocusSessions: $totalFocusSessions, ')
          ..write('totalFocusMinutes: $totalFocusMinutes, ')
          ..write('mazeRuns: $mazeRuns, ')
          ..write('mistDewCollected: $mistDewCollected, ')
          ..write('deepDives: $deepDives')
          ..write(')'))
        .toString();
  }
}

class $StreakStatesTable extends StreakStates
    with TableInfo<$StreakStatesTable, StreakState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StreakStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _sunnyDaysMeta =
      const VerificationMeta('sunnyDays');
  @override
  late final GeneratedColumn<int> sunnyDays = GeneratedColumn<int>(
      'sunny_days', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lastSunnyMeta =
      const VerificationMeta('lastSunny');
  @override
  late final GeneratedColumn<String> lastSunny = GeneratedColumn<String>(
      'last_sunny', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, sunnyDays, lastSunny];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'streak_states';
  @override
  VerificationContext validateIntegrity(Insertable<StreakState> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sunny_days')) {
      context.handle(_sunnyDaysMeta,
          sunnyDays.isAcceptableOrUnknown(data['sunny_days']!, _sunnyDaysMeta));
    } else if (isInserting) {
      context.missing(_sunnyDaysMeta);
    }
    if (data.containsKey('last_sunny')) {
      context.handle(_lastSunnyMeta,
          lastSunny.isAcceptableOrUnknown(data['last_sunny']!, _lastSunnyMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StreakState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StreakState(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sunnyDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sunny_days'])!,
      lastSunny: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_sunny']),
    );
  }

  @override
  $StreakStatesTable createAlias(String alias) {
    return $StreakStatesTable(attachedDatabase, alias);
  }
}

class StreakState extends DataClass implements Insertable<StreakState> {
  final int id;
  final int sunnyDays;
  final String? lastSunny;
  const StreakState(
      {required this.id, required this.sunnyDays, this.lastSunny});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sunny_days'] = Variable<int>(sunnyDays);
    if (!nullToAbsent || lastSunny != null) {
      map['last_sunny'] = Variable<String>(lastSunny);
    }
    return map;
  }

  StreakStatesCompanion toCompanion(bool nullToAbsent) {
    return StreakStatesCompanion(
      id: Value(id),
      sunnyDays: Value(sunnyDays),
      lastSunny: lastSunny == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSunny),
    );
  }

  factory StreakState.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StreakState(
      id: serializer.fromJson<int>(json['id']),
      sunnyDays: serializer.fromJson<int>(json['sunnyDays']),
      lastSunny: serializer.fromJson<String?>(json['lastSunny']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sunnyDays': serializer.toJson<int>(sunnyDays),
      'lastSunny': serializer.toJson<String?>(lastSunny),
    };
  }

  StreakState copyWith(
          {int? id,
          int? sunnyDays,
          Value<String?> lastSunny = const Value.absent()}) =>
      StreakState(
        id: id ?? this.id,
        sunnyDays: sunnyDays ?? this.sunnyDays,
        lastSunny: lastSunny.present ? lastSunny.value : this.lastSunny,
      );
  StreakState copyWithCompanion(StreakStatesCompanion data) {
    return StreakState(
      id: data.id.present ? data.id.value : this.id,
      sunnyDays: data.sunnyDays.present ? data.sunnyDays.value : this.sunnyDays,
      lastSunny: data.lastSunny.present ? data.lastSunny.value : this.lastSunny,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StreakState(')
          ..write('id: $id, ')
          ..write('sunnyDays: $sunnyDays, ')
          ..write('lastSunny: $lastSunny')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sunnyDays, lastSunny);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StreakState &&
          other.id == this.id &&
          other.sunnyDays == this.sunnyDays &&
          other.lastSunny == this.lastSunny);
}

class StreakStatesCompanion extends UpdateCompanion<StreakState> {
  final Value<int> id;
  final Value<int> sunnyDays;
  final Value<String?> lastSunny;
  const StreakStatesCompanion({
    this.id = const Value.absent(),
    this.sunnyDays = const Value.absent(),
    this.lastSunny = const Value.absent(),
  });
  StreakStatesCompanion.insert({
    this.id = const Value.absent(),
    required int sunnyDays,
    this.lastSunny = const Value.absent(),
  }) : sunnyDays = Value(sunnyDays);
  static Insertable<StreakState> custom({
    Expression<int>? id,
    Expression<int>? sunnyDays,
    Expression<String>? lastSunny,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sunnyDays != null) 'sunny_days': sunnyDays,
      if (lastSunny != null) 'last_sunny': lastSunny,
    });
  }

  StreakStatesCompanion copyWith(
      {Value<int>? id, Value<int>? sunnyDays, Value<String?>? lastSunny}) {
    return StreakStatesCompanion(
      id: id ?? this.id,
      sunnyDays: sunnyDays ?? this.sunnyDays,
      lastSunny: lastSunny ?? this.lastSunny,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sunnyDays.present) {
      map['sunny_days'] = Variable<int>(sunnyDays.value);
    }
    if (lastSunny.present) {
      map['last_sunny'] = Variable<String>(lastSunny.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StreakStatesCompanion(')
          ..write('id: $id, ')
          ..write('sunnyDays: $sunnyDays, ')
          ..write('lastSunny: $lastSunny')
          ..write(')'))
        .toString();
  }
}

class $KeeperStatesTable extends KeeperStates
    with TableInfo<$KeeperStatesTable, KeeperState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KeeperStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
      'level', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _expMeta = const VerificationMeta('exp');
  @override
  late final GeneratedColumn<int> exp = GeneratedColumn<int>(
      'exp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, level, exp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'keeper_states';
  @override
  VerificationContext validateIntegrity(Insertable<KeeperState> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('exp')) {
      context.handle(
          _expMeta, exp.isAcceptableOrUnknown(data['exp']!, _expMeta));
    } else if (isInserting) {
      context.missing(_expMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KeeperState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KeeperState(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}level'])!,
      exp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}exp'])!,
    );
  }

  @override
  $KeeperStatesTable createAlias(String alias) {
    return $KeeperStatesTable(attachedDatabase, alias);
  }
}

class KeeperState extends DataClass implements Insertable<KeeperState> {
  final int id;
  final int level;
  final int exp;
  const KeeperState({required this.id, required this.level, required this.exp});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['level'] = Variable<int>(level);
    map['exp'] = Variable<int>(exp);
    return map;
  }

  KeeperStatesCompanion toCompanion(bool nullToAbsent) {
    return KeeperStatesCompanion(
      id: Value(id),
      level: Value(level),
      exp: Value(exp),
    );
  }

  factory KeeperState.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KeeperState(
      id: serializer.fromJson<int>(json['id']),
      level: serializer.fromJson<int>(json['level']),
      exp: serializer.fromJson<int>(json['exp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'level': serializer.toJson<int>(level),
      'exp': serializer.toJson<int>(exp),
    };
  }

  KeeperState copyWith({int? id, int? level, int? exp}) => KeeperState(
        id: id ?? this.id,
        level: level ?? this.level,
        exp: exp ?? this.exp,
      );
  KeeperState copyWithCompanion(KeeperStatesCompanion data) {
    return KeeperState(
      id: data.id.present ? data.id.value : this.id,
      level: data.level.present ? data.level.value : this.level,
      exp: data.exp.present ? data.exp.value : this.exp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KeeperState(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('exp: $exp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, level, exp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KeeperState &&
          other.id == this.id &&
          other.level == this.level &&
          other.exp == this.exp);
}

class KeeperStatesCompanion extends UpdateCompanion<KeeperState> {
  final Value<int> id;
  final Value<int> level;
  final Value<int> exp;
  const KeeperStatesCompanion({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    this.exp = const Value.absent(),
  });
  KeeperStatesCompanion.insert({
    this.id = const Value.absent(),
    required int level,
    required int exp,
  })  : level = Value(level),
        exp = Value(exp);
  static Insertable<KeeperState> custom({
    Expression<int>? id,
    Expression<int>? level,
    Expression<int>? exp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (level != null) 'level': level,
      if (exp != null) 'exp': exp,
    });
  }

  KeeperStatesCompanion copyWith(
      {Value<int>? id, Value<int>? level, Value<int>? exp}) {
    return KeeperStatesCompanion(
      id: id ?? this.id,
      level: level ?? this.level,
      exp: exp ?? this.exp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (exp.present) {
      map['exp'] = Variable<int>(exp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KeeperStatesCompanion(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('exp: $exp')
          ..write(')'))
        .toString();
  }
}

class $ResonanceStatesTable extends ResonanceStates
    with TableInfo<$ResonanceStatesTable, ResonanceState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ResonanceStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lastEmotionMeta =
      const VerificationMeta('lastEmotion');
  @override
  late final GeneratedColumn<String> lastEmotion = GeneratedColumn<String>(
      'last_emotion', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES emotion_catalog (code)'));
  static const VerificationMeta _lengthMeta = const VerificationMeta('length');
  @override
  late final GeneratedColumn<int> length = GeneratedColumn<int>(
      'length', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _bestMeta = const VerificationMeta('best');
  @override
  late final GeneratedColumn<int> best = GeneratedColumn<int>(
      'best', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lastAtMsMeta =
      const VerificationMeta('lastAtMs');
  @override
  late final GeneratedColumn<int> lastAtMs = GeneratedColumn<int>(
      'last_at_ms', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, lastEmotion, length, best, lastAtMs];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'resonance_states';
  @override
  VerificationContext validateIntegrity(Insertable<ResonanceState> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('last_emotion')) {
      context.handle(
          _lastEmotionMeta,
          lastEmotion.isAcceptableOrUnknown(
              data['last_emotion']!, _lastEmotionMeta));
    }
    if (data.containsKey('length')) {
      context.handle(_lengthMeta,
          length.isAcceptableOrUnknown(data['length']!, _lengthMeta));
    } else if (isInserting) {
      context.missing(_lengthMeta);
    }
    if (data.containsKey('best')) {
      context.handle(
          _bestMeta, best.isAcceptableOrUnknown(data['best']!, _bestMeta));
    } else if (isInserting) {
      context.missing(_bestMeta);
    }
    if (data.containsKey('last_at_ms')) {
      context.handle(_lastAtMsMeta,
          lastAtMs.isAcceptableOrUnknown(data['last_at_ms']!, _lastAtMsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ResonanceState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ResonanceState(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      lastEmotion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_emotion']),
      length: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}length'])!,
      best: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}best'])!,
      lastAtMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_at_ms']),
    );
  }

  @override
  $ResonanceStatesTable createAlias(String alias) {
    return $ResonanceStatesTable(attachedDatabase, alias);
  }
}

class ResonanceState extends DataClass implements Insertable<ResonanceState> {
  final int id;
  final String? lastEmotion;
  final int length;
  final int best;
  final int? lastAtMs;
  const ResonanceState(
      {required this.id,
      this.lastEmotion,
      required this.length,
      required this.best,
      this.lastAtMs});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || lastEmotion != null) {
      map['last_emotion'] = Variable<String>(lastEmotion);
    }
    map['length'] = Variable<int>(length);
    map['best'] = Variable<int>(best);
    if (!nullToAbsent || lastAtMs != null) {
      map['last_at_ms'] = Variable<int>(lastAtMs);
    }
    return map;
  }

  ResonanceStatesCompanion toCompanion(bool nullToAbsent) {
    return ResonanceStatesCompanion(
      id: Value(id),
      lastEmotion: lastEmotion == null && nullToAbsent
          ? const Value.absent()
          : Value(lastEmotion),
      length: Value(length),
      best: Value(best),
      lastAtMs: lastAtMs == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAtMs),
    );
  }

  factory ResonanceState.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ResonanceState(
      id: serializer.fromJson<int>(json['id']),
      lastEmotion: serializer.fromJson<String?>(json['lastEmotion']),
      length: serializer.fromJson<int>(json['length']),
      best: serializer.fromJson<int>(json['best']),
      lastAtMs: serializer.fromJson<int?>(json['lastAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lastEmotion': serializer.toJson<String?>(lastEmotion),
      'length': serializer.toJson<int>(length),
      'best': serializer.toJson<int>(best),
      'lastAtMs': serializer.toJson<int?>(lastAtMs),
    };
  }

  ResonanceState copyWith(
          {int? id,
          Value<String?> lastEmotion = const Value.absent(),
          int? length,
          int? best,
          Value<int?> lastAtMs = const Value.absent()}) =>
      ResonanceState(
        id: id ?? this.id,
        lastEmotion: lastEmotion.present ? lastEmotion.value : this.lastEmotion,
        length: length ?? this.length,
        best: best ?? this.best,
        lastAtMs: lastAtMs.present ? lastAtMs.value : this.lastAtMs,
      );
  ResonanceState copyWithCompanion(ResonanceStatesCompanion data) {
    return ResonanceState(
      id: data.id.present ? data.id.value : this.id,
      lastEmotion:
          data.lastEmotion.present ? data.lastEmotion.value : this.lastEmotion,
      length: data.length.present ? data.length.value : this.length,
      best: data.best.present ? data.best.value : this.best,
      lastAtMs: data.lastAtMs.present ? data.lastAtMs.value : this.lastAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ResonanceState(')
          ..write('id: $id, ')
          ..write('lastEmotion: $lastEmotion, ')
          ..write('length: $length, ')
          ..write('best: $best, ')
          ..write('lastAtMs: $lastAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lastEmotion, length, best, lastAtMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ResonanceState &&
          other.id == this.id &&
          other.lastEmotion == this.lastEmotion &&
          other.length == this.length &&
          other.best == this.best &&
          other.lastAtMs == this.lastAtMs);
}

class ResonanceStatesCompanion extends UpdateCompanion<ResonanceState> {
  final Value<int> id;
  final Value<String?> lastEmotion;
  final Value<int> length;
  final Value<int> best;
  final Value<int?> lastAtMs;
  const ResonanceStatesCompanion({
    this.id = const Value.absent(),
    this.lastEmotion = const Value.absent(),
    this.length = const Value.absent(),
    this.best = const Value.absent(),
    this.lastAtMs = const Value.absent(),
  });
  ResonanceStatesCompanion.insert({
    this.id = const Value.absent(),
    this.lastEmotion = const Value.absent(),
    required int length,
    required int best,
    this.lastAtMs = const Value.absent(),
  })  : length = Value(length),
        best = Value(best);
  static Insertable<ResonanceState> custom({
    Expression<int>? id,
    Expression<String>? lastEmotion,
    Expression<int>? length,
    Expression<int>? best,
    Expression<int>? lastAtMs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lastEmotion != null) 'last_emotion': lastEmotion,
      if (length != null) 'length': length,
      if (best != null) 'best': best,
      if (lastAtMs != null) 'last_at_ms': lastAtMs,
    });
  }

  ResonanceStatesCompanion copyWith(
      {Value<int>? id,
      Value<String?>? lastEmotion,
      Value<int>? length,
      Value<int>? best,
      Value<int?>? lastAtMs}) {
    return ResonanceStatesCompanion(
      id: id ?? this.id,
      lastEmotion: lastEmotion ?? this.lastEmotion,
      length: length ?? this.length,
      best: best ?? this.best,
      lastAtMs: lastAtMs ?? this.lastAtMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lastEmotion.present) {
      map['last_emotion'] = Variable<String>(lastEmotion.value);
    }
    if (length.present) {
      map['length'] = Variable<int>(length.value);
    }
    if (best.present) {
      map['best'] = Variable<int>(best.value);
    }
    if (lastAtMs.present) {
      map['last_at_ms'] = Variable<int>(lastAtMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ResonanceStatesCompanion(')
          ..write('id: $id, ')
          ..write('lastEmotion: $lastEmotion, ')
          ..write('length: $length, ')
          ..write('best: $best, ')
          ..write('lastAtMs: $lastAtMs')
          ..write(')'))
        .toString();
  }
}

class $ClimateStatesTable extends ClimateStates
    with TableInfo<$ClimateStatesTable, ClimateState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClimateStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _fogMeta = const VerificationMeta('fog');
  @override
  late final GeneratedColumn<double> fog = GeneratedColumn<double>(
      'fog', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _tierMeta = const VerificationMeta('tier');
  @override
  late final GeneratedColumn<String> tier = GeneratedColumn<String>(
      'tier', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tierHoldDaysMeta =
      const VerificationMeta('tierHoldDays');
  @override
  late final GeneratedColumn<int> tierHoldDays = GeneratedColumn<int>(
      'tier_hold_days', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _zeroDoneStreakMeta =
      const VerificationMeta('zeroDoneStreak');
  @override
  late final GeneratedColumn<int> zeroDoneStreak = GeneratedColumn<int>(
      'zero_done_streak', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, fog, tier, tierHoldDays, zeroDoneStreak];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'climate_states';
  @override
  VerificationContext validateIntegrity(Insertable<ClimateState> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('fog')) {
      context.handle(
          _fogMeta, fog.isAcceptableOrUnknown(data['fog']!, _fogMeta));
    } else if (isInserting) {
      context.missing(_fogMeta);
    }
    if (data.containsKey('tier')) {
      context.handle(
          _tierMeta, tier.isAcceptableOrUnknown(data['tier']!, _tierMeta));
    } else if (isInserting) {
      context.missing(_tierMeta);
    }
    if (data.containsKey('tier_hold_days')) {
      context.handle(
          _tierHoldDaysMeta,
          tierHoldDays.isAcceptableOrUnknown(
              data['tier_hold_days']!, _tierHoldDaysMeta));
    } else if (isInserting) {
      context.missing(_tierHoldDaysMeta);
    }
    if (data.containsKey('zero_done_streak')) {
      context.handle(
          _zeroDoneStreakMeta,
          zeroDoneStreak.isAcceptableOrUnknown(
              data['zero_done_streak']!, _zeroDoneStreakMeta));
    } else if (isInserting) {
      context.missing(_zeroDoneStreakMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClimateState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClimateState(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      fog: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fog'])!,
      tier: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tier'])!,
      tierHoldDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tier_hold_days'])!,
      zeroDoneStreak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}zero_done_streak'])!,
    );
  }

  @override
  $ClimateStatesTable createAlias(String alias) {
    return $ClimateStatesTable(attachedDatabase, alias);
  }
}

class ClimateState extends DataClass implements Insertable<ClimateState> {
  final int id;
  final double fog;
  final String tier;
  final int tierHoldDays;
  final int zeroDoneStreak;
  const ClimateState(
      {required this.id,
      required this.fog,
      required this.tier,
      required this.tierHoldDays,
      required this.zeroDoneStreak});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['fog'] = Variable<double>(fog);
    map['tier'] = Variable<String>(tier);
    map['tier_hold_days'] = Variable<int>(tierHoldDays);
    map['zero_done_streak'] = Variable<int>(zeroDoneStreak);
    return map;
  }

  ClimateStatesCompanion toCompanion(bool nullToAbsent) {
    return ClimateStatesCompanion(
      id: Value(id),
      fog: Value(fog),
      tier: Value(tier),
      tierHoldDays: Value(tierHoldDays),
      zeroDoneStreak: Value(zeroDoneStreak),
    );
  }

  factory ClimateState.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClimateState(
      id: serializer.fromJson<int>(json['id']),
      fog: serializer.fromJson<double>(json['fog']),
      tier: serializer.fromJson<String>(json['tier']),
      tierHoldDays: serializer.fromJson<int>(json['tierHoldDays']),
      zeroDoneStreak: serializer.fromJson<int>(json['zeroDoneStreak']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fog': serializer.toJson<double>(fog),
      'tier': serializer.toJson<String>(tier),
      'tierHoldDays': serializer.toJson<int>(tierHoldDays),
      'zeroDoneStreak': serializer.toJson<int>(zeroDoneStreak),
    };
  }

  ClimateState copyWith(
          {int? id,
          double? fog,
          String? tier,
          int? tierHoldDays,
          int? zeroDoneStreak}) =>
      ClimateState(
        id: id ?? this.id,
        fog: fog ?? this.fog,
        tier: tier ?? this.tier,
        tierHoldDays: tierHoldDays ?? this.tierHoldDays,
        zeroDoneStreak: zeroDoneStreak ?? this.zeroDoneStreak,
      );
  ClimateState copyWithCompanion(ClimateStatesCompanion data) {
    return ClimateState(
      id: data.id.present ? data.id.value : this.id,
      fog: data.fog.present ? data.fog.value : this.fog,
      tier: data.tier.present ? data.tier.value : this.tier,
      tierHoldDays: data.tierHoldDays.present
          ? data.tierHoldDays.value
          : this.tierHoldDays,
      zeroDoneStreak: data.zeroDoneStreak.present
          ? data.zeroDoneStreak.value
          : this.zeroDoneStreak,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClimateState(')
          ..write('id: $id, ')
          ..write('fog: $fog, ')
          ..write('tier: $tier, ')
          ..write('tierHoldDays: $tierHoldDays, ')
          ..write('zeroDoneStreak: $zeroDoneStreak')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fog, tier, tierHoldDays, zeroDoneStreak);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClimateState &&
          other.id == this.id &&
          other.fog == this.fog &&
          other.tier == this.tier &&
          other.tierHoldDays == this.tierHoldDays &&
          other.zeroDoneStreak == this.zeroDoneStreak);
}

class ClimateStatesCompanion extends UpdateCompanion<ClimateState> {
  final Value<int> id;
  final Value<double> fog;
  final Value<String> tier;
  final Value<int> tierHoldDays;
  final Value<int> zeroDoneStreak;
  const ClimateStatesCompanion({
    this.id = const Value.absent(),
    this.fog = const Value.absent(),
    this.tier = const Value.absent(),
    this.tierHoldDays = const Value.absent(),
    this.zeroDoneStreak = const Value.absent(),
  });
  ClimateStatesCompanion.insert({
    this.id = const Value.absent(),
    required double fog,
    required String tier,
    required int tierHoldDays,
    required int zeroDoneStreak,
  })  : fog = Value(fog),
        tier = Value(tier),
        tierHoldDays = Value(tierHoldDays),
        zeroDoneStreak = Value(zeroDoneStreak);
  static Insertable<ClimateState> custom({
    Expression<int>? id,
    Expression<double>? fog,
    Expression<String>? tier,
    Expression<int>? tierHoldDays,
    Expression<int>? zeroDoneStreak,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fog != null) 'fog': fog,
      if (tier != null) 'tier': tier,
      if (tierHoldDays != null) 'tier_hold_days': tierHoldDays,
      if (zeroDoneStreak != null) 'zero_done_streak': zeroDoneStreak,
    });
  }

  ClimateStatesCompanion copyWith(
      {Value<int>? id,
      Value<double>? fog,
      Value<String>? tier,
      Value<int>? tierHoldDays,
      Value<int>? zeroDoneStreak}) {
    return ClimateStatesCompanion(
      id: id ?? this.id,
      fog: fog ?? this.fog,
      tier: tier ?? this.tier,
      tierHoldDays: tierHoldDays ?? this.tierHoldDays,
      zeroDoneStreak: zeroDoneStreak ?? this.zeroDoneStreak,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fog.present) {
      map['fog'] = Variable<double>(fog.value);
    }
    if (tier.present) {
      map['tier'] = Variable<String>(tier.value);
    }
    if (tierHoldDays.present) {
      map['tier_hold_days'] = Variable<int>(tierHoldDays.value);
    }
    if (zeroDoneStreak.present) {
      map['zero_done_streak'] = Variable<int>(zeroDoneStreak.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClimateStatesCompanion(')
          ..write('id: $id, ')
          ..write('fog: $fog, ')
          ..write('tier: $tier, ')
          ..write('tierHoldDays: $tierHoldDays, ')
          ..write('zeroDoneStreak: $zeroDoneStreak')
          ..write(')'))
        .toString();
  }
}

class $ClimateDaysTable extends ClimateDays
    with TableInfo<$ClimateDaysTable, ClimateDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClimateDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<int> done = GeneratedColumn<int>(
      'done', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _focusMinutesMeta =
      const VerificationMeta('focusMinutes');
  @override
  late final GeneratedColumn<int> focusMinutes = GeneratedColumn<int>(
      'focus_minutes', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [date, done, focusMinutes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'climate_days';
  @override
  VerificationContext validateIntegrity(Insertable<ClimateDay> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('done')) {
      context.handle(
          _doneMeta, done.isAcceptableOrUnknown(data['done']!, _doneMeta));
    } else if (isInserting) {
      context.missing(_doneMeta);
    }
    if (data.containsKey('focus_minutes')) {
      context.handle(
          _focusMinutesMeta,
          focusMinutes.isAcceptableOrUnknown(
              data['focus_minutes']!, _focusMinutesMeta));
    } else if (isInserting) {
      context.missing(_focusMinutesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  ClimateDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClimateDay(
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      done: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}done'])!,
      focusMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}focus_minutes'])!,
    );
  }

  @override
  $ClimateDaysTable createAlias(String alias) {
    return $ClimateDaysTable(attachedDatabase, alias);
  }
}

class ClimateDay extends DataClass implements Insertable<ClimateDay> {
  final String date;
  final int done;
  final int focusMinutes;
  const ClimateDay(
      {required this.date, required this.done, required this.focusMinutes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['done'] = Variable<int>(done);
    map['focus_minutes'] = Variable<int>(focusMinutes);
    return map;
  }

  ClimateDaysCompanion toCompanion(bool nullToAbsent) {
    return ClimateDaysCompanion(
      date: Value(date),
      done: Value(done),
      focusMinutes: Value(focusMinutes),
    );
  }

  factory ClimateDay.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClimateDay(
      date: serializer.fromJson<String>(json['date']),
      done: serializer.fromJson<int>(json['done']),
      focusMinutes: serializer.fromJson<int>(json['focusMinutes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'done': serializer.toJson<int>(done),
      'focusMinutes': serializer.toJson<int>(focusMinutes),
    };
  }

  ClimateDay copyWith({String? date, int? done, int? focusMinutes}) =>
      ClimateDay(
        date: date ?? this.date,
        done: done ?? this.done,
        focusMinutes: focusMinutes ?? this.focusMinutes,
      );
  ClimateDay copyWithCompanion(ClimateDaysCompanion data) {
    return ClimateDay(
      date: data.date.present ? data.date.value : this.date,
      done: data.done.present ? data.done.value : this.done,
      focusMinutes: data.focusMinutes.present
          ? data.focusMinutes.value
          : this.focusMinutes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClimateDay(')
          ..write('date: $date, ')
          ..write('done: $done, ')
          ..write('focusMinutes: $focusMinutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, done, focusMinutes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClimateDay &&
          other.date == this.date &&
          other.done == this.done &&
          other.focusMinutes == this.focusMinutes);
}

class ClimateDaysCompanion extends UpdateCompanion<ClimateDay> {
  final Value<String> date;
  final Value<int> done;
  final Value<int> focusMinutes;
  final Value<int> rowid;
  const ClimateDaysCompanion({
    this.date = const Value.absent(),
    this.done = const Value.absent(),
    this.focusMinutes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClimateDaysCompanion.insert({
    required String date,
    required int done,
    required int focusMinutes,
    this.rowid = const Value.absent(),
  })  : date = Value(date),
        done = Value(done),
        focusMinutes = Value(focusMinutes);
  static Insertable<ClimateDay> custom({
    Expression<String>? date,
    Expression<int>? done,
    Expression<int>? focusMinutes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (done != null) 'done': done,
      if (focusMinutes != null) 'focus_minutes': focusMinutes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClimateDaysCompanion copyWith(
      {Value<String>? date,
      Value<int>? done,
      Value<int>? focusMinutes,
      Value<int>? rowid}) {
    return ClimateDaysCompanion(
      date: date ?? this.date,
      done: done ?? this.done,
      focusMinutes: focusMinutes ?? this.focusMinutes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (done.present) {
      map['done'] = Variable<int>(done.value);
    }
    if (focusMinutes.present) {
      map['focus_minutes'] = Variable<int>(focusMinutes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClimateDaysCompanion(')
          ..write('date: $date, ')
          ..write('done: $done, ')
          ..write('focusMinutes: $focusMinutes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FocusMetadataTable extends FocusMetadata
    with TableInfo<$FocusMetadataTable, FocusMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _todayMinutesMeta =
      const VerificationMeta('todayMinutes');
  @override
  late final GeneratedColumn<int> todayMinutes = GeneratedColumn<int>(
      'today_minutes', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _weekMinutesMeta =
      const VerificationMeta('weekMinutes');
  @override
  late final GeneratedColumn<int> weekMinutes = GeneratedColumn<int>(
      'week_minutes', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _weekStartMeta =
      const VerificationMeta('weekStart');
  @override
  late final GeneratedColumn<String> weekStart = GeneratedColumn<String>(
      'week_start', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _glancesTodayMeta =
      const VerificationMeta('glancesToday');
  @override
  late final GeneratedColumn<int> glancesToday = GeneratedColumn<int>(
      'glances_today', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, todayMinutes, weekMinutes, weekStart, glancesToday];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_metadata';
  @override
  VerificationContext validateIntegrity(Insertable<FocusMetadataData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('today_minutes')) {
      context.handle(
          _todayMinutesMeta,
          todayMinutes.isAcceptableOrUnknown(
              data['today_minutes']!, _todayMinutesMeta));
    } else if (isInserting) {
      context.missing(_todayMinutesMeta);
    }
    if (data.containsKey('week_minutes')) {
      context.handle(
          _weekMinutesMeta,
          weekMinutes.isAcceptableOrUnknown(
              data['week_minutes']!, _weekMinutesMeta));
    } else if (isInserting) {
      context.missing(_weekMinutesMeta);
    }
    if (data.containsKey('week_start')) {
      context.handle(_weekStartMeta,
          weekStart.isAcceptableOrUnknown(data['week_start']!, _weekStartMeta));
    }
    if (data.containsKey('glances_today')) {
      context.handle(
          _glancesTodayMeta,
          glancesToday.isAcceptableOrUnknown(
              data['glances_today']!, _glancesTodayMeta));
    } else if (isInserting) {
      context.missing(_glancesTodayMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FocusMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FocusMetadataData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      todayMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}today_minutes'])!,
      weekMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}week_minutes'])!,
      weekStart: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}week_start']),
      glancesToday: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}glances_today'])!,
    );
  }

  @override
  $FocusMetadataTable createAlias(String alias) {
    return $FocusMetadataTable(attachedDatabase, alias);
  }
}

class FocusMetadataData extends DataClass
    implements Insertable<FocusMetadataData> {
  final int id;
  final int todayMinutes;
  final int weekMinutes;
  final String? weekStart;
  final int glancesToday;
  const FocusMetadataData(
      {required this.id,
      required this.todayMinutes,
      required this.weekMinutes,
      this.weekStart,
      required this.glancesToday});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['today_minutes'] = Variable<int>(todayMinutes);
    map['week_minutes'] = Variable<int>(weekMinutes);
    if (!nullToAbsent || weekStart != null) {
      map['week_start'] = Variable<String>(weekStart);
    }
    map['glances_today'] = Variable<int>(glancesToday);
    return map;
  }

  FocusMetadataCompanion toCompanion(bool nullToAbsent) {
    return FocusMetadataCompanion(
      id: Value(id),
      todayMinutes: Value(todayMinutes),
      weekMinutes: Value(weekMinutes),
      weekStart: weekStart == null && nullToAbsent
          ? const Value.absent()
          : Value(weekStart),
      glancesToday: Value(glancesToday),
    );
  }

  factory FocusMetadataData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FocusMetadataData(
      id: serializer.fromJson<int>(json['id']),
      todayMinutes: serializer.fromJson<int>(json['todayMinutes']),
      weekMinutes: serializer.fromJson<int>(json['weekMinutes']),
      weekStart: serializer.fromJson<String?>(json['weekStart']),
      glancesToday: serializer.fromJson<int>(json['glancesToday']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'todayMinutes': serializer.toJson<int>(todayMinutes),
      'weekMinutes': serializer.toJson<int>(weekMinutes),
      'weekStart': serializer.toJson<String?>(weekStart),
      'glancesToday': serializer.toJson<int>(glancesToday),
    };
  }

  FocusMetadataData copyWith(
          {int? id,
          int? todayMinutes,
          int? weekMinutes,
          Value<String?> weekStart = const Value.absent(),
          int? glancesToday}) =>
      FocusMetadataData(
        id: id ?? this.id,
        todayMinutes: todayMinutes ?? this.todayMinutes,
        weekMinutes: weekMinutes ?? this.weekMinutes,
        weekStart: weekStart.present ? weekStart.value : this.weekStart,
        glancesToday: glancesToday ?? this.glancesToday,
      );
  FocusMetadataData copyWithCompanion(FocusMetadataCompanion data) {
    return FocusMetadataData(
      id: data.id.present ? data.id.value : this.id,
      todayMinutes: data.todayMinutes.present
          ? data.todayMinutes.value
          : this.todayMinutes,
      weekMinutes:
          data.weekMinutes.present ? data.weekMinutes.value : this.weekMinutes,
      weekStart: data.weekStart.present ? data.weekStart.value : this.weekStart,
      glancesToday: data.glancesToday.present
          ? data.glancesToday.value
          : this.glancesToday,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FocusMetadataData(')
          ..write('id: $id, ')
          ..write('todayMinutes: $todayMinutes, ')
          ..write('weekMinutes: $weekMinutes, ')
          ..write('weekStart: $weekStart, ')
          ..write('glancesToday: $glancesToday')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, todayMinutes, weekMinutes, weekStart, glancesToday);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FocusMetadataData &&
          other.id == this.id &&
          other.todayMinutes == this.todayMinutes &&
          other.weekMinutes == this.weekMinutes &&
          other.weekStart == this.weekStart &&
          other.glancesToday == this.glancesToday);
}

class FocusMetadataCompanion extends UpdateCompanion<FocusMetadataData> {
  final Value<int> id;
  final Value<int> todayMinutes;
  final Value<int> weekMinutes;
  final Value<String?> weekStart;
  final Value<int> glancesToday;
  const FocusMetadataCompanion({
    this.id = const Value.absent(),
    this.todayMinutes = const Value.absent(),
    this.weekMinutes = const Value.absent(),
    this.weekStart = const Value.absent(),
    this.glancesToday = const Value.absent(),
  });
  FocusMetadataCompanion.insert({
    this.id = const Value.absent(),
    required int todayMinutes,
    required int weekMinutes,
    this.weekStart = const Value.absent(),
    required int glancesToday,
  })  : todayMinutes = Value(todayMinutes),
        weekMinutes = Value(weekMinutes),
        glancesToday = Value(glancesToday);
  static Insertable<FocusMetadataData> custom({
    Expression<int>? id,
    Expression<int>? todayMinutes,
    Expression<int>? weekMinutes,
    Expression<String>? weekStart,
    Expression<int>? glancesToday,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (todayMinutes != null) 'today_minutes': todayMinutes,
      if (weekMinutes != null) 'week_minutes': weekMinutes,
      if (weekStart != null) 'week_start': weekStart,
      if (glancesToday != null) 'glances_today': glancesToday,
    });
  }

  FocusMetadataCompanion copyWith(
      {Value<int>? id,
      Value<int>? todayMinutes,
      Value<int>? weekMinutes,
      Value<String?>? weekStart,
      Value<int>? glancesToday}) {
    return FocusMetadataCompanion(
      id: id ?? this.id,
      todayMinutes: todayMinutes ?? this.todayMinutes,
      weekMinutes: weekMinutes ?? this.weekMinutes,
      weekStart: weekStart ?? this.weekStart,
      glancesToday: glancesToday ?? this.glancesToday,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (todayMinutes.present) {
      map['today_minutes'] = Variable<int>(todayMinutes.value);
    }
    if (weekMinutes.present) {
      map['week_minutes'] = Variable<int>(weekMinutes.value);
    }
    if (weekStart.present) {
      map['week_start'] = Variable<String>(weekStart.value);
    }
    if (glancesToday.present) {
      map['glances_today'] = Variable<int>(glancesToday.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocusMetadataCompanion(')
          ..write('id: $id, ')
          ..write('todayMinutes: $todayMinutes, ')
          ..write('weekMinutes: $weekMinutes, ')
          ..write('weekStart: $weekStart, ')
          ..write('glancesToday: $glancesToday')
          ..write(')'))
        .toString();
  }
}

class $ActiveFocusSessionsTable extends ActiveFocusSessions
    with TableInfo<$ActiveFocusSessionsTable, ActiveFocusSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActiveFocusSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _petMeta = const VerificationMeta('pet');
  @override
  late final GeneratedColumn<String> pet = GeneratedColumn<String>(
      'pet', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES emotion_catalog (code)'));
  static const VerificationMeta _planMinutesMeta =
      const VerificationMeta('planMinutes');
  @override
  late final GeneratedColumn<int> planMinutes = GeneratedColumn<int>(
      'plan_minutes', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tierMultiplierMeta =
      const VerificationMeta('tierMultiplier');
  @override
  late final GeneratedColumn<double> tierMultiplier = GeneratedColumn<double>(
      'tier_multiplier', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _phaseMeta = const VerificationMeta('phase');
  @override
  late final GeneratedColumn<String> phase = GeneratedColumn<String>(
      'phase', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accumulatedSecondsMeta =
      const VerificationMeta('accumulatedSeconds');
  @override
  late final GeneratedColumn<int> accumulatedSeconds = GeneratedColumn<int>(
      'accumulated_seconds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _startedAtMsMeta =
      const VerificationMeta('startedAtMs');
  @override
  late final GeneratedColumn<int> startedAtMs = GeneratedColumn<int>(
      'started_at_ms', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lastTickAtMsMeta =
      const VerificationMeta('lastTickAtMs');
  @override
  late final GeneratedColumn<int> lastTickAtMs = GeneratedColumn<int>(
      'last_tick_at_ms', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _pausedAtMsMeta =
      const VerificationMeta('pausedAtMs');
  @override
  late final GeneratedColumn<int> pausedAtMs = GeneratedColumn<int>(
      'paused_at_ms', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        pet,
        planMinutes,
        tierMultiplier,
        phase,
        accumulatedSeconds,
        startedAtMs,
        lastTickAtMs,
        pausedAtMs
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'active_focus_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<ActiveFocusSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pet')) {
      context.handle(
          _petMeta, pet.isAcceptableOrUnknown(data['pet']!, _petMeta));
    } else if (isInserting) {
      context.missing(_petMeta);
    }
    if (data.containsKey('plan_minutes')) {
      context.handle(
          _planMinutesMeta,
          planMinutes.isAcceptableOrUnknown(
              data['plan_minutes']!, _planMinutesMeta));
    } else if (isInserting) {
      context.missing(_planMinutesMeta);
    }
    if (data.containsKey('tier_multiplier')) {
      context.handle(
          _tierMultiplierMeta,
          tierMultiplier.isAcceptableOrUnknown(
              data['tier_multiplier']!, _tierMultiplierMeta));
    } else if (isInserting) {
      context.missing(_tierMultiplierMeta);
    }
    if (data.containsKey('phase')) {
      context.handle(
          _phaseMeta, phase.isAcceptableOrUnknown(data['phase']!, _phaseMeta));
    } else if (isInserting) {
      context.missing(_phaseMeta);
    }
    if (data.containsKey('accumulated_seconds')) {
      context.handle(
          _accumulatedSecondsMeta,
          accumulatedSeconds.isAcceptableOrUnknown(
              data['accumulated_seconds']!, _accumulatedSecondsMeta));
    } else if (isInserting) {
      context.missing(_accumulatedSecondsMeta);
    }
    if (data.containsKey('started_at_ms')) {
      context.handle(
          _startedAtMsMeta,
          startedAtMs.isAcceptableOrUnknown(
              data['started_at_ms']!, _startedAtMsMeta));
    } else if (isInserting) {
      context.missing(_startedAtMsMeta);
    }
    if (data.containsKey('last_tick_at_ms')) {
      context.handle(
          _lastTickAtMsMeta,
          lastTickAtMs.isAcceptableOrUnknown(
              data['last_tick_at_ms']!, _lastTickAtMsMeta));
    } else if (isInserting) {
      context.missing(_lastTickAtMsMeta);
    }
    if (data.containsKey('paused_at_ms')) {
      context.handle(
          _pausedAtMsMeta,
          pausedAtMs.isAcceptableOrUnknown(
              data['paused_at_ms']!, _pausedAtMsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActiveFocusSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActiveFocusSession(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      pet: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pet'])!,
      planMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}plan_minutes'])!,
      tierMultiplier: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}tier_multiplier'])!,
      phase: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phase'])!,
      accumulatedSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}accumulated_seconds'])!,
      startedAtMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}started_at_ms'])!,
      lastTickAtMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_tick_at_ms'])!,
      pausedAtMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}paused_at_ms']),
    );
  }

  @override
  $ActiveFocusSessionsTable createAlias(String alias) {
    return $ActiveFocusSessionsTable(attachedDatabase, alias);
  }
}

class ActiveFocusSession extends DataClass
    implements Insertable<ActiveFocusSession> {
  final int id;
  final String pet;
  final int planMinutes;
  final double tierMultiplier;
  final String phase;
  final int accumulatedSeconds;
  final int startedAtMs;
  final int lastTickAtMs;
  final int? pausedAtMs;
  const ActiveFocusSession(
      {required this.id,
      required this.pet,
      required this.planMinutes,
      required this.tierMultiplier,
      required this.phase,
      required this.accumulatedSeconds,
      required this.startedAtMs,
      required this.lastTickAtMs,
      this.pausedAtMs});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pet'] = Variable<String>(pet);
    map['plan_minutes'] = Variable<int>(planMinutes);
    map['tier_multiplier'] = Variable<double>(tierMultiplier);
    map['phase'] = Variable<String>(phase);
    map['accumulated_seconds'] = Variable<int>(accumulatedSeconds);
    map['started_at_ms'] = Variable<int>(startedAtMs);
    map['last_tick_at_ms'] = Variable<int>(lastTickAtMs);
    if (!nullToAbsent || pausedAtMs != null) {
      map['paused_at_ms'] = Variable<int>(pausedAtMs);
    }
    return map;
  }

  ActiveFocusSessionsCompanion toCompanion(bool nullToAbsent) {
    return ActiveFocusSessionsCompanion(
      id: Value(id),
      pet: Value(pet),
      planMinutes: Value(planMinutes),
      tierMultiplier: Value(tierMultiplier),
      phase: Value(phase),
      accumulatedSeconds: Value(accumulatedSeconds),
      startedAtMs: Value(startedAtMs),
      lastTickAtMs: Value(lastTickAtMs),
      pausedAtMs: pausedAtMs == null && nullToAbsent
          ? const Value.absent()
          : Value(pausedAtMs),
    );
  }

  factory ActiveFocusSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActiveFocusSession(
      id: serializer.fromJson<int>(json['id']),
      pet: serializer.fromJson<String>(json['pet']),
      planMinutes: serializer.fromJson<int>(json['planMinutes']),
      tierMultiplier: serializer.fromJson<double>(json['tierMultiplier']),
      phase: serializer.fromJson<String>(json['phase']),
      accumulatedSeconds: serializer.fromJson<int>(json['accumulatedSeconds']),
      startedAtMs: serializer.fromJson<int>(json['startedAtMs']),
      lastTickAtMs: serializer.fromJson<int>(json['lastTickAtMs']),
      pausedAtMs: serializer.fromJson<int?>(json['pausedAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pet': serializer.toJson<String>(pet),
      'planMinutes': serializer.toJson<int>(planMinutes),
      'tierMultiplier': serializer.toJson<double>(tierMultiplier),
      'phase': serializer.toJson<String>(phase),
      'accumulatedSeconds': serializer.toJson<int>(accumulatedSeconds),
      'startedAtMs': serializer.toJson<int>(startedAtMs),
      'lastTickAtMs': serializer.toJson<int>(lastTickAtMs),
      'pausedAtMs': serializer.toJson<int?>(pausedAtMs),
    };
  }

  ActiveFocusSession copyWith(
          {int? id,
          String? pet,
          int? planMinutes,
          double? tierMultiplier,
          String? phase,
          int? accumulatedSeconds,
          int? startedAtMs,
          int? lastTickAtMs,
          Value<int?> pausedAtMs = const Value.absent()}) =>
      ActiveFocusSession(
        id: id ?? this.id,
        pet: pet ?? this.pet,
        planMinutes: planMinutes ?? this.planMinutes,
        tierMultiplier: tierMultiplier ?? this.tierMultiplier,
        phase: phase ?? this.phase,
        accumulatedSeconds: accumulatedSeconds ?? this.accumulatedSeconds,
        startedAtMs: startedAtMs ?? this.startedAtMs,
        lastTickAtMs: lastTickAtMs ?? this.lastTickAtMs,
        pausedAtMs: pausedAtMs.present ? pausedAtMs.value : this.pausedAtMs,
      );
  ActiveFocusSession copyWithCompanion(ActiveFocusSessionsCompanion data) {
    return ActiveFocusSession(
      id: data.id.present ? data.id.value : this.id,
      pet: data.pet.present ? data.pet.value : this.pet,
      planMinutes:
          data.planMinutes.present ? data.planMinutes.value : this.planMinutes,
      tierMultiplier: data.tierMultiplier.present
          ? data.tierMultiplier.value
          : this.tierMultiplier,
      phase: data.phase.present ? data.phase.value : this.phase,
      accumulatedSeconds: data.accumulatedSeconds.present
          ? data.accumulatedSeconds.value
          : this.accumulatedSeconds,
      startedAtMs:
          data.startedAtMs.present ? data.startedAtMs.value : this.startedAtMs,
      lastTickAtMs: data.lastTickAtMs.present
          ? data.lastTickAtMs.value
          : this.lastTickAtMs,
      pausedAtMs:
          data.pausedAtMs.present ? data.pausedAtMs.value : this.pausedAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActiveFocusSession(')
          ..write('id: $id, ')
          ..write('pet: $pet, ')
          ..write('planMinutes: $planMinutes, ')
          ..write('tierMultiplier: $tierMultiplier, ')
          ..write('phase: $phase, ')
          ..write('accumulatedSeconds: $accumulatedSeconds, ')
          ..write('startedAtMs: $startedAtMs, ')
          ..write('lastTickAtMs: $lastTickAtMs, ')
          ..write('pausedAtMs: $pausedAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, pet, planMinutes, tierMultiplier, phase,
      accumulatedSeconds, startedAtMs, lastTickAtMs, pausedAtMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActiveFocusSession &&
          other.id == this.id &&
          other.pet == this.pet &&
          other.planMinutes == this.planMinutes &&
          other.tierMultiplier == this.tierMultiplier &&
          other.phase == this.phase &&
          other.accumulatedSeconds == this.accumulatedSeconds &&
          other.startedAtMs == this.startedAtMs &&
          other.lastTickAtMs == this.lastTickAtMs &&
          other.pausedAtMs == this.pausedAtMs);
}

class ActiveFocusSessionsCompanion extends UpdateCompanion<ActiveFocusSession> {
  final Value<int> id;
  final Value<String> pet;
  final Value<int> planMinutes;
  final Value<double> tierMultiplier;
  final Value<String> phase;
  final Value<int> accumulatedSeconds;
  final Value<int> startedAtMs;
  final Value<int> lastTickAtMs;
  final Value<int?> pausedAtMs;
  const ActiveFocusSessionsCompanion({
    this.id = const Value.absent(),
    this.pet = const Value.absent(),
    this.planMinutes = const Value.absent(),
    this.tierMultiplier = const Value.absent(),
    this.phase = const Value.absent(),
    this.accumulatedSeconds = const Value.absent(),
    this.startedAtMs = const Value.absent(),
    this.lastTickAtMs = const Value.absent(),
    this.pausedAtMs = const Value.absent(),
  });
  ActiveFocusSessionsCompanion.insert({
    this.id = const Value.absent(),
    required String pet,
    required int planMinutes,
    required double tierMultiplier,
    required String phase,
    required int accumulatedSeconds,
    required int startedAtMs,
    required int lastTickAtMs,
    this.pausedAtMs = const Value.absent(),
  })  : pet = Value(pet),
        planMinutes = Value(planMinutes),
        tierMultiplier = Value(tierMultiplier),
        phase = Value(phase),
        accumulatedSeconds = Value(accumulatedSeconds),
        startedAtMs = Value(startedAtMs),
        lastTickAtMs = Value(lastTickAtMs);
  static Insertable<ActiveFocusSession> custom({
    Expression<int>? id,
    Expression<String>? pet,
    Expression<int>? planMinutes,
    Expression<double>? tierMultiplier,
    Expression<String>? phase,
    Expression<int>? accumulatedSeconds,
    Expression<int>? startedAtMs,
    Expression<int>? lastTickAtMs,
    Expression<int>? pausedAtMs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pet != null) 'pet': pet,
      if (planMinutes != null) 'plan_minutes': planMinutes,
      if (tierMultiplier != null) 'tier_multiplier': tierMultiplier,
      if (phase != null) 'phase': phase,
      if (accumulatedSeconds != null) 'accumulated_seconds': accumulatedSeconds,
      if (startedAtMs != null) 'started_at_ms': startedAtMs,
      if (lastTickAtMs != null) 'last_tick_at_ms': lastTickAtMs,
      if (pausedAtMs != null) 'paused_at_ms': pausedAtMs,
    });
  }

  ActiveFocusSessionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? pet,
      Value<int>? planMinutes,
      Value<double>? tierMultiplier,
      Value<String>? phase,
      Value<int>? accumulatedSeconds,
      Value<int>? startedAtMs,
      Value<int>? lastTickAtMs,
      Value<int?>? pausedAtMs}) {
    return ActiveFocusSessionsCompanion(
      id: id ?? this.id,
      pet: pet ?? this.pet,
      planMinutes: planMinutes ?? this.planMinutes,
      tierMultiplier: tierMultiplier ?? this.tierMultiplier,
      phase: phase ?? this.phase,
      accumulatedSeconds: accumulatedSeconds ?? this.accumulatedSeconds,
      startedAtMs: startedAtMs ?? this.startedAtMs,
      lastTickAtMs: lastTickAtMs ?? this.lastTickAtMs,
      pausedAtMs: pausedAtMs ?? this.pausedAtMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pet.present) {
      map['pet'] = Variable<String>(pet.value);
    }
    if (planMinutes.present) {
      map['plan_minutes'] = Variable<int>(planMinutes.value);
    }
    if (tierMultiplier.present) {
      map['tier_multiplier'] = Variable<double>(tierMultiplier.value);
    }
    if (phase.present) {
      map['phase'] = Variable<String>(phase.value);
    }
    if (accumulatedSeconds.present) {
      map['accumulated_seconds'] = Variable<int>(accumulatedSeconds.value);
    }
    if (startedAtMs.present) {
      map['started_at_ms'] = Variable<int>(startedAtMs.value);
    }
    if (lastTickAtMs.present) {
      map['last_tick_at_ms'] = Variable<int>(lastTickAtMs.value);
    }
    if (pausedAtMs.present) {
      map['paused_at_ms'] = Variable<int>(pausedAtMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActiveFocusSessionsCompanion(')
          ..write('id: $id, ')
          ..write('pet: $pet, ')
          ..write('planMinutes: $planMinutes, ')
          ..write('tierMultiplier: $tierMultiplier, ')
          ..write('phase: $phase, ')
          ..write('accumulatedSeconds: $accumulatedSeconds, ')
          ..write('startedAtMs: $startedAtMs, ')
          ..write('lastTickAtMs: $lastTickAtMs, ')
          ..write('pausedAtMs: $pausedAtMs')
          ..write(')'))
        .toString();
  }
}

class $DailyStatesTable extends DailyStates
    with TableInfo<$DailyStatesTable, DailyState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _checkinDaysMeta =
      const VerificationMeta('checkinDays');
  @override
  late final GeneratedColumn<int> checkinDays = GeneratedColumn<int>(
      'checkin_days', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _checkinBestMeta =
      const VerificationMeta('checkinBest');
  @override
  late final GeneratedColumn<int> checkinBest = GeneratedColumn<int>(
      'checkin_best', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _checkedTodayMeta =
      const VerificationMeta('checkedToday');
  @override
  late final GeneratedColumn<bool> checkedToday = GeneratedColumn<bool>(
      'checked_today', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("checked_today" IN (0, 1))'));
  static const VerificationMeta _lastCheckinMeta =
      const VerificationMeta('lastCheckin');
  @override
  late final GeneratedColumn<String> lastCheckin = GeneratedColumn<String>(
      'last_checkin', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastGreetMeta =
      const VerificationMeta('lastGreet');
  @override
  late final GeneratedColumn<String> lastGreet = GeneratedColumn<String>(
      'last_greet', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _mazeTodayMeta =
      const VerificationMeta('mazeToday');
  @override
  late final GeneratedColumn<int> mazeToday = GeneratedColumn<int>(
      'maze_today', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        date,
        checkinDays,
        checkinBest,
        checkedToday,
        lastCheckin,
        lastGreet,
        mazeToday
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_states';
  @override
  VerificationContext validateIntegrity(Insertable<DailyState> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('checkin_days')) {
      context.handle(
          _checkinDaysMeta,
          checkinDays.isAcceptableOrUnknown(
              data['checkin_days']!, _checkinDaysMeta));
    } else if (isInserting) {
      context.missing(_checkinDaysMeta);
    }
    if (data.containsKey('checkin_best')) {
      context.handle(
          _checkinBestMeta,
          checkinBest.isAcceptableOrUnknown(
              data['checkin_best']!, _checkinBestMeta));
    } else if (isInserting) {
      context.missing(_checkinBestMeta);
    }
    if (data.containsKey('checked_today')) {
      context.handle(
          _checkedTodayMeta,
          checkedToday.isAcceptableOrUnknown(
              data['checked_today']!, _checkedTodayMeta));
    } else if (isInserting) {
      context.missing(_checkedTodayMeta);
    }
    if (data.containsKey('last_checkin')) {
      context.handle(
          _lastCheckinMeta,
          lastCheckin.isAcceptableOrUnknown(
              data['last_checkin']!, _lastCheckinMeta));
    }
    if (data.containsKey('last_greet')) {
      context.handle(_lastGreetMeta,
          lastGreet.isAcceptableOrUnknown(data['last_greet']!, _lastGreetMeta));
    }
    if (data.containsKey('maze_today')) {
      context.handle(_mazeTodayMeta,
          mazeToday.isAcceptableOrUnknown(data['maze_today']!, _mazeTodayMeta));
    } else if (isInserting) {
      context.missing(_mazeTodayMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyState(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date']),
      checkinDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}checkin_days'])!,
      checkinBest: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}checkin_best'])!,
      checkedToday: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}checked_today'])!,
      lastCheckin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_checkin']),
      lastGreet: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_greet']),
      mazeToday: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}maze_today'])!,
    );
  }

  @override
  $DailyStatesTable createAlias(String alias) {
    return $DailyStatesTable(attachedDatabase, alias);
  }
}

class DailyState extends DataClass implements Insertable<DailyState> {
  final int id;
  final String? date;
  final int checkinDays;
  final int checkinBest;
  final bool checkedToday;
  final String? lastCheckin;
  final String? lastGreet;
  final int mazeToday;
  const DailyState(
      {required this.id,
      this.date,
      required this.checkinDays,
      required this.checkinBest,
      required this.checkedToday,
      this.lastCheckin,
      this.lastGreet,
      required this.mazeToday});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<String>(date);
    }
    map['checkin_days'] = Variable<int>(checkinDays);
    map['checkin_best'] = Variable<int>(checkinBest);
    map['checked_today'] = Variable<bool>(checkedToday);
    if (!nullToAbsent || lastCheckin != null) {
      map['last_checkin'] = Variable<String>(lastCheckin);
    }
    if (!nullToAbsent || lastGreet != null) {
      map['last_greet'] = Variable<String>(lastGreet);
    }
    map['maze_today'] = Variable<int>(mazeToday);
    return map;
  }

  DailyStatesCompanion toCompanion(bool nullToAbsent) {
    return DailyStatesCompanion(
      id: Value(id),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      checkinDays: Value(checkinDays),
      checkinBest: Value(checkinBest),
      checkedToday: Value(checkedToday),
      lastCheckin: lastCheckin == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCheckin),
      lastGreet: lastGreet == null && nullToAbsent
          ? const Value.absent()
          : Value(lastGreet),
      mazeToday: Value(mazeToday),
    );
  }

  factory DailyState.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyState(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String?>(json['date']),
      checkinDays: serializer.fromJson<int>(json['checkinDays']),
      checkinBest: serializer.fromJson<int>(json['checkinBest']),
      checkedToday: serializer.fromJson<bool>(json['checkedToday']),
      lastCheckin: serializer.fromJson<String?>(json['lastCheckin']),
      lastGreet: serializer.fromJson<String?>(json['lastGreet']),
      mazeToday: serializer.fromJson<int>(json['mazeToday']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String?>(date),
      'checkinDays': serializer.toJson<int>(checkinDays),
      'checkinBest': serializer.toJson<int>(checkinBest),
      'checkedToday': serializer.toJson<bool>(checkedToday),
      'lastCheckin': serializer.toJson<String?>(lastCheckin),
      'lastGreet': serializer.toJson<String?>(lastGreet),
      'mazeToday': serializer.toJson<int>(mazeToday),
    };
  }

  DailyState copyWith(
          {int? id,
          Value<String?> date = const Value.absent(),
          int? checkinDays,
          int? checkinBest,
          bool? checkedToday,
          Value<String?> lastCheckin = const Value.absent(),
          Value<String?> lastGreet = const Value.absent(),
          int? mazeToday}) =>
      DailyState(
        id: id ?? this.id,
        date: date.present ? date.value : this.date,
        checkinDays: checkinDays ?? this.checkinDays,
        checkinBest: checkinBest ?? this.checkinBest,
        checkedToday: checkedToday ?? this.checkedToday,
        lastCheckin: lastCheckin.present ? lastCheckin.value : this.lastCheckin,
        lastGreet: lastGreet.present ? lastGreet.value : this.lastGreet,
        mazeToday: mazeToday ?? this.mazeToday,
      );
  DailyState copyWithCompanion(DailyStatesCompanion data) {
    return DailyState(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      checkinDays:
          data.checkinDays.present ? data.checkinDays.value : this.checkinDays,
      checkinBest:
          data.checkinBest.present ? data.checkinBest.value : this.checkinBest,
      checkedToday: data.checkedToday.present
          ? data.checkedToday.value
          : this.checkedToday,
      lastCheckin:
          data.lastCheckin.present ? data.lastCheckin.value : this.lastCheckin,
      lastGreet: data.lastGreet.present ? data.lastGreet.value : this.lastGreet,
      mazeToday: data.mazeToday.present ? data.mazeToday.value : this.mazeToday,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyState(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('checkinDays: $checkinDays, ')
          ..write('checkinBest: $checkinBest, ')
          ..write('checkedToday: $checkedToday, ')
          ..write('lastCheckin: $lastCheckin, ')
          ..write('lastGreet: $lastGreet, ')
          ..write('mazeToday: $mazeToday')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, checkinDays, checkinBest,
      checkedToday, lastCheckin, lastGreet, mazeToday);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyState &&
          other.id == this.id &&
          other.date == this.date &&
          other.checkinDays == this.checkinDays &&
          other.checkinBest == this.checkinBest &&
          other.checkedToday == this.checkedToday &&
          other.lastCheckin == this.lastCheckin &&
          other.lastGreet == this.lastGreet &&
          other.mazeToday == this.mazeToday);
}

class DailyStatesCompanion extends UpdateCompanion<DailyState> {
  final Value<int> id;
  final Value<String?> date;
  final Value<int> checkinDays;
  final Value<int> checkinBest;
  final Value<bool> checkedToday;
  final Value<String?> lastCheckin;
  final Value<String?> lastGreet;
  final Value<int> mazeToday;
  const DailyStatesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.checkinDays = const Value.absent(),
    this.checkinBest = const Value.absent(),
    this.checkedToday = const Value.absent(),
    this.lastCheckin = const Value.absent(),
    this.lastGreet = const Value.absent(),
    this.mazeToday = const Value.absent(),
  });
  DailyStatesCompanion.insert({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    required int checkinDays,
    required int checkinBest,
    required bool checkedToday,
    this.lastCheckin = const Value.absent(),
    this.lastGreet = const Value.absent(),
    required int mazeToday,
  })  : checkinDays = Value(checkinDays),
        checkinBest = Value(checkinBest),
        checkedToday = Value(checkedToday),
        mazeToday = Value(mazeToday);
  static Insertable<DailyState> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<int>? checkinDays,
    Expression<int>? checkinBest,
    Expression<bool>? checkedToday,
    Expression<String>? lastCheckin,
    Expression<String>? lastGreet,
    Expression<int>? mazeToday,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (checkinDays != null) 'checkin_days': checkinDays,
      if (checkinBest != null) 'checkin_best': checkinBest,
      if (checkedToday != null) 'checked_today': checkedToday,
      if (lastCheckin != null) 'last_checkin': lastCheckin,
      if (lastGreet != null) 'last_greet': lastGreet,
      if (mazeToday != null) 'maze_today': mazeToday,
    });
  }

  DailyStatesCompanion copyWith(
      {Value<int>? id,
      Value<String?>? date,
      Value<int>? checkinDays,
      Value<int>? checkinBest,
      Value<bool>? checkedToday,
      Value<String?>? lastCheckin,
      Value<String?>? lastGreet,
      Value<int>? mazeToday}) {
    return DailyStatesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      checkinDays: checkinDays ?? this.checkinDays,
      checkinBest: checkinBest ?? this.checkinBest,
      checkedToday: checkedToday ?? this.checkedToday,
      lastCheckin: lastCheckin ?? this.lastCheckin,
      lastGreet: lastGreet ?? this.lastGreet,
      mazeToday: mazeToday ?? this.mazeToday,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (checkinDays.present) {
      map['checkin_days'] = Variable<int>(checkinDays.value);
    }
    if (checkinBest.present) {
      map['checkin_best'] = Variable<int>(checkinBest.value);
    }
    if (checkedToday.present) {
      map['checked_today'] = Variable<bool>(checkedToday.value);
    }
    if (lastCheckin.present) {
      map['last_checkin'] = Variable<String>(lastCheckin.value);
    }
    if (lastGreet.present) {
      map['last_greet'] = Variable<String>(lastGreet.value);
    }
    if (mazeToday.present) {
      map['maze_today'] = Variable<int>(mazeToday.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyStatesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('checkinDays: $checkinDays, ')
          ..write('checkinBest: $checkinBest, ')
          ..write('checkedToday: $checkedToday, ')
          ..write('lastCheckin: $lastCheckin, ')
          ..write('lastGreet: $lastGreet, ')
          ..write('mazeToday: $mazeToday')
          ..write(')'))
        .toString();
  }
}

class $DailyQuestProgressRowsTable extends DailyQuestProgressRows
    with TableInfo<$DailyQuestProgressRowsTable, DailyQuestProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyQuestProgressRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _questCodeMeta =
      const VerificationMeta('questCode');
  @override
  late final GeneratedColumn<String> questCode = GeneratedColumn<String>(
      'quest_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES daily_quest_catalog (code)'));
  static const VerificationMeta _progressMeta =
      const VerificationMeta('progress');
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
      'progress', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _claimedMeta =
      const VerificationMeta('claimed');
  @override
  late final GeneratedColumn<bool> claimed = GeneratedColumn<bool>(
      'claimed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("claimed" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [questCode, progress, claimed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_quest_progress';
  @override
  VerificationContext validateIntegrity(
      Insertable<DailyQuestProgressRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('quest_code')) {
      context.handle(_questCodeMeta,
          questCode.isAcceptableOrUnknown(data['quest_code']!, _questCodeMeta));
    } else if (isInserting) {
      context.missing(_questCodeMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(_progressMeta,
          progress.isAcceptableOrUnknown(data['progress']!, _progressMeta));
    } else if (isInserting) {
      context.missing(_progressMeta);
    }
    if (data.containsKey('claimed')) {
      context.handle(_claimedMeta,
          claimed.isAcceptableOrUnknown(data['claimed']!, _claimedMeta));
    } else if (isInserting) {
      context.missing(_claimedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {questCode};
  @override
  DailyQuestProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyQuestProgressRow(
      questCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}quest_code'])!,
      progress: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}progress'])!,
      claimed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}claimed'])!,
    );
  }

  @override
  $DailyQuestProgressRowsTable createAlias(String alias) {
    return $DailyQuestProgressRowsTable(attachedDatabase, alias);
  }
}

class DailyQuestProgressRow extends DataClass
    implements Insertable<DailyQuestProgressRow> {
  final String questCode;
  final int progress;
  final bool claimed;
  const DailyQuestProgressRow(
      {required this.questCode, required this.progress, required this.claimed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['quest_code'] = Variable<String>(questCode);
    map['progress'] = Variable<int>(progress);
    map['claimed'] = Variable<bool>(claimed);
    return map;
  }

  DailyQuestProgressRowsCompanion toCompanion(bool nullToAbsent) {
    return DailyQuestProgressRowsCompanion(
      questCode: Value(questCode),
      progress: Value(progress),
      claimed: Value(claimed),
    );
  }

  factory DailyQuestProgressRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyQuestProgressRow(
      questCode: serializer.fromJson<String>(json['questCode']),
      progress: serializer.fromJson<int>(json['progress']),
      claimed: serializer.fromJson<bool>(json['claimed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'questCode': serializer.toJson<String>(questCode),
      'progress': serializer.toJson<int>(progress),
      'claimed': serializer.toJson<bool>(claimed),
    };
  }

  DailyQuestProgressRow copyWith(
          {String? questCode, int? progress, bool? claimed}) =>
      DailyQuestProgressRow(
        questCode: questCode ?? this.questCode,
        progress: progress ?? this.progress,
        claimed: claimed ?? this.claimed,
      );
  DailyQuestProgressRow copyWithCompanion(
      DailyQuestProgressRowsCompanion data) {
    return DailyQuestProgressRow(
      questCode: data.questCode.present ? data.questCode.value : this.questCode,
      progress: data.progress.present ? data.progress.value : this.progress,
      claimed: data.claimed.present ? data.claimed.value : this.claimed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyQuestProgressRow(')
          ..write('questCode: $questCode, ')
          ..write('progress: $progress, ')
          ..write('claimed: $claimed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(questCode, progress, claimed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyQuestProgressRow &&
          other.questCode == this.questCode &&
          other.progress == this.progress &&
          other.claimed == this.claimed);
}

class DailyQuestProgressRowsCompanion
    extends UpdateCompanion<DailyQuestProgressRow> {
  final Value<String> questCode;
  final Value<int> progress;
  final Value<bool> claimed;
  final Value<int> rowid;
  const DailyQuestProgressRowsCompanion({
    this.questCode = const Value.absent(),
    this.progress = const Value.absent(),
    this.claimed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyQuestProgressRowsCompanion.insert({
    required String questCode,
    required int progress,
    required bool claimed,
    this.rowid = const Value.absent(),
  })  : questCode = Value(questCode),
        progress = Value(progress),
        claimed = Value(claimed);
  static Insertable<DailyQuestProgressRow> custom({
    Expression<String>? questCode,
    Expression<int>? progress,
    Expression<bool>? claimed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (questCode != null) 'quest_code': questCode,
      if (progress != null) 'progress': progress,
      if (claimed != null) 'claimed': claimed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyQuestProgressRowsCompanion copyWith(
      {Value<String>? questCode,
      Value<int>? progress,
      Value<bool>? claimed,
      Value<int>? rowid}) {
    return DailyQuestProgressRowsCompanion(
      questCode: questCode ?? this.questCode,
      progress: progress ?? this.progress,
      claimed: claimed ?? this.claimed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (questCode.present) {
      map['quest_code'] = Variable<String>(questCode.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (claimed.present) {
      map['claimed'] = Variable<bool>(claimed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyQuestProgressRowsCompanion(')
          ..write('questCode: $questCode, ')
          ..write('progress: $progress, ')
          ..write('claimed: $claimed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AchievementUnlocksTable extends AchievementUnlocks
    with TableInfo<$AchievementUnlocksTable, AchievementUnlock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementUnlocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL CHECK (position >= 0)');
  @override
  List<GeneratedColumn> get $columns => [code, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievement_unlocks';
  @override
  VerificationContext validateIntegrity(Insertable<AchievementUnlock> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  AchievementUnlock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AchievementUnlock(
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
    );
  }

  @override
  $AchievementUnlocksTable createAlias(String alias) {
    return $AchievementUnlocksTable(attachedDatabase, alias);
  }
}

class AchievementUnlock extends DataClass
    implements Insertable<AchievementUnlock> {
  final String code;
  final int position;
  const AchievementUnlock({required this.code, required this.position});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['position'] = Variable<int>(position);
    return map;
  }

  AchievementUnlocksCompanion toCompanion(bool nullToAbsent) {
    return AchievementUnlocksCompanion(
      code: Value(code),
      position: Value(position),
    );
  }

  factory AchievementUnlock.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AchievementUnlock(
      code: serializer.fromJson<String>(json['code']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'position': serializer.toJson<int>(position),
    };
  }

  AchievementUnlock copyWith({String? code, int? position}) =>
      AchievementUnlock(
        code: code ?? this.code,
        position: position ?? this.position,
      );
  AchievementUnlock copyWithCompanion(AchievementUnlocksCompanion data) {
    return AchievementUnlock(
      code: data.code.present ? data.code.value : this.code,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AchievementUnlock(')
          ..write('code: $code, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AchievementUnlock &&
          other.code == this.code &&
          other.position == this.position);
}

class AchievementUnlocksCompanion extends UpdateCompanion<AchievementUnlock> {
  final Value<String> code;
  final Value<int> position;
  final Value<int> rowid;
  const AchievementUnlocksCompanion({
    this.code = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AchievementUnlocksCompanion.insert({
    required String code,
    required int position,
    this.rowid = const Value.absent(),
  })  : code = Value(code),
        position = Value(position);
  static Insertable<AchievementUnlock> custom({
    Expression<String>? code,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AchievementUnlocksCompanion copyWith(
      {Value<String>? code, Value<int>? position, Value<int>? rowid}) {
    return AchievementUnlocksCompanion(
      code: code ?? this.code,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AchievementUnlocksCompanion(')
          ..write('code: $code, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoamSlotsTable extends RoamSlots
    with TableInfo<$RoamSlotsTable, RoamSlot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoamSlotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _slotIndexMeta =
      const VerificationMeta('slotIndex');
  @override
  late final GeneratedColumn<int> slotIndex = GeneratedColumn<int>(
      'slot_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _petMeta = const VerificationMeta('pet');
  @override
  late final GeneratedColumn<String> pet = GeneratedColumn<String>(
      'pet', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES emotion_catalog (code)'));
  static const VerificationMeta _routeIdMeta =
      const VerificationMeta('routeId');
  @override
  late final GeneratedColumn<String> routeId = GeneratedColumn<String>(
      'route_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startedAtMsMeta =
      const VerificationMeta('startedAtMs');
  @override
  late final GeneratedColumn<int> startedAtMs = GeneratedColumn<int>(
      'started_at_ms', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _durationMsMeta =
      const VerificationMeta('durationMs');
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
      'duration_ms', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [slotIndex, pet, routeId, startedAtMs, durationMs];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'roam_slots';
  @override
  VerificationContext validateIntegrity(Insertable<RoamSlot> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('slot_index')) {
      context.handle(_slotIndexMeta,
          slotIndex.isAcceptableOrUnknown(data['slot_index']!, _slotIndexMeta));
    }
    if (data.containsKey('pet')) {
      context.handle(
          _petMeta, pet.isAcceptableOrUnknown(data['pet']!, _petMeta));
    } else if (isInserting) {
      context.missing(_petMeta);
    }
    if (data.containsKey('route_id')) {
      context.handle(_routeIdMeta,
          routeId.isAcceptableOrUnknown(data['route_id']!, _routeIdMeta));
    } else if (isInserting) {
      context.missing(_routeIdMeta);
    }
    if (data.containsKey('started_at_ms')) {
      context.handle(
          _startedAtMsMeta,
          startedAtMs.isAcceptableOrUnknown(
              data['started_at_ms']!, _startedAtMsMeta));
    } else if (isInserting) {
      context.missing(_startedAtMsMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
          _durationMsMeta,
          durationMs.isAcceptableOrUnknown(
              data['duration_ms']!, _durationMsMeta));
    } else if (isInserting) {
      context.missing(_durationMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {slotIndex};
  @override
  RoamSlot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoamSlot(
      slotIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}slot_index'])!,
      pet: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pet'])!,
      routeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}route_id'])!,
      startedAtMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}started_at_ms'])!,
      durationMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_ms'])!,
    );
  }

  @override
  $RoamSlotsTable createAlias(String alias) {
    return $RoamSlotsTable(attachedDatabase, alias);
  }
}

class RoamSlot extends DataClass implements Insertable<RoamSlot> {
  final int slotIndex;
  final String pet;
  final String routeId;
  final int startedAtMs;
  final int durationMs;
  const RoamSlot(
      {required this.slotIndex,
      required this.pet,
      required this.routeId,
      required this.startedAtMs,
      required this.durationMs});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['slot_index'] = Variable<int>(slotIndex);
    map['pet'] = Variable<String>(pet);
    map['route_id'] = Variable<String>(routeId);
    map['started_at_ms'] = Variable<int>(startedAtMs);
    map['duration_ms'] = Variable<int>(durationMs);
    return map;
  }

  RoamSlotsCompanion toCompanion(bool nullToAbsent) {
    return RoamSlotsCompanion(
      slotIndex: Value(slotIndex),
      pet: Value(pet),
      routeId: Value(routeId),
      startedAtMs: Value(startedAtMs),
      durationMs: Value(durationMs),
    );
  }

  factory RoamSlot.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoamSlot(
      slotIndex: serializer.fromJson<int>(json['slotIndex']),
      pet: serializer.fromJson<String>(json['pet']),
      routeId: serializer.fromJson<String>(json['routeId']),
      startedAtMs: serializer.fromJson<int>(json['startedAtMs']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'slotIndex': serializer.toJson<int>(slotIndex),
      'pet': serializer.toJson<String>(pet),
      'routeId': serializer.toJson<String>(routeId),
      'startedAtMs': serializer.toJson<int>(startedAtMs),
      'durationMs': serializer.toJson<int>(durationMs),
    };
  }

  RoamSlot copyWith(
          {int? slotIndex,
          String? pet,
          String? routeId,
          int? startedAtMs,
          int? durationMs}) =>
      RoamSlot(
        slotIndex: slotIndex ?? this.slotIndex,
        pet: pet ?? this.pet,
        routeId: routeId ?? this.routeId,
        startedAtMs: startedAtMs ?? this.startedAtMs,
        durationMs: durationMs ?? this.durationMs,
      );
  RoamSlot copyWithCompanion(RoamSlotsCompanion data) {
    return RoamSlot(
      slotIndex: data.slotIndex.present ? data.slotIndex.value : this.slotIndex,
      pet: data.pet.present ? data.pet.value : this.pet,
      routeId: data.routeId.present ? data.routeId.value : this.routeId,
      startedAtMs:
          data.startedAtMs.present ? data.startedAtMs.value : this.startedAtMs,
      durationMs:
          data.durationMs.present ? data.durationMs.value : this.durationMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoamSlot(')
          ..write('slotIndex: $slotIndex, ')
          ..write('pet: $pet, ')
          ..write('routeId: $routeId, ')
          ..write('startedAtMs: $startedAtMs, ')
          ..write('durationMs: $durationMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(slotIndex, pet, routeId, startedAtMs, durationMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoamSlot &&
          other.slotIndex == this.slotIndex &&
          other.pet == this.pet &&
          other.routeId == this.routeId &&
          other.startedAtMs == this.startedAtMs &&
          other.durationMs == this.durationMs);
}

class RoamSlotsCompanion extends UpdateCompanion<RoamSlot> {
  final Value<int> slotIndex;
  final Value<String> pet;
  final Value<String> routeId;
  final Value<int> startedAtMs;
  final Value<int> durationMs;
  const RoamSlotsCompanion({
    this.slotIndex = const Value.absent(),
    this.pet = const Value.absent(),
    this.routeId = const Value.absent(),
    this.startedAtMs = const Value.absent(),
    this.durationMs = const Value.absent(),
  });
  RoamSlotsCompanion.insert({
    this.slotIndex = const Value.absent(),
    required String pet,
    required String routeId,
    required int startedAtMs,
    required int durationMs,
  })  : pet = Value(pet),
        routeId = Value(routeId),
        startedAtMs = Value(startedAtMs),
        durationMs = Value(durationMs);
  static Insertable<RoamSlot> custom({
    Expression<int>? slotIndex,
    Expression<String>? pet,
    Expression<String>? routeId,
    Expression<int>? startedAtMs,
    Expression<int>? durationMs,
  }) {
    return RawValuesInsertable({
      if (slotIndex != null) 'slot_index': slotIndex,
      if (pet != null) 'pet': pet,
      if (routeId != null) 'route_id': routeId,
      if (startedAtMs != null) 'started_at_ms': startedAtMs,
      if (durationMs != null) 'duration_ms': durationMs,
    });
  }

  RoamSlotsCompanion copyWith(
      {Value<int>? slotIndex,
      Value<String>? pet,
      Value<String>? routeId,
      Value<int>? startedAtMs,
      Value<int>? durationMs}) {
    return RoamSlotsCompanion(
      slotIndex: slotIndex ?? this.slotIndex,
      pet: pet ?? this.pet,
      routeId: routeId ?? this.routeId,
      startedAtMs: startedAtMs ?? this.startedAtMs,
      durationMs: durationMs ?? this.durationMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (slotIndex.present) {
      map['slot_index'] = Variable<int>(slotIndex.value);
    }
    if (pet.present) {
      map['pet'] = Variable<String>(pet.value);
    }
    if (routeId.present) {
      map['route_id'] = Variable<String>(routeId.value);
    }
    if (startedAtMs.present) {
      map['started_at_ms'] = Variable<int>(startedAtMs.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoamSlotsCompanion(')
          ..write('slotIndex: $slotIndex, ')
          ..write('pet: $pet, ')
          ..write('routeId: $routeId, ')
          ..write('startedAtMs: $startedAtMs, ')
          ..write('durationMs: $durationMs')
          ..write(')'))
        .toString();
  }
}

class $SouvenirInventoryRowsTable extends SouvenirInventoryRows
    with TableInfo<$SouvenirInventoryRowsTable, SouvenirInventoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SouvenirInventoryRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _souvenirCodeMeta =
      const VerificationMeta('souvenirCode');
  @override
  late final GeneratedColumn<String> souvenirCode = GeneratedColumn<String>(
      'souvenir_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES souvenir_catalog (code)'));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL CHECK (quantity >= 0)');
  @override
  List<GeneratedColumn> get $columns => [souvenirCode, quantity];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'souvenir_inventory';
  @override
  VerificationContext validateIntegrity(
      Insertable<SouvenirInventoryRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('souvenir_code')) {
      context.handle(
          _souvenirCodeMeta,
          souvenirCode.isAcceptableOrUnknown(
              data['souvenir_code']!, _souvenirCodeMeta));
    } else if (isInserting) {
      context.missing(_souvenirCodeMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {souvenirCode};
  @override
  SouvenirInventoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SouvenirInventoryRow(
      souvenirCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}souvenir_code'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
    );
  }

  @override
  $SouvenirInventoryRowsTable createAlias(String alias) {
    return $SouvenirInventoryRowsTable(attachedDatabase, alias);
  }
}

class SouvenirInventoryRow extends DataClass
    implements Insertable<SouvenirInventoryRow> {
  final String souvenirCode;
  final int quantity;
  const SouvenirInventoryRow(
      {required this.souvenirCode, required this.quantity});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['souvenir_code'] = Variable<String>(souvenirCode);
    map['quantity'] = Variable<int>(quantity);
    return map;
  }

  SouvenirInventoryRowsCompanion toCompanion(bool nullToAbsent) {
    return SouvenirInventoryRowsCompanion(
      souvenirCode: Value(souvenirCode),
      quantity: Value(quantity),
    );
  }

  factory SouvenirInventoryRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SouvenirInventoryRow(
      souvenirCode: serializer.fromJson<String>(json['souvenirCode']),
      quantity: serializer.fromJson<int>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'souvenirCode': serializer.toJson<String>(souvenirCode),
      'quantity': serializer.toJson<int>(quantity),
    };
  }

  SouvenirInventoryRow copyWith({String? souvenirCode, int? quantity}) =>
      SouvenirInventoryRow(
        souvenirCode: souvenirCode ?? this.souvenirCode,
        quantity: quantity ?? this.quantity,
      );
  SouvenirInventoryRow copyWithCompanion(SouvenirInventoryRowsCompanion data) {
    return SouvenirInventoryRow(
      souvenirCode: data.souvenirCode.present
          ? data.souvenirCode.value
          : this.souvenirCode,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SouvenirInventoryRow(')
          ..write('souvenirCode: $souvenirCode, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(souvenirCode, quantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SouvenirInventoryRow &&
          other.souvenirCode == this.souvenirCode &&
          other.quantity == this.quantity);
}

class SouvenirInventoryRowsCompanion
    extends UpdateCompanion<SouvenirInventoryRow> {
  final Value<String> souvenirCode;
  final Value<int> quantity;
  final Value<int> rowid;
  const SouvenirInventoryRowsCompanion({
    this.souvenirCode = const Value.absent(),
    this.quantity = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SouvenirInventoryRowsCompanion.insert({
    required String souvenirCode,
    required int quantity,
    this.rowid = const Value.absent(),
  })  : souvenirCode = Value(souvenirCode),
        quantity = Value(quantity);
  static Insertable<SouvenirInventoryRow> custom({
    Expression<String>? souvenirCode,
    Expression<int>? quantity,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (souvenirCode != null) 'souvenir_code': souvenirCode,
      if (quantity != null) 'quantity': quantity,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SouvenirInventoryRowsCompanion copyWith(
      {Value<String>? souvenirCode, Value<int>? quantity, Value<int>? rowid}) {
    return SouvenirInventoryRowsCompanion(
      souvenirCode: souvenirCode ?? this.souvenirCode,
      quantity: quantity ?? this.quantity,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (souvenirCode.present) {
      map['souvenir_code'] = Variable<String>(souvenirCode.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SouvenirInventoryRowsCompanion(')
          ..write('souvenirCode: $souvenirCode, ')
          ..write('quantity: $quantity, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SocialProfilesTable extends SocialProfiles
    with TableInfo<$SocialProfilesTable, SocialProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SocialProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _myNameMeta = const VerificationMeta('myName');
  @override
  late final GeneratedColumn<String> myName = GeneratedColumn<String>(
      'my_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _visitingPetMeta =
      const VerificationMeta('visitingPet');
  @override
  late final GeneratedColumn<String> visitingPet = GeneratedColumn<String>(
      'visiting_pet', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES emotion_catalog (code)'));
  static const VerificationMeta _visitingExpireMsMeta =
      const VerificationMeta('visitingExpireMs');
  @override
  late final GeneratedColumn<int> visitingExpireMs = GeneratedColumn<int>(
      'visiting_expire_ms', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _pendantMeta =
      const VerificationMeta('pendant');
  @override
  late final GeneratedColumn<String> pendant = GeneratedColumn<String>(
      'pendant', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES souvenir_catalog (code)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, myName, visitingPet, visitingExpireMs, pendant];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'social_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<SocialProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('my_name')) {
      context.handle(_myNameMeta,
          myName.isAcceptableOrUnknown(data['my_name']!, _myNameMeta));
    } else if (isInserting) {
      context.missing(_myNameMeta);
    }
    if (data.containsKey('visiting_pet')) {
      context.handle(
          _visitingPetMeta,
          visitingPet.isAcceptableOrUnknown(
              data['visiting_pet']!, _visitingPetMeta));
    }
    if (data.containsKey('visiting_expire_ms')) {
      context.handle(
          _visitingExpireMsMeta,
          visitingExpireMs.isAcceptableOrUnknown(
              data['visiting_expire_ms']!, _visitingExpireMsMeta));
    }
    if (data.containsKey('pendant')) {
      context.handle(_pendantMeta,
          pendant.isAcceptableOrUnknown(data['pendant']!, _pendantMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SocialProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SocialProfile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      myName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}my_name'])!,
      visitingPet: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}visiting_pet']),
      visitingExpireMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}visiting_expire_ms']),
      pendant: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pendant']),
    );
  }

  @override
  $SocialProfilesTable createAlias(String alias) {
    return $SocialProfilesTable(attachedDatabase, alias);
  }
}

class SocialProfile extends DataClass implements Insertable<SocialProfile> {
  final int id;
  final String myName;
  final String? visitingPet;
  final int? visitingExpireMs;
  final String? pendant;
  const SocialProfile(
      {required this.id,
      required this.myName,
      this.visitingPet,
      this.visitingExpireMs,
      this.pendant});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['my_name'] = Variable<String>(myName);
    if (!nullToAbsent || visitingPet != null) {
      map['visiting_pet'] = Variable<String>(visitingPet);
    }
    if (!nullToAbsent || visitingExpireMs != null) {
      map['visiting_expire_ms'] = Variable<int>(visitingExpireMs);
    }
    if (!nullToAbsent || pendant != null) {
      map['pendant'] = Variable<String>(pendant);
    }
    return map;
  }

  SocialProfilesCompanion toCompanion(bool nullToAbsent) {
    return SocialProfilesCompanion(
      id: Value(id),
      myName: Value(myName),
      visitingPet: visitingPet == null && nullToAbsent
          ? const Value.absent()
          : Value(visitingPet),
      visitingExpireMs: visitingExpireMs == null && nullToAbsent
          ? const Value.absent()
          : Value(visitingExpireMs),
      pendant: pendant == null && nullToAbsent
          ? const Value.absent()
          : Value(pendant),
    );
  }

  factory SocialProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SocialProfile(
      id: serializer.fromJson<int>(json['id']),
      myName: serializer.fromJson<String>(json['myName']),
      visitingPet: serializer.fromJson<String?>(json['visitingPet']),
      visitingExpireMs: serializer.fromJson<int?>(json['visitingExpireMs']),
      pendant: serializer.fromJson<String?>(json['pendant']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'myName': serializer.toJson<String>(myName),
      'visitingPet': serializer.toJson<String?>(visitingPet),
      'visitingExpireMs': serializer.toJson<int?>(visitingExpireMs),
      'pendant': serializer.toJson<String?>(pendant),
    };
  }

  SocialProfile copyWith(
          {int? id,
          String? myName,
          Value<String?> visitingPet = const Value.absent(),
          Value<int?> visitingExpireMs = const Value.absent(),
          Value<String?> pendant = const Value.absent()}) =>
      SocialProfile(
        id: id ?? this.id,
        myName: myName ?? this.myName,
        visitingPet: visitingPet.present ? visitingPet.value : this.visitingPet,
        visitingExpireMs: visitingExpireMs.present
            ? visitingExpireMs.value
            : this.visitingExpireMs,
        pendant: pendant.present ? pendant.value : this.pendant,
      );
  SocialProfile copyWithCompanion(SocialProfilesCompanion data) {
    return SocialProfile(
      id: data.id.present ? data.id.value : this.id,
      myName: data.myName.present ? data.myName.value : this.myName,
      visitingPet:
          data.visitingPet.present ? data.visitingPet.value : this.visitingPet,
      visitingExpireMs: data.visitingExpireMs.present
          ? data.visitingExpireMs.value
          : this.visitingExpireMs,
      pendant: data.pendant.present ? data.pendant.value : this.pendant,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SocialProfile(')
          ..write('id: $id, ')
          ..write('myName: $myName, ')
          ..write('visitingPet: $visitingPet, ')
          ..write('visitingExpireMs: $visitingExpireMs, ')
          ..write('pendant: $pendant')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, myName, visitingPet, visitingExpireMs, pendant);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SocialProfile &&
          other.id == this.id &&
          other.myName == this.myName &&
          other.visitingPet == this.visitingPet &&
          other.visitingExpireMs == this.visitingExpireMs &&
          other.pendant == this.pendant);
}

class SocialProfilesCompanion extends UpdateCompanion<SocialProfile> {
  final Value<int> id;
  final Value<String> myName;
  final Value<String?> visitingPet;
  final Value<int?> visitingExpireMs;
  final Value<String?> pendant;
  const SocialProfilesCompanion({
    this.id = const Value.absent(),
    this.myName = const Value.absent(),
    this.visitingPet = const Value.absent(),
    this.visitingExpireMs = const Value.absent(),
    this.pendant = const Value.absent(),
  });
  SocialProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String myName,
    this.visitingPet = const Value.absent(),
    this.visitingExpireMs = const Value.absent(),
    this.pendant = const Value.absent(),
  }) : myName = Value(myName);
  static Insertable<SocialProfile> custom({
    Expression<int>? id,
    Expression<String>? myName,
    Expression<String>? visitingPet,
    Expression<int>? visitingExpireMs,
    Expression<String>? pendant,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (myName != null) 'my_name': myName,
      if (visitingPet != null) 'visiting_pet': visitingPet,
      if (visitingExpireMs != null) 'visiting_expire_ms': visitingExpireMs,
      if (pendant != null) 'pendant': pendant,
    });
  }

  SocialProfilesCompanion copyWith(
      {Value<int>? id,
      Value<String>? myName,
      Value<String?>? visitingPet,
      Value<int?>? visitingExpireMs,
      Value<String?>? pendant}) {
    return SocialProfilesCompanion(
      id: id ?? this.id,
      myName: myName ?? this.myName,
      visitingPet: visitingPet ?? this.visitingPet,
      visitingExpireMs: visitingExpireMs ?? this.visitingExpireMs,
      pendant: pendant ?? this.pendant,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (myName.present) {
      map['my_name'] = Variable<String>(myName.value);
    }
    if (visitingPet.present) {
      map['visiting_pet'] = Variable<String>(visitingPet.value);
    }
    if (visitingExpireMs.present) {
      map['visiting_expire_ms'] = Variable<int>(visitingExpireMs.value);
    }
    if (pendant.present) {
      map['pendant'] = Variable<String>(pendant.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SocialProfilesCompanion(')
          ..write('id: $id, ')
          ..write('myName: $myName, ')
          ..write('visitingPet: $visitingPet, ')
          ..write('visitingExpireMs: $visitingExpireMs, ')
          ..write('pendant: $pendant')
          ..write(')'))
        .toString();
  }
}

class $PostcardsTable extends Postcards
    with TableInfo<$PostcardsTable, Postcard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PostcardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _friendNameMeta =
      const VerificationMeta('friendName');
  @override
  late final GeneratedColumn<String> friendName = GeneratedColumn<String>(
      'friend_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _friendPetMeta =
      const VerificationMeta('friendPet');
  @override
  late final GeneratedColumn<String> friendPet = GeneratedColumn<String>(
      'friend_pet', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES emotion_catalog (code)'));
  static const VerificationMeta _receivedAtMsMeta =
      const VerificationMeta('receivedAtMs');
  @override
  late final GeneratedColumn<int> receivedAtMs = GeneratedColumn<int>(
      'received_at_ms', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, code, friendName, friendPet, receivedAtMs];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'postcards';
  @override
  VerificationContext validateIntegrity(Insertable<Postcard> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('friend_name')) {
      context.handle(
          _friendNameMeta,
          friendName.isAcceptableOrUnknown(
              data['friend_name']!, _friendNameMeta));
    } else if (isInserting) {
      context.missing(_friendNameMeta);
    }
    if (data.containsKey('friend_pet')) {
      context.handle(_friendPetMeta,
          friendPet.isAcceptableOrUnknown(data['friend_pet']!, _friendPetMeta));
    } else if (isInserting) {
      context.missing(_friendPetMeta);
    }
    if (data.containsKey('received_at_ms')) {
      context.handle(
          _receivedAtMsMeta,
          receivedAtMs.isAcceptableOrUnknown(
              data['received_at_ms']!, _receivedAtMsMeta));
    } else if (isInserting) {
      context.missing(_receivedAtMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Postcard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Postcard(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      friendName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}friend_name'])!,
      friendPet: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}friend_pet'])!,
      receivedAtMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}received_at_ms'])!,
    );
  }

  @override
  $PostcardsTable createAlias(String alias) {
    return $PostcardsTable(attachedDatabase, alias);
  }
}

class Postcard extends DataClass implements Insertable<Postcard> {
  final int id;
  final String code;
  final String friendName;
  final String friendPet;
  final int receivedAtMs;
  const Postcard(
      {required this.id,
      required this.code,
      required this.friendName,
      required this.friendPet,
      required this.receivedAtMs});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['friend_name'] = Variable<String>(friendName);
    map['friend_pet'] = Variable<String>(friendPet);
    map['received_at_ms'] = Variable<int>(receivedAtMs);
    return map;
  }

  PostcardsCompanion toCompanion(bool nullToAbsent) {
    return PostcardsCompanion(
      id: Value(id),
      code: Value(code),
      friendName: Value(friendName),
      friendPet: Value(friendPet),
      receivedAtMs: Value(receivedAtMs),
    );
  }

  factory Postcard.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Postcard(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      friendName: serializer.fromJson<String>(json['friendName']),
      friendPet: serializer.fromJson<String>(json['friendPet']),
      receivedAtMs: serializer.fromJson<int>(json['receivedAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'friendName': serializer.toJson<String>(friendName),
      'friendPet': serializer.toJson<String>(friendPet),
      'receivedAtMs': serializer.toJson<int>(receivedAtMs),
    };
  }

  Postcard copyWith(
          {int? id,
          String? code,
          String? friendName,
          String? friendPet,
          int? receivedAtMs}) =>
      Postcard(
        id: id ?? this.id,
        code: code ?? this.code,
        friendName: friendName ?? this.friendName,
        friendPet: friendPet ?? this.friendPet,
        receivedAtMs: receivedAtMs ?? this.receivedAtMs,
      );
  Postcard copyWithCompanion(PostcardsCompanion data) {
    return Postcard(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      friendName:
          data.friendName.present ? data.friendName.value : this.friendName,
      friendPet: data.friendPet.present ? data.friendPet.value : this.friendPet,
      receivedAtMs: data.receivedAtMs.present
          ? data.receivedAtMs.value
          : this.receivedAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Postcard(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('friendName: $friendName, ')
          ..write('friendPet: $friendPet, ')
          ..write('receivedAtMs: $receivedAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, code, friendName, friendPet, receivedAtMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Postcard &&
          other.id == this.id &&
          other.code == this.code &&
          other.friendName == this.friendName &&
          other.friendPet == this.friendPet &&
          other.receivedAtMs == this.receivedAtMs);
}

class PostcardsCompanion extends UpdateCompanion<Postcard> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> friendName;
  final Value<String> friendPet;
  final Value<int> receivedAtMs;
  const PostcardsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.friendName = const Value.absent(),
    this.friendPet = const Value.absent(),
    this.receivedAtMs = const Value.absent(),
  });
  PostcardsCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String friendName,
    required String friendPet,
    required int receivedAtMs,
  })  : code = Value(code),
        friendName = Value(friendName),
        friendPet = Value(friendPet),
        receivedAtMs = Value(receivedAtMs);
  static Insertable<Postcard> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? friendName,
    Expression<String>? friendPet,
    Expression<int>? receivedAtMs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (friendName != null) 'friend_name': friendName,
      if (friendPet != null) 'friend_pet': friendPet,
      if (receivedAtMs != null) 'received_at_ms': receivedAtMs,
    });
  }

  PostcardsCompanion copyWith(
      {Value<int>? id,
      Value<String>? code,
      Value<String>? friendName,
      Value<String>? friendPet,
      Value<int>? receivedAtMs}) {
    return PostcardsCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      friendName: friendName ?? this.friendName,
      friendPet: friendPet ?? this.friendPet,
      receivedAtMs: receivedAtMs ?? this.receivedAtMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (friendName.present) {
      map['friend_name'] = Variable<String>(friendName.value);
    }
    if (friendPet.present) {
      map['friend_pet'] = Variable<String>(friendPet.value);
    }
    if (receivedAtMs.present) {
      map['received_at_ms'] = Variable<int>(receivedAtMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PostcardsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('friendName: $friendName, ')
          ..write('friendPet: $friendPet, ')
          ..write('receivedAtMs: $receivedAtMs')
          ..write(')'))
        .toString();
  }
}

class $ActiveMazeRunsTable extends ActiveMazeRuns
    with TableInfo<$ActiveMazeRunsTable, ActiveMazeRun> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActiveMazeRunsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _zoneIndexMeta =
      const VerificationMeta('zoneIndex');
  @override
  late final GeneratedColumn<int> zoneIndex = GeneratedColumn<int>(
      'zone_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _seedMeta = const VerificationMeta('seed');
  @override
  late final GeneratedColumn<int> seed = GeneratedColumn<int>(
      'seed', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _startLevelMeta =
      const VerificationMeta('startLevel');
  @override
  late final GeneratedColumn<int> startLevel = GeneratedColumn<int>(
      'start_level', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _floorIndexMeta =
      const VerificationMeta('floorIndex');
  @override
  late final GeneratedColumn<int> floorIndex = GeneratedColumn<int>(
      'floor_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _positionXMeta =
      const VerificationMeta('positionX');
  @override
  late final GeneratedColumn<int> positionX = GeneratedColumn<int>(
      'position_x', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _positionYMeta =
      const VerificationMeta('positionY');
  @override
  late final GeneratedColumn<int> positionY = GeneratedColumn<int>(
      'position_y', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
      'level', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _keysMeta = const VerificationMeta('keys');
  @override
  late final GeneratedColumn<int> keys = GeneratedColumn<int>(
      'keys', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lanternsMeta =
      const VerificationMeta('lanterns');
  @override
  late final GeneratedColumn<int> lanterns = GeneratedColumn<int>(
      'lanterns', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _stepsMeta = const VerificationMeta('steps');
  @override
  late final GeneratedColumn<int> steps = GeneratedColumn<int>(
      'steps', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _killsMeta = const VerificationMeta('kills');
  @override
  late final GeneratedColumn<int> kills = GeneratedColumn<int>(
      'kills', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _eliteKillsMeta =
      const VerificationMeta('eliteKills');
  @override
  late final GeneratedColumn<int> eliteKills = GeneratedColumn<int>(
      'elite_kills', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _bossBeatenMeta =
      const VerificationMeta('bossBeaten');
  @override
  late final GeneratedColumn<bool> bossBeaten = GeneratedColumn<bool>(
      'boss_beaten', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("boss_beaten" IN (0, 1))'));
  static const VerificationMeta _usedUndoMeta =
      const VerificationMeta('usedUndo');
  @override
  late final GeneratedColumn<bool> usedUndo = GeneratedColumn<bool>(
      'used_undo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("used_undo" IN (0, 1))'));
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
      'active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("active" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        zoneIndex,
        seed,
        startLevel,
        floorIndex,
        positionX,
        positionY,
        level,
        keys,
        lanterns,
        steps,
        kills,
        eliteKills,
        bossBeaten,
        usedUndo,
        active
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'active_maze_runs';
  @override
  VerificationContext validateIntegrity(Insertable<ActiveMazeRun> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('zone_index')) {
      context.handle(_zoneIndexMeta,
          zoneIndex.isAcceptableOrUnknown(data['zone_index']!, _zoneIndexMeta));
    } else if (isInserting) {
      context.missing(_zoneIndexMeta);
    }
    if (data.containsKey('seed')) {
      context.handle(
          _seedMeta, seed.isAcceptableOrUnknown(data['seed']!, _seedMeta));
    } else if (isInserting) {
      context.missing(_seedMeta);
    }
    if (data.containsKey('start_level')) {
      context.handle(
          _startLevelMeta,
          startLevel.isAcceptableOrUnknown(
              data['start_level']!, _startLevelMeta));
    } else if (isInserting) {
      context.missing(_startLevelMeta);
    }
    if (data.containsKey('floor_index')) {
      context.handle(
          _floorIndexMeta,
          floorIndex.isAcceptableOrUnknown(
              data['floor_index']!, _floorIndexMeta));
    } else if (isInserting) {
      context.missing(_floorIndexMeta);
    }
    if (data.containsKey('position_x')) {
      context.handle(_positionXMeta,
          positionX.isAcceptableOrUnknown(data['position_x']!, _positionXMeta));
    } else if (isInserting) {
      context.missing(_positionXMeta);
    }
    if (data.containsKey('position_y')) {
      context.handle(_positionYMeta,
          positionY.isAcceptableOrUnknown(data['position_y']!, _positionYMeta));
    } else if (isInserting) {
      context.missing(_positionYMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('keys')) {
      context.handle(
          _keysMeta, keys.isAcceptableOrUnknown(data['keys']!, _keysMeta));
    } else if (isInserting) {
      context.missing(_keysMeta);
    }
    if (data.containsKey('lanterns')) {
      context.handle(_lanternsMeta,
          lanterns.isAcceptableOrUnknown(data['lanterns']!, _lanternsMeta));
    } else if (isInserting) {
      context.missing(_lanternsMeta);
    }
    if (data.containsKey('steps')) {
      context.handle(
          _stepsMeta, steps.isAcceptableOrUnknown(data['steps']!, _stepsMeta));
    } else if (isInserting) {
      context.missing(_stepsMeta);
    }
    if (data.containsKey('kills')) {
      context.handle(
          _killsMeta, kills.isAcceptableOrUnknown(data['kills']!, _killsMeta));
    } else if (isInserting) {
      context.missing(_killsMeta);
    }
    if (data.containsKey('elite_kills')) {
      context.handle(
          _eliteKillsMeta,
          eliteKills.isAcceptableOrUnknown(
              data['elite_kills']!, _eliteKillsMeta));
    } else if (isInserting) {
      context.missing(_eliteKillsMeta);
    }
    if (data.containsKey('boss_beaten')) {
      context.handle(
          _bossBeatenMeta,
          bossBeaten.isAcceptableOrUnknown(
              data['boss_beaten']!, _bossBeatenMeta));
    } else if (isInserting) {
      context.missing(_bossBeatenMeta);
    }
    if (data.containsKey('used_undo')) {
      context.handle(_usedUndoMeta,
          usedUndo.isAcceptableOrUnknown(data['used_undo']!, _usedUndoMeta));
    } else if (isInserting) {
      context.missing(_usedUndoMeta);
    }
    if (data.containsKey('active')) {
      context.handle(_activeMeta,
          active.isAcceptableOrUnknown(data['active']!, _activeMeta));
    } else if (isInserting) {
      context.missing(_activeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActiveMazeRun map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActiveMazeRun(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      zoneIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}zone_index'])!,
      seed: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}seed'])!,
      startLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_level'])!,
      floorIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}floor_index'])!,
      positionX: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position_x'])!,
      positionY: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position_y'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}level'])!,
      keys: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}keys'])!,
      lanterns: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}lanterns'])!,
      steps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}steps'])!,
      kills: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}kills'])!,
      eliteKills: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}elite_kills'])!,
      bossBeaten: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}boss_beaten'])!,
      usedUndo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}used_undo'])!,
      active: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}active'])!,
    );
  }

  @override
  $ActiveMazeRunsTable createAlias(String alias) {
    return $ActiveMazeRunsTable(attachedDatabase, alias);
  }
}

class ActiveMazeRun extends DataClass implements Insertable<ActiveMazeRun> {
  final int id;
  final int zoneIndex;
  final int seed;
  final int startLevel;
  final int floorIndex;
  final int positionX;
  final int positionY;
  final int level;
  final int keys;
  final int lanterns;
  final int steps;
  final int kills;
  final int eliteKills;
  final bool bossBeaten;
  final bool usedUndo;
  final bool active;
  const ActiveMazeRun(
      {required this.id,
      required this.zoneIndex,
      required this.seed,
      required this.startLevel,
      required this.floorIndex,
      required this.positionX,
      required this.positionY,
      required this.level,
      required this.keys,
      required this.lanterns,
      required this.steps,
      required this.kills,
      required this.eliteKills,
      required this.bossBeaten,
      required this.usedUndo,
      required this.active});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['zone_index'] = Variable<int>(zoneIndex);
    map['seed'] = Variable<int>(seed);
    map['start_level'] = Variable<int>(startLevel);
    map['floor_index'] = Variable<int>(floorIndex);
    map['position_x'] = Variable<int>(positionX);
    map['position_y'] = Variable<int>(positionY);
    map['level'] = Variable<int>(level);
    map['keys'] = Variable<int>(keys);
    map['lanterns'] = Variable<int>(lanterns);
    map['steps'] = Variable<int>(steps);
    map['kills'] = Variable<int>(kills);
    map['elite_kills'] = Variable<int>(eliteKills);
    map['boss_beaten'] = Variable<bool>(bossBeaten);
    map['used_undo'] = Variable<bool>(usedUndo);
    map['active'] = Variable<bool>(active);
    return map;
  }

  ActiveMazeRunsCompanion toCompanion(bool nullToAbsent) {
    return ActiveMazeRunsCompanion(
      id: Value(id),
      zoneIndex: Value(zoneIndex),
      seed: Value(seed),
      startLevel: Value(startLevel),
      floorIndex: Value(floorIndex),
      positionX: Value(positionX),
      positionY: Value(positionY),
      level: Value(level),
      keys: Value(keys),
      lanterns: Value(lanterns),
      steps: Value(steps),
      kills: Value(kills),
      eliteKills: Value(eliteKills),
      bossBeaten: Value(bossBeaten),
      usedUndo: Value(usedUndo),
      active: Value(active),
    );
  }

  factory ActiveMazeRun.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActiveMazeRun(
      id: serializer.fromJson<int>(json['id']),
      zoneIndex: serializer.fromJson<int>(json['zoneIndex']),
      seed: serializer.fromJson<int>(json['seed']),
      startLevel: serializer.fromJson<int>(json['startLevel']),
      floorIndex: serializer.fromJson<int>(json['floorIndex']),
      positionX: serializer.fromJson<int>(json['positionX']),
      positionY: serializer.fromJson<int>(json['positionY']),
      level: serializer.fromJson<int>(json['level']),
      keys: serializer.fromJson<int>(json['keys']),
      lanterns: serializer.fromJson<int>(json['lanterns']),
      steps: serializer.fromJson<int>(json['steps']),
      kills: serializer.fromJson<int>(json['kills']),
      eliteKills: serializer.fromJson<int>(json['eliteKills']),
      bossBeaten: serializer.fromJson<bool>(json['bossBeaten']),
      usedUndo: serializer.fromJson<bool>(json['usedUndo']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'zoneIndex': serializer.toJson<int>(zoneIndex),
      'seed': serializer.toJson<int>(seed),
      'startLevel': serializer.toJson<int>(startLevel),
      'floorIndex': serializer.toJson<int>(floorIndex),
      'positionX': serializer.toJson<int>(positionX),
      'positionY': serializer.toJson<int>(positionY),
      'level': serializer.toJson<int>(level),
      'keys': serializer.toJson<int>(keys),
      'lanterns': serializer.toJson<int>(lanterns),
      'steps': serializer.toJson<int>(steps),
      'kills': serializer.toJson<int>(kills),
      'eliteKills': serializer.toJson<int>(eliteKills),
      'bossBeaten': serializer.toJson<bool>(bossBeaten),
      'usedUndo': serializer.toJson<bool>(usedUndo),
      'active': serializer.toJson<bool>(active),
    };
  }

  ActiveMazeRun copyWith(
          {int? id,
          int? zoneIndex,
          int? seed,
          int? startLevel,
          int? floorIndex,
          int? positionX,
          int? positionY,
          int? level,
          int? keys,
          int? lanterns,
          int? steps,
          int? kills,
          int? eliteKills,
          bool? bossBeaten,
          bool? usedUndo,
          bool? active}) =>
      ActiveMazeRun(
        id: id ?? this.id,
        zoneIndex: zoneIndex ?? this.zoneIndex,
        seed: seed ?? this.seed,
        startLevel: startLevel ?? this.startLevel,
        floorIndex: floorIndex ?? this.floorIndex,
        positionX: positionX ?? this.positionX,
        positionY: positionY ?? this.positionY,
        level: level ?? this.level,
        keys: keys ?? this.keys,
        lanterns: lanterns ?? this.lanterns,
        steps: steps ?? this.steps,
        kills: kills ?? this.kills,
        eliteKills: eliteKills ?? this.eliteKills,
        bossBeaten: bossBeaten ?? this.bossBeaten,
        usedUndo: usedUndo ?? this.usedUndo,
        active: active ?? this.active,
      );
  ActiveMazeRun copyWithCompanion(ActiveMazeRunsCompanion data) {
    return ActiveMazeRun(
      id: data.id.present ? data.id.value : this.id,
      zoneIndex: data.zoneIndex.present ? data.zoneIndex.value : this.zoneIndex,
      seed: data.seed.present ? data.seed.value : this.seed,
      startLevel:
          data.startLevel.present ? data.startLevel.value : this.startLevel,
      floorIndex:
          data.floorIndex.present ? data.floorIndex.value : this.floorIndex,
      positionX: data.positionX.present ? data.positionX.value : this.positionX,
      positionY: data.positionY.present ? data.positionY.value : this.positionY,
      level: data.level.present ? data.level.value : this.level,
      keys: data.keys.present ? data.keys.value : this.keys,
      lanterns: data.lanterns.present ? data.lanterns.value : this.lanterns,
      steps: data.steps.present ? data.steps.value : this.steps,
      kills: data.kills.present ? data.kills.value : this.kills,
      eliteKills:
          data.eliteKills.present ? data.eliteKills.value : this.eliteKills,
      bossBeaten:
          data.bossBeaten.present ? data.bossBeaten.value : this.bossBeaten,
      usedUndo: data.usedUndo.present ? data.usedUndo.value : this.usedUndo,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActiveMazeRun(')
          ..write('id: $id, ')
          ..write('zoneIndex: $zoneIndex, ')
          ..write('seed: $seed, ')
          ..write('startLevel: $startLevel, ')
          ..write('floorIndex: $floorIndex, ')
          ..write('positionX: $positionX, ')
          ..write('positionY: $positionY, ')
          ..write('level: $level, ')
          ..write('keys: $keys, ')
          ..write('lanterns: $lanterns, ')
          ..write('steps: $steps, ')
          ..write('kills: $kills, ')
          ..write('eliteKills: $eliteKills, ')
          ..write('bossBeaten: $bossBeaten, ')
          ..write('usedUndo: $usedUndo, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      zoneIndex,
      seed,
      startLevel,
      floorIndex,
      positionX,
      positionY,
      level,
      keys,
      lanterns,
      steps,
      kills,
      eliteKills,
      bossBeaten,
      usedUndo,
      active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActiveMazeRun &&
          other.id == this.id &&
          other.zoneIndex == this.zoneIndex &&
          other.seed == this.seed &&
          other.startLevel == this.startLevel &&
          other.floorIndex == this.floorIndex &&
          other.positionX == this.positionX &&
          other.positionY == this.positionY &&
          other.level == this.level &&
          other.keys == this.keys &&
          other.lanterns == this.lanterns &&
          other.steps == this.steps &&
          other.kills == this.kills &&
          other.eliteKills == this.eliteKills &&
          other.bossBeaten == this.bossBeaten &&
          other.usedUndo == this.usedUndo &&
          other.active == this.active);
}

class ActiveMazeRunsCompanion extends UpdateCompanion<ActiveMazeRun> {
  final Value<int> id;
  final Value<int> zoneIndex;
  final Value<int> seed;
  final Value<int> startLevel;
  final Value<int> floorIndex;
  final Value<int> positionX;
  final Value<int> positionY;
  final Value<int> level;
  final Value<int> keys;
  final Value<int> lanterns;
  final Value<int> steps;
  final Value<int> kills;
  final Value<int> eliteKills;
  final Value<bool> bossBeaten;
  final Value<bool> usedUndo;
  final Value<bool> active;
  const ActiveMazeRunsCompanion({
    this.id = const Value.absent(),
    this.zoneIndex = const Value.absent(),
    this.seed = const Value.absent(),
    this.startLevel = const Value.absent(),
    this.floorIndex = const Value.absent(),
    this.positionX = const Value.absent(),
    this.positionY = const Value.absent(),
    this.level = const Value.absent(),
    this.keys = const Value.absent(),
    this.lanterns = const Value.absent(),
    this.steps = const Value.absent(),
    this.kills = const Value.absent(),
    this.eliteKills = const Value.absent(),
    this.bossBeaten = const Value.absent(),
    this.usedUndo = const Value.absent(),
    this.active = const Value.absent(),
  });
  ActiveMazeRunsCompanion.insert({
    this.id = const Value.absent(),
    required int zoneIndex,
    required int seed,
    required int startLevel,
    required int floorIndex,
    required int positionX,
    required int positionY,
    required int level,
    required int keys,
    required int lanterns,
    required int steps,
    required int kills,
    required int eliteKills,
    required bool bossBeaten,
    required bool usedUndo,
    required bool active,
  })  : zoneIndex = Value(zoneIndex),
        seed = Value(seed),
        startLevel = Value(startLevel),
        floorIndex = Value(floorIndex),
        positionX = Value(positionX),
        positionY = Value(positionY),
        level = Value(level),
        keys = Value(keys),
        lanterns = Value(lanterns),
        steps = Value(steps),
        kills = Value(kills),
        eliteKills = Value(eliteKills),
        bossBeaten = Value(bossBeaten),
        usedUndo = Value(usedUndo),
        active = Value(active);
  static Insertable<ActiveMazeRun> custom({
    Expression<int>? id,
    Expression<int>? zoneIndex,
    Expression<int>? seed,
    Expression<int>? startLevel,
    Expression<int>? floorIndex,
    Expression<int>? positionX,
    Expression<int>? positionY,
    Expression<int>? level,
    Expression<int>? keys,
    Expression<int>? lanterns,
    Expression<int>? steps,
    Expression<int>? kills,
    Expression<int>? eliteKills,
    Expression<bool>? bossBeaten,
    Expression<bool>? usedUndo,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (zoneIndex != null) 'zone_index': zoneIndex,
      if (seed != null) 'seed': seed,
      if (startLevel != null) 'start_level': startLevel,
      if (floorIndex != null) 'floor_index': floorIndex,
      if (positionX != null) 'position_x': positionX,
      if (positionY != null) 'position_y': positionY,
      if (level != null) 'level': level,
      if (keys != null) 'keys': keys,
      if (lanterns != null) 'lanterns': lanterns,
      if (steps != null) 'steps': steps,
      if (kills != null) 'kills': kills,
      if (eliteKills != null) 'elite_kills': eliteKills,
      if (bossBeaten != null) 'boss_beaten': bossBeaten,
      if (usedUndo != null) 'used_undo': usedUndo,
      if (active != null) 'active': active,
    });
  }

  ActiveMazeRunsCompanion copyWith(
      {Value<int>? id,
      Value<int>? zoneIndex,
      Value<int>? seed,
      Value<int>? startLevel,
      Value<int>? floorIndex,
      Value<int>? positionX,
      Value<int>? positionY,
      Value<int>? level,
      Value<int>? keys,
      Value<int>? lanterns,
      Value<int>? steps,
      Value<int>? kills,
      Value<int>? eliteKills,
      Value<bool>? bossBeaten,
      Value<bool>? usedUndo,
      Value<bool>? active}) {
    return ActiveMazeRunsCompanion(
      id: id ?? this.id,
      zoneIndex: zoneIndex ?? this.zoneIndex,
      seed: seed ?? this.seed,
      startLevel: startLevel ?? this.startLevel,
      floorIndex: floorIndex ?? this.floorIndex,
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
      level: level ?? this.level,
      keys: keys ?? this.keys,
      lanterns: lanterns ?? this.lanterns,
      steps: steps ?? this.steps,
      kills: kills ?? this.kills,
      eliteKills: eliteKills ?? this.eliteKills,
      bossBeaten: bossBeaten ?? this.bossBeaten,
      usedUndo: usedUndo ?? this.usedUndo,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (zoneIndex.present) {
      map['zone_index'] = Variable<int>(zoneIndex.value);
    }
    if (seed.present) {
      map['seed'] = Variable<int>(seed.value);
    }
    if (startLevel.present) {
      map['start_level'] = Variable<int>(startLevel.value);
    }
    if (floorIndex.present) {
      map['floor_index'] = Variable<int>(floorIndex.value);
    }
    if (positionX.present) {
      map['position_x'] = Variable<int>(positionX.value);
    }
    if (positionY.present) {
      map['position_y'] = Variable<int>(positionY.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (keys.present) {
      map['keys'] = Variable<int>(keys.value);
    }
    if (lanterns.present) {
      map['lanterns'] = Variable<int>(lanterns.value);
    }
    if (steps.present) {
      map['steps'] = Variable<int>(steps.value);
    }
    if (kills.present) {
      map['kills'] = Variable<int>(kills.value);
    }
    if (eliteKills.present) {
      map['elite_kills'] = Variable<int>(eliteKills.value);
    }
    if (bossBeaten.present) {
      map['boss_beaten'] = Variable<bool>(bossBeaten.value);
    }
    if (usedUndo.present) {
      map['used_undo'] = Variable<bool>(usedUndo.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActiveMazeRunsCompanion(')
          ..write('id: $id, ')
          ..write('zoneIndex: $zoneIndex, ')
          ..write('seed: $seed, ')
          ..write('startLevel: $startLevel, ')
          ..write('floorIndex: $floorIndex, ')
          ..write('positionX: $positionX, ')
          ..write('positionY: $positionY, ')
          ..write('level: $level, ')
          ..write('keys: $keys, ')
          ..write('lanterns: $lanterns, ')
          ..write('steps: $steps, ')
          ..write('kills: $kills, ')
          ..write('eliteKills: $eliteKills, ')
          ..write('bossBeaten: $bossBeaten, ')
          ..write('usedUndo: $usedUndo, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }
}

class $MazeCellStatesTable extends MazeCellStates
    with TableInfo<$MazeCellStatesTable, MazeCellState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MazeCellStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _floorIndexMeta =
      const VerificationMeta('floorIndex');
  @override
  late final GeneratedColumn<int> floorIndex = GeneratedColumn<int>(
      'floor_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _cellKeyMeta =
      const VerificationMeta('cellKey');
  @override
  late final GeneratedColumn<String> cellKey = GeneratedColumn<String>(
      'cell_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _consumedMeta =
      const VerificationMeta('consumed');
  @override
  late final GeneratedColumn<bool> consumed = GeneratedColumn<bool>(
      'consumed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("consumed" IN (0, 1))'));
  static const VerificationMeta _pickedMeta = const VerificationMeta('picked');
  @override
  late final GeneratedColumn<bool> picked = GeneratedColumn<bool>(
      'picked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("picked" IN (0, 1))'));
  static const VerificationMeta _openedMeta = const VerificationMeta('opened');
  @override
  late final GeneratedColumn<bool> opened = GeneratedColumn<bool>(
      'opened', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("opened" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns =>
      [floorIndex, cellKey, consumed, picked, opened];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maze_cell_states';
  @override
  VerificationContext validateIntegrity(Insertable<MazeCellState> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('floor_index')) {
      context.handle(
          _floorIndexMeta,
          floorIndex.isAcceptableOrUnknown(
              data['floor_index']!, _floorIndexMeta));
    } else if (isInserting) {
      context.missing(_floorIndexMeta);
    }
    if (data.containsKey('cell_key')) {
      context.handle(_cellKeyMeta,
          cellKey.isAcceptableOrUnknown(data['cell_key']!, _cellKeyMeta));
    } else if (isInserting) {
      context.missing(_cellKeyMeta);
    }
    if (data.containsKey('consumed')) {
      context.handle(_consumedMeta,
          consumed.isAcceptableOrUnknown(data['consumed']!, _consumedMeta));
    } else if (isInserting) {
      context.missing(_consumedMeta);
    }
    if (data.containsKey('picked')) {
      context.handle(_pickedMeta,
          picked.isAcceptableOrUnknown(data['picked']!, _pickedMeta));
    } else if (isInserting) {
      context.missing(_pickedMeta);
    }
    if (data.containsKey('opened')) {
      context.handle(_openedMeta,
          opened.isAcceptableOrUnknown(data['opened']!, _openedMeta));
    } else if (isInserting) {
      context.missing(_openedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {floorIndex, cellKey};
  @override
  MazeCellState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MazeCellState(
      floorIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}floor_index'])!,
      cellKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cell_key'])!,
      consumed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}consumed'])!,
      picked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}picked'])!,
      opened: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}opened'])!,
    );
  }

  @override
  $MazeCellStatesTable createAlias(String alias) {
    return $MazeCellStatesTable(attachedDatabase, alias);
  }
}

class MazeCellState extends DataClass implements Insertable<MazeCellState> {
  final int floorIndex;
  final String cellKey;
  final bool consumed;
  final bool picked;
  final bool opened;
  const MazeCellState(
      {required this.floorIndex,
      required this.cellKey,
      required this.consumed,
      required this.picked,
      required this.opened});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['floor_index'] = Variable<int>(floorIndex);
    map['cell_key'] = Variable<String>(cellKey);
    map['consumed'] = Variable<bool>(consumed);
    map['picked'] = Variable<bool>(picked);
    map['opened'] = Variable<bool>(opened);
    return map;
  }

  MazeCellStatesCompanion toCompanion(bool nullToAbsent) {
    return MazeCellStatesCompanion(
      floorIndex: Value(floorIndex),
      cellKey: Value(cellKey),
      consumed: Value(consumed),
      picked: Value(picked),
      opened: Value(opened),
    );
  }

  factory MazeCellState.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MazeCellState(
      floorIndex: serializer.fromJson<int>(json['floorIndex']),
      cellKey: serializer.fromJson<String>(json['cellKey']),
      consumed: serializer.fromJson<bool>(json['consumed']),
      picked: serializer.fromJson<bool>(json['picked']),
      opened: serializer.fromJson<bool>(json['opened']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'floorIndex': serializer.toJson<int>(floorIndex),
      'cellKey': serializer.toJson<String>(cellKey),
      'consumed': serializer.toJson<bool>(consumed),
      'picked': serializer.toJson<bool>(picked),
      'opened': serializer.toJson<bool>(opened),
    };
  }

  MazeCellState copyWith(
          {int? floorIndex,
          String? cellKey,
          bool? consumed,
          bool? picked,
          bool? opened}) =>
      MazeCellState(
        floorIndex: floorIndex ?? this.floorIndex,
        cellKey: cellKey ?? this.cellKey,
        consumed: consumed ?? this.consumed,
        picked: picked ?? this.picked,
        opened: opened ?? this.opened,
      );
  MazeCellState copyWithCompanion(MazeCellStatesCompanion data) {
    return MazeCellState(
      floorIndex:
          data.floorIndex.present ? data.floorIndex.value : this.floorIndex,
      cellKey: data.cellKey.present ? data.cellKey.value : this.cellKey,
      consumed: data.consumed.present ? data.consumed.value : this.consumed,
      picked: data.picked.present ? data.picked.value : this.picked,
      opened: data.opened.present ? data.opened.value : this.opened,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MazeCellState(')
          ..write('floorIndex: $floorIndex, ')
          ..write('cellKey: $cellKey, ')
          ..write('consumed: $consumed, ')
          ..write('picked: $picked, ')
          ..write('opened: $opened')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(floorIndex, cellKey, consumed, picked, opened);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MazeCellState &&
          other.floorIndex == this.floorIndex &&
          other.cellKey == this.cellKey &&
          other.consumed == this.consumed &&
          other.picked == this.picked &&
          other.opened == this.opened);
}

class MazeCellStatesCompanion extends UpdateCompanion<MazeCellState> {
  final Value<int> floorIndex;
  final Value<String> cellKey;
  final Value<bool> consumed;
  final Value<bool> picked;
  final Value<bool> opened;
  final Value<int> rowid;
  const MazeCellStatesCompanion({
    this.floorIndex = const Value.absent(),
    this.cellKey = const Value.absent(),
    this.consumed = const Value.absent(),
    this.picked = const Value.absent(),
    this.opened = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MazeCellStatesCompanion.insert({
    required int floorIndex,
    required String cellKey,
    required bool consumed,
    required bool picked,
    required bool opened,
    this.rowid = const Value.absent(),
  })  : floorIndex = Value(floorIndex),
        cellKey = Value(cellKey),
        consumed = Value(consumed),
        picked = Value(picked),
        opened = Value(opened);
  static Insertable<MazeCellState> custom({
    Expression<int>? floorIndex,
    Expression<String>? cellKey,
    Expression<bool>? consumed,
    Expression<bool>? picked,
    Expression<bool>? opened,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (floorIndex != null) 'floor_index': floorIndex,
      if (cellKey != null) 'cell_key': cellKey,
      if (consumed != null) 'consumed': consumed,
      if (picked != null) 'picked': picked,
      if (opened != null) 'opened': opened,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MazeCellStatesCompanion copyWith(
      {Value<int>? floorIndex,
      Value<String>? cellKey,
      Value<bool>? consumed,
      Value<bool>? picked,
      Value<bool>? opened,
      Value<int>? rowid}) {
    return MazeCellStatesCompanion(
      floorIndex: floorIndex ?? this.floorIndex,
      cellKey: cellKey ?? this.cellKey,
      consumed: consumed ?? this.consumed,
      picked: picked ?? this.picked,
      opened: opened ?? this.opened,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (floorIndex.present) {
      map['floor_index'] = Variable<int>(floorIndex.value);
    }
    if (cellKey.present) {
      map['cell_key'] = Variable<String>(cellKey.value);
    }
    if (consumed.present) {
      map['consumed'] = Variable<bool>(consumed.value);
    }
    if (picked.present) {
      map['picked'] = Variable<bool>(picked.value);
    }
    if (opened.present) {
      map['opened'] = Variable<bool>(opened.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MazeCellStatesCompanion(')
          ..write('floorIndex: $floorIndex, ')
          ..write('cellKey: $cellKey, ')
          ..write('consumed: $consumed, ')
          ..write('picked: $picked, ')
          ..write('opened: $opened, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MazeUndoSnapshotsTable extends MazeUndoSnapshots
    with TableInfo<$MazeUndoSnapshotsTable, MazeUndoSnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MazeUndoSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _snapshotIndexMeta =
      const VerificationMeta('snapshotIndex');
  @override
  late final GeneratedColumn<int> snapshotIndex = GeneratedColumn<int>(
      'snapshot_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _positionXMeta =
      const VerificationMeta('positionX');
  @override
  late final GeneratedColumn<int> positionX = GeneratedColumn<int>(
      'position_x', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _positionYMeta =
      const VerificationMeta('positionY');
  @override
  late final GeneratedColumn<int> positionY = GeneratedColumn<int>(
      'position_y', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
      'level', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _keysMeta = const VerificationMeta('keys');
  @override
  late final GeneratedColumn<int> keys = GeneratedColumn<int>(
      'keys', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _stepsMeta = const VerificationMeta('steps');
  @override
  late final GeneratedColumn<int> steps = GeneratedColumn<int>(
      'steps', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _killsMeta = const VerificationMeta('kills');
  @override
  late final GeneratedColumn<int> kills = GeneratedColumn<int>(
      'kills', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _eliteKillsMeta =
      const VerificationMeta('eliteKills');
  @override
  late final GeneratedColumn<int> eliteKills = GeneratedColumn<int>(
      'elite_kills', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _bossBeatenMeta =
      const VerificationMeta('bossBeaten');
  @override
  late final GeneratedColumn<bool> bossBeaten = GeneratedColumn<bool>(
      'boss_beaten', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("boss_beaten" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [
        snapshotIndex,
        positionX,
        positionY,
        level,
        keys,
        steps,
        kills,
        eliteKills,
        bossBeaten
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maze_undo_snapshots';
  @override
  VerificationContext validateIntegrity(Insertable<MazeUndoSnapshot> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('snapshot_index')) {
      context.handle(
          _snapshotIndexMeta,
          snapshotIndex.isAcceptableOrUnknown(
              data['snapshot_index']!, _snapshotIndexMeta));
    }
    if (data.containsKey('position_x')) {
      context.handle(_positionXMeta,
          positionX.isAcceptableOrUnknown(data['position_x']!, _positionXMeta));
    } else if (isInserting) {
      context.missing(_positionXMeta);
    }
    if (data.containsKey('position_y')) {
      context.handle(_positionYMeta,
          positionY.isAcceptableOrUnknown(data['position_y']!, _positionYMeta));
    } else if (isInserting) {
      context.missing(_positionYMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('keys')) {
      context.handle(
          _keysMeta, keys.isAcceptableOrUnknown(data['keys']!, _keysMeta));
    } else if (isInserting) {
      context.missing(_keysMeta);
    }
    if (data.containsKey('steps')) {
      context.handle(
          _stepsMeta, steps.isAcceptableOrUnknown(data['steps']!, _stepsMeta));
    } else if (isInserting) {
      context.missing(_stepsMeta);
    }
    if (data.containsKey('kills')) {
      context.handle(
          _killsMeta, kills.isAcceptableOrUnknown(data['kills']!, _killsMeta));
    } else if (isInserting) {
      context.missing(_killsMeta);
    }
    if (data.containsKey('elite_kills')) {
      context.handle(
          _eliteKillsMeta,
          eliteKills.isAcceptableOrUnknown(
              data['elite_kills']!, _eliteKillsMeta));
    } else if (isInserting) {
      context.missing(_eliteKillsMeta);
    }
    if (data.containsKey('boss_beaten')) {
      context.handle(
          _bossBeatenMeta,
          bossBeaten.isAcceptableOrUnknown(
              data['boss_beaten']!, _bossBeatenMeta));
    } else if (isInserting) {
      context.missing(_bossBeatenMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {snapshotIndex};
  @override
  MazeUndoSnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MazeUndoSnapshot(
      snapshotIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}snapshot_index'])!,
      positionX: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position_x'])!,
      positionY: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position_y'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}level'])!,
      keys: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}keys'])!,
      steps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}steps'])!,
      kills: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}kills'])!,
      eliteKills: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}elite_kills'])!,
      bossBeaten: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}boss_beaten'])!,
    );
  }

  @override
  $MazeUndoSnapshotsTable createAlias(String alias) {
    return $MazeUndoSnapshotsTable(attachedDatabase, alias);
  }
}

class MazeUndoSnapshot extends DataClass
    implements Insertable<MazeUndoSnapshot> {
  final int snapshotIndex;
  final int positionX;
  final int positionY;
  final int level;
  final int keys;
  final int steps;
  final int kills;
  final int eliteKills;
  final bool bossBeaten;
  const MazeUndoSnapshot(
      {required this.snapshotIndex,
      required this.positionX,
      required this.positionY,
      required this.level,
      required this.keys,
      required this.steps,
      required this.kills,
      required this.eliteKills,
      required this.bossBeaten});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['snapshot_index'] = Variable<int>(snapshotIndex);
    map['position_x'] = Variable<int>(positionX);
    map['position_y'] = Variable<int>(positionY);
    map['level'] = Variable<int>(level);
    map['keys'] = Variable<int>(keys);
    map['steps'] = Variable<int>(steps);
    map['kills'] = Variable<int>(kills);
    map['elite_kills'] = Variable<int>(eliteKills);
    map['boss_beaten'] = Variable<bool>(bossBeaten);
    return map;
  }

  MazeUndoSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return MazeUndoSnapshotsCompanion(
      snapshotIndex: Value(snapshotIndex),
      positionX: Value(positionX),
      positionY: Value(positionY),
      level: Value(level),
      keys: Value(keys),
      steps: Value(steps),
      kills: Value(kills),
      eliteKills: Value(eliteKills),
      bossBeaten: Value(bossBeaten),
    );
  }

  factory MazeUndoSnapshot.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MazeUndoSnapshot(
      snapshotIndex: serializer.fromJson<int>(json['snapshotIndex']),
      positionX: serializer.fromJson<int>(json['positionX']),
      positionY: serializer.fromJson<int>(json['positionY']),
      level: serializer.fromJson<int>(json['level']),
      keys: serializer.fromJson<int>(json['keys']),
      steps: serializer.fromJson<int>(json['steps']),
      kills: serializer.fromJson<int>(json['kills']),
      eliteKills: serializer.fromJson<int>(json['eliteKills']),
      bossBeaten: serializer.fromJson<bool>(json['bossBeaten']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'snapshotIndex': serializer.toJson<int>(snapshotIndex),
      'positionX': serializer.toJson<int>(positionX),
      'positionY': serializer.toJson<int>(positionY),
      'level': serializer.toJson<int>(level),
      'keys': serializer.toJson<int>(keys),
      'steps': serializer.toJson<int>(steps),
      'kills': serializer.toJson<int>(kills),
      'eliteKills': serializer.toJson<int>(eliteKills),
      'bossBeaten': serializer.toJson<bool>(bossBeaten),
    };
  }

  MazeUndoSnapshot copyWith(
          {int? snapshotIndex,
          int? positionX,
          int? positionY,
          int? level,
          int? keys,
          int? steps,
          int? kills,
          int? eliteKills,
          bool? bossBeaten}) =>
      MazeUndoSnapshot(
        snapshotIndex: snapshotIndex ?? this.snapshotIndex,
        positionX: positionX ?? this.positionX,
        positionY: positionY ?? this.positionY,
        level: level ?? this.level,
        keys: keys ?? this.keys,
        steps: steps ?? this.steps,
        kills: kills ?? this.kills,
        eliteKills: eliteKills ?? this.eliteKills,
        bossBeaten: bossBeaten ?? this.bossBeaten,
      );
  MazeUndoSnapshot copyWithCompanion(MazeUndoSnapshotsCompanion data) {
    return MazeUndoSnapshot(
      snapshotIndex: data.snapshotIndex.present
          ? data.snapshotIndex.value
          : this.snapshotIndex,
      positionX: data.positionX.present ? data.positionX.value : this.positionX,
      positionY: data.positionY.present ? data.positionY.value : this.positionY,
      level: data.level.present ? data.level.value : this.level,
      keys: data.keys.present ? data.keys.value : this.keys,
      steps: data.steps.present ? data.steps.value : this.steps,
      kills: data.kills.present ? data.kills.value : this.kills,
      eliteKills:
          data.eliteKills.present ? data.eliteKills.value : this.eliteKills,
      bossBeaten:
          data.bossBeaten.present ? data.bossBeaten.value : this.bossBeaten,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MazeUndoSnapshot(')
          ..write('snapshotIndex: $snapshotIndex, ')
          ..write('positionX: $positionX, ')
          ..write('positionY: $positionY, ')
          ..write('level: $level, ')
          ..write('keys: $keys, ')
          ..write('steps: $steps, ')
          ..write('kills: $kills, ')
          ..write('eliteKills: $eliteKills, ')
          ..write('bossBeaten: $bossBeaten')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(snapshotIndex, positionX, positionY, level,
      keys, steps, kills, eliteKills, bossBeaten);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MazeUndoSnapshot &&
          other.snapshotIndex == this.snapshotIndex &&
          other.positionX == this.positionX &&
          other.positionY == this.positionY &&
          other.level == this.level &&
          other.keys == this.keys &&
          other.steps == this.steps &&
          other.kills == this.kills &&
          other.eliteKills == this.eliteKills &&
          other.bossBeaten == this.bossBeaten);
}

class MazeUndoSnapshotsCompanion extends UpdateCompanion<MazeUndoSnapshot> {
  final Value<int> snapshotIndex;
  final Value<int> positionX;
  final Value<int> positionY;
  final Value<int> level;
  final Value<int> keys;
  final Value<int> steps;
  final Value<int> kills;
  final Value<int> eliteKills;
  final Value<bool> bossBeaten;
  const MazeUndoSnapshotsCompanion({
    this.snapshotIndex = const Value.absent(),
    this.positionX = const Value.absent(),
    this.positionY = const Value.absent(),
    this.level = const Value.absent(),
    this.keys = const Value.absent(),
    this.steps = const Value.absent(),
    this.kills = const Value.absent(),
    this.eliteKills = const Value.absent(),
    this.bossBeaten = const Value.absent(),
  });
  MazeUndoSnapshotsCompanion.insert({
    this.snapshotIndex = const Value.absent(),
    required int positionX,
    required int positionY,
    required int level,
    required int keys,
    required int steps,
    required int kills,
    required int eliteKills,
    required bool bossBeaten,
  })  : positionX = Value(positionX),
        positionY = Value(positionY),
        level = Value(level),
        keys = Value(keys),
        steps = Value(steps),
        kills = Value(kills),
        eliteKills = Value(eliteKills),
        bossBeaten = Value(bossBeaten);
  static Insertable<MazeUndoSnapshot> custom({
    Expression<int>? snapshotIndex,
    Expression<int>? positionX,
    Expression<int>? positionY,
    Expression<int>? level,
    Expression<int>? keys,
    Expression<int>? steps,
    Expression<int>? kills,
    Expression<int>? eliteKills,
    Expression<bool>? bossBeaten,
  }) {
    return RawValuesInsertable({
      if (snapshotIndex != null) 'snapshot_index': snapshotIndex,
      if (positionX != null) 'position_x': positionX,
      if (positionY != null) 'position_y': positionY,
      if (level != null) 'level': level,
      if (keys != null) 'keys': keys,
      if (steps != null) 'steps': steps,
      if (kills != null) 'kills': kills,
      if (eliteKills != null) 'elite_kills': eliteKills,
      if (bossBeaten != null) 'boss_beaten': bossBeaten,
    });
  }

  MazeUndoSnapshotsCompanion copyWith(
      {Value<int>? snapshotIndex,
      Value<int>? positionX,
      Value<int>? positionY,
      Value<int>? level,
      Value<int>? keys,
      Value<int>? steps,
      Value<int>? kills,
      Value<int>? eliteKills,
      Value<bool>? bossBeaten}) {
    return MazeUndoSnapshotsCompanion(
      snapshotIndex: snapshotIndex ?? this.snapshotIndex,
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
      level: level ?? this.level,
      keys: keys ?? this.keys,
      steps: steps ?? this.steps,
      kills: kills ?? this.kills,
      eliteKills: eliteKills ?? this.eliteKills,
      bossBeaten: bossBeaten ?? this.bossBeaten,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (snapshotIndex.present) {
      map['snapshot_index'] = Variable<int>(snapshotIndex.value);
    }
    if (positionX.present) {
      map['position_x'] = Variable<int>(positionX.value);
    }
    if (positionY.present) {
      map['position_y'] = Variable<int>(positionY.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (keys.present) {
      map['keys'] = Variable<int>(keys.value);
    }
    if (steps.present) {
      map['steps'] = Variable<int>(steps.value);
    }
    if (kills.present) {
      map['kills'] = Variable<int>(kills.value);
    }
    if (eliteKills.present) {
      map['elite_kills'] = Variable<int>(eliteKills.value);
    }
    if (bossBeaten.present) {
      map['boss_beaten'] = Variable<bool>(bossBeaten.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MazeUndoSnapshotsCompanion(')
          ..write('snapshotIndex: $snapshotIndex, ')
          ..write('positionX: $positionX, ')
          ..write('positionY: $positionY, ')
          ..write('level: $level, ')
          ..write('keys: $keys, ')
          ..write('steps: $steps, ')
          ..write('kills: $kills, ')
          ..write('eliteKills: $eliteKills, ')
          ..write('bossBeaten: $bossBeaten')
          ..write(')'))
        .toString();
  }
}

class $MazeUndoCellStatesTable extends MazeUndoCellStates
    with TableInfo<$MazeUndoCellStatesTable, MazeUndoCellState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MazeUndoCellStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _snapshotIndexMeta =
      const VerificationMeta('snapshotIndex');
  @override
  late final GeneratedColumn<int> snapshotIndex = GeneratedColumn<int>(
      'snapshot_index', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES maze_undo_snapshots (snapshot_index) ON DELETE CASCADE'));
  static const VerificationMeta _floorIndexMeta =
      const VerificationMeta('floorIndex');
  @override
  late final GeneratedColumn<int> floorIndex = GeneratedColumn<int>(
      'floor_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _cellKeyMeta =
      const VerificationMeta('cellKey');
  @override
  late final GeneratedColumn<String> cellKey = GeneratedColumn<String>(
      'cell_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _consumedMeta =
      const VerificationMeta('consumed');
  @override
  late final GeneratedColumn<bool> consumed = GeneratedColumn<bool>(
      'consumed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("consumed" IN (0, 1))'));
  static const VerificationMeta _pickedMeta = const VerificationMeta('picked');
  @override
  late final GeneratedColumn<bool> picked = GeneratedColumn<bool>(
      'picked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("picked" IN (0, 1))'));
  static const VerificationMeta _openedMeta = const VerificationMeta('opened');
  @override
  late final GeneratedColumn<bool> opened = GeneratedColumn<bool>(
      'opened', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("opened" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns =>
      [snapshotIndex, floorIndex, cellKey, consumed, picked, opened];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maze_undo_cell_states';
  @override
  VerificationContext validateIntegrity(Insertable<MazeUndoCellState> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('snapshot_index')) {
      context.handle(
          _snapshotIndexMeta,
          snapshotIndex.isAcceptableOrUnknown(
              data['snapshot_index']!, _snapshotIndexMeta));
    } else if (isInserting) {
      context.missing(_snapshotIndexMeta);
    }
    if (data.containsKey('floor_index')) {
      context.handle(
          _floorIndexMeta,
          floorIndex.isAcceptableOrUnknown(
              data['floor_index']!, _floorIndexMeta));
    } else if (isInserting) {
      context.missing(_floorIndexMeta);
    }
    if (data.containsKey('cell_key')) {
      context.handle(_cellKeyMeta,
          cellKey.isAcceptableOrUnknown(data['cell_key']!, _cellKeyMeta));
    } else if (isInserting) {
      context.missing(_cellKeyMeta);
    }
    if (data.containsKey('consumed')) {
      context.handle(_consumedMeta,
          consumed.isAcceptableOrUnknown(data['consumed']!, _consumedMeta));
    } else if (isInserting) {
      context.missing(_consumedMeta);
    }
    if (data.containsKey('picked')) {
      context.handle(_pickedMeta,
          picked.isAcceptableOrUnknown(data['picked']!, _pickedMeta));
    } else if (isInserting) {
      context.missing(_pickedMeta);
    }
    if (data.containsKey('opened')) {
      context.handle(_openedMeta,
          opened.isAcceptableOrUnknown(data['opened']!, _openedMeta));
    } else if (isInserting) {
      context.missing(_openedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {snapshotIndex, floorIndex, cellKey};
  @override
  MazeUndoCellState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MazeUndoCellState(
      snapshotIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}snapshot_index'])!,
      floorIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}floor_index'])!,
      cellKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cell_key'])!,
      consumed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}consumed'])!,
      picked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}picked'])!,
      opened: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}opened'])!,
    );
  }

  @override
  $MazeUndoCellStatesTable createAlias(String alias) {
    return $MazeUndoCellStatesTable(attachedDatabase, alias);
  }
}

class MazeUndoCellState extends DataClass
    implements Insertable<MazeUndoCellState> {
  final int snapshotIndex;
  final int floorIndex;
  final String cellKey;
  final bool consumed;
  final bool picked;
  final bool opened;
  const MazeUndoCellState(
      {required this.snapshotIndex,
      required this.floorIndex,
      required this.cellKey,
      required this.consumed,
      required this.picked,
      required this.opened});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['snapshot_index'] = Variable<int>(snapshotIndex);
    map['floor_index'] = Variable<int>(floorIndex);
    map['cell_key'] = Variable<String>(cellKey);
    map['consumed'] = Variable<bool>(consumed);
    map['picked'] = Variable<bool>(picked);
    map['opened'] = Variable<bool>(opened);
    return map;
  }

  MazeUndoCellStatesCompanion toCompanion(bool nullToAbsent) {
    return MazeUndoCellStatesCompanion(
      snapshotIndex: Value(snapshotIndex),
      floorIndex: Value(floorIndex),
      cellKey: Value(cellKey),
      consumed: Value(consumed),
      picked: Value(picked),
      opened: Value(opened),
    );
  }

  factory MazeUndoCellState.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MazeUndoCellState(
      snapshotIndex: serializer.fromJson<int>(json['snapshotIndex']),
      floorIndex: serializer.fromJson<int>(json['floorIndex']),
      cellKey: serializer.fromJson<String>(json['cellKey']),
      consumed: serializer.fromJson<bool>(json['consumed']),
      picked: serializer.fromJson<bool>(json['picked']),
      opened: serializer.fromJson<bool>(json['opened']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'snapshotIndex': serializer.toJson<int>(snapshotIndex),
      'floorIndex': serializer.toJson<int>(floorIndex),
      'cellKey': serializer.toJson<String>(cellKey),
      'consumed': serializer.toJson<bool>(consumed),
      'picked': serializer.toJson<bool>(picked),
      'opened': serializer.toJson<bool>(opened),
    };
  }

  MazeUndoCellState copyWith(
          {int? snapshotIndex,
          int? floorIndex,
          String? cellKey,
          bool? consumed,
          bool? picked,
          bool? opened}) =>
      MazeUndoCellState(
        snapshotIndex: snapshotIndex ?? this.snapshotIndex,
        floorIndex: floorIndex ?? this.floorIndex,
        cellKey: cellKey ?? this.cellKey,
        consumed: consumed ?? this.consumed,
        picked: picked ?? this.picked,
        opened: opened ?? this.opened,
      );
  MazeUndoCellState copyWithCompanion(MazeUndoCellStatesCompanion data) {
    return MazeUndoCellState(
      snapshotIndex: data.snapshotIndex.present
          ? data.snapshotIndex.value
          : this.snapshotIndex,
      floorIndex:
          data.floorIndex.present ? data.floorIndex.value : this.floorIndex,
      cellKey: data.cellKey.present ? data.cellKey.value : this.cellKey,
      consumed: data.consumed.present ? data.consumed.value : this.consumed,
      picked: data.picked.present ? data.picked.value : this.picked,
      opened: data.opened.present ? data.opened.value : this.opened,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MazeUndoCellState(')
          ..write('snapshotIndex: $snapshotIndex, ')
          ..write('floorIndex: $floorIndex, ')
          ..write('cellKey: $cellKey, ')
          ..write('consumed: $consumed, ')
          ..write('picked: $picked, ')
          ..write('opened: $opened')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(snapshotIndex, floorIndex, cellKey, consumed, picked, opened);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MazeUndoCellState &&
          other.snapshotIndex == this.snapshotIndex &&
          other.floorIndex == this.floorIndex &&
          other.cellKey == this.cellKey &&
          other.consumed == this.consumed &&
          other.picked == this.picked &&
          other.opened == this.opened);
}

class MazeUndoCellStatesCompanion extends UpdateCompanion<MazeUndoCellState> {
  final Value<int> snapshotIndex;
  final Value<int> floorIndex;
  final Value<String> cellKey;
  final Value<bool> consumed;
  final Value<bool> picked;
  final Value<bool> opened;
  final Value<int> rowid;
  const MazeUndoCellStatesCompanion({
    this.snapshotIndex = const Value.absent(),
    this.floorIndex = const Value.absent(),
    this.cellKey = const Value.absent(),
    this.consumed = const Value.absent(),
    this.picked = const Value.absent(),
    this.opened = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MazeUndoCellStatesCompanion.insert({
    required int snapshotIndex,
    required int floorIndex,
    required String cellKey,
    required bool consumed,
    required bool picked,
    required bool opened,
    this.rowid = const Value.absent(),
  })  : snapshotIndex = Value(snapshotIndex),
        floorIndex = Value(floorIndex),
        cellKey = Value(cellKey),
        consumed = Value(consumed),
        picked = Value(picked),
        opened = Value(opened);
  static Insertable<MazeUndoCellState> custom({
    Expression<int>? snapshotIndex,
    Expression<int>? floorIndex,
    Expression<String>? cellKey,
    Expression<bool>? consumed,
    Expression<bool>? picked,
    Expression<bool>? opened,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (snapshotIndex != null) 'snapshot_index': snapshotIndex,
      if (floorIndex != null) 'floor_index': floorIndex,
      if (cellKey != null) 'cell_key': cellKey,
      if (consumed != null) 'consumed': consumed,
      if (picked != null) 'picked': picked,
      if (opened != null) 'opened': opened,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MazeUndoCellStatesCompanion copyWith(
      {Value<int>? snapshotIndex,
      Value<int>? floorIndex,
      Value<String>? cellKey,
      Value<bool>? consumed,
      Value<bool>? picked,
      Value<bool>? opened,
      Value<int>? rowid}) {
    return MazeUndoCellStatesCompanion(
      snapshotIndex: snapshotIndex ?? this.snapshotIndex,
      floorIndex: floorIndex ?? this.floorIndex,
      cellKey: cellKey ?? this.cellKey,
      consumed: consumed ?? this.consumed,
      picked: picked ?? this.picked,
      opened: opened ?? this.opened,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (snapshotIndex.present) {
      map['snapshot_index'] = Variable<int>(snapshotIndex.value);
    }
    if (floorIndex.present) {
      map['floor_index'] = Variable<int>(floorIndex.value);
    }
    if (cellKey.present) {
      map['cell_key'] = Variable<String>(cellKey.value);
    }
    if (consumed.present) {
      map['consumed'] = Variable<bool>(consumed.value);
    }
    if (picked.present) {
      map['picked'] = Variable<bool>(picked.value);
    }
    if (opened.present) {
      map['opened'] = Variable<bool>(opened.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MazeUndoCellStatesCompanion(')
          ..write('snapshotIndex: $snapshotIndex, ')
          ..write('floorIndex: $floorIndex, ')
          ..write('cellKey: $cellKey, ')
          ..write('consumed: $consumed, ')
          ..write('picked: $picked, ')
          ..write('opened: $opened, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MazeSettlementsTable extends MazeSettlements
    with TableInfo<$MazeSettlementsTable, MazeSettlement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MazeSettlementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _expMeta = const VerificationMeta('exp');
  @override
  late final GeneratedColumn<int> exp = GeneratedColumn<int>(
      'exp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _clearingGainMeta =
      const VerificationMeta('clearingGain');
  @override
  late final GeneratedColumn<int> clearingGain = GeneratedColumn<int>(
      'clearing_gain', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _perfectMeta =
      const VerificationMeta('perfect');
  @override
  late final GeneratedColumn<bool> perfect = GeneratedColumn<bool>(
      'perfect', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("perfect" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [id, exp, clearingGain, perfect];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maze_settlements';
  @override
  VerificationContext validateIntegrity(Insertable<MazeSettlement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exp')) {
      context.handle(
          _expMeta, exp.isAcceptableOrUnknown(data['exp']!, _expMeta));
    } else if (isInserting) {
      context.missing(_expMeta);
    }
    if (data.containsKey('clearing_gain')) {
      context.handle(
          _clearingGainMeta,
          clearingGain.isAcceptableOrUnknown(
              data['clearing_gain']!, _clearingGainMeta));
    } else if (isInserting) {
      context.missing(_clearingGainMeta);
    }
    if (data.containsKey('perfect')) {
      context.handle(_perfectMeta,
          perfect.isAcceptableOrUnknown(data['perfect']!, _perfectMeta));
    } else if (isInserting) {
      context.missing(_perfectMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MazeSettlement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MazeSettlement(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      exp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}exp'])!,
      clearingGain: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}clearing_gain'])!,
      perfect: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}perfect'])!,
    );
  }

  @override
  $MazeSettlementsTable createAlias(String alias) {
    return $MazeSettlementsTable(attachedDatabase, alias);
  }
}

class MazeSettlement extends DataClass implements Insertable<MazeSettlement> {
  final int id;
  final int exp;
  final int clearingGain;
  final bool perfect;
  const MazeSettlement(
      {required this.id,
      required this.exp,
      required this.clearingGain,
      required this.perfect});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['exp'] = Variable<int>(exp);
    map['clearing_gain'] = Variable<int>(clearingGain);
    map['perfect'] = Variable<bool>(perfect);
    return map;
  }

  MazeSettlementsCompanion toCompanion(bool nullToAbsent) {
    return MazeSettlementsCompanion(
      id: Value(id),
      exp: Value(exp),
      clearingGain: Value(clearingGain),
      perfect: Value(perfect),
    );
  }

  factory MazeSettlement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MazeSettlement(
      id: serializer.fromJson<int>(json['id']),
      exp: serializer.fromJson<int>(json['exp']),
      clearingGain: serializer.fromJson<int>(json['clearingGain']),
      perfect: serializer.fromJson<bool>(json['perfect']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'exp': serializer.toJson<int>(exp),
      'clearingGain': serializer.toJson<int>(clearingGain),
      'perfect': serializer.toJson<bool>(perfect),
    };
  }

  MazeSettlement copyWith(
          {int? id, int? exp, int? clearingGain, bool? perfect}) =>
      MazeSettlement(
        id: id ?? this.id,
        exp: exp ?? this.exp,
        clearingGain: clearingGain ?? this.clearingGain,
        perfect: perfect ?? this.perfect,
      );
  MazeSettlement copyWithCompanion(MazeSettlementsCompanion data) {
    return MazeSettlement(
      id: data.id.present ? data.id.value : this.id,
      exp: data.exp.present ? data.exp.value : this.exp,
      clearingGain: data.clearingGain.present
          ? data.clearingGain.value
          : this.clearingGain,
      perfect: data.perfect.present ? data.perfect.value : this.perfect,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MazeSettlement(')
          ..write('id: $id, ')
          ..write('exp: $exp, ')
          ..write('clearingGain: $clearingGain, ')
          ..write('perfect: $perfect')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, exp, clearingGain, perfect);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MazeSettlement &&
          other.id == this.id &&
          other.exp == this.exp &&
          other.clearingGain == this.clearingGain &&
          other.perfect == this.perfect);
}

class MazeSettlementsCompanion extends UpdateCompanion<MazeSettlement> {
  final Value<int> id;
  final Value<int> exp;
  final Value<int> clearingGain;
  final Value<bool> perfect;
  const MazeSettlementsCompanion({
    this.id = const Value.absent(),
    this.exp = const Value.absent(),
    this.clearingGain = const Value.absent(),
    this.perfect = const Value.absent(),
  });
  MazeSettlementsCompanion.insert({
    this.id = const Value.absent(),
    required int exp,
    required int clearingGain,
    required bool perfect,
  })  : exp = Value(exp),
        clearingGain = Value(clearingGain),
        perfect = Value(perfect);
  static Insertable<MazeSettlement> custom({
    Expression<int>? id,
    Expression<int>? exp,
    Expression<int>? clearingGain,
    Expression<bool>? perfect,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exp != null) 'exp': exp,
      if (clearingGain != null) 'clearing_gain': clearingGain,
      if (perfect != null) 'perfect': perfect,
    });
  }

  MazeSettlementsCompanion copyWith(
      {Value<int>? id,
      Value<int>? exp,
      Value<int>? clearingGain,
      Value<bool>? perfect}) {
    return MazeSettlementsCompanion(
      id: id ?? this.id,
      exp: exp ?? this.exp,
      clearingGain: clearingGain ?? this.clearingGain,
      perfect: perfect ?? this.perfect,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (exp.present) {
      map['exp'] = Variable<int>(exp.value);
    }
    if (clearingGain.present) {
      map['clearing_gain'] = Variable<int>(clearingGain.value);
    }
    if (perfect.present) {
      map['perfect'] = Variable<bool>(perfect.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MazeSettlementsCompanion(')
          ..write('id: $id, ')
          ..write('exp: $exp, ')
          ..write('clearingGain: $clearingGain, ')
          ..write('perfect: $perfect')
          ..write(')'))
        .toString();
  }
}

class $MazeSettlementLootRowsTable extends MazeSettlementLootRows
    with TableInfo<$MazeSettlementLootRowsTable, MazeSettlementLootRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MazeSettlementLootRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemCodeMeta =
      const VerificationMeta('itemCode');
  @override
  late final GeneratedColumn<String> itemCode = GeneratedColumn<String>(
      'item_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES item_catalog (code)'));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL CHECK (quantity >= 0)');
  @override
  List<GeneratedColumn> get $columns => [itemCode, quantity];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maze_settlement_loot';
  @override
  VerificationContext validateIntegrity(
      Insertable<MazeSettlementLootRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_code')) {
      context.handle(_itemCodeMeta,
          itemCode.isAcceptableOrUnknown(data['item_code']!, _itemCodeMeta));
    } else if (isInserting) {
      context.missing(_itemCodeMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemCode};
  @override
  MazeSettlementLootRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MazeSettlementLootRow(
      itemCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_code'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
    );
  }

  @override
  $MazeSettlementLootRowsTable createAlias(String alias) {
    return $MazeSettlementLootRowsTable(attachedDatabase, alias);
  }
}

class MazeSettlementLootRow extends DataClass
    implements Insertable<MazeSettlementLootRow> {
  final String itemCode;
  final int quantity;
  const MazeSettlementLootRow({required this.itemCode, required this.quantity});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_code'] = Variable<String>(itemCode);
    map['quantity'] = Variable<int>(quantity);
    return map;
  }

  MazeSettlementLootRowsCompanion toCompanion(bool nullToAbsent) {
    return MazeSettlementLootRowsCompanion(
      itemCode: Value(itemCode),
      quantity: Value(quantity),
    );
  }

  factory MazeSettlementLootRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MazeSettlementLootRow(
      itemCode: serializer.fromJson<String>(json['itemCode']),
      quantity: serializer.fromJson<int>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemCode': serializer.toJson<String>(itemCode),
      'quantity': serializer.toJson<int>(quantity),
    };
  }

  MazeSettlementLootRow copyWith({String? itemCode, int? quantity}) =>
      MazeSettlementLootRow(
        itemCode: itemCode ?? this.itemCode,
        quantity: quantity ?? this.quantity,
      );
  MazeSettlementLootRow copyWithCompanion(
      MazeSettlementLootRowsCompanion data) {
    return MazeSettlementLootRow(
      itemCode: data.itemCode.present ? data.itemCode.value : this.itemCode,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MazeSettlementLootRow(')
          ..write('itemCode: $itemCode, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(itemCode, quantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MazeSettlementLootRow &&
          other.itemCode == this.itemCode &&
          other.quantity == this.quantity);
}

class MazeSettlementLootRowsCompanion
    extends UpdateCompanion<MazeSettlementLootRow> {
  final Value<String> itemCode;
  final Value<int> quantity;
  final Value<int> rowid;
  const MazeSettlementLootRowsCompanion({
    this.itemCode = const Value.absent(),
    this.quantity = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MazeSettlementLootRowsCompanion.insert({
    required String itemCode,
    required int quantity,
    this.rowid = const Value.absent(),
  })  : itemCode = Value(itemCode),
        quantity = Value(quantity);
  static Insertable<MazeSettlementLootRow> custom({
    Expression<String>? itemCode,
    Expression<int>? quantity,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemCode != null) 'item_code': itemCode,
      if (quantity != null) 'quantity': quantity,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MazeSettlementLootRowsCompanion copyWith(
      {Value<String>? itemCode, Value<int>? quantity, Value<int>? rowid}) {
    return MazeSettlementLootRowsCompanion(
      itemCode: itemCode ?? this.itemCode,
      quantity: quantity ?? this.quantity,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemCode.present) {
      map['item_code'] = Variable<String>(itemCode.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MazeSettlementLootRowsCompanion(')
          ..write('itemCode: $itemCode, ')
          ..write('quantity: $quantity, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$MoodisleDatabase extends GeneratedDatabase {
  _$MoodisleDatabase(QueryExecutor e) : super(e);
  $MoodisleDatabaseManager get managers => $MoodisleDatabaseManager(this);
  late final $EmotionCatalogTable emotionCatalog = $EmotionCatalogTable(this);
  late final $ItemCatalogTable itemCatalog = $ItemCatalogTable(this);
  late final $DailyQuestCatalogTable dailyQuestCatalog =
      $DailyQuestCatalogTable(this);
  late final $SouvenirCatalogTable souvenirCatalog =
      $SouvenirCatalogTable(this);
  late final $PlayerProfilesTable playerProfiles = $PlayerProfilesTable(this);
  late final $TaskRowsTable taskRows = $TaskRowsTable(this);
  late final $PetRecordsTable petRecords = $PetRecordsTable(this);
  late final $InventoryRowsTable inventoryRows = $InventoryRowsTable(this);
  late final $GameStatisticsTable gameStatistics = $GameStatisticsTable(this);
  late final $StreakStatesTable streakStates = $StreakStatesTable(this);
  late final $KeeperStatesTable keeperStates = $KeeperStatesTable(this);
  late final $ResonanceStatesTable resonanceStates =
      $ResonanceStatesTable(this);
  late final $ClimateStatesTable climateStates = $ClimateStatesTable(this);
  late final $ClimateDaysTable climateDays = $ClimateDaysTable(this);
  late final $FocusMetadataTable focusMetadata = $FocusMetadataTable(this);
  late final $ActiveFocusSessionsTable activeFocusSessions =
      $ActiveFocusSessionsTable(this);
  late final $DailyStatesTable dailyStates = $DailyStatesTable(this);
  late final $DailyQuestProgressRowsTable dailyQuestProgressRows =
      $DailyQuestProgressRowsTable(this);
  late final $AchievementUnlocksTable achievementUnlocks =
      $AchievementUnlocksTable(this);
  late final $RoamSlotsTable roamSlots = $RoamSlotsTable(this);
  late final $SouvenirInventoryRowsTable souvenirInventoryRows =
      $SouvenirInventoryRowsTable(this);
  late final $SocialProfilesTable socialProfiles = $SocialProfilesTable(this);
  late final $PostcardsTable postcards = $PostcardsTable(this);
  late final $ActiveMazeRunsTable activeMazeRuns = $ActiveMazeRunsTable(this);
  late final $MazeCellStatesTable mazeCellStates = $MazeCellStatesTable(this);
  late final $MazeUndoSnapshotsTable mazeUndoSnapshots =
      $MazeUndoSnapshotsTable(this);
  late final $MazeUndoCellStatesTable mazeUndoCellStates =
      $MazeUndoCellStatesTable(this);
  late final $MazeSettlementsTable mazeSettlements =
      $MazeSettlementsTable(this);
  late final $MazeSettlementLootRowsTable mazeSettlementLootRows =
      $MazeSettlementLootRowsTable(this);
  late final Index idxTasksStatusCreatedOn = Index(
      'idx_tasks_status_created_on',
      'CREATE INDEX idx_tasks_status_created_on ON tasks (status, created_on)');
  late final Index idxPostcardsReceivedAt = Index('idx_postcards_received_at',
      'CREATE INDEX idx_postcards_received_at ON postcards (received_at_ms)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        emotionCatalog,
        itemCatalog,
        dailyQuestCatalog,
        souvenirCatalog,
        playerProfiles,
        taskRows,
        petRecords,
        inventoryRows,
        gameStatistics,
        streakStates,
        keeperStates,
        resonanceStates,
        climateStates,
        climateDays,
        focusMetadata,
        activeFocusSessions,
        dailyStates,
        dailyQuestProgressRows,
        achievementUnlocks,
        roamSlots,
        souvenirInventoryRows,
        socialProfiles,
        postcards,
        activeMazeRuns,
        mazeCellStates,
        mazeUndoSnapshots,
        mazeUndoCellStates,
        mazeSettlements,
        mazeSettlementLootRows,
        idxTasksStatusCreatedOn,
        idxPostcardsReceivedAt
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('maze_undo_snapshots',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('maze_undo_cell_states', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$EmotionCatalogTableCreateCompanionBuilder = EmotionCatalogCompanion
    Function({
  required String code,
  Value<int> rowid,
});
typedef $$EmotionCatalogTableUpdateCompanionBuilder = EmotionCatalogCompanion
    Function({
  Value<String> code,
  Value<int> rowid,
});

final class $$EmotionCatalogTableReferences extends BaseReferences<
    _$MoodisleDatabase, $EmotionCatalogTable, EmotionCatalogData> {
  $$EmotionCatalogTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlayerProfilesTable, List<PlayerProfile>>
      _playerProfilesRefsTable(_$MoodisleDatabase db) =>
          MultiTypedResultKey.fromTable(db.playerProfiles,
              aliasName: 'emotion_catalog__code__player_profiles__companion');

  $$PlayerProfilesTableProcessedTableManager get playerProfilesRefs {
    final manager = $$PlayerProfilesTableTableManager($_db, $_db.playerProfiles)
        .filter(
            (f) => f.companion.code.sqlEquals($_itemColumn<String>('code')!));

    final cache = $_typedResult.readTableOrNull(_playerProfilesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TaskRowsTable, List<TaskRow>> _taskRowsRefsTable(
          _$MoodisleDatabase db) =>
      MultiTypedResultKey.fromTable(db.taskRows,
          aliasName: 'emotion_catalog__code__tasks__emotion');

  $$TaskRowsTableProcessedTableManager get taskRowsRefs {
    final manager = $$TaskRowsTableTableManager($_db, $_db.taskRows)
        .filter((f) => f.emotion.code.sqlEquals($_itemColumn<String>('code')!));

    final cache = $_typedResult.readTableOrNull(_taskRowsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PetRecordsTable, List<DbPetRecord>>
      _petRecordsRefsTable(_$MoodisleDatabase db) =>
          MultiTypedResultKey.fromTable(db.petRecords,
              aliasName: 'emotion_catalog__code__pet_records__emotion');

  $$PetRecordsTableProcessedTableManager get petRecordsRefs {
    final manager = $$PetRecordsTableTableManager($_db, $_db.petRecords)
        .filter((f) => f.emotion.code.sqlEquals($_itemColumn<String>('code')!));

    final cache = $_typedResult.readTableOrNull(_petRecordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ResonanceStatesTable, List<ResonanceState>>
      _resonanceStatesRefsTable(_$MoodisleDatabase db) =>
          MultiTypedResultKey.fromTable(db.resonanceStates,
              aliasName:
                  'emotion_catalog__code__resonance_states__last_emotion');

  $$ResonanceStatesTableProcessedTableManager get resonanceStatesRefs {
    final manager =
        $$ResonanceStatesTableTableManager($_db, $_db.resonanceStates).filter(
            (f) => f.lastEmotion.code.sqlEquals($_itemColumn<String>('code')!));

    final cache =
        $_typedResult.readTableOrNull(_resonanceStatesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ActiveFocusSessionsTable,
      List<ActiveFocusSession>> _activeFocusSessionsRefsTable(
          _$MoodisleDatabase db) =>
      MultiTypedResultKey.fromTable(db.activeFocusSessions,
          aliasName: 'emotion_catalog__code__active_focus_sessions__pet');

  $$ActiveFocusSessionsTableProcessedTableManager get activeFocusSessionsRefs {
    final manager =
        $$ActiveFocusSessionsTableTableManager($_db, $_db.activeFocusSessions)
            .filter((f) => f.pet.code.sqlEquals($_itemColumn<String>('code')!));

    final cache =
        $_typedResult.readTableOrNull(_activeFocusSessionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$RoamSlotsTable, List<RoamSlot>>
      _roamSlotsRefsTable(_$MoodisleDatabase db) =>
          MultiTypedResultKey.fromTable(db.roamSlots,
              aliasName: 'emotion_catalog__code__roam_slots__pet');

  $$RoamSlotsTableProcessedTableManager get roamSlotsRefs {
    final manager = $$RoamSlotsTableTableManager($_db, $_db.roamSlots)
        .filter((f) => f.pet.code.sqlEquals($_itemColumn<String>('code')!));

    final cache = $_typedResult.readTableOrNull(_roamSlotsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SocialProfilesTable, List<SocialProfile>>
      _socialProfilesRefsTable(_$MoodisleDatabase db) =>
          MultiTypedResultKey.fromTable(db.socialProfiles,
              aliasName:
                  'emotion_catalog__code__social_profiles__visiting_pet');

  $$SocialProfilesTableProcessedTableManager get socialProfilesRefs {
    final manager = $$SocialProfilesTableTableManager($_db, $_db.socialProfiles)
        .filter(
            (f) => f.visitingPet.code.sqlEquals($_itemColumn<String>('code')!));

    final cache = $_typedResult.readTableOrNull(_socialProfilesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PostcardsTable, List<Postcard>>
      _postcardsRefsTable(_$MoodisleDatabase db) =>
          MultiTypedResultKey.fromTable(db.postcards,
              aliasName: 'emotion_catalog__code__postcards__friend_pet');

  $$PostcardsTableProcessedTableManager get postcardsRefs {
    final manager = $$PostcardsTableTableManager($_db, $_db.postcards).filter(
        (f) => f.friendPet.code.sqlEquals($_itemColumn<String>('code')!));

    final cache = $_typedResult.readTableOrNull(_postcardsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$EmotionCatalogTableFilterComposer
    extends Composer<_$MoodisleDatabase, $EmotionCatalogTable> {
  $$EmotionCatalogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  Expression<bool> playerProfilesRefs(
      Expression<bool> Function($$PlayerProfilesTableFilterComposer f) f) {
    final $$PlayerProfilesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.playerProfiles,
        getReferencedColumn: (t) => t.companion,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerProfilesTableFilterComposer(
              $db: $db,
              $table: $db.playerProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> taskRowsRefs(
      Expression<bool> Function($$TaskRowsTableFilterComposer f) f) {
    final $$TaskRowsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.taskRows,
        getReferencedColumn: (t) => t.emotion,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TaskRowsTableFilterComposer(
              $db: $db,
              $table: $db.taskRows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> petRecordsRefs(
      Expression<bool> Function($$PetRecordsTableFilterComposer f) f) {
    final $$PetRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.petRecords,
        getReferencedColumn: (t) => t.emotion,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PetRecordsTableFilterComposer(
              $db: $db,
              $table: $db.petRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> resonanceStatesRefs(
      Expression<bool> Function($$ResonanceStatesTableFilterComposer f) f) {
    final $$ResonanceStatesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.resonanceStates,
        getReferencedColumn: (t) => t.lastEmotion,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ResonanceStatesTableFilterComposer(
              $db: $db,
              $table: $db.resonanceStates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> activeFocusSessionsRefs(
      Expression<bool> Function($$ActiveFocusSessionsTableFilterComposer f) f) {
    final $$ActiveFocusSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.activeFocusSessions,
        getReferencedColumn: (t) => t.pet,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ActiveFocusSessionsTableFilterComposer(
              $db: $db,
              $table: $db.activeFocusSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> roamSlotsRefs(
      Expression<bool> Function($$RoamSlotsTableFilterComposer f) f) {
    final $$RoamSlotsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.roamSlots,
        getReferencedColumn: (t) => t.pet,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoamSlotsTableFilterComposer(
              $db: $db,
              $table: $db.roamSlots,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> socialProfilesRefs(
      Expression<bool> Function($$SocialProfilesTableFilterComposer f) f) {
    final $$SocialProfilesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.socialProfiles,
        getReferencedColumn: (t) => t.visitingPet,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SocialProfilesTableFilterComposer(
              $db: $db,
              $table: $db.socialProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> postcardsRefs(
      Expression<bool> Function($$PostcardsTableFilterComposer f) f) {
    final $$PostcardsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.postcards,
        getReferencedColumn: (t) => t.friendPet,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PostcardsTableFilterComposer(
              $db: $db,
              $table: $db.postcards,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EmotionCatalogTableOrderingComposer
    extends Composer<_$MoodisleDatabase, $EmotionCatalogTable> {
  $$EmotionCatalogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));
}

class $$EmotionCatalogTableAnnotationComposer
    extends Composer<_$MoodisleDatabase, $EmotionCatalogTable> {
  $$EmotionCatalogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  Expression<T> playerProfilesRefs<T extends Object>(
      Expression<T> Function($$PlayerProfilesTableAnnotationComposer a) f) {
    final $$PlayerProfilesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.playerProfiles,
        getReferencedColumn: (t) => t.companion,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlayerProfilesTableAnnotationComposer(
              $db: $db,
              $table: $db.playerProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> taskRowsRefs<T extends Object>(
      Expression<T> Function($$TaskRowsTableAnnotationComposer a) f) {
    final $$TaskRowsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.taskRows,
        getReferencedColumn: (t) => t.emotion,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TaskRowsTableAnnotationComposer(
              $db: $db,
              $table: $db.taskRows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> petRecordsRefs<T extends Object>(
      Expression<T> Function($$PetRecordsTableAnnotationComposer a) f) {
    final $$PetRecordsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.petRecords,
        getReferencedColumn: (t) => t.emotion,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PetRecordsTableAnnotationComposer(
              $db: $db,
              $table: $db.petRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> resonanceStatesRefs<T extends Object>(
      Expression<T> Function($$ResonanceStatesTableAnnotationComposer a) f) {
    final $$ResonanceStatesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.resonanceStates,
        getReferencedColumn: (t) => t.lastEmotion,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ResonanceStatesTableAnnotationComposer(
              $db: $db,
              $table: $db.resonanceStates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> activeFocusSessionsRefs<T extends Object>(
      Expression<T> Function($$ActiveFocusSessionsTableAnnotationComposer a)
          f) {
    final $$ActiveFocusSessionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.code,
            referencedTable: $db.activeFocusSessions,
            getReferencedColumn: (t) => t.pet,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ActiveFocusSessionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.activeFocusSessions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> roamSlotsRefs<T extends Object>(
      Expression<T> Function($$RoamSlotsTableAnnotationComposer a) f) {
    final $$RoamSlotsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.roamSlots,
        getReferencedColumn: (t) => t.pet,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoamSlotsTableAnnotationComposer(
              $db: $db,
              $table: $db.roamSlots,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> socialProfilesRefs<T extends Object>(
      Expression<T> Function($$SocialProfilesTableAnnotationComposer a) f) {
    final $$SocialProfilesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.socialProfiles,
        getReferencedColumn: (t) => t.visitingPet,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SocialProfilesTableAnnotationComposer(
              $db: $db,
              $table: $db.socialProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> postcardsRefs<T extends Object>(
      Expression<T> Function($$PostcardsTableAnnotationComposer a) f) {
    final $$PostcardsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.postcards,
        getReferencedColumn: (t) => t.friendPet,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PostcardsTableAnnotationComposer(
              $db: $db,
              $table: $db.postcards,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EmotionCatalogTableTableManager extends RootTableManager<
    _$MoodisleDatabase,
    $EmotionCatalogTable,
    EmotionCatalogData,
    $$EmotionCatalogTableFilterComposer,
    $$EmotionCatalogTableOrderingComposer,
    $$EmotionCatalogTableAnnotationComposer,
    $$EmotionCatalogTableCreateCompanionBuilder,
    $$EmotionCatalogTableUpdateCompanionBuilder,
    (EmotionCatalogData, $$EmotionCatalogTableReferences),
    EmotionCatalogData,
    PrefetchHooks Function(
        {bool playerProfilesRefs,
        bool taskRowsRefs,
        bool petRecordsRefs,
        bool resonanceStatesRefs,
        bool activeFocusSessionsRefs,
        bool roamSlotsRefs,
        bool socialProfilesRefs,
        bool postcardsRefs})> {
  $$EmotionCatalogTableTableManager(
      _$MoodisleDatabase db, $EmotionCatalogTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmotionCatalogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmotionCatalogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmotionCatalogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EmotionCatalogCompanion(
            code: code,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            Value<int> rowid = const Value.absent(),
          }) =>
              EmotionCatalogCompanion.insert(
            code: code,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$EmotionCatalogTable, EmotionCatalogData>(
                        table),
                    $$EmotionCatalogTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {playerProfilesRefs = false,
              taskRowsRefs = false,
              petRecordsRefs = false,
              resonanceStatesRefs = false,
              activeFocusSessionsRefs = false,
              roamSlotsRefs = false,
              socialProfilesRefs = false,
              postcardsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (playerProfilesRefs) db.playerProfiles,
                if (taskRowsRefs) db.taskRows,
                if (petRecordsRefs) db.petRecords,
                if (resonanceStatesRefs) db.resonanceStates,
                if (activeFocusSessionsRefs) db.activeFocusSessions,
                if (roamSlotsRefs) db.roamSlots,
                if (socialProfilesRefs) db.socialProfiles,
                if (postcardsRefs) db.postcards
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (playerProfilesRefs)
                    await $_getPrefetchedData<EmotionCatalogData,
                            $EmotionCatalogTable, PlayerProfile>(
                        currentTable: table,
                        referencedTable: $$EmotionCatalogTableReferences
                            ._playerProfilesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EmotionCatalogTableReferences(db, table, p0)
                                .playerProfilesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.companion == item.code),
                        typedResults: items),
                  if (taskRowsRefs)
                    await $_getPrefetchedData<EmotionCatalogData,
                            $EmotionCatalogTable, TaskRow>(
                        currentTable: table,
                        referencedTable: $$EmotionCatalogTableReferences
                            ._taskRowsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EmotionCatalogTableReferences(db, table, p0)
                                .taskRowsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.emotion == item.code),
                        typedResults: items),
                  if (petRecordsRefs)
                    await $_getPrefetchedData<EmotionCatalogData,
                            $EmotionCatalogTable, DbPetRecord>(
                        currentTable: table,
                        referencedTable: $$EmotionCatalogTableReferences
                            ._petRecordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EmotionCatalogTableReferences(db, table, p0)
                                .petRecordsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.emotion == item.code),
                        typedResults: items),
                  if (resonanceStatesRefs)
                    await $_getPrefetchedData<EmotionCatalogData,
                            $EmotionCatalogTable, ResonanceState>(
                        currentTable: table,
                        referencedTable: $$EmotionCatalogTableReferences
                            ._resonanceStatesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EmotionCatalogTableReferences(db, table, p0)
                                .resonanceStatesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.lastEmotion == item.code),
                        typedResults: items),
                  if (activeFocusSessionsRefs)
                    await $_getPrefetchedData<EmotionCatalogData,
                            $EmotionCatalogTable, ActiveFocusSession>(
                        currentTable: table,
                        referencedTable: $$EmotionCatalogTableReferences
                            ._activeFocusSessionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EmotionCatalogTableReferences(db, table, p0)
                                .activeFocusSessionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.pet == item.code),
                        typedResults: items),
                  if (roamSlotsRefs)
                    await $_getPrefetchedData<EmotionCatalogData,
                            $EmotionCatalogTable, RoamSlot>(
                        currentTable: table,
                        referencedTable: $$EmotionCatalogTableReferences
                            ._roamSlotsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EmotionCatalogTableReferences(db, table, p0)
                                .roamSlotsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.pet == item.code),
                        typedResults: items),
                  if (socialProfilesRefs)
                    await $_getPrefetchedData<EmotionCatalogData,
                            $EmotionCatalogTable, SocialProfile>(
                        currentTable: table,
                        referencedTable: $$EmotionCatalogTableReferences
                            ._socialProfilesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EmotionCatalogTableReferences(db, table, p0)
                                .socialProfilesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.visitingPet == item.code),
                        typedResults: items),
                  if (postcardsRefs)
                    await $_getPrefetchedData<EmotionCatalogData,
                            $EmotionCatalogTable, Postcard>(
                        currentTable: table,
                        referencedTable: $$EmotionCatalogTableReferences
                            ._postcardsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EmotionCatalogTableReferences(db, table, p0)
                                .postcardsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.friendPet == item.code),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$EmotionCatalogTableProcessedTableManager = ProcessedTableManager<
    _$MoodisleDatabase,
    $EmotionCatalogTable,
    EmotionCatalogData,
    $$EmotionCatalogTableFilterComposer,
    $$EmotionCatalogTableOrderingComposer,
    $$EmotionCatalogTableAnnotationComposer,
    $$EmotionCatalogTableCreateCompanionBuilder,
    $$EmotionCatalogTableUpdateCompanionBuilder,
    (EmotionCatalogData, $$EmotionCatalogTableReferences),
    EmotionCatalogData,
    PrefetchHooks Function(
        {bool playerProfilesRefs,
        bool taskRowsRefs,
        bool petRecordsRefs,
        bool resonanceStatesRefs,
        bool activeFocusSessionsRefs,
        bool roamSlotsRefs,
        bool socialProfilesRefs,
        bool postcardsRefs})>;
typedef $$ItemCatalogTableCreateCompanionBuilder = ItemCatalogCompanion
    Function({
  required String code,
  Value<int> rowid,
});
typedef $$ItemCatalogTableUpdateCompanionBuilder = ItemCatalogCompanion
    Function({
  Value<String> code,
  Value<int> rowid,
});

final class $$ItemCatalogTableReferences extends BaseReferences<
    _$MoodisleDatabase, $ItemCatalogTable, ItemCatalogData> {
  $$ItemCatalogTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$InventoryRowsTable, List<InventoryRow>>
      _inventoryRowsRefsTable(_$MoodisleDatabase db) =>
          MultiTypedResultKey.fromTable(db.inventoryRows,
              aliasName: 'item_catalog__code__inventory__item_code');

  $$InventoryRowsTableProcessedTableManager get inventoryRowsRefs {
    final manager = $$InventoryRowsTableTableManager($_db, $_db.inventoryRows)
        .filter(
            (f) => f.itemCode.code.sqlEquals($_itemColumn<String>('code')!));

    final cache = $_typedResult.readTableOrNull(_inventoryRowsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MazeSettlementLootRowsTable,
      List<MazeSettlementLootRow>> _mazeSettlementLootRowsRefsTable(
          _$MoodisleDatabase db) =>
      MultiTypedResultKey.fromTable(db.mazeSettlementLootRows,
          aliasName: 'item_catalog__code__maze_settlement_loot__item_code');

  $$MazeSettlementLootRowsTableProcessedTableManager
      get mazeSettlementLootRowsRefs {
    final manager = $$MazeSettlementLootRowsTableTableManager(
            $_db, $_db.mazeSettlementLootRows)
        .filter(
            (f) => f.itemCode.code.sqlEquals($_itemColumn<String>('code')!));

    final cache =
        $_typedResult.readTableOrNull(_mazeSettlementLootRowsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ItemCatalogTableFilterComposer
    extends Composer<_$MoodisleDatabase, $ItemCatalogTable> {
  $$ItemCatalogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  Expression<bool> inventoryRowsRefs(
      Expression<bool> Function($$InventoryRowsTableFilterComposer f) f) {
    final $$InventoryRowsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.inventoryRows,
        getReferencedColumn: (t) => t.itemCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoryRowsTableFilterComposer(
              $db: $db,
              $table: $db.inventoryRows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> mazeSettlementLootRowsRefs(
      Expression<bool> Function($$MazeSettlementLootRowsTableFilterComposer f)
          f) {
    final $$MazeSettlementLootRowsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.code,
            referencedTable: $db.mazeSettlementLootRows,
            getReferencedColumn: (t) => t.itemCode,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MazeSettlementLootRowsTableFilterComposer(
                  $db: $db,
                  $table: $db.mazeSettlementLootRows,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ItemCatalogTableOrderingComposer
    extends Composer<_$MoodisleDatabase, $ItemCatalogTable> {
  $$ItemCatalogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));
}

class $$ItemCatalogTableAnnotationComposer
    extends Composer<_$MoodisleDatabase, $ItemCatalogTable> {
  $$ItemCatalogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  Expression<T> inventoryRowsRefs<T extends Object>(
      Expression<T> Function($$InventoryRowsTableAnnotationComposer a) f) {
    final $$InventoryRowsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.inventoryRows,
        getReferencedColumn: (t) => t.itemCode,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoryRowsTableAnnotationComposer(
              $db: $db,
              $table: $db.inventoryRows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> mazeSettlementLootRowsRefs<T extends Object>(
      Expression<T> Function($$MazeSettlementLootRowsTableAnnotationComposer a)
          f) {
    final $$MazeSettlementLootRowsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.code,
            referencedTable: $db.mazeSettlementLootRows,
            getReferencedColumn: (t) => t.itemCode,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MazeSettlementLootRowsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.mazeSettlementLootRows,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ItemCatalogTableTableManager extends RootTableManager<
    _$MoodisleDatabase,
    $ItemCatalogTable,
    ItemCatalogData,
    $$ItemCatalogTableFilterComposer,
    $$ItemCatalogTableOrderingComposer,
    $$ItemCatalogTableAnnotationComposer,
    $$ItemCatalogTableCreateCompanionBuilder,
    $$ItemCatalogTableUpdateCompanionBuilder,
    (ItemCatalogData, $$ItemCatalogTableReferences),
    ItemCatalogData,
    PrefetchHooks Function(
        {bool inventoryRowsRefs, bool mazeSettlementLootRowsRefs})> {
  $$ItemCatalogTableTableManager(_$MoodisleDatabase db, $ItemCatalogTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemCatalogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemCatalogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemCatalogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ItemCatalogCompanion(
            code: code,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            Value<int> rowid = const Value.absent(),
          }) =>
              ItemCatalogCompanion.insert(
            code: code,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ItemCatalogTable, ItemCatalogData>(table),
                    $$ItemCatalogTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {inventoryRowsRefs = false, mazeSettlementLootRowsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (inventoryRowsRefs) db.inventoryRows,
                if (mazeSettlementLootRowsRefs) db.mazeSettlementLootRows
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (inventoryRowsRefs)
                    await $_getPrefetchedData<ItemCatalogData,
                            $ItemCatalogTable, InventoryRow>(
                        currentTable: table,
                        referencedTable: $$ItemCatalogTableReferences
                            ._inventoryRowsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ItemCatalogTableReferences(db, table, p0)
                                .inventoryRowsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.itemCode == item.code),
                        typedResults: items),
                  if (mazeSettlementLootRowsRefs)
                    await $_getPrefetchedData<ItemCatalogData,
                            $ItemCatalogTable, MazeSettlementLootRow>(
                        currentTable: table,
                        referencedTable: $$ItemCatalogTableReferences
                            ._mazeSettlementLootRowsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ItemCatalogTableReferences(db, table, p0)
                                .mazeSettlementLootRowsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.itemCode == item.code),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ItemCatalogTableProcessedTableManager = ProcessedTableManager<
    _$MoodisleDatabase,
    $ItemCatalogTable,
    ItemCatalogData,
    $$ItemCatalogTableFilterComposer,
    $$ItemCatalogTableOrderingComposer,
    $$ItemCatalogTableAnnotationComposer,
    $$ItemCatalogTableCreateCompanionBuilder,
    $$ItemCatalogTableUpdateCompanionBuilder,
    (ItemCatalogData, $$ItemCatalogTableReferences),
    ItemCatalogData,
    PrefetchHooks Function(
        {bool inventoryRowsRefs, bool mazeSettlementLootRowsRefs})>;
typedef $$DailyQuestCatalogTableCreateCompanionBuilder
    = DailyQuestCatalogCompanion Function({
  required String code,
  Value<int> rowid,
});
typedef $$DailyQuestCatalogTableUpdateCompanionBuilder
    = DailyQuestCatalogCompanion Function({
  Value<String> code,
  Value<int> rowid,
});

final class $$DailyQuestCatalogTableReferences extends BaseReferences<
    _$MoodisleDatabase, $DailyQuestCatalogTable, DailyQuestCatalogData> {
  $$DailyQuestCatalogTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DailyQuestProgressRowsTable,
      List<DailyQuestProgressRow>> _dailyQuestProgressRowsRefsTable(
          _$MoodisleDatabase db) =>
      MultiTypedResultKey.fromTable(db.dailyQuestProgressRows,
          aliasName:
              'daily_quest_catalog__code__daily_quest_progress__quest_code');

  $$DailyQuestProgressRowsTableProcessedTableManager
      get dailyQuestProgressRowsRefs {
    final manager = $$DailyQuestProgressRowsTableTableManager(
            $_db, $_db.dailyQuestProgressRows)
        .filter(
            (f) => f.questCode.code.sqlEquals($_itemColumn<String>('code')!));

    final cache =
        $_typedResult.readTableOrNull(_dailyQuestProgressRowsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DailyQuestCatalogTableFilterComposer
    extends Composer<_$MoodisleDatabase, $DailyQuestCatalogTable> {
  $$DailyQuestCatalogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  Expression<bool> dailyQuestProgressRowsRefs(
      Expression<bool> Function($$DailyQuestProgressRowsTableFilterComposer f)
          f) {
    final $$DailyQuestProgressRowsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.code,
            referencedTable: $db.dailyQuestProgressRows,
            getReferencedColumn: (t) => t.questCode,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$DailyQuestProgressRowsTableFilterComposer(
                  $db: $db,
                  $table: $db.dailyQuestProgressRows,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$DailyQuestCatalogTableOrderingComposer
    extends Composer<_$MoodisleDatabase, $DailyQuestCatalogTable> {
  $$DailyQuestCatalogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));
}

class $$DailyQuestCatalogTableAnnotationComposer
    extends Composer<_$MoodisleDatabase, $DailyQuestCatalogTable> {
  $$DailyQuestCatalogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  Expression<T> dailyQuestProgressRowsRefs<T extends Object>(
      Expression<T> Function($$DailyQuestProgressRowsTableAnnotationComposer a)
          f) {
    final $$DailyQuestProgressRowsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.code,
            referencedTable: $db.dailyQuestProgressRows,
            getReferencedColumn: (t) => t.questCode,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$DailyQuestProgressRowsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.dailyQuestProgressRows,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$DailyQuestCatalogTableTableManager extends RootTableManager<
    _$MoodisleDatabase,
    $DailyQuestCatalogTable,
    DailyQuestCatalogData,
    $$DailyQuestCatalogTableFilterComposer,
    $$DailyQuestCatalogTableOrderingComposer,
    $$DailyQuestCatalogTableAnnotationComposer,
    $$DailyQuestCatalogTableCreateCompanionBuilder,
    $$DailyQuestCatalogTableUpdateCompanionBuilder,
    (DailyQuestCatalogData, $$DailyQuestCatalogTableReferences),
    DailyQuestCatalogData,
    PrefetchHooks Function({bool dailyQuestProgressRowsRefs})> {
  $$DailyQuestCatalogTableTableManager(
      _$MoodisleDatabase db, $DailyQuestCatalogTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyQuestCatalogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyQuestCatalogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyQuestCatalogTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DailyQuestCatalogCompanion(
            code: code,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            Value<int> rowid = const Value.absent(),
          }) =>
              DailyQuestCatalogCompanion.insert(
            code: code,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$DailyQuestCatalogTable, DailyQuestCatalogData>(
                        table),
                    $$DailyQuestCatalogTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({dailyQuestProgressRowsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (dailyQuestProgressRowsRefs) db.dailyQuestProgressRows
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (dailyQuestProgressRowsRefs)
                    await $_getPrefetchedData<DailyQuestCatalogData,
                            $DailyQuestCatalogTable, DailyQuestProgressRow>(
                        currentTable: table,
                        referencedTable: $$DailyQuestCatalogTableReferences
                            ._dailyQuestProgressRowsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DailyQuestCatalogTableReferences(db, table, p0)
                                .dailyQuestProgressRowsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.questCode == item.code),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DailyQuestCatalogTableProcessedTableManager = ProcessedTableManager<
    _$MoodisleDatabase,
    $DailyQuestCatalogTable,
    DailyQuestCatalogData,
    $$DailyQuestCatalogTableFilterComposer,
    $$DailyQuestCatalogTableOrderingComposer,
    $$DailyQuestCatalogTableAnnotationComposer,
    $$DailyQuestCatalogTableCreateCompanionBuilder,
    $$DailyQuestCatalogTableUpdateCompanionBuilder,
    (DailyQuestCatalogData, $$DailyQuestCatalogTableReferences),
    DailyQuestCatalogData,
    PrefetchHooks Function({bool dailyQuestProgressRowsRefs})>;
typedef $$SouvenirCatalogTableCreateCompanionBuilder = SouvenirCatalogCompanion
    Function({
  required String code,
  required bool pendant,
  required int rarity,
  Value<int> rowid,
});
typedef $$SouvenirCatalogTableUpdateCompanionBuilder = SouvenirCatalogCompanion
    Function({
  Value<String> code,
  Value<bool> pendant,
  Value<int> rarity,
  Value<int> rowid,
});

final class $$SouvenirCatalogTableReferences extends BaseReferences<
    _$MoodisleDatabase, $SouvenirCatalogTable, SouvenirCatalogData> {
  $$SouvenirCatalogTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SouvenirInventoryRowsTable,
      List<SouvenirInventoryRow>> _souvenirInventoryRowsRefsTable(
          _$MoodisleDatabase db) =>
      MultiTypedResultKey.fromTable(db.souvenirInventoryRows,
          aliasName:
              'souvenir_catalog__code__souvenir_inventory__souvenir_code');

  $$SouvenirInventoryRowsTableProcessedTableManager
      get souvenirInventoryRowsRefs {
    final manager = $$SouvenirInventoryRowsTableTableManager(
            $_db, $_db.souvenirInventoryRows)
        .filter((f) =>
            f.souvenirCode.code.sqlEquals($_itemColumn<String>('code')!));

    final cache =
        $_typedResult.readTableOrNull(_souvenirInventoryRowsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SocialProfilesTable, List<SocialProfile>>
      _socialProfilesRefsTable(_$MoodisleDatabase db) =>
          MultiTypedResultKey.fromTable(db.socialProfiles,
              aliasName: 'souvenir_catalog__code__social_profiles__pendant');

  $$SocialProfilesTableProcessedTableManager get socialProfilesRefs {
    final manager = $$SocialProfilesTableTableManager($_db, $_db.socialProfiles)
        .filter((f) => f.pendant.code.sqlEquals($_itemColumn<String>('code')!));

    final cache = $_typedResult.readTableOrNull(_socialProfilesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SouvenirCatalogTableFilterComposer
    extends Composer<_$MoodisleDatabase, $SouvenirCatalogTable> {
  $$SouvenirCatalogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get pendant => $composableBuilder(
      column: $table.pendant, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rarity => $composableBuilder(
      column: $table.rarity, builder: (column) => ColumnFilters(column));

  Expression<bool> souvenirInventoryRowsRefs(
      Expression<bool> Function($$SouvenirInventoryRowsTableFilterComposer f)
          f) {
    final $$SouvenirInventoryRowsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.code,
            referencedTable: $db.souvenirInventoryRows,
            getReferencedColumn: (t) => t.souvenirCode,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$SouvenirInventoryRowsTableFilterComposer(
                  $db: $db,
                  $table: $db.souvenirInventoryRows,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> socialProfilesRefs(
      Expression<bool> Function($$SocialProfilesTableFilterComposer f) f) {
    final $$SocialProfilesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.socialProfiles,
        getReferencedColumn: (t) => t.pendant,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SocialProfilesTableFilterComposer(
              $db: $db,
              $table: $db.socialProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SouvenirCatalogTableOrderingComposer
    extends Composer<_$MoodisleDatabase, $SouvenirCatalogTable> {
  $$SouvenirCatalogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get pendant => $composableBuilder(
      column: $table.pendant, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rarity => $composableBuilder(
      column: $table.rarity, builder: (column) => ColumnOrderings(column));
}

class $$SouvenirCatalogTableAnnotationComposer
    extends Composer<_$MoodisleDatabase, $SouvenirCatalogTable> {
  $$SouvenirCatalogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<bool> get pendant =>
      $composableBuilder(column: $table.pendant, builder: (column) => column);

  GeneratedColumn<int> get rarity =>
      $composableBuilder(column: $table.rarity, builder: (column) => column);

  Expression<T> souvenirInventoryRowsRefs<T extends Object>(
      Expression<T> Function($$SouvenirInventoryRowsTableAnnotationComposer a)
          f) {
    final $$SouvenirInventoryRowsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.code,
            referencedTable: $db.souvenirInventoryRows,
            getReferencedColumn: (t) => t.souvenirCode,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$SouvenirInventoryRowsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.souvenirInventoryRows,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> socialProfilesRefs<T extends Object>(
      Expression<T> Function($$SocialProfilesTableAnnotationComposer a) f) {
    final $$SocialProfilesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.code,
        referencedTable: $db.socialProfiles,
        getReferencedColumn: (t) => t.pendant,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SocialProfilesTableAnnotationComposer(
              $db: $db,
              $table: $db.socialProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SouvenirCatalogTableTableManager extends RootTableManager<
    _$MoodisleDatabase,
    $SouvenirCatalogTable,
    SouvenirCatalogData,
    $$SouvenirCatalogTableFilterComposer,
    $$SouvenirCatalogTableOrderingComposer,
    $$SouvenirCatalogTableAnnotationComposer,
    $$SouvenirCatalogTableCreateCompanionBuilder,
    $$SouvenirCatalogTableUpdateCompanionBuilder,
    (SouvenirCatalogData, $$SouvenirCatalogTableReferences),
    SouvenirCatalogData,
    PrefetchHooks Function(
        {bool souvenirInventoryRowsRefs, bool socialProfilesRefs})> {
  $$SouvenirCatalogTableTableManager(
      _$MoodisleDatabase db, $SouvenirCatalogTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SouvenirCatalogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SouvenirCatalogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SouvenirCatalogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<bool> pendant = const Value.absent(),
            Value<int> rarity = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SouvenirCatalogCompanion(
            code: code,
            pendant: pendant,
            rarity: rarity,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            required bool pendant,
            required int rarity,
            Value<int> rowid = const Value.absent(),
          }) =>
              SouvenirCatalogCompanion.insert(
            code: code,
            pendant: pendant,
            rarity: rarity,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SouvenirCatalogTable, SouvenirCatalogData>(
                        table),
                    $$SouvenirCatalogTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {souvenirInventoryRowsRefs = false, socialProfilesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (souvenirInventoryRowsRefs) db.souvenirInventoryRows,
                if (socialProfilesRefs) db.socialProfiles
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (souvenirInventoryRowsRefs)
                    await $_getPrefetchedData<SouvenirCatalogData,
                            $SouvenirCatalogTable, SouvenirInventoryRow>(
                        currentTable: table,
                        referencedTable: $$SouvenirCatalogTableReferences
                            ._souvenirInventoryRowsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SouvenirCatalogTableReferences(db, table, p0)
                                .souvenirInventoryRowsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.souvenirCode == item.code),
                        typedResults: items),
                  if (socialProfilesRefs)
                    await $_getPrefetchedData<SouvenirCatalogData,
                            $SouvenirCatalogTable, SocialProfile>(
                        currentTable: table,
                        referencedTable: $$SouvenirCatalogTableReferences
                            ._socialProfilesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SouvenirCatalogTableReferences(db, table, p0)
                                .socialProfilesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.pendant == item.code),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SouvenirCatalogTableProcessedTableManager = ProcessedTableManager<
    _$MoodisleDatabase,
    $SouvenirCatalogTable,
    SouvenirCatalogData,
    $$SouvenirCatalogTableFilterComposer,
    $$SouvenirCatalogTableOrderingComposer,
    $$SouvenirCatalogTableAnnotationComposer,
    $$SouvenirCatalogTableCreateCompanionBuilder,
    $$SouvenirCatalogTableUpdateCompanionBuilder,
    (SouvenirCatalogData, $$SouvenirCatalogTableReferences),
    SouvenirCatalogData,
    PrefetchHooks Function(
        {bool souvenirInventoryRowsRefs, bool socialProfilesRefs})>;
typedef $$PlayerProfilesTableCreateCompanionBuilder = PlayerProfilesCompanion
    Function({
  Value<int> id,
  required int saveFormatVersion,
  required int nextTaskId,
  required double clearing,
  required int energy,
  required int warmFrontTurns,
  required int tailwindTurns,
  Value<String?> companion,
  required bool onboarded,
  Value<String?> lastReportWeek,
});
typedef $$PlayerProfilesTableUpdateCompanionBuilder = PlayerProfilesCompanion
    Function({
  Value<int> id,
  Value<int> saveFormatVersion,
  Value<int> nextTaskId,
  Value<double> clearing,
  Value<int> energy,
  Value<int> warmFrontTurns,
  Value<int> tailwindTurns,
  Value<String?> companion,
  Value<bool> onboarded,
  Value<String?> lastReportWeek,
});

final class $$PlayerProfilesTableReferences extends BaseReferences<
    _$MoodisleDatabase, $PlayerProfilesTable, PlayerProfile> {
  $$PlayerProfilesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $EmotionCatalogTable _companionTable(_$MoodisleDatabase db) =>
      db.emotionCatalog
          .createAlias('player_profiles__companion__emotion_catalog__code');

  $$EmotionCatalogTableProcessedTableManager? get companion {
    final $_column = $_itemColumn<String>('companion');
    if ($_column == null) return null;
    final manager = $$EmotionCatalogTableTableManager($_db, $_db.emotionCatalog)
        .filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_companionTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PlayerProfilesTableFilterComposer
    extends Composer<_$MoodisleDatabase, $PlayerProfilesTable> {
  $$PlayerProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get saveFormatVersion => $composableBuilder(
      column: $table.saveFormatVersion,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get nextTaskId => $composableBuilder(
      column: $table.nextTaskId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get clearing => $composableBuilder(
      column: $table.clearing, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get energy => $composableBuilder(
      column: $table.energy, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get warmFrontTurns => $composableBuilder(
      column: $table.warmFrontTurns,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tailwindTurns => $composableBuilder(
      column: $table.tailwindTurns, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get onboarded => $composableBuilder(
      column: $table.onboarded, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastReportWeek => $composableBuilder(
      column: $table.lastReportWeek,
      builder: (column) => ColumnFilters(column));

  $$EmotionCatalogTableFilterComposer get companion {
    final $$EmotionCatalogTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.companion,
        referencedTable: $db.emotionCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmotionCatalogTableFilterComposer(
              $db: $db,
              $table: $db.emotionCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlayerProfilesTableOrderingComposer
    extends Composer<_$MoodisleDatabase, $PlayerProfilesTable> {
  $$PlayerProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get saveFormatVersion => $composableBuilder(
      column: $table.saveFormatVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get nextTaskId => $composableBuilder(
      column: $table.nextTaskId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get clearing => $composableBuilder(
      column: $table.clearing, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get energy => $composableBuilder(
      column: $table.energy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get warmFrontTurns => $composableBuilder(
      column: $table.warmFrontTurns,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tailwindTurns => $composableBuilder(
      column: $table.tailwindTurns,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get onboarded => $composableBuilder(
      column: $table.onboarded, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastReportWeek => $composableBuilder(
      column: $table.lastReportWeek,
      builder: (column) => ColumnOrderings(column));

  $$EmotionCatalogTableOrderingComposer get companion {
    final $$EmotionCatalogTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.companion,
        referencedTable: $db.emotionCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmotionCatalogTableOrderingComposer(
              $db: $db,
              $table: $db.emotionCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlayerProfilesTableAnnotationComposer
    extends Composer<_$MoodisleDatabase, $PlayerProfilesTable> {
  $$PlayerProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get saveFormatVersion => $composableBuilder(
      column: $table.saveFormatVersion, builder: (column) => column);

  GeneratedColumn<int> get nextTaskId => $composableBuilder(
      column: $table.nextTaskId, builder: (column) => column);

  GeneratedColumn<double> get clearing =>
      $composableBuilder(column: $table.clearing, builder: (column) => column);

  GeneratedColumn<int> get energy =>
      $composableBuilder(column: $table.energy, builder: (column) => column);

  GeneratedColumn<int> get warmFrontTurns => $composableBuilder(
      column: $table.warmFrontTurns, builder: (column) => column);

  GeneratedColumn<int> get tailwindTurns => $composableBuilder(
      column: $table.tailwindTurns, builder: (column) => column);

  GeneratedColumn<bool> get onboarded =>
      $composableBuilder(column: $table.onboarded, builder: (column) => column);

  GeneratedColumn<String> get lastReportWeek => $composableBuilder(
      column: $table.lastReportWeek, builder: (column) => column);

  $$EmotionCatalogTableAnnotationComposer get companion {
    final $$EmotionCatalogTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.companion,
        referencedTable: $db.emotionCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmotionCatalogTableAnnotationComposer(
              $db: $db,
              $table: $db.emotionCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlayerProfilesTableTableManager extends RootTableManager<
    _$MoodisleDatabase,
    $PlayerProfilesTable,
    PlayerProfile,
    $$PlayerProfilesTableFilterComposer,
    $$PlayerProfilesTableOrderingComposer,
    $$PlayerProfilesTableAnnotationComposer,
    $$PlayerProfilesTableCreateCompanionBuilder,
    $$PlayerProfilesTableUpdateCompanionBuilder,
    (PlayerProfile, $$PlayerProfilesTableReferences),
    PlayerProfile,
    PrefetchHooks Function({bool companion})> {
  $$PlayerProfilesTableTableManager(
      _$MoodisleDatabase db, $PlayerProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayerProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayerProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayerProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> saveFormatVersion = const Value.absent(),
            Value<int> nextTaskId = const Value.absent(),
            Value<double> clearing = const Value.absent(),
            Value<int> energy = const Value.absent(),
            Value<int> warmFrontTurns = const Value.absent(),
            Value<int> tailwindTurns = const Value.absent(),
            Value<String?> companion = const Value.absent(),
            Value<bool> onboarded = const Value.absent(),
            Value<String?> lastReportWeek = const Value.absent(),
          }) =>
              PlayerProfilesCompanion(
            id: id,
            saveFormatVersion: saveFormatVersion,
            nextTaskId: nextTaskId,
            clearing: clearing,
            energy: energy,
            warmFrontTurns: warmFrontTurns,
            tailwindTurns: tailwindTurns,
            companion: companion,
            onboarded: onboarded,
            lastReportWeek: lastReportWeek,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int saveFormatVersion,
            required int nextTaskId,
            required double clearing,
            required int energy,
            required int warmFrontTurns,
            required int tailwindTurns,
            Value<String?> companion = const Value.absent(),
            required bool onboarded,
            Value<String?> lastReportWeek = const Value.absent(),
          }) =>
              PlayerProfilesCompanion.insert(
            id: id,
            saveFormatVersion: saveFormatVersion,
            nextTaskId: nextTaskId,
            clearing: clearing,
            energy: energy,
            warmFrontTurns: warmFrontTurns,
            tailwindTurns: tailwindTurns,
            companion: companion,
            onboarded: onboarded,
            lastReportWeek: lastReportWeek,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$PlayerProfilesTable, PlayerProfile>(table),
                    $$PlayerProfilesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({companion = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (companion) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.companion,
                    referencedTable:
                        $$PlayerProfilesTableReferences._companionTable(db),
                    referencedColumn: $$PlayerProfilesTableReferences
                        ._companionTable(db)
                        .code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PlayerProfilesTableProcessedTableManager = ProcessedTableManager<
    _$MoodisleDatabase,
    $PlayerProfilesTable,
    PlayerProfile,
    $$PlayerProfilesTableFilterComposer,
    $$PlayerProfilesTableOrderingComposer,
    $$PlayerProfilesTableAnnotationComposer,
    $$PlayerProfilesTableCreateCompanionBuilder,
    $$PlayerProfilesTableUpdateCompanionBuilder,
    (PlayerProfile, $$PlayerProfilesTableReferences),
    PlayerProfile,
    PrefetchHooks Function({bool companion})>;
typedef $$TaskRowsTableCreateCompanionBuilder = TaskRowsCompanion Function({
  Value<int> id,
  required int position,
  required String taskText,
  required String emotion,
  required int difficulty,
  required String status,
  required String createdOn,
  required bool pinned,
});
typedef $$TaskRowsTableUpdateCompanionBuilder = TaskRowsCompanion Function({
  Value<int> id,
  Value<int> position,
  Value<String> taskText,
  Value<String> emotion,
  Value<int> difficulty,
  Value<String> status,
  Value<String> createdOn,
  Value<bool> pinned,
});

final class $$TaskRowsTableReferences
    extends BaseReferences<_$MoodisleDatabase, $TaskRowsTable, TaskRow> {
  $$TaskRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EmotionCatalogTable _emotionTable(_$MoodisleDatabase db) =>
      db.emotionCatalog.createAlias('tasks__emotion__emotion_catalog__code');

  $$EmotionCatalogTableProcessedTableManager get emotion {
    final $_column = $_itemColumn<String>('emotion')!;

    final manager = $$EmotionCatalogTableTableManager($_db, $_db.emotionCatalog)
        .filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_emotionTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TaskRowsTableFilterComposer
    extends Composer<_$MoodisleDatabase, $TaskRowsTable> {
  $$TaskRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taskText => $composableBuilder(
      column: $table.taskText, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdOn => $composableBuilder(
      column: $table.createdOn, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get pinned => $composableBuilder(
      column: $table.pinned, builder: (column) => ColumnFilters(column));

  $$EmotionCatalogTableFilterComposer get emotion {
    final $$EmotionCatalogTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.emotion,
        referencedTable: $db.emotionCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmotionCatalogTableFilterComposer(
              $db: $db,
              $table: $db.emotionCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TaskRowsTableOrderingComposer
    extends Composer<_$MoodisleDatabase, $TaskRowsTable> {
  $$TaskRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taskText => $composableBuilder(
      column: $table.taskText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdOn => $composableBuilder(
      column: $table.createdOn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get pinned => $composableBuilder(
      column: $table.pinned, builder: (column) => ColumnOrderings(column));

  $$EmotionCatalogTableOrderingComposer get emotion {
    final $$EmotionCatalogTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.emotion,
        referencedTable: $db.emotionCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmotionCatalogTableOrderingComposer(
              $db: $db,
              $table: $db.emotionCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TaskRowsTableAnnotationComposer
    extends Composer<_$MoodisleDatabase, $TaskRowsTable> {
  $$TaskRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get taskText =>
      $composableBuilder(column: $table.taskText, builder: (column) => column);

  GeneratedColumn<int> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdOn =>
      $composableBuilder(column: $table.createdOn, builder: (column) => column);

  GeneratedColumn<bool> get pinned =>
      $composableBuilder(column: $table.pinned, builder: (column) => column);

  $$EmotionCatalogTableAnnotationComposer get emotion {
    final $$EmotionCatalogTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.emotion,
        referencedTable: $db.emotionCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmotionCatalogTableAnnotationComposer(
              $db: $db,
              $table: $db.emotionCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TaskRowsTableTableManager extends RootTableManager<
    _$MoodisleDatabase,
    $TaskRowsTable,
    TaskRow,
    $$TaskRowsTableFilterComposer,
    $$TaskRowsTableOrderingComposer,
    $$TaskRowsTableAnnotationComposer,
    $$TaskRowsTableCreateCompanionBuilder,
    $$TaskRowsTableUpdateCompanionBuilder,
    (TaskRow, $$TaskRowsTableReferences),
    TaskRow,
    PrefetchHooks Function({bool emotion})> {
  $$TaskRowsTableTableManager(_$MoodisleDatabase db, $TaskRowsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<String> taskText = const Value.absent(),
            Value<String> emotion = const Value.absent(),
            Value<int> difficulty = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> createdOn = const Value.absent(),
            Value<bool> pinned = const Value.absent(),
          }) =>
              TaskRowsCompanion(
            id: id,
            position: position,
            taskText: taskText,
            emotion: emotion,
            difficulty: difficulty,
            status: status,
            createdOn: createdOn,
            pinned: pinned,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int position,
            required String taskText,
            required String emotion,
            required int difficulty,
            required String status,
            required String createdOn,
            required bool pinned,
          }) =>
              TaskRowsCompanion.insert(
            id: id,
            position: position,
            taskText: taskText,
            emotion: emotion,
            difficulty: difficulty,
            status: status,
            createdOn: createdOn,
            pinned: pinned,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$TaskRowsTable, TaskRow>(table),
                    $$TaskRowsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({emotion = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (emotion) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.emotion,
                    referencedTable:
                        $$TaskRowsTableReferences._emotionTable(db),
                    referencedColumn:
                        $$TaskRowsTableReferences._emotionTable(db).code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TaskRowsTableProcessedTableManager = ProcessedTableManager<
    _$MoodisleDatabase,
    $TaskRowsTable,
    TaskRow,
    $$TaskRowsTableFilterComposer,
    $$TaskRowsTableOrderingComposer,
    $$TaskRowsTableAnnotationComposer,
    $$TaskRowsTableCreateCompanionBuilder,
    $$TaskRowsTableUpdateCompanionBuilder,
    (TaskRow, $$TaskRowsTableReferences),
    TaskRow,
    PrefetchHooks Function({bool emotion})>;
typedef $$PetRecordsTableCreateCompanionBuilder = PetRecordsCompanion Function({
  required String emotion,
  required int count,
  Value<String?> branch,
  required int bondMinutes,
  Value<int> rowid,
});
typedef $$PetRecordsTableUpdateCompanionBuilder = PetRecordsCompanion Function({
  Value<String> emotion,
  Value<int> count,
  Value<String?> branch,
  Value<int> bondMinutes,
  Value<int> rowid,
});

final class $$PetRecordsTableReferences
    extends BaseReferences<_$MoodisleDatabase, $PetRecordsTable, DbPetRecord> {
  $$PetRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EmotionCatalogTable _emotionTable(_$MoodisleDatabase db) =>
      db.emotionCatalog
          .createAlias('pet_records__emotion__emotion_catalog__code');

  $$EmotionCatalogTableProcessedTableManager get emotion {
    final $_column = $_itemColumn<String>('emotion')!;

    final manager = $$EmotionCatalogTableTableManager($_db, $_db.emotionCatalog)
        .filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_emotionTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PetRecordsTableFilterComposer
    extends Composer<_$MoodisleDatabase, $PetRecordsTable> {
  $$PetRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get count => $composableBuilder(
      column: $table.count, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get branch => $composableBuilder(
      column: $table.branch, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bondMinutes => $composableBuilder(
      column: $table.bondMinutes, builder: (column) => ColumnFilters(column));

  $$EmotionCatalogTableFilterComposer get emotion {
    final $$EmotionCatalogTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.emotion,
        referencedTable: $db.emotionCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmotionCatalogTableFilterComposer(
              $db: $db,
              $table: $db.emotionCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PetRecordsTableOrderingComposer
    extends Composer<_$MoodisleDatabase, $PetRecordsTable> {
  $$PetRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get count => $composableBuilder(
      column: $table.count, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get branch => $composableBuilder(
      column: $table.branch, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bondMinutes => $composableBuilder(
      column: $table.bondMinutes, builder: (column) => ColumnOrderings(column));

  $$EmotionCatalogTableOrderingComposer get emotion {
    final $$EmotionCatalogTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.emotion,
        referencedTable: $db.emotionCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmotionCatalogTableOrderingComposer(
              $db: $db,
              $table: $db.emotionCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PetRecordsTableAnnotationComposer
    extends Composer<_$MoodisleDatabase, $PetRecordsTable> {
  $$PetRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<String> get branch =>
      $composableBuilder(column: $table.branch, builder: (column) => column);

  GeneratedColumn<int> get bondMinutes => $composableBuilder(
      column: $table.bondMinutes, builder: (column) => column);

  $$EmotionCatalogTableAnnotationComposer get emotion {
    final $$EmotionCatalogTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.emotion,
        referencedTable: $db.emotionCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmotionCatalogTableAnnotationComposer(
              $db: $db,
              $table: $db.emotionCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PetRecordsTableTableManager extends RootTableManager<
    _$MoodisleDatabase,
    $PetRecordsTable,
    DbPetRecord,
    $$PetRecordsTableFilterComposer,
    $$PetRecordsTableOrderingComposer,
    $$PetRecordsTableAnnotationComposer,
    $$PetRecordsTableCreateCompanionBuilder,
    $$PetRecordsTableUpdateCompanionBuilder,
    (DbPetRecord, $$PetRecordsTableReferences),
    DbPetRecord,
    PrefetchHooks Function({bool emotion})> {
  $$PetRecordsTableTableManager(_$MoodisleDatabase db, $PetRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PetRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PetRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PetRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> emotion = const Value.absent(),
            Value<int> count = const Value.absent(),
            Value<String?> branch = const Value.absent(),
            Value<int> bondMinutes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PetRecordsCompanion(
            emotion: emotion,
            count: count,
            branch: branch,
            bondMinutes: bondMinutes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String emotion,
            required int count,
            Value<String?> branch = const Value.absent(),
            required int bondMinutes,
            Value<int> rowid = const Value.absent(),
          }) =>
              PetRecordsCompanion.insert(
            emotion: emotion,
            count: count,
            branch: branch,
            bondMinutes: bondMinutes,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$PetRecordsTable, DbPetRecord>(table),
                    $$PetRecordsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({emotion = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (emotion) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.emotion,
                    referencedTable:
                        $$PetRecordsTableReferences._emotionTable(db),
                    referencedColumn:
                        $$PetRecordsTableReferences._emotionTable(db).code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PetRecordsTableProcessedTableManager = ProcessedTableManager<
    _$MoodisleDatabase,
    $PetRecordsTable,
    DbPetRecord,
    $$PetRecordsTableFilterComposer,
    $$PetRecordsTableOrderingComposer,
    $$PetRecordsTableAnnotationComposer,
    $$PetRecordsTableCreateCompanionBuilder,
    $$PetRecordsTableUpdateCompanionBuilder,
    (DbPetRecord, $$PetRecordsTableReferences),
    DbPetRecord,
    PrefetchHooks Function({bool emotion})>;
typedef $$InventoryRowsTableCreateCompanionBuilder = InventoryRowsCompanion
    Function({
  required String itemCode,
  required int quantity,
  Value<int> rowid,
});
typedef $$InventoryRowsTableUpdateCompanionBuilder = InventoryRowsCompanion
    Function({
  Value<String> itemCode,
  Value<int> quantity,
  Value<int> rowid,
});

final class $$InventoryRowsTableReferences extends BaseReferences<
    _$MoodisleDatabase, $InventoryRowsTable, InventoryRow> {
  $$InventoryRowsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ItemCatalogTable _itemCodeTable(_$MoodisleDatabase db) =>
      db.itemCatalog.createAlias('inventory__item_code__item_catalog__code');

  $$ItemCatalogTableProcessedTableManager get itemCode {
    final $_column = $_itemColumn<String>('item_code')!;

    final manager = $$ItemCatalogTableTableManager($_db, $_db.itemCatalog)
        .filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$InventoryRowsTableFilterComposer
    extends Composer<_$MoodisleDatabase, $InventoryRowsTable> {
  $$InventoryRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  $$ItemCatalogTableFilterComposer get itemCode {
    final $$ItemCatalogTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemCode,
        referencedTable: $db.itemCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemCatalogTableFilterComposer(
              $db: $db,
              $table: $db.itemCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InventoryRowsTableOrderingComposer
    extends Composer<_$MoodisleDatabase, $InventoryRowsTable> {
  $$InventoryRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  $$ItemCatalogTableOrderingComposer get itemCode {
    final $$ItemCatalogTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemCode,
        referencedTable: $db.itemCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemCatalogTableOrderingComposer(
              $db: $db,
              $table: $db.itemCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InventoryRowsTableAnnotationComposer
    extends Composer<_$MoodisleDatabase, $InventoryRowsTable> {
  $$InventoryRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  $$ItemCatalogTableAnnotationComposer get itemCode {
    final $$ItemCatalogTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemCode,
        referencedTable: $db.itemCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemCatalogTableAnnotationComposer(
              $db: $db,
              $table: $db.itemCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InventoryRowsTableTableManager extends RootTableManager<
    _$MoodisleDatabase,
    $InventoryRowsTable,
    InventoryRow,
    $$InventoryRowsTableFilterComposer,
    $$InventoryRowsTableOrderingComposer,
    $$InventoryRowsTableAnnotationComposer,
    $$InventoryRowsTableCreateCompanionBuilder,
    $$InventoryRowsTableUpdateCompanionBuilder,
    (InventoryRow, $$InventoryRowsTableReferences),
    InventoryRow,
    PrefetchHooks Function({bool itemCode})> {
  $$InventoryRowsTableTableManager(
      _$MoodisleDatabase db, $InventoryRowsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoryRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> itemCode = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InventoryRowsCompanion(
            itemCode: itemCode,
            quantity: quantity,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String itemCode,
            required int quantity,
            Value<int> rowid = const Value.absent(),
          }) =>
              InventoryRowsCompanion.insert(
            itemCode: itemCode,
            quantity: quantity,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$InventoryRowsTable, InventoryRow>(table),
                    $$InventoryRowsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({itemCode = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (itemCode) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.itemCode,
                    referencedTable:
                        $$InventoryRowsTableReferences._itemCodeTable(db),
                    referencedColumn:
                        $$InventoryRowsTableReferences._itemCodeTable(db).code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$InventoryRowsTableProcessedTableManager = ProcessedTableManager<
    _$MoodisleDatabase,
    $InventoryRowsTable,
    InventoryRow,
    $$InventoryRowsTableFilterComposer,
    $$InventoryRowsTableOrderingComposer,
    $$InventoryRowsTableAnnotationComposer,
    $$InventoryRowsTableCreateCompanionBuilder,
    $$InventoryRowsTableUpdateCompanionBuilder,
    (InventoryRow, $$InventoryRowsTableReferences),
    InventoryRow,
    PrefetchHooks Function({bool itemCode})>;
typedef $$GameStatisticsTableCreateCompanionBuilder = GameStatisticsCompanion
    Function({
  Value<int> id,
  required int totalDone,
  required int totalFocusSessions,
  required int totalFocusMinutes,
  required int mazeRuns,
  required int mistDewCollected,
  required int deepDives,
});
typedef $$GameStatisticsTableUpdateCompanionBuilder = GameStatisticsCompanion
    Function({
  Value<int> id,
  Value<int> totalDone,
  Value<int> totalFocusSessions,
  Value<int> totalFocusMinutes,
  Value<int> mazeRuns,
  Value<int> mistDewCollected,
  Value<int> deepDives,
});

class $$GameStatisticsTableFilterComposer
    extends Composer<_$MoodisleDatabase, $GameStatisticsTable> {
  $$GameStatisticsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalDone => $composableBuilder(
      column: $table.totalDone, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalFocusSessions => $composableBuilder(
      column: $table.totalFocusSessions,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalFocusMinutes => $composableBuilder(
      column: $table.totalFocusMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get mazeRuns => $composableBuilder(
      column: $table.mazeRuns, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get mistDewCollected => $composableBuilder(
      column: $table.mistDewCollected,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deepDives => $composableBuilder(
      column: $table.deepDives, builder: (column) => ColumnFilters(column));
}

class $$GameStatisticsTableOrderingComposer
    extends Composer<_$MoodisleDatabase, $GameStatisticsTable> {
  $$GameStatisticsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalDone => $composableBuilder(
      column: $table.totalDone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalFocusSessions => $composableBuilder(
      column: $table.totalFocusSessions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalFocusMinutes => $composableBuilder(
      column: $table.totalFocusMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get mazeRuns => $composableBuilder(
      column: $table.mazeRuns, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get mistDewCollected => $composableBuilder(
      column: $table.mistDewCollected,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deepDives => $composableBuilder(
      column: $table.deepDives, builder: (column) => ColumnOrderings(column));
}

class $$GameStatisticsTableAnnotationComposer
    extends Composer<_$MoodisleDatabase, $GameStatisticsTable> {
  $$GameStatisticsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get totalDone =>
      $composableBuilder(column: $table.totalDone, builder: (column) => column);

  GeneratedColumn<int> get totalFocusSessions => $composableBuilder(
      column: $table.totalFocusSessions, builder: (column) => column);

  GeneratedColumn<int> get totalFocusMinutes => $composableBuilder(
      column: $table.totalFocusMinutes, builder: (column) => column);

  GeneratedColumn<int> get mazeRuns =>
      $composableBuilder(column: $table.mazeRuns, builder: (column) => column);

  GeneratedColumn<int> get mistDewCollected => $composableBuilder(
      column: $table.mistDewCollected, builder: (column) => column);

  GeneratedColumn<int> get deepDives =>
      $composableBuilder(column: $table.deepDives, builder: (column) => column);
}

class $$GameStatisticsTableTableManager extends RootTableManager<
    _$MoodisleDatabase,
    $GameStatisticsTable,
    GameStatistic,
    $$GameStatisticsTableFilterComposer,
    $$GameStatisticsTableOrderingComposer,
    $$GameStatisticsTableAnnotationComposer,
    $$GameStatisticsTableCreateCompanionBuilder,
    $$GameStatisticsTableUpdateCompanionBuilder,
    (
      GameStatistic,
      BaseReferences<_$MoodisleDatabase, $GameStatisticsTable, GameStatistic>
    ),
    GameStatistic,
    PrefetchHooks Function()> {
  $$GameStatisticsTableTableManager(
      _$MoodisleDatabase db, $GameStatisticsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GameStatisticsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GameStatisticsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GameStatisticsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> totalDone = const Value.absent(),
            Value<int> totalFocusSessions = const Value.absent(),
            Value<int> totalFocusMinutes = const Value.absent(),
            Value<int> mazeRuns = const Value.absent(),
            Value<int> mistDewCollected = const Value.absent(),
            Value<int> deepDives = const Value.absent(),
          }) =>
              GameStatisticsCompanion(
            id: id,
            totalDone: totalDone,
            totalFocusSessions: totalFocusSessions,
            totalFocusMinutes: totalFocusMinutes,
            mazeRuns: mazeRuns,
            mistDewCollected: mistDewCollected,
            deepDives: deepDives,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int totalDone,
            required int totalFocusSessions,
            required int totalFocusMinutes,
            required int mazeRuns,
            required int mistDewCollected,
            required int deepDives,
          }) =>
              GameStatisticsCompanion.insert(
            id: id,
            totalDone: totalDone,
            totalFocusSessions: totalFocusSessions,
            totalFocusMinutes: totalFocusMinutes,
            mazeRuns: mazeRuns,
            mistDewCollected: mistDewCollected,
            deepDives: deepDives,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$GameStatisticsTable, GameStatistic>(table),
                    BaseReferences<_$MoodisleDatabase, $GameStatisticsTable,
                        GameStatistic>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GameStatisticsTableProcessedTableManager = ProcessedTableManager<
    _$MoodisleDatabase,
    $GameStatisticsTable,
    GameStatistic,
    $$GameStatisticsTableFilterComposer,
    $$GameStatisticsTableOrderingComposer,
    $$GameStatisticsTableAnnotationComposer,
    $$GameStatisticsTableCreateCompanionBuilder,
    $$GameStatisticsTableUpdateCompanionBuilder,
    (
      GameStatistic,
      BaseReferences<_$MoodisleDatabase, $GameStatisticsTable, GameStatistic>
    ),
    GameStatistic,
    PrefetchHooks Function()>;
typedef $$StreakStatesTableCreateCompanionBuilder = StreakStatesCompanion
    Function({
  Value<int> id,
  required int sunnyDays,
  Value<String?> lastSunny,
});
typedef $$StreakStatesTableUpdateCompanionBuilder = StreakStatesCompanion
    Function({
  Value<int> id,
  Value<int> sunnyDays,
  Value<String?> lastSunny,
});

class $$StreakStatesTableFilterComposer
    extends Composer<_$MoodisleDatabase, $StreakStatesTable> {
  $$StreakStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sunnyDays => $composableBuilder(
      column: $table.sunnyDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastSunny => $composableBuilder(
      column: $table.lastSunny, builder: (column) => ColumnFilters(column));
}

class $$StreakStatesTableOrderingComposer
    extends Composer<_$MoodisleDatabase, $StreakStatesTable> {
  $$StreakStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sunnyDays => $composableBuilder(
      column: $table.sunnyDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastSunny => $composableBuilder(
      column: $table.lastSunny, builder: (column) => ColumnOrderings(column));
}

class $$StreakStatesTableAnnotationComposer
    extends Composer<_$MoodisleDatabase, $StreakStatesTable> {
  $$StreakStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sunnyDays =>
      $composableBuilder(column: $table.sunnyDays, builder: (column) => column);

  GeneratedColumn<String> get lastSunny =>
      $composableBuilder(column: $table.lastSunny, builder: (column) => column);
}

class $$StreakStatesTableTableManager extends RootTableManager<
    _$MoodisleDatabase,
    $StreakStatesTable,
    StreakState,
    $$StreakStatesTableFilterComposer,
    $$StreakStatesTableOrderingComposer,
    $$StreakStatesTableAnnotationComposer,
    $$StreakStatesTableCreateCompanionBuilder,
    $$StreakStatesTableUpdateCompanionBuilder,
    (
      StreakState,
      BaseReferences<_$MoodisleDatabase, $StreakStatesTable, StreakState>
    ),
    StreakState,
    PrefetchHooks Function()> {
  $$StreakStatesTableTableManager(
      _$MoodisleDatabase db, $StreakStatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StreakStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StreakStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StreakStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> sunnyDays = const Value.absent(),
            Value<String?> lastSunny = const Value.absent(),
          }) =>
              StreakStatesCompanion(
            id: id,
            sunnyDays: sunnyDays,
            lastSunny: lastSunny,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int sunnyDays,
            Value<String?> lastSunny = const Value.absent(),
          }) =>
              StreakStatesCompanion.insert(
            id: id,
            sunnyDays: sunnyDays,
            lastSunny: lastSunny,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$StreakStatesTable, StreakState>(table),
                    BaseReferences<_$MoodisleDatabase, $StreakStatesTable,
                        StreakState>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StreakStatesTableProcessedTableManager = ProcessedTableManager<
    _$MoodisleDatabase,
    $StreakStatesTable,
    StreakState,
    $$StreakStatesTableFilterComposer,
    $$StreakStatesTableOrderingComposer,
    $$StreakStatesTableAnnotationComposer,
    $$StreakStatesTableCreateCompanionBuilder,
    $$StreakStatesTableUpdateCompanionBuilder,
    (
      StreakState,
      BaseReferences<_$MoodisleDatabase, $StreakStatesTable, StreakState>
    ),
    StreakState,
    PrefetchHooks Function()>;
typedef $$KeeperStatesTableCreateCompanionBuilder = KeeperStatesCompanion
    Function({
  Value<int> id,
  required int level,
  required int exp,
});
typedef $$KeeperStatesTableUpdateCompanionBuilder = KeeperStatesCompanion
    Function({
  Value<int> id,
  Value<int> level,
  Value<int> exp,
});

class $$KeeperStatesTableFilterComposer
    extends Composer<_$MoodisleDatabase, $KeeperStatesTable> {
  $$KeeperStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get exp => $composableBuilder(
      column: $table.exp, builder: (column) => ColumnFilters(column));
}

class $$KeeperStatesTableOrderingComposer
    extends Composer<_$MoodisleDatabase, $KeeperStatesTable> {
  $$KeeperStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get exp => $composableBuilder(
      column: $table.exp, builder: (column) => ColumnOrderings(column));
}

class $$KeeperStatesTableAnnotationComposer
    extends Composer<_$MoodisleDatabase, $KeeperStatesTable> {
  $$KeeperStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get exp =>
      $composableBuilder(column: $table.exp, builder: (column) => column);
}

class $$KeeperStatesTableTableManager extends RootTableManager<
    _$MoodisleDatabase,
    $KeeperStatesTable,
    KeeperState,
    $$KeeperStatesTableFilterComposer,
    $$KeeperStatesTableOrderingComposer,
    $$KeeperStatesTableAnnotationComposer,
    $$KeeperStatesTableCreateCompanionBuilder,
    $$KeeperStatesTableUpdateCompanionBuilder,
    (
      KeeperState,
      BaseReferences<_$MoodisleDatabase, $KeeperStatesTable, KeeperState>
    ),
    KeeperState,
    PrefetchHooks Function()> {
  $$KeeperStatesTableTableManager(
      _$MoodisleDatabase db, $KeeperStatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KeeperStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KeeperStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KeeperStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> level = const Value.absent(),
            Value<int> exp = const Value.absent(),
          }) =>
              KeeperStatesCompanion(
            id: id,
            level: level,
            exp: exp,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int level,
            required int exp,
          }) =>
              KeeperStatesCompanion.insert(
            id: id,
            level: level,
            exp: exp,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$KeeperStatesTable, KeeperState>(table),
                    BaseReferences<_$MoodisleDatabase, $KeeperStatesTable,
                        KeeperState>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$KeeperStatesTableProcessedTableManager = ProcessedTableManager<
    _$MoodisleDatabase,
    $KeeperStatesTable,
    KeeperState,
    $$KeeperStatesTableFilterComposer,
    $$KeeperStatesTableOrderingComposer,
    $$KeeperStatesTableAnnotationComposer,
    $$KeeperStatesTableCreateCompanionBuilder,
    $$KeeperStatesTableUpdateCompanionBuilder,
    (
      KeeperState,
      BaseReferences<_$MoodisleDatabase, $KeeperStatesTable, KeeperState>
    ),
    KeeperState,
    PrefetchHooks Function()>;
typedef $$ResonanceStatesTableCreateCompanionBuilder = ResonanceStatesCompanion
    Function({
  Value<int> id,
  Value<String?> lastEmotion,
  required int length,
  required int best,
  Value<int?> lastAtMs,
});
typedef $$ResonanceStatesTableUpdateCompanionBuilder = ResonanceStatesCompanion
    Function({
  Value<int> id,
  Value<String?> lastEmotion,
  Value<int> length,
  Value<int> best,
  Value<int?> lastAtMs,
});

final class $$ResonanceStatesTableReferences extends BaseReferences<
    _$MoodisleDatabase, $ResonanceStatesTable, ResonanceState> {
  $$ResonanceStatesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $EmotionCatalogTable _lastEmotionTable(_$MoodisleDatabase db) =>
      db.emotionCatalog
          .createAlias('resonance_states__last_emotion__emotion_catalog__code');

  $$EmotionCatalogTableProcessedTableManager? get lastEmotion {
    final $_column = $_itemColumn<String>('last_emotion');
    if ($_column == null) return null;
    final manager = $$EmotionCatalogTableTableManager($_db, $_db.emotionCatalog)
        .filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lastEmotionTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ResonanceStatesTableFilterComposer
    extends Composer<_$MoodisleDatabase, $ResonanceStatesTable> {
  $$ResonanceStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get length => $composableBuilder(
      column: $table.length, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get best => $composableBuilder(
      column: $table.best, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastAtMs => $composableBuilder(
      column: $table.lastAtMs, builder: (column) => ColumnFilters(column));

  $$EmotionCatalogTableFilterComposer get lastEmotion {
    final $$EmotionCatalogTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lastEmotion,
        referencedTable: $db.emotionCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmotionCatalogTableFilterComposer(
              $db: $db,
              $table: $db.emotionCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ResonanceStatesTableOrderingComposer
    extends Composer<_$MoodisleDatabase, $ResonanceStatesTable> {
  $$ResonanceStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get length => $composableBuilder(
      column: $table.length, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get best => $composableBuilder(
      column: $table.best, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastAtMs => $composableBuilder(
      column: $table.lastAtMs, builder: (column) => ColumnOrderings(column));

  $$EmotionCatalogTableOrderingComposer get lastEmotion {
    final $$EmotionCatalogTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lastEmotion,
        referencedTable: $db.emotionCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmotionCatalogTableOrderingComposer(
              $db: $db,
              $table: $db.emotionCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ResonanceStatesTableAnnotationComposer
    extends Composer<_$MoodisleDatabase, $ResonanceStatesTable> {
  $$ResonanceStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get length =>
      $composableBuilder(column: $table.length, builder: (column) => column);

  GeneratedColumn<int> get best =>
      $composableBuilder(column: $table.best, builder: (column) => column);

  GeneratedColumn<int> get lastAtMs =>
      $composableBuilder(column: $table.lastAtMs, builder: (column) => column);

  $$EmotionCatalogTableAnnotationComposer get lastEmotion {
    final $$EmotionCatalogTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.lastEmotion,
        referencedTable: $db.emotionCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmotionCatalogTableAnnotationComposer(
              $db: $db,
              $table: $db.emotionCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ResonanceStatesTableTableManager extends RootTableManager<
    _$MoodisleDatabase,
    $ResonanceStatesTable,
    ResonanceState,
    $$ResonanceStatesTableFilterComposer,
    $$ResonanceStatesTableOrderingComposer,
    $$ResonanceStatesTableAnnotationComposer,
    $$ResonanceStatesTableCreateCompanionBuilder,
    $$ResonanceStatesTableUpdateCompanionBuilder,
    (ResonanceState, $$ResonanceStatesTableReferences),
    ResonanceState,
    PrefetchHooks Function({bool lastEmotion})> {
  $$ResonanceStatesTableTableManager(
      _$MoodisleDatabase db, $ResonanceStatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ResonanceStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ResonanceStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ResonanceStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> lastEmotion = const Value.absent(),
            Value<int> length = const Value.absent(),
            Value<int> best = const Value.absent(),
            Value<int?> lastAtMs = const Value.absent(),
          }) =>
              ResonanceStatesCompanion(
            id: id,
            lastEmotion: lastEmotion,
            length: length,
            best: best,
            lastAtMs: lastAtMs,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> lastEmotion = const Value.absent(),
            required int length,
            required int best,
            Value<int?> lastAtMs = const Value.absent(),
          }) =>
              ResonanceStatesCompanion.insert(
            id: id,
            lastEmotion: lastEmotion,
            length: length,
            best: best,
            lastAtMs: lastAtMs,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ResonanceStatesTable, ResonanceState>(table),
                    $$ResonanceStatesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({lastEmotion = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (lastEmotion) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.lastEmotion,
                    referencedTable:
                        $$ResonanceStatesTableReferences._lastEmotionTable(db),
                    referencedColumn: $$ResonanceStatesTableReferences
                        ._lastEmotionTable(db)
                        .code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ResonanceStatesTableProcessedTableManager = ProcessedTableManager<
    _$MoodisleDatabase,
    $ResonanceStatesTable,
    ResonanceState,
    $$ResonanceStatesTableFilterComposer,
    $$ResonanceStatesTableOrderingComposer,
    $$ResonanceStatesTableAnnotationComposer,
    $$ResonanceStatesTableCreateCompanionBuilder,
    $$ResonanceStatesTableUpdateCompanionBuilder,
    (ResonanceState, $$ResonanceStatesTableReferences),
    ResonanceState,
    PrefetchHooks Function({bool lastEmotion})>;
typedef $$ClimateStatesTableCreateCompanionBuilder = ClimateStatesCompanion
    Function({
  Value<int> id,
  required double fog,
  required String tier,
  required int tierHoldDays,
  required int zeroDoneStreak,
});
typedef $$ClimateStatesTableUpdateCompanionBuilder = ClimateStatesCompanion
    Function({
  Value<int> id,
  Value<double> fog,
  Value<String> tier,
  Value<int> tierHoldDays,
  Value<int> zeroDoneStreak,
});

class $$ClimateStatesTableFilterComposer
    extends Composer<_$MoodisleDatabase, $ClimateStatesTable> {
  $$ClimateStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fog => $composableBuilder(
      column: $table.fog, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tier => $composableBuilder(
      column: $table.tier, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tierHoldDays => $composableBuilder(
      column: $table.tierHoldDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get zeroDoneStreak => $composableBuilder(
      column: $table.zeroDoneStreak,
      builder: (column) => ColumnFilters(column));
}

class $$ClimateStatesTableOrderingComposer
    extends Composer<_$MoodisleDatabase, $ClimateStatesTable> {
  $$ClimateStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fog => $composableBuilder(
      column: $table.fog, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tier => $composableBuilder(
      column: $table.tier, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tierHoldDays => $composableBuilder(
      column: $table.tierHoldDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get zeroDoneStreak => $composableBuilder(
      column: $table.zeroDoneStreak,
      builder: (column) => ColumnOrderings(column));
}

class $$ClimateStatesTableAnnotationComposer
    extends Composer<_$MoodisleDatabase, $ClimateStatesTable> {
  $$ClimateStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get fog =>
      $composableBuilder(column: $table.fog, builder: (column) => column);

  GeneratedColumn<String> get tier =>
      $composableBuilder(column: $table.tier, builder: (column) => column);

  GeneratedColumn<int> get tierHoldDays => $composableBuilder(
      column: $table.tierHoldDays, builder: (column) => column);

  GeneratedColumn<int> get zeroDoneStreak => $composableBuilder(
      column: $table.zeroDoneStreak, builder: (column) => column);
}

class $$ClimateStatesTableTableManager extends RootTableManager<
    _$MoodisleDatabase,
    $ClimateStatesTable,
    ClimateState,
    $$ClimateStatesTableFilterComposer,
    $$ClimateStatesTableOrderingComposer,
    $$ClimateStatesTableAnnotationComposer,
    $$ClimateStatesTableCreateCompanionBuilder,
    $$ClimateStatesTableUpdateCompanionBuilder,
    (
      ClimateState,
      BaseReferences<_$MoodisleDatabase, $ClimateStatesTable, ClimateState>
    ),
    ClimateState,
    PrefetchHooks Function()> {
  $$ClimateStatesTableTableManager(
      _$MoodisleDatabase db, $ClimateStatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClimateStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClimateStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClimateStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> fog = const Value.absent(),
            Value<String> tier = const Value.absent(),
            Value<int> tierHoldDays = const Value.absent(),
            Value<int> zeroDoneStreak = const Value.absent(),
          }) =>
              ClimateStatesCompanion(
            id: id,
            fog: fog,
            tier: tier,
            tierHoldDays: tierHoldDays,
            zeroDoneStreak: zeroDoneStreak,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required double fog,
            required String tier,
            required int tierHoldDays,
            required int zeroDoneStreak,
          }) =>
              ClimateStatesCompanion.insert(
            id: id,
            fog: fog,
            tier: tier,
            tierHoldDays: tierHoldDays,
            zeroDoneStreak: zeroDoneStreak,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ClimateStatesTable, ClimateState>(table),
                    BaseReferences<_$MoodisleDatabase, $ClimateStatesTable,
                        ClimateState>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ClimateStatesTableProcessedTableManager = ProcessedTableManager<
    _$MoodisleDatabase,
    $ClimateStatesTable,
    ClimateState,
    $$ClimateStatesTableFilterComposer,
    $$ClimateStatesTableOrderingComposer,
    $$ClimateStatesTableAnnotationComposer,
    $$ClimateStatesTableCreateCompanionBuilder,
    $$ClimateStatesTableUpdateCompanionBuilder,
    (
      ClimateState,
      BaseReferences<_$MoodisleDatabase, $ClimateStatesTable, ClimateState>
    ),
    ClimateState,
    PrefetchHooks Function()>;
typedef $$ClimateDaysTableCreateCompanionBuilder = ClimateDaysCompanion
    Function({
  required String date,
  required int done,
  required int focusMinutes,
  Value<int> rowid,
});
typedef $$ClimateDaysTableUpdateCompanionBuilder = ClimateDaysCompanion
    Function({
  Value<String> date,
  Value<int> done,
  Value<int> focusMinutes,
  Value<int> rowid,
});

class $$ClimateDaysTableFilterComposer
    extends Composer<_$MoodisleDatabase, $ClimateDaysTable> {
  $$ClimateDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get done => $composableBuilder(
      column: $table.done, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get focusMinutes => $composableBuilder(
      column: $table.focusMinutes, builder: (column) => ColumnFilters(column));
}

class $$ClimateDaysTableOrderingComposer
    extends Composer<_$MoodisleDatabase, $ClimateDaysTable> {
  $$ClimateDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get done => $composableBuilder(
      column: $table.done, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get focusMinutes => $composableBuilder(
      column: $table.focusMinutes,
      builder: (column) => ColumnOrderings(column));
}

class $$ClimateDaysTableAnnotationComposer
    extends Composer<_$MoodisleDatabase, $ClimateDaysTable> {
  $$ClimateDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  GeneratedColumn<int> get focusMinutes => $composableBuilder(
      column: $table.focusMinutes, builder: (column) => column);
}

class $$ClimateDaysTableTableManager extends RootTableManager<
    _$MoodisleDatabase,
    $ClimateDaysTable,
    ClimateDay,
    $$ClimateDaysTableFilterComposer,
    $$ClimateDaysTableOrderingComposer,
    $$ClimateDaysTableAnnotationComposer,
    $$ClimateDaysTableCreateCompanionBuilder,
    $$ClimateDaysTableUpdateCompanionBuilder,
    (
      ClimateDay,
      BaseReferences<_$MoodisleDatabase, $ClimateDaysTable, ClimateDay>
    ),
    ClimateDay,
    PrefetchHooks Function()> {
  $$ClimateDaysTableTableManager(_$MoodisleDatabase db, $ClimateDaysTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClimateDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClimateDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClimateDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> date = const Value.absent(),
            Value<int> done = const Value.absent(),
            Value<int> focusMinutes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ClimateDaysCompanion(
            date: date,
            done: done,
            focusMinutes: focusMinutes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String date,
            required int done,
            required int focusMinutes,
            Value<int> rowid = const Value.absent(),
          }) =>
              ClimateDaysCompanion.insert(
            date: date,
            done: done,
            focusMinutes: focusMinutes,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ClimateDaysTable, ClimateDay>(table),
                    BaseReferences<_$MoodisleDatabase, $ClimateDaysTable,
                        ClimateDay>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ClimateDaysTableProcessedTableManager = ProcessedTableManager<
    _$MoodisleDatabase,
    $ClimateDaysTable,
    ClimateDay,
    $$ClimateDaysTableFilterComposer,
    $$ClimateDaysTableOrderingComposer,
    $$ClimateDaysTableAnnotationComposer,
    $$ClimateDaysTableCreateCompanionBuilder,
    $$ClimateDaysTableUpdateCompanionBuilder,
    (
      ClimateDay,
      BaseReferences<_$MoodisleDatabase, $ClimateDaysTable, ClimateDay>
    ),
    ClimateDay,
    PrefetchHooks Function()>;
typedef $$FocusMetadataTableCreateCompanionBuilder = FocusMetadataCompanion
    Function({
  Value<int> id,
  required int todayMinutes,
  required int weekMinutes,
  Value<String?> weekStart,
  required int glancesToday,
});
typedef $$FocusMetadataTableUpdateCompanionBuilder = FocusMetadataCompanion
    Function({
  Value<int> id,
  Value<int> todayMinutes,
  Value<int> weekMinutes,
  Value<String?> weekStart,
  Value<int> glancesToday,
});

class $$FocusMetadataTableFilterComposer
    extends Composer<_$MoodisleDatabase, $FocusMetadataTable> {
  $$FocusMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get todayMinutes => $composableBuilder(
      column: $table.todayMinutes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weekMinutes => $composableBuilder(
      column: $table.weekMinutes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get weekStart => $composableBuilder(
      column: $table.weekStart, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get glancesToday => $composableBuilder(
      column: $table.glancesToday, builder: (column) => ColumnFilters(column));
}

class $$FocusMetadataTableOrderingComposer
    extends Composer<_$MoodisleDatabase, $FocusMetadataTable> {
  $$FocusMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get todayMinutes => $composableBuilder(
      column: $table.todayMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weekMinutes => $composableBuilder(
      column: $table.weekMinutes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get weekStart => $composableBuilder(
      column: $table.weekStart, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get glancesToday => $composableBuilder(
      column: $table.glancesToday,
      builder: (column) => ColumnOrderings(column));
}

class $$FocusMetadataTableAnnotationComposer
    extends Composer<_$MoodisleDatabase, $FocusMetadataTable> {
  $$FocusMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get todayMinutes => $composableBuilder(
      column: $table.todayMinutes, builder: (column) => column);

  GeneratedColumn<int> get weekMinutes => $composableBuilder(
      column: $table.weekMinutes, builder: (column) => column);

  GeneratedColumn<String> get weekStart =>
      $composableBuilder(column: $table.weekStart, builder: (column) => column);

  GeneratedColumn<int> get glancesToday => $composableBuilder(
      column: $table.glancesToday, builder: (column) => column);
}

class $$FocusMetadataTableTableManager extends RootTableManager<
    _$MoodisleDatabase,
    $FocusMetadataTable,
    FocusMetadataData,
    $$FocusMetadataTableFilterComposer,
    $$FocusMetadataTableOrderingComposer,
    $$FocusMetadataTableAnnotationComposer,
    $$FocusMetadataTableCreateCompanionBuilder,
    $$FocusMetadataTableUpdateCompanionBuilder,
    (
      FocusMetadataData,
      BaseReferences<_$MoodisleDatabase, $FocusMetadataTable, FocusMetadataData>
    ),
    FocusMetadataData,
    PrefetchHooks Function()> {
  $$FocusMetadataTableTableManager(
      _$MoodisleDatabase db, $FocusMetadataTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FocusMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FocusMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FocusMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> todayMinutes = const Value.absent(),
            Value<int> weekMinutes = const Value.absent(),
            Value<String?> weekStart = const Value.absent(),
            Value<int> glancesToday = const Value.absent(),
          }) =>
              FocusMetadataCompanion(
            id: id,
            todayMinutes: todayMinutes,
            weekMinutes: weekMinutes,
            weekStart: weekStart,
            glancesToday: glancesToday,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int todayMinutes,
            required int weekMinutes,
            Value<String?> weekStart = const Value.absent(),
            required int glancesToday,
          }) =>
              FocusMetadataCompanion.insert(
            id: id,
            todayMinutes: todayMinutes,
            weekMinutes: weekMinutes,
            weekStart: weekStart,
            glancesToday: glancesToday,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$FocusMetadataTable, FocusMetadataData>(table),
                    BaseReferences<_$MoodisleDatabase, $FocusMetadataTable,
                        FocusMetadataData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FocusMetadataTableProcessedTableManager = ProcessedTableManager<
    _$MoodisleDatabase,
    $FocusMetadataTable,
    FocusMetadataData,
    $$FocusMetadataTableFilterComposer,
    $$FocusMetadataTableOrderingComposer,
    $$FocusMetadataTableAnnotationComposer,
    $$FocusMetadataTableCreateCompanionBuilder,
    $$FocusMetadataTableUpdateCompanionBuilder,
    (
      FocusMetadataData,
      BaseReferences<_$MoodisleDatabase, $FocusMetadataTable, FocusMetadataData>
    ),
    FocusMetadataData,
    PrefetchHooks Function()>;
typedef $$ActiveFocusSessionsTableCreateCompanionBuilder
    = ActiveFocusSessionsCompanion Function({
  Value<int> id,
  required String pet,
  required int planMinutes,
  required double tierMultiplier,
  required String phase,
  required int accumulatedSeconds,
  required int startedAtMs,
  required int lastTickAtMs,
  Value<int?> pausedAtMs,
});
typedef $$ActiveFocusSessionsTableUpdateCompanionBuilder
    = ActiveFocusSessionsCompanion Function({
  Value<int> id,
  Value<String> pet,
  Value<int> planMinutes,
  Value<double> tierMultiplier,
  Value<String> phase,
  Value<int> accumulatedSeconds,
  Value<int> startedAtMs,
  Value<int> lastTickAtMs,
  Value<int?> pausedAtMs,
});

final class $$ActiveFocusSessionsTableReferences extends BaseReferences<
    _$MoodisleDatabase, $ActiveFocusSessionsTable, ActiveFocusSession> {
  $$ActiveFocusSessionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $EmotionCatalogTable _petTable(_$MoodisleDatabase db) =>
      db.emotionCatalog
          .createAlias('active_focus_sessions__pet__emotion_catalog__code');

  $$EmotionCatalogTableProcessedTableManager get pet {
    final $_column = $_itemColumn<String>('pet')!;

    final manager = $$EmotionCatalogTableTableManager($_db, $_db.emotionCatalog)
        .filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_petTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ActiveFocusSessionsTableFilterComposer
    extends Composer<_$MoodisleDatabase, $ActiveFocusSessionsTable> {
  $$ActiveFocusSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get planMinutes => $composableBuilder(
      column: $table.planMinutes, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tierMultiplier => $composableBuilder(
      column: $table.tierMultiplier,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phase => $composableBuilder(
      column: $table.phase, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get accumulatedSeconds => $composableBuilder(
      column: $table.accumulatedSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startedAtMs => $composableBuilder(
      column: $table.startedAtMs, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastTickAtMs => $composableBuilder(
      column: $table.lastTickAtMs, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pausedAtMs => $composableBuilder(
      column: $table.pausedAtMs, builder: (column) => ColumnFilters(column));

  $$EmotionCatalogTableFilterComposer get pet {
    final $$EmotionCatalogTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pet,
        referencedTable: $db.emotionCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmotionCatalogTableFilterComposer(
              $db: $db,
              $table: $db.emotionCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ActiveFocusSessionsTableOrderingComposer
    extends Composer<_$MoodisleDatabase, $ActiveFocusSessionsTable> {
  $$ActiveFocusSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get planMinutes => $composableBuilder(
      column: $table.planMinutes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tierMultiplier => $composableBuilder(
      column: $table.tierMultiplier,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phase => $composableBuilder(
      column: $table.phase, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get accumulatedSeconds => $composableBuilder(
      column: $table.accumulatedSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startedAtMs => $composableBuilder(
      column: $table.startedAtMs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastTickAtMs => $composableBuilder(
      column: $table.lastTickAtMs,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pausedAtMs => $composableBuilder(
      column: $table.pausedAtMs, builder: (column) => ColumnOrderings(column));

  $$EmotionCatalogTableOrderingComposer get pet {
    final $$EmotionCatalogTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pet,
        referencedTable: $db.emotionCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmotionCatalogTableOrderingComposer(
              $db: $db,
              $table: $db.emotionCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ActiveFocusSessionsTableAnnotationComposer
    extends Composer<_$MoodisleDatabase, $ActiveFocusSessionsTable> {
  $$ActiveFocusSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get planMinutes => $composableBuilder(
      column: $table.planMinutes, builder: (column) => column);

  GeneratedColumn<double> get tierMultiplier => $composableBuilder(
      column: $table.tierMultiplier, builder: (column) => column);

  GeneratedColumn<String> get phase =>
      $composableBuilder(column: $table.phase, builder: (column) => column);

  GeneratedColumn<int> get accumulatedSeconds => $composableBuilder(
      column: $table.accumulatedSeconds, builder: (column) => column);

  GeneratedColumn<int> get startedAtMs => $composableBuilder(
      column: $table.startedAtMs, builder: (column) => column);

  GeneratedColumn<int> get lastTickAtMs => $composableBuilder(
      column: $table.lastTickAtMs, builder: (column) => column);

  GeneratedColumn<int> get pausedAtMs => $composableBuilder(
      column: $table.pausedAtMs, builder: (column) => column);

  $$EmotionCatalogTableAnnotationComposer get pet {
    final $$EmotionCatalogTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pet,
        referencedTable: $db.emotionCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmotionCatalogTableAnnotationComposer(
              $db: $db,
              $table: $db.emotionCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ActiveFocusSessionsTableTableManager extends RootTableManager<
    _$MoodisleDatabase,
    $ActiveFocusSessionsTable,
    ActiveFocusSession,
    $$ActiveFocusSessionsTableFilterComposer,
    $$ActiveFocusSessionsTableOrderingComposer,
    $$ActiveFocusSessionsTableAnnotationComposer,
    $$ActiveFocusSessionsTableCreateCompanionBuilder,
    $$ActiveFocusSessionsTableUpdateCompanionBuilder,
    (ActiveFocusSession, $$ActiveFocusSessionsTableReferences),
    ActiveFocusSession,
    PrefetchHooks Function({bool pet})> {
  $$ActiveFocusSessionsTableTableManager(
      _$MoodisleDatabase db, $ActiveFocusSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActiveFocusSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActiveFocusSessionsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActiveFocusSessionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> pet = const Value.absent(),
            Value<int> planMinutes = const Value.absent(),
            Value<double> tierMultiplier = const Value.absent(),
            Value<String> phase = const Value.absent(),
            Value<int> accumulatedSeconds = const Value.absent(),
            Value<int> startedAtMs = const Value.absent(),
            Value<int> lastTickAtMs = const Value.absent(),
            Value<int?> pausedAtMs = const Value.absent(),
          }) =>
              ActiveFocusSessionsCompanion(
            id: id,
            pet: pet,
            planMinutes: planMinutes,
            tierMultiplier: tierMultiplier,
            phase: phase,
            accumulatedSeconds: accumulatedSeconds,
            startedAtMs: startedAtMs,
            lastTickAtMs: lastTickAtMs,
            pausedAtMs: pausedAtMs,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String pet,
            required int planMinutes,
            required double tierMultiplier,
            required String phase,
            required int accumulatedSeconds,
            required int startedAtMs,
            required int lastTickAtMs,
            Value<int?> pausedAtMs = const Value.absent(),
          }) =>
              ActiveFocusSessionsCompanion.insert(
            id: id,
            pet: pet,
            planMinutes: planMinutes,
            tierMultiplier: tierMultiplier,
            phase: phase,
            accumulatedSeconds: accumulatedSeconds,
            startedAtMs: startedAtMs,
            lastTickAtMs: lastTickAtMs,
            pausedAtMs: pausedAtMs,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ActiveFocusSessionsTable, ActiveFocusSession>(
                        table),
                    $$ActiveFocusSessionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({pet = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (pet) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.pet,
                    referencedTable:
                        $$ActiveFocusSessionsTableReferences._petTable(db),
                    referencedColumn:
                        $$ActiveFocusSessionsTableReferences._petTable(db).code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ActiveFocusSessionsTableProcessedTableManager = ProcessedTableManager<
    _$MoodisleDatabase,
    $ActiveFocusSessionsTable,
    ActiveFocusSession,
    $$ActiveFocusSessionsTableFilterComposer,
    $$ActiveFocusSessionsTableOrderingComposer,
    $$ActiveFocusSessionsTableAnnotationComposer,
    $$ActiveFocusSessionsTableCreateCompanionBuilder,
    $$ActiveFocusSessionsTableUpdateCompanionBuilder,
    (ActiveFocusSession, $$ActiveFocusSessionsTableReferences),
    ActiveFocusSession,
    PrefetchHooks Function({bool pet})>;
typedef $$DailyStatesTableCreateCompanionBuilder = DailyStatesCompanion
    Function({
  Value<int> id,
  Value<String?> date,
  required int checkinDays,
  required int checkinBest,
  required bool checkedToday,
  Value<String?> lastCheckin,
  Value<String?> lastGreet,
  required int mazeToday,
});
typedef $$DailyStatesTableUpdateCompanionBuilder = DailyStatesCompanion
    Function({
  Value<int> id,
  Value<String?> date,
  Value<int> checkinDays,
  Value<int> checkinBest,
  Value<bool> checkedToday,
  Value<String?> lastCheckin,
  Value<String?> lastGreet,
  Value<int> mazeToday,
});

class $$DailyStatesTableFilterComposer
    extends Composer<_$MoodisleDatabase, $DailyStatesTable> {
  $$DailyStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get checkinDays => $composableBuilder(
      column: $table.checkinDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get checkinBest => $composableBuilder(
      column: $table.checkinBest, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get checkedToday => $composableBuilder(
      column: $table.checkedToday, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastCheckin => $composableBuilder(
      column: $table.lastCheckin, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastGreet => $composableBuilder(
      column: $table.lastGreet, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get mazeToday => $composableBuilder(
      column: $table.mazeToday, builder: (column) => ColumnFilters(column));
}

class $$DailyStatesTableOrderingComposer
    extends Composer<_$MoodisleDatabase, $DailyStatesTable> {
  $$DailyStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get checkinDays => $composableBuilder(
      column: $table.checkinDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get checkinBest => $composableBuilder(
      column: $table.checkinBest, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get checkedToday => $composableBuilder(
      column: $table.checkedToday,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastCheckin => $composableBuilder(
      column: $table.lastCheckin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastGreet => $composableBuilder(
      column: $table.lastGreet, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get mazeToday => $composableBuilder(
      column: $table.mazeToday, builder: (column) => ColumnOrderings(column));
}

class $$DailyStatesTableAnnotationComposer
    extends Composer<_$MoodisleDatabase, $DailyStatesTable> {
  $$DailyStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get checkinDays => $composableBuilder(
      column: $table.checkinDays, builder: (column) => column);

  GeneratedColumn<int> get checkinBest => $composableBuilder(
      column: $table.checkinBest, builder: (column) => column);

  GeneratedColumn<bool> get checkedToday => $composableBuilder(
      column: $table.checkedToday, builder: (column) => column);

  GeneratedColumn<String> get lastCheckin => $composableBuilder(
      column: $table.lastCheckin, builder: (column) => column);

  GeneratedColumn<String> get lastGreet =>
      $composableBuilder(column: $table.lastGreet, builder: (column) => column);

  GeneratedColumn<int> get mazeToday =>
      $composableBuilder(column: $table.mazeToday, builder: (column) => column);
}

class $$DailyStatesTableTableManager extends RootTableManager<
    _$MoodisleDatabase,
    $DailyStatesTable,
    DailyState,
    $$DailyStatesTableFilterComposer,
    $$DailyStatesTableOrderingComposer,
    $$DailyStatesTableAnnotationComposer,
    $$DailyStatesTableCreateCompanionBuilder,
    $$DailyStatesTableUpdateCompanionBuilder,
    (
      DailyState,
      BaseReferences<_$MoodisleDatabase, $DailyStatesTable, DailyState>
    ),
    DailyState,
    PrefetchHooks Function()> {
  $$DailyStatesTableTableManager(_$MoodisleDatabase db, $DailyStatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> date = const Value.absent(),
            Value<int> checkinDays = const Value.absent(),
            Value<int> checkinBest = const Value.absent(),
            Value<bool> checkedToday = const Value.absent(),
            Value<String?> lastCheckin = const Value.absent(),
            Value<String?> lastGreet = const Value.absent(),
            Value<int> mazeToday = const Value.absent(),
          }) =>
              DailyStatesCompanion(
            id: id,
            date: date,
            checkinDays: checkinDays,
            checkinBest: checkinBest,
            checkedToday: checkedToday,
            lastCheckin: lastCheckin,
            lastGreet: lastGreet,
            mazeToday: mazeToday,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> date = const Value.absent(),
            required int checkinDays,
            required int checkinBest,
            required bool checkedToday,
            Value<String?> lastCheckin = const Value.absent(),
            Value<String?> lastGreet = const Value.absent(),
            required int mazeToday,
          }) =>
              DailyStatesCompanion.insert(
            id: id,
            date: date,
            checkinDays: checkinDays,
            checkinBest: checkinBest,
            checkedToday: checkedToday,
            lastCheckin: lastCheckin,
            lastGreet: lastGreet,
            mazeToday: mazeToday,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$DailyStatesTable, DailyState>(table),
                    BaseReferences<_$MoodisleDatabase, $DailyStatesTable,
                        DailyState>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DailyStatesTableProcessedTableManager = ProcessedTableManager<
    _$MoodisleDatabase,
    $DailyStatesTable,
    DailyState,
    $$DailyStatesTableFilterComposer,
    $$DailyStatesTableOrderingComposer,
    $$DailyStatesTableAnnotationComposer,
    $$DailyStatesTableCreateCompanionBuilder,
    $$DailyStatesTableUpdateCompanionBuilder,
    (
      DailyState,
      BaseReferences<_$MoodisleDatabase, $DailyStatesTable, DailyState>
    ),
    DailyState,
    PrefetchHooks Function()>;
typedef $$DailyQuestProgressRowsTableCreateCompanionBuilder
    = DailyQuestProgressRowsCompanion Function({
  required String questCode,
  required int progress,
  required bool claimed,
  Value<int> rowid,
});
typedef $$DailyQuestProgressRowsTableUpdateCompanionBuilder
    = DailyQuestProgressRowsCompanion Function({
  Value<String> questCode,
  Value<int> progress,
  Value<bool> claimed,
  Value<int> rowid,
});

final class $$DailyQuestProgressRowsTableReferences extends BaseReferences<
    _$MoodisleDatabase, $DailyQuestProgressRowsTable, DailyQuestProgressRow> {
  $$DailyQuestProgressRowsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $DailyQuestCatalogTable _questCodeTable(_$MoodisleDatabase db) =>
      db.dailyQuestCatalog.createAlias(
          'daily_quest_progress__quest_code__daily_quest_catalog__code');

  $$DailyQuestCatalogTableProcessedTableManager get questCode {
    final $_column = $_itemColumn<String>('quest_code')!;

    final manager =
        $$DailyQuestCatalogTableTableManager($_db, $_db.dailyQuestCatalog)
            .filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_questCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DailyQuestProgressRowsTableFilterComposer
    extends Composer<_$MoodisleDatabase, $DailyQuestProgressRowsTable> {
  $$DailyQuestProgressRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get claimed => $composableBuilder(
      column: $table.claimed, builder: (column) => ColumnFilters(column));

  $$DailyQuestCatalogTableFilterComposer get questCode {
    final $$DailyQuestCatalogTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.questCode,
        referencedTable: $db.dailyQuestCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DailyQuestCatalogTableFilterComposer(
              $db: $db,
              $table: $db.dailyQuestCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DailyQuestProgressRowsTableOrderingComposer
    extends Composer<_$MoodisleDatabase, $DailyQuestProgressRowsTable> {
  $$DailyQuestProgressRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get claimed => $composableBuilder(
      column: $table.claimed, builder: (column) => ColumnOrderings(column));

  $$DailyQuestCatalogTableOrderingComposer get questCode {
    final $$DailyQuestCatalogTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.questCode,
        referencedTable: $db.dailyQuestCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DailyQuestCatalogTableOrderingComposer(
              $db: $db,
              $table: $db.dailyQuestCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DailyQuestProgressRowsTableAnnotationComposer
    extends Composer<_$MoodisleDatabase, $DailyQuestProgressRowsTable> {
  $$DailyQuestProgressRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<bool> get claimed =>
      $composableBuilder(column: $table.claimed, builder: (column) => column);

  $$DailyQuestCatalogTableAnnotationComposer get questCode {
    final $$DailyQuestCatalogTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.questCode,
            referencedTable: $db.dailyQuestCatalog,
            getReferencedColumn: (t) => t.code,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$DailyQuestCatalogTableAnnotationComposer(
                  $db: $db,
                  $table: $db.dailyQuestCatalog,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$DailyQuestProgressRowsTableTableManager extends RootTableManager<
    _$MoodisleDatabase,
    $DailyQuestProgressRowsTable,
    DailyQuestProgressRow,
    $$DailyQuestProgressRowsTableFilterComposer,
    $$DailyQuestProgressRowsTableOrderingComposer,
    $$DailyQuestProgressRowsTableAnnotationComposer,
    $$DailyQuestProgressRowsTableCreateCompanionBuilder,
    $$DailyQuestProgressRowsTableUpdateCompanionBuilder,
    (DailyQuestProgressRow, $$DailyQuestProgressRowsTableReferences),
    DailyQuestProgressRow,
    PrefetchHooks Function({bool questCode})> {
  $$DailyQuestProgressRowsTableTableManager(
      _$MoodisleDatabase db, $DailyQuestProgressRowsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyQuestProgressRowsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyQuestProgressRowsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyQuestProgressRowsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> questCode = const Value.absent(),
            Value<int> progress = const Value.absent(),
            Value<bool> claimed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DailyQuestProgressRowsCompanion(
            questCode: questCode,
            progress: progress,
            claimed: claimed,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String questCode,
            required int progress,
            required bool claimed,
            Value<int> rowid = const Value.absent(),
          }) =>
              DailyQuestProgressRowsCompanion.insert(
            questCode: questCode,
            progress: progress,
            claimed: claimed,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$DailyQuestProgressRowsTable,
                        DailyQuestProgressRow>(table),
                    $$DailyQuestProgressRowsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({questCode = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (questCode) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.questCode,
                    referencedTable: $$DailyQuestProgressRowsTableReferences
                        ._questCodeTable(db),
                    referencedColumn: $$DailyQuestProgressRowsTableReferences
                        ._questCodeTable(db)
                        .code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$DailyQuestProgressRowsTableProcessedTableManager
    = ProcessedTableManager<
        _$MoodisleDatabase,
        $DailyQuestProgressRowsTable,
        DailyQuestProgressRow,
        $$DailyQuestProgressRowsTableFilterComposer,
        $$DailyQuestProgressRowsTableOrderingComposer,
        $$DailyQuestProgressRowsTableAnnotationComposer,
        $$DailyQuestProgressRowsTableCreateCompanionBuilder,
        $$DailyQuestProgressRowsTableUpdateCompanionBuilder,
        (DailyQuestProgressRow, $$DailyQuestProgressRowsTableReferences),
        DailyQuestProgressRow,
        PrefetchHooks Function({bool questCode})>;
typedef $$AchievementUnlocksTableCreateCompanionBuilder
    = AchievementUnlocksCompanion Function({
  required String code,
  required int position,
  Value<int> rowid,
});
typedef $$AchievementUnlocksTableUpdateCompanionBuilder
    = AchievementUnlocksCompanion Function({
  Value<String> code,
  Value<int> position,
  Value<int> rowid,
});

class $$AchievementUnlocksTableFilterComposer
    extends Composer<_$MoodisleDatabase, $AchievementUnlocksTable> {
  $$AchievementUnlocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));
}

class $$AchievementUnlocksTableOrderingComposer
    extends Composer<_$MoodisleDatabase, $AchievementUnlocksTable> {
  $$AchievementUnlocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));
}

class $$AchievementUnlocksTableAnnotationComposer
    extends Composer<_$MoodisleDatabase, $AchievementUnlocksTable> {
  $$AchievementUnlocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$AchievementUnlocksTableTableManager extends RootTableManager<
    _$MoodisleDatabase,
    $AchievementUnlocksTable,
    AchievementUnlock,
    $$AchievementUnlocksTableFilterComposer,
    $$AchievementUnlocksTableOrderingComposer,
    $$AchievementUnlocksTableAnnotationComposer,
    $$AchievementUnlocksTableCreateCompanionBuilder,
    $$AchievementUnlocksTableUpdateCompanionBuilder,
    (
      AchievementUnlock,
      BaseReferences<_$MoodisleDatabase, $AchievementUnlocksTable,
          AchievementUnlock>
    ),
    AchievementUnlock,
    PrefetchHooks Function()> {
  $$AchievementUnlocksTableTableManager(
      _$MoodisleDatabase db, $AchievementUnlocksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AchievementUnlocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AchievementUnlocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AchievementUnlocksTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AchievementUnlocksCompanion(
            code: code,
            position: position,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String code,
            required int position,
            Value<int> rowid = const Value.absent(),
          }) =>
              AchievementUnlocksCompanion.insert(
            code: code,
            position: position,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$AchievementUnlocksTable, AchievementUnlock>(
                        table),
                    BaseReferences<_$MoodisleDatabase, $AchievementUnlocksTable,
                        AchievementUnlock>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AchievementUnlocksTableProcessedTableManager = ProcessedTableManager<
    _$MoodisleDatabase,
    $AchievementUnlocksTable,
    AchievementUnlock,
    $$AchievementUnlocksTableFilterComposer,
    $$AchievementUnlocksTableOrderingComposer,
    $$AchievementUnlocksTableAnnotationComposer,
    $$AchievementUnlocksTableCreateCompanionBuilder,
    $$AchievementUnlocksTableUpdateCompanionBuilder,
    (
      AchievementUnlock,
      BaseReferences<_$MoodisleDatabase, $AchievementUnlocksTable,
          AchievementUnlock>
    ),
    AchievementUnlock,
    PrefetchHooks Function()>;
typedef $$RoamSlotsTableCreateCompanionBuilder = RoamSlotsCompanion Function({
  Value<int> slotIndex,
  required String pet,
  required String routeId,
  required int startedAtMs,
  required int durationMs,
});
typedef $$RoamSlotsTableUpdateCompanionBuilder = RoamSlotsCompanion Function({
  Value<int> slotIndex,
  Value<String> pet,
  Value<String> routeId,
  Value<int> startedAtMs,
  Value<int> durationMs,
});

final class $$RoamSlotsTableReferences
    extends BaseReferences<_$MoodisleDatabase, $RoamSlotsTable, RoamSlot> {
  $$RoamSlotsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EmotionCatalogTable _petTable(_$MoodisleDatabase db) =>
      db.emotionCatalog.createAlias('roam_slots__pet__emotion_catalog__code');

  $$EmotionCatalogTableProcessedTableManager get pet {
    final $_column = $_itemColumn<String>('pet')!;

    final manager = $$EmotionCatalogTableTableManager($_db, $_db.emotionCatalog)
        .filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_petTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RoamSlotsTableFilterComposer
    extends Composer<_$MoodisleDatabase, $RoamSlotsTable> {
  $$RoamSlotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get slotIndex => $composableBuilder(
      column: $table.slotIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get routeId => $composableBuilder(
      column: $table.routeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startedAtMs => $composableBuilder(
      column: $table.startedAtMs, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationMs => $composableBuilder(
      column: $table.durationMs, builder: (column) => ColumnFilters(column));

  $$EmotionCatalogTableFilterComposer get pet {
    final $$EmotionCatalogTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pet,
        referencedTable: $db.emotionCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmotionCatalogTableFilterComposer(
              $db: $db,
              $table: $db.emotionCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RoamSlotsTableOrderingComposer
    extends Composer<_$MoodisleDatabase, $RoamSlotsTable> {
  $$RoamSlotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get slotIndex => $composableBuilder(
      column: $table.slotIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get routeId => $composableBuilder(
      column: $table.routeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startedAtMs => $composableBuilder(
      column: $table.startedAtMs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationMs => $composableBuilder(
      column: $table.durationMs, builder: (column) => ColumnOrderings(column));

  $$EmotionCatalogTableOrderingComposer get pet {
    final $$EmotionCatalogTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pet,
        referencedTable: $db.emotionCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmotionCatalogTableOrderingComposer(
              $db: $db,
              $table: $db.emotionCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RoamSlotsTableAnnotationComposer
    extends Composer<_$MoodisleDatabase, $RoamSlotsTable> {
  $$RoamSlotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get slotIndex =>
      $composableBuilder(column: $table.slotIndex, builder: (column) => column);

  GeneratedColumn<String> get routeId =>
      $composableBuilder(column: $table.routeId, builder: (column) => column);

  GeneratedColumn<int> get startedAtMs => $composableBuilder(
      column: $table.startedAtMs, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
      column: $table.durationMs, builder: (column) => column);

  $$EmotionCatalogTableAnnotationComposer get pet {
    final $$EmotionCatalogTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pet,
        referencedTable: $db.emotionCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmotionCatalogTableAnnotationComposer(
              $db: $db,
              $table: $db.emotionCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RoamSlotsTableTableManager extends RootTableManager<
    _$MoodisleDatabase,
    $RoamSlotsTable,
    RoamSlot,
    $$RoamSlotsTableFilterComposer,
    $$RoamSlotsTableOrderingComposer,
    $$RoamSlotsTableAnnotationComposer,
    $$RoamSlotsTableCreateCompanionBuilder,
    $$RoamSlotsTableUpdateCompanionBuilder,
    (RoamSlot, $$RoamSlotsTableReferences),
    RoamSlot,
    PrefetchHooks Function({bool pet})> {
  $$RoamSlotsTableTableManager(_$MoodisleDatabase db, $RoamSlotsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoamSlotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoamSlotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoamSlotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> slotIndex = const Value.absent(),
            Value<String> pet = const Value.absent(),
            Value<String> routeId = const Value.absent(),
            Value<int> startedAtMs = const Value.absent(),
            Value<int> durationMs = const Value.absent(),
          }) =>
              RoamSlotsCompanion(
            slotIndex: slotIndex,
            pet: pet,
            routeId: routeId,
            startedAtMs: startedAtMs,
            durationMs: durationMs,
          ),
          createCompanionCallback: ({
            Value<int> slotIndex = const Value.absent(),
            required String pet,
            required String routeId,
            required int startedAtMs,
            required int durationMs,
          }) =>
              RoamSlotsCompanion.insert(
            slotIndex: slotIndex,
            pet: pet,
            routeId: routeId,
            startedAtMs: startedAtMs,
            durationMs: durationMs,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$RoamSlotsTable, RoamSlot>(table),
                    $$RoamSlotsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({pet = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (pet) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.pet,
                    referencedTable: $$RoamSlotsTableReferences._petTable(db),
                    referencedColumn:
                        $$RoamSlotsTableReferences._petTable(db).code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RoamSlotsTableProcessedTableManager = ProcessedTableManager<
    _$MoodisleDatabase,
    $RoamSlotsTable,
    RoamSlot,
    $$RoamSlotsTableFilterComposer,
    $$RoamSlotsTableOrderingComposer,
    $$RoamSlotsTableAnnotationComposer,
    $$RoamSlotsTableCreateCompanionBuilder,
    $$RoamSlotsTableUpdateCompanionBuilder,
    (RoamSlot, $$RoamSlotsTableReferences),
    RoamSlot,
    PrefetchHooks Function({bool pet})>;
typedef $$SouvenirInventoryRowsTableCreateCompanionBuilder
    = SouvenirInventoryRowsCompanion Function({
  required String souvenirCode,
  required int quantity,
  Value<int> rowid,
});
typedef $$SouvenirInventoryRowsTableUpdateCompanionBuilder
    = SouvenirInventoryRowsCompanion Function({
  Value<String> souvenirCode,
  Value<int> quantity,
  Value<int> rowid,
});

final class $$SouvenirInventoryRowsTableReferences extends BaseReferences<
    _$MoodisleDatabase, $SouvenirInventoryRowsTable, SouvenirInventoryRow> {
  $$SouvenirInventoryRowsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SouvenirCatalogTable _souvenirCodeTable(_$MoodisleDatabase db) => db
      .souvenirCatalog
      .createAlias('souvenir_inventory__souvenir_code__souvenir_catalog__code');

  $$SouvenirCatalogTableProcessedTableManager get souvenirCode {
    final $_column = $_itemColumn<String>('souvenir_code')!;

    final manager =
        $$SouvenirCatalogTableTableManager($_db, $_db.souvenirCatalog)
            .filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_souvenirCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SouvenirInventoryRowsTableFilterComposer
    extends Composer<_$MoodisleDatabase, $SouvenirInventoryRowsTable> {
  $$SouvenirInventoryRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  $$SouvenirCatalogTableFilterComposer get souvenirCode {
    final $$SouvenirCatalogTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.souvenirCode,
        referencedTable: $db.souvenirCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SouvenirCatalogTableFilterComposer(
              $db: $db,
              $table: $db.souvenirCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SouvenirInventoryRowsTableOrderingComposer
    extends Composer<_$MoodisleDatabase, $SouvenirInventoryRowsTable> {
  $$SouvenirInventoryRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  $$SouvenirCatalogTableOrderingComposer get souvenirCode {
    final $$SouvenirCatalogTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.souvenirCode,
        referencedTable: $db.souvenirCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SouvenirCatalogTableOrderingComposer(
              $db: $db,
              $table: $db.souvenirCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SouvenirInventoryRowsTableAnnotationComposer
    extends Composer<_$MoodisleDatabase, $SouvenirInventoryRowsTable> {
  $$SouvenirInventoryRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  $$SouvenirCatalogTableAnnotationComposer get souvenirCode {
    final $$SouvenirCatalogTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.souvenirCode,
        referencedTable: $db.souvenirCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SouvenirCatalogTableAnnotationComposer(
              $db: $db,
              $table: $db.souvenirCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SouvenirInventoryRowsTableTableManager extends RootTableManager<
    _$MoodisleDatabase,
    $SouvenirInventoryRowsTable,
    SouvenirInventoryRow,
    $$SouvenirInventoryRowsTableFilterComposer,
    $$SouvenirInventoryRowsTableOrderingComposer,
    $$SouvenirInventoryRowsTableAnnotationComposer,
    $$SouvenirInventoryRowsTableCreateCompanionBuilder,
    $$SouvenirInventoryRowsTableUpdateCompanionBuilder,
    (SouvenirInventoryRow, $$SouvenirInventoryRowsTableReferences),
    SouvenirInventoryRow,
    PrefetchHooks Function({bool souvenirCode})> {
  $$SouvenirInventoryRowsTableTableManager(
      _$MoodisleDatabase db, $SouvenirInventoryRowsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SouvenirInventoryRowsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$SouvenirInventoryRowsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SouvenirInventoryRowsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> souvenirCode = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SouvenirInventoryRowsCompanion(
            souvenirCode: souvenirCode,
            quantity: quantity,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String souvenirCode,
            required int quantity,
            Value<int> rowid = const Value.absent(),
          }) =>
              SouvenirInventoryRowsCompanion.insert(
            souvenirCode: souvenirCode,
            quantity: quantity,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SouvenirInventoryRowsTable,
                        SouvenirInventoryRow>(table),
                    $$SouvenirInventoryRowsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({souvenirCode = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (souvenirCode) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.souvenirCode,
                    referencedTable: $$SouvenirInventoryRowsTableReferences
                        ._souvenirCodeTable(db),
                    referencedColumn: $$SouvenirInventoryRowsTableReferences
                        ._souvenirCodeTable(db)
                        .code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SouvenirInventoryRowsTableProcessedTableManager
    = ProcessedTableManager<
        _$MoodisleDatabase,
        $SouvenirInventoryRowsTable,
        SouvenirInventoryRow,
        $$SouvenirInventoryRowsTableFilterComposer,
        $$SouvenirInventoryRowsTableOrderingComposer,
        $$SouvenirInventoryRowsTableAnnotationComposer,
        $$SouvenirInventoryRowsTableCreateCompanionBuilder,
        $$SouvenirInventoryRowsTableUpdateCompanionBuilder,
        (SouvenirInventoryRow, $$SouvenirInventoryRowsTableReferences),
        SouvenirInventoryRow,
        PrefetchHooks Function({bool souvenirCode})>;
typedef $$SocialProfilesTableCreateCompanionBuilder = SocialProfilesCompanion
    Function({
  Value<int> id,
  required String myName,
  Value<String?> visitingPet,
  Value<int?> visitingExpireMs,
  Value<String?> pendant,
});
typedef $$SocialProfilesTableUpdateCompanionBuilder = SocialProfilesCompanion
    Function({
  Value<int> id,
  Value<String> myName,
  Value<String?> visitingPet,
  Value<int?> visitingExpireMs,
  Value<String?> pendant,
});

final class $$SocialProfilesTableReferences extends BaseReferences<
    _$MoodisleDatabase, $SocialProfilesTable, SocialProfile> {
  $$SocialProfilesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $EmotionCatalogTable _visitingPetTable(_$MoodisleDatabase db) =>
      db.emotionCatalog
          .createAlias('social_profiles__visiting_pet__emotion_catalog__code');

  $$EmotionCatalogTableProcessedTableManager? get visitingPet {
    final $_column = $_itemColumn<String>('visiting_pet');
    if ($_column == null) return null;
    final manager = $$EmotionCatalogTableTableManager($_db, $_db.emotionCatalog)
        .filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_visitingPetTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $SouvenirCatalogTable _pendantTable(_$MoodisleDatabase db) =>
      db.souvenirCatalog
          .createAlias('social_profiles__pendant__souvenir_catalog__code');

  $$SouvenirCatalogTableProcessedTableManager? get pendant {
    final $_column = $_itemColumn<String>('pendant');
    if ($_column == null) return null;
    final manager =
        $$SouvenirCatalogTableTableManager($_db, $_db.souvenirCatalog)
            .filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pendantTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SocialProfilesTableFilterComposer
    extends Composer<_$MoodisleDatabase, $SocialProfilesTable> {
  $$SocialProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get myName => $composableBuilder(
      column: $table.myName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get visitingExpireMs => $composableBuilder(
      column: $table.visitingExpireMs,
      builder: (column) => ColumnFilters(column));

  $$EmotionCatalogTableFilterComposer get visitingPet {
    final $$EmotionCatalogTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.visitingPet,
        referencedTable: $db.emotionCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmotionCatalogTableFilterComposer(
              $db: $db,
              $table: $db.emotionCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SouvenirCatalogTableFilterComposer get pendant {
    final $$SouvenirCatalogTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pendant,
        referencedTable: $db.souvenirCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SouvenirCatalogTableFilterComposer(
              $db: $db,
              $table: $db.souvenirCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SocialProfilesTableOrderingComposer
    extends Composer<_$MoodisleDatabase, $SocialProfilesTable> {
  $$SocialProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get myName => $composableBuilder(
      column: $table.myName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get visitingExpireMs => $composableBuilder(
      column: $table.visitingExpireMs,
      builder: (column) => ColumnOrderings(column));

  $$EmotionCatalogTableOrderingComposer get visitingPet {
    final $$EmotionCatalogTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.visitingPet,
        referencedTable: $db.emotionCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmotionCatalogTableOrderingComposer(
              $db: $db,
              $table: $db.emotionCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SouvenirCatalogTableOrderingComposer get pendant {
    final $$SouvenirCatalogTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pendant,
        referencedTable: $db.souvenirCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SouvenirCatalogTableOrderingComposer(
              $db: $db,
              $table: $db.souvenirCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SocialProfilesTableAnnotationComposer
    extends Composer<_$MoodisleDatabase, $SocialProfilesTable> {
  $$SocialProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get myName =>
      $composableBuilder(column: $table.myName, builder: (column) => column);

  GeneratedColumn<int> get visitingExpireMs => $composableBuilder(
      column: $table.visitingExpireMs, builder: (column) => column);

  $$EmotionCatalogTableAnnotationComposer get visitingPet {
    final $$EmotionCatalogTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.visitingPet,
        referencedTable: $db.emotionCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmotionCatalogTableAnnotationComposer(
              $db: $db,
              $table: $db.emotionCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SouvenirCatalogTableAnnotationComposer get pendant {
    final $$SouvenirCatalogTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pendant,
        referencedTable: $db.souvenirCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SouvenirCatalogTableAnnotationComposer(
              $db: $db,
              $table: $db.souvenirCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SocialProfilesTableTableManager extends RootTableManager<
    _$MoodisleDatabase,
    $SocialProfilesTable,
    SocialProfile,
    $$SocialProfilesTableFilterComposer,
    $$SocialProfilesTableOrderingComposer,
    $$SocialProfilesTableAnnotationComposer,
    $$SocialProfilesTableCreateCompanionBuilder,
    $$SocialProfilesTableUpdateCompanionBuilder,
    (SocialProfile, $$SocialProfilesTableReferences),
    SocialProfile,
    PrefetchHooks Function({bool visitingPet, bool pendant})> {
  $$SocialProfilesTableTableManager(
      _$MoodisleDatabase db, $SocialProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SocialProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SocialProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SocialProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> myName = const Value.absent(),
            Value<String?> visitingPet = const Value.absent(),
            Value<int?> visitingExpireMs = const Value.absent(),
            Value<String?> pendant = const Value.absent(),
          }) =>
              SocialProfilesCompanion(
            id: id,
            myName: myName,
            visitingPet: visitingPet,
            visitingExpireMs: visitingExpireMs,
            pendant: pendant,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String myName,
            Value<String?> visitingPet = const Value.absent(),
            Value<int?> visitingExpireMs = const Value.absent(),
            Value<String?> pendant = const Value.absent(),
          }) =>
              SocialProfilesCompanion.insert(
            id: id,
            myName: myName,
            visitingPet: visitingPet,
            visitingExpireMs: visitingExpireMs,
            pendant: pendant,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SocialProfilesTable, SocialProfile>(table),
                    $$SocialProfilesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({visitingPet = false, pendant = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (visitingPet) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.visitingPet,
                    referencedTable:
                        $$SocialProfilesTableReferences._visitingPetTable(db),
                    referencedColumn: $$SocialProfilesTableReferences
                        ._visitingPetTable(db)
                        .code,
                  ) as T;
                }
                if (pendant) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.pendant,
                    referencedTable:
                        $$SocialProfilesTableReferences._pendantTable(db),
                    referencedColumn:
                        $$SocialProfilesTableReferences._pendantTable(db).code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SocialProfilesTableProcessedTableManager = ProcessedTableManager<
    _$MoodisleDatabase,
    $SocialProfilesTable,
    SocialProfile,
    $$SocialProfilesTableFilterComposer,
    $$SocialProfilesTableOrderingComposer,
    $$SocialProfilesTableAnnotationComposer,
    $$SocialProfilesTableCreateCompanionBuilder,
    $$SocialProfilesTableUpdateCompanionBuilder,
    (SocialProfile, $$SocialProfilesTableReferences),
    SocialProfile,
    PrefetchHooks Function({bool visitingPet, bool pendant})>;
typedef $$PostcardsTableCreateCompanionBuilder = PostcardsCompanion Function({
  Value<int> id,
  required String code,
  required String friendName,
  required String friendPet,
  required int receivedAtMs,
});
typedef $$PostcardsTableUpdateCompanionBuilder = PostcardsCompanion Function({
  Value<int> id,
  Value<String> code,
  Value<String> friendName,
  Value<String> friendPet,
  Value<int> receivedAtMs,
});

final class $$PostcardsTableReferences
    extends BaseReferences<_$MoodisleDatabase, $PostcardsTable, Postcard> {
  $$PostcardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EmotionCatalogTable _friendPetTable(_$MoodisleDatabase db) =>
      db.emotionCatalog
          .createAlias('postcards__friend_pet__emotion_catalog__code');

  $$EmotionCatalogTableProcessedTableManager get friendPet {
    final $_column = $_itemColumn<String>('friend_pet')!;

    final manager = $$EmotionCatalogTableTableManager($_db, $_db.emotionCatalog)
        .filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_friendPetTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PostcardsTableFilterComposer
    extends Composer<_$MoodisleDatabase, $PostcardsTable> {
  $$PostcardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get friendName => $composableBuilder(
      column: $table.friendName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get receivedAtMs => $composableBuilder(
      column: $table.receivedAtMs, builder: (column) => ColumnFilters(column));

  $$EmotionCatalogTableFilterComposer get friendPet {
    final $$EmotionCatalogTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.friendPet,
        referencedTable: $db.emotionCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmotionCatalogTableFilterComposer(
              $db: $db,
              $table: $db.emotionCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PostcardsTableOrderingComposer
    extends Composer<_$MoodisleDatabase, $PostcardsTable> {
  $$PostcardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get friendName => $composableBuilder(
      column: $table.friendName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get receivedAtMs => $composableBuilder(
      column: $table.receivedAtMs,
      builder: (column) => ColumnOrderings(column));

  $$EmotionCatalogTableOrderingComposer get friendPet {
    final $$EmotionCatalogTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.friendPet,
        referencedTable: $db.emotionCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmotionCatalogTableOrderingComposer(
              $db: $db,
              $table: $db.emotionCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PostcardsTableAnnotationComposer
    extends Composer<_$MoodisleDatabase, $PostcardsTable> {
  $$PostcardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get friendName => $composableBuilder(
      column: $table.friendName, builder: (column) => column);

  GeneratedColumn<int> get receivedAtMs => $composableBuilder(
      column: $table.receivedAtMs, builder: (column) => column);

  $$EmotionCatalogTableAnnotationComposer get friendPet {
    final $$EmotionCatalogTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.friendPet,
        referencedTable: $db.emotionCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EmotionCatalogTableAnnotationComposer(
              $db: $db,
              $table: $db.emotionCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PostcardsTableTableManager extends RootTableManager<
    _$MoodisleDatabase,
    $PostcardsTable,
    Postcard,
    $$PostcardsTableFilterComposer,
    $$PostcardsTableOrderingComposer,
    $$PostcardsTableAnnotationComposer,
    $$PostcardsTableCreateCompanionBuilder,
    $$PostcardsTableUpdateCompanionBuilder,
    (Postcard, $$PostcardsTableReferences),
    Postcard,
    PrefetchHooks Function({bool friendPet})> {
  $$PostcardsTableTableManager(_$MoodisleDatabase db, $PostcardsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PostcardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PostcardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PostcardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<String> friendName = const Value.absent(),
            Value<String> friendPet = const Value.absent(),
            Value<int> receivedAtMs = const Value.absent(),
          }) =>
              PostcardsCompanion(
            id: id,
            code: code,
            friendName: friendName,
            friendPet: friendPet,
            receivedAtMs: receivedAtMs,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String code,
            required String friendName,
            required String friendPet,
            required int receivedAtMs,
          }) =>
              PostcardsCompanion.insert(
            id: id,
            code: code,
            friendName: friendName,
            friendPet: friendPet,
            receivedAtMs: receivedAtMs,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$PostcardsTable, Postcard>(table),
                    $$PostcardsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({friendPet = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (friendPet) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.friendPet,
                    referencedTable:
                        $$PostcardsTableReferences._friendPetTable(db),
                    referencedColumn:
                        $$PostcardsTableReferences._friendPetTable(db).code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PostcardsTableProcessedTableManager = ProcessedTableManager<
    _$MoodisleDatabase,
    $PostcardsTable,
    Postcard,
    $$PostcardsTableFilterComposer,
    $$PostcardsTableOrderingComposer,
    $$PostcardsTableAnnotationComposer,
    $$PostcardsTableCreateCompanionBuilder,
    $$PostcardsTableUpdateCompanionBuilder,
    (Postcard, $$PostcardsTableReferences),
    Postcard,
    PrefetchHooks Function({bool friendPet})>;
typedef $$ActiveMazeRunsTableCreateCompanionBuilder = ActiveMazeRunsCompanion
    Function({
  Value<int> id,
  required int zoneIndex,
  required int seed,
  required int startLevel,
  required int floorIndex,
  required int positionX,
  required int positionY,
  required int level,
  required int keys,
  required int lanterns,
  required int steps,
  required int kills,
  required int eliteKills,
  required bool bossBeaten,
  required bool usedUndo,
  required bool active,
});
typedef $$ActiveMazeRunsTableUpdateCompanionBuilder = ActiveMazeRunsCompanion
    Function({
  Value<int> id,
  Value<int> zoneIndex,
  Value<int> seed,
  Value<int> startLevel,
  Value<int> floorIndex,
  Value<int> positionX,
  Value<int> positionY,
  Value<int> level,
  Value<int> keys,
  Value<int> lanterns,
  Value<int> steps,
  Value<int> kills,
  Value<int> eliteKills,
  Value<bool> bossBeaten,
  Value<bool> usedUndo,
  Value<bool> active,
});

class $$ActiveMazeRunsTableFilterComposer
    extends Composer<_$MoodisleDatabase, $ActiveMazeRunsTable> {
  $$ActiveMazeRunsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get zoneIndex => $composableBuilder(
      column: $table.zoneIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get seed => $composableBuilder(
      column: $table.seed, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startLevel => $composableBuilder(
      column: $table.startLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get floorIndex => $composableBuilder(
      column: $table.floorIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get positionX => $composableBuilder(
      column: $table.positionX, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get positionY => $composableBuilder(
      column: $table.positionY, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get keys => $composableBuilder(
      column: $table.keys, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lanterns => $composableBuilder(
      column: $table.lanterns, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get steps => $composableBuilder(
      column: $table.steps, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get kills => $composableBuilder(
      column: $table.kills, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get eliteKills => $composableBuilder(
      column: $table.eliteKills, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get bossBeaten => $composableBuilder(
      column: $table.bossBeaten, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get usedUndo => $composableBuilder(
      column: $table.usedUndo, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnFilters(column));
}

class $$ActiveMazeRunsTableOrderingComposer
    extends Composer<_$MoodisleDatabase, $ActiveMazeRunsTable> {
  $$ActiveMazeRunsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get zoneIndex => $composableBuilder(
      column: $table.zoneIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get seed => $composableBuilder(
      column: $table.seed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startLevel => $composableBuilder(
      column: $table.startLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get floorIndex => $composableBuilder(
      column: $table.floorIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get positionX => $composableBuilder(
      column: $table.positionX, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get positionY => $composableBuilder(
      column: $table.positionY, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get keys => $composableBuilder(
      column: $table.keys, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lanterns => $composableBuilder(
      column: $table.lanterns, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get steps => $composableBuilder(
      column: $table.steps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get kills => $composableBuilder(
      column: $table.kills, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get eliteKills => $composableBuilder(
      column: $table.eliteKills, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get bossBeaten => $composableBuilder(
      column: $table.bossBeaten, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get usedUndo => $composableBuilder(
      column: $table.usedUndo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnOrderings(column));
}

class $$ActiveMazeRunsTableAnnotationComposer
    extends Composer<_$MoodisleDatabase, $ActiveMazeRunsTable> {
  $$ActiveMazeRunsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get zoneIndex =>
      $composableBuilder(column: $table.zoneIndex, builder: (column) => column);

  GeneratedColumn<int> get seed =>
      $composableBuilder(column: $table.seed, builder: (column) => column);

  GeneratedColumn<int> get startLevel => $composableBuilder(
      column: $table.startLevel, builder: (column) => column);

  GeneratedColumn<int> get floorIndex => $composableBuilder(
      column: $table.floorIndex, builder: (column) => column);

  GeneratedColumn<int> get positionX =>
      $composableBuilder(column: $table.positionX, builder: (column) => column);

  GeneratedColumn<int> get positionY =>
      $composableBuilder(column: $table.positionY, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get keys =>
      $composableBuilder(column: $table.keys, builder: (column) => column);

  GeneratedColumn<int> get lanterns =>
      $composableBuilder(column: $table.lanterns, builder: (column) => column);

  GeneratedColumn<int> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => column);

  GeneratedColumn<int> get kills =>
      $composableBuilder(column: $table.kills, builder: (column) => column);

  GeneratedColumn<int> get eliteKills => $composableBuilder(
      column: $table.eliteKills, builder: (column) => column);

  GeneratedColumn<bool> get bossBeaten => $composableBuilder(
      column: $table.bossBeaten, builder: (column) => column);

  GeneratedColumn<bool> get usedUndo =>
      $composableBuilder(column: $table.usedUndo, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$ActiveMazeRunsTableTableManager extends RootTableManager<
    _$MoodisleDatabase,
    $ActiveMazeRunsTable,
    ActiveMazeRun,
    $$ActiveMazeRunsTableFilterComposer,
    $$ActiveMazeRunsTableOrderingComposer,
    $$ActiveMazeRunsTableAnnotationComposer,
    $$ActiveMazeRunsTableCreateCompanionBuilder,
    $$ActiveMazeRunsTableUpdateCompanionBuilder,
    (
      ActiveMazeRun,
      BaseReferences<_$MoodisleDatabase, $ActiveMazeRunsTable, ActiveMazeRun>
    ),
    ActiveMazeRun,
    PrefetchHooks Function()> {
  $$ActiveMazeRunsTableTableManager(
      _$MoodisleDatabase db, $ActiveMazeRunsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActiveMazeRunsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActiveMazeRunsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActiveMazeRunsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> zoneIndex = const Value.absent(),
            Value<int> seed = const Value.absent(),
            Value<int> startLevel = const Value.absent(),
            Value<int> floorIndex = const Value.absent(),
            Value<int> positionX = const Value.absent(),
            Value<int> positionY = const Value.absent(),
            Value<int> level = const Value.absent(),
            Value<int> keys = const Value.absent(),
            Value<int> lanterns = const Value.absent(),
            Value<int> steps = const Value.absent(),
            Value<int> kills = const Value.absent(),
            Value<int> eliteKills = const Value.absent(),
            Value<bool> bossBeaten = const Value.absent(),
            Value<bool> usedUndo = const Value.absent(),
            Value<bool> active = const Value.absent(),
          }) =>
              ActiveMazeRunsCompanion(
            id: id,
            zoneIndex: zoneIndex,
            seed: seed,
            startLevel: startLevel,
            floorIndex: floorIndex,
            positionX: positionX,
            positionY: positionY,
            level: level,
            keys: keys,
            lanterns: lanterns,
            steps: steps,
            kills: kills,
            eliteKills: eliteKills,
            bossBeaten: bossBeaten,
            usedUndo: usedUndo,
            active: active,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int zoneIndex,
            required int seed,
            required int startLevel,
            required int floorIndex,
            required int positionX,
            required int positionY,
            required int level,
            required int keys,
            required int lanterns,
            required int steps,
            required int kills,
            required int eliteKills,
            required bool bossBeaten,
            required bool usedUndo,
            required bool active,
          }) =>
              ActiveMazeRunsCompanion.insert(
            id: id,
            zoneIndex: zoneIndex,
            seed: seed,
            startLevel: startLevel,
            floorIndex: floorIndex,
            positionX: positionX,
            positionY: positionY,
            level: level,
            keys: keys,
            lanterns: lanterns,
            steps: steps,
            kills: kills,
            eliteKills: eliteKills,
            bossBeaten: bossBeaten,
            usedUndo: usedUndo,
            active: active,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ActiveMazeRunsTable, ActiveMazeRun>(table),
                    BaseReferences<_$MoodisleDatabase, $ActiveMazeRunsTable,
                        ActiveMazeRun>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ActiveMazeRunsTableProcessedTableManager = ProcessedTableManager<
    _$MoodisleDatabase,
    $ActiveMazeRunsTable,
    ActiveMazeRun,
    $$ActiveMazeRunsTableFilterComposer,
    $$ActiveMazeRunsTableOrderingComposer,
    $$ActiveMazeRunsTableAnnotationComposer,
    $$ActiveMazeRunsTableCreateCompanionBuilder,
    $$ActiveMazeRunsTableUpdateCompanionBuilder,
    (
      ActiveMazeRun,
      BaseReferences<_$MoodisleDatabase, $ActiveMazeRunsTable, ActiveMazeRun>
    ),
    ActiveMazeRun,
    PrefetchHooks Function()>;
typedef $$MazeCellStatesTableCreateCompanionBuilder = MazeCellStatesCompanion
    Function({
  required int floorIndex,
  required String cellKey,
  required bool consumed,
  required bool picked,
  required bool opened,
  Value<int> rowid,
});
typedef $$MazeCellStatesTableUpdateCompanionBuilder = MazeCellStatesCompanion
    Function({
  Value<int> floorIndex,
  Value<String> cellKey,
  Value<bool> consumed,
  Value<bool> picked,
  Value<bool> opened,
  Value<int> rowid,
});

class $$MazeCellStatesTableFilterComposer
    extends Composer<_$MoodisleDatabase, $MazeCellStatesTable> {
  $$MazeCellStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get floorIndex => $composableBuilder(
      column: $table.floorIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cellKey => $composableBuilder(
      column: $table.cellKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get consumed => $composableBuilder(
      column: $table.consumed, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get picked => $composableBuilder(
      column: $table.picked, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get opened => $composableBuilder(
      column: $table.opened, builder: (column) => ColumnFilters(column));
}

class $$MazeCellStatesTableOrderingComposer
    extends Composer<_$MoodisleDatabase, $MazeCellStatesTable> {
  $$MazeCellStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get floorIndex => $composableBuilder(
      column: $table.floorIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cellKey => $composableBuilder(
      column: $table.cellKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get consumed => $composableBuilder(
      column: $table.consumed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get picked => $composableBuilder(
      column: $table.picked, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get opened => $composableBuilder(
      column: $table.opened, builder: (column) => ColumnOrderings(column));
}

class $$MazeCellStatesTableAnnotationComposer
    extends Composer<_$MoodisleDatabase, $MazeCellStatesTable> {
  $$MazeCellStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get floorIndex => $composableBuilder(
      column: $table.floorIndex, builder: (column) => column);

  GeneratedColumn<String> get cellKey =>
      $composableBuilder(column: $table.cellKey, builder: (column) => column);

  GeneratedColumn<bool> get consumed =>
      $composableBuilder(column: $table.consumed, builder: (column) => column);

  GeneratedColumn<bool> get picked =>
      $composableBuilder(column: $table.picked, builder: (column) => column);

  GeneratedColumn<bool> get opened =>
      $composableBuilder(column: $table.opened, builder: (column) => column);
}

class $$MazeCellStatesTableTableManager extends RootTableManager<
    _$MoodisleDatabase,
    $MazeCellStatesTable,
    MazeCellState,
    $$MazeCellStatesTableFilterComposer,
    $$MazeCellStatesTableOrderingComposer,
    $$MazeCellStatesTableAnnotationComposer,
    $$MazeCellStatesTableCreateCompanionBuilder,
    $$MazeCellStatesTableUpdateCompanionBuilder,
    (
      MazeCellState,
      BaseReferences<_$MoodisleDatabase, $MazeCellStatesTable, MazeCellState>
    ),
    MazeCellState,
    PrefetchHooks Function()> {
  $$MazeCellStatesTableTableManager(
      _$MoodisleDatabase db, $MazeCellStatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MazeCellStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MazeCellStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MazeCellStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> floorIndex = const Value.absent(),
            Value<String> cellKey = const Value.absent(),
            Value<bool> consumed = const Value.absent(),
            Value<bool> picked = const Value.absent(),
            Value<bool> opened = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MazeCellStatesCompanion(
            floorIndex: floorIndex,
            cellKey: cellKey,
            consumed: consumed,
            picked: picked,
            opened: opened,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int floorIndex,
            required String cellKey,
            required bool consumed,
            required bool picked,
            required bool opened,
            Value<int> rowid = const Value.absent(),
          }) =>
              MazeCellStatesCompanion.insert(
            floorIndex: floorIndex,
            cellKey: cellKey,
            consumed: consumed,
            picked: picked,
            opened: opened,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$MazeCellStatesTable, MazeCellState>(table),
                    BaseReferences<_$MoodisleDatabase, $MazeCellStatesTable,
                        MazeCellState>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MazeCellStatesTableProcessedTableManager = ProcessedTableManager<
    _$MoodisleDatabase,
    $MazeCellStatesTable,
    MazeCellState,
    $$MazeCellStatesTableFilterComposer,
    $$MazeCellStatesTableOrderingComposer,
    $$MazeCellStatesTableAnnotationComposer,
    $$MazeCellStatesTableCreateCompanionBuilder,
    $$MazeCellStatesTableUpdateCompanionBuilder,
    (
      MazeCellState,
      BaseReferences<_$MoodisleDatabase, $MazeCellStatesTable, MazeCellState>
    ),
    MazeCellState,
    PrefetchHooks Function()>;
typedef $$MazeUndoSnapshotsTableCreateCompanionBuilder
    = MazeUndoSnapshotsCompanion Function({
  Value<int> snapshotIndex,
  required int positionX,
  required int positionY,
  required int level,
  required int keys,
  required int steps,
  required int kills,
  required int eliteKills,
  required bool bossBeaten,
});
typedef $$MazeUndoSnapshotsTableUpdateCompanionBuilder
    = MazeUndoSnapshotsCompanion Function({
  Value<int> snapshotIndex,
  Value<int> positionX,
  Value<int> positionY,
  Value<int> level,
  Value<int> keys,
  Value<int> steps,
  Value<int> kills,
  Value<int> eliteKills,
  Value<bool> bossBeaten,
});

final class $$MazeUndoSnapshotsTableReferences extends BaseReferences<
    _$MoodisleDatabase, $MazeUndoSnapshotsTable, MazeUndoSnapshot> {
  $$MazeUndoSnapshotsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MazeUndoCellStatesTable,
      List<MazeUndoCellState>> _mazeUndoCellStatesRefsTable(
          _$MoodisleDatabase db) =>
      MultiTypedResultKey.fromTable(db.mazeUndoCellStates,
          aliasName:
              'maze_undo_snapshots__snapshot_index__maze_undo_cell_states__snapshot_index');

  $$MazeUndoCellStatesTableProcessedTableManager get mazeUndoCellStatesRefs {
    final manager =
        $$MazeUndoCellStatesTableTableManager($_db, $_db.mazeUndoCellStates)
            .filter((f) => f.snapshotIndex.snapshotIndex
                .sqlEquals($_itemColumn<int>('snapshot_index')!));

    final cache =
        $_typedResult.readTableOrNull(_mazeUndoCellStatesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MazeUndoSnapshotsTableFilterComposer
    extends Composer<_$MoodisleDatabase, $MazeUndoSnapshotsTable> {
  $$MazeUndoSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get snapshotIndex => $composableBuilder(
      column: $table.snapshotIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get positionX => $composableBuilder(
      column: $table.positionX, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get positionY => $composableBuilder(
      column: $table.positionY, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get keys => $composableBuilder(
      column: $table.keys, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get steps => $composableBuilder(
      column: $table.steps, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get kills => $composableBuilder(
      column: $table.kills, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get eliteKills => $composableBuilder(
      column: $table.eliteKills, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get bossBeaten => $composableBuilder(
      column: $table.bossBeaten, builder: (column) => ColumnFilters(column));

  Expression<bool> mazeUndoCellStatesRefs(
      Expression<bool> Function($$MazeUndoCellStatesTableFilterComposer f) f) {
    final $$MazeUndoCellStatesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.snapshotIndex,
        referencedTable: $db.mazeUndoCellStates,
        getReferencedColumn: (t) => t.snapshotIndex,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MazeUndoCellStatesTableFilterComposer(
              $db: $db,
              $table: $db.mazeUndoCellStates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MazeUndoSnapshotsTableOrderingComposer
    extends Composer<_$MoodisleDatabase, $MazeUndoSnapshotsTable> {
  $$MazeUndoSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get snapshotIndex => $composableBuilder(
      column: $table.snapshotIndex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get positionX => $composableBuilder(
      column: $table.positionX, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get positionY => $composableBuilder(
      column: $table.positionY, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get keys => $composableBuilder(
      column: $table.keys, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get steps => $composableBuilder(
      column: $table.steps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get kills => $composableBuilder(
      column: $table.kills, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get eliteKills => $composableBuilder(
      column: $table.eliteKills, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get bossBeaten => $composableBuilder(
      column: $table.bossBeaten, builder: (column) => ColumnOrderings(column));
}

class $$MazeUndoSnapshotsTableAnnotationComposer
    extends Composer<_$MoodisleDatabase, $MazeUndoSnapshotsTable> {
  $$MazeUndoSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get snapshotIndex => $composableBuilder(
      column: $table.snapshotIndex, builder: (column) => column);

  GeneratedColumn<int> get positionX =>
      $composableBuilder(column: $table.positionX, builder: (column) => column);

  GeneratedColumn<int> get positionY =>
      $composableBuilder(column: $table.positionY, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get keys =>
      $composableBuilder(column: $table.keys, builder: (column) => column);

  GeneratedColumn<int> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => column);

  GeneratedColumn<int> get kills =>
      $composableBuilder(column: $table.kills, builder: (column) => column);

  GeneratedColumn<int> get eliteKills => $composableBuilder(
      column: $table.eliteKills, builder: (column) => column);

  GeneratedColumn<bool> get bossBeaten => $composableBuilder(
      column: $table.bossBeaten, builder: (column) => column);

  Expression<T> mazeUndoCellStatesRefs<T extends Object>(
      Expression<T> Function($$MazeUndoCellStatesTableAnnotationComposer a) f) {
    final $$MazeUndoCellStatesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.snapshotIndex,
            referencedTable: $db.mazeUndoCellStates,
            getReferencedColumn: (t) => t.snapshotIndex,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MazeUndoCellStatesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.mazeUndoCellStates,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$MazeUndoSnapshotsTableTableManager extends RootTableManager<
    _$MoodisleDatabase,
    $MazeUndoSnapshotsTable,
    MazeUndoSnapshot,
    $$MazeUndoSnapshotsTableFilterComposer,
    $$MazeUndoSnapshotsTableOrderingComposer,
    $$MazeUndoSnapshotsTableAnnotationComposer,
    $$MazeUndoSnapshotsTableCreateCompanionBuilder,
    $$MazeUndoSnapshotsTableUpdateCompanionBuilder,
    (MazeUndoSnapshot, $$MazeUndoSnapshotsTableReferences),
    MazeUndoSnapshot,
    PrefetchHooks Function({bool mazeUndoCellStatesRefs})> {
  $$MazeUndoSnapshotsTableTableManager(
      _$MoodisleDatabase db, $MazeUndoSnapshotsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MazeUndoSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MazeUndoSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MazeUndoSnapshotsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> snapshotIndex = const Value.absent(),
            Value<int> positionX = const Value.absent(),
            Value<int> positionY = const Value.absent(),
            Value<int> level = const Value.absent(),
            Value<int> keys = const Value.absent(),
            Value<int> steps = const Value.absent(),
            Value<int> kills = const Value.absent(),
            Value<int> eliteKills = const Value.absent(),
            Value<bool> bossBeaten = const Value.absent(),
          }) =>
              MazeUndoSnapshotsCompanion(
            snapshotIndex: snapshotIndex,
            positionX: positionX,
            positionY: positionY,
            level: level,
            keys: keys,
            steps: steps,
            kills: kills,
            eliteKills: eliteKills,
            bossBeaten: bossBeaten,
          ),
          createCompanionCallback: ({
            Value<int> snapshotIndex = const Value.absent(),
            required int positionX,
            required int positionY,
            required int level,
            required int keys,
            required int steps,
            required int kills,
            required int eliteKills,
            required bool bossBeaten,
          }) =>
              MazeUndoSnapshotsCompanion.insert(
            snapshotIndex: snapshotIndex,
            positionX: positionX,
            positionY: positionY,
            level: level,
            keys: keys,
            steps: steps,
            kills: kills,
            eliteKills: eliteKills,
            bossBeaten: bossBeaten,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$MazeUndoSnapshotsTable, MazeUndoSnapshot>(
                        table),
                    $$MazeUndoSnapshotsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({mazeUndoCellStatesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (mazeUndoCellStatesRefs) db.mazeUndoCellStates
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mazeUndoCellStatesRefs)
                    await $_getPrefetchedData<MazeUndoSnapshot,
                            $MazeUndoSnapshotsTable, MazeUndoCellState>(
                        currentTable: table,
                        referencedTable: $$MazeUndoSnapshotsTableReferences
                            ._mazeUndoCellStatesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MazeUndoSnapshotsTableReferences(db, table, p0)
                                .mazeUndoCellStatesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems.where(
                                (e) => e.snapshotIndex == item.snapshotIndex),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MazeUndoSnapshotsTableProcessedTableManager = ProcessedTableManager<
    _$MoodisleDatabase,
    $MazeUndoSnapshotsTable,
    MazeUndoSnapshot,
    $$MazeUndoSnapshotsTableFilterComposer,
    $$MazeUndoSnapshotsTableOrderingComposer,
    $$MazeUndoSnapshotsTableAnnotationComposer,
    $$MazeUndoSnapshotsTableCreateCompanionBuilder,
    $$MazeUndoSnapshotsTableUpdateCompanionBuilder,
    (MazeUndoSnapshot, $$MazeUndoSnapshotsTableReferences),
    MazeUndoSnapshot,
    PrefetchHooks Function({bool mazeUndoCellStatesRefs})>;
typedef $$MazeUndoCellStatesTableCreateCompanionBuilder
    = MazeUndoCellStatesCompanion Function({
  required int snapshotIndex,
  required int floorIndex,
  required String cellKey,
  required bool consumed,
  required bool picked,
  required bool opened,
  Value<int> rowid,
});
typedef $$MazeUndoCellStatesTableUpdateCompanionBuilder
    = MazeUndoCellStatesCompanion Function({
  Value<int> snapshotIndex,
  Value<int> floorIndex,
  Value<String> cellKey,
  Value<bool> consumed,
  Value<bool> picked,
  Value<bool> opened,
  Value<int> rowid,
});

final class $$MazeUndoCellStatesTableReferences extends BaseReferences<
    _$MoodisleDatabase, $MazeUndoCellStatesTable, MazeUndoCellState> {
  $$MazeUndoCellStatesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MazeUndoSnapshotsTable _snapshotIndexTable(_$MoodisleDatabase db) =>
      db.mazeUndoSnapshots.createAlias(
          'maze_undo_cell_states__snapshot_index__maze_undo_snapshots__snapshot_index');

  $$MazeUndoSnapshotsTableProcessedTableManager get snapshotIndex {
    final $_column = $_itemColumn<int>('snapshot_index')!;

    final manager =
        $$MazeUndoSnapshotsTableTableManager($_db, $_db.mazeUndoSnapshots)
            .filter((f) => f.snapshotIndex.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_snapshotIndexTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MazeUndoCellStatesTableFilterComposer
    extends Composer<_$MoodisleDatabase, $MazeUndoCellStatesTable> {
  $$MazeUndoCellStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get floorIndex => $composableBuilder(
      column: $table.floorIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cellKey => $composableBuilder(
      column: $table.cellKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get consumed => $composableBuilder(
      column: $table.consumed, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get picked => $composableBuilder(
      column: $table.picked, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get opened => $composableBuilder(
      column: $table.opened, builder: (column) => ColumnFilters(column));

  $$MazeUndoSnapshotsTableFilterComposer get snapshotIndex {
    final $$MazeUndoSnapshotsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.snapshotIndex,
        referencedTable: $db.mazeUndoSnapshots,
        getReferencedColumn: (t) => t.snapshotIndex,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MazeUndoSnapshotsTableFilterComposer(
              $db: $db,
              $table: $db.mazeUndoSnapshots,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MazeUndoCellStatesTableOrderingComposer
    extends Composer<_$MoodisleDatabase, $MazeUndoCellStatesTable> {
  $$MazeUndoCellStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get floorIndex => $composableBuilder(
      column: $table.floorIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cellKey => $composableBuilder(
      column: $table.cellKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get consumed => $composableBuilder(
      column: $table.consumed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get picked => $composableBuilder(
      column: $table.picked, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get opened => $composableBuilder(
      column: $table.opened, builder: (column) => ColumnOrderings(column));

  $$MazeUndoSnapshotsTableOrderingComposer get snapshotIndex {
    final $$MazeUndoSnapshotsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.snapshotIndex,
        referencedTable: $db.mazeUndoSnapshots,
        getReferencedColumn: (t) => t.snapshotIndex,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MazeUndoSnapshotsTableOrderingComposer(
              $db: $db,
              $table: $db.mazeUndoSnapshots,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MazeUndoCellStatesTableAnnotationComposer
    extends Composer<_$MoodisleDatabase, $MazeUndoCellStatesTable> {
  $$MazeUndoCellStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get floorIndex => $composableBuilder(
      column: $table.floorIndex, builder: (column) => column);

  GeneratedColumn<String> get cellKey =>
      $composableBuilder(column: $table.cellKey, builder: (column) => column);

  GeneratedColumn<bool> get consumed =>
      $composableBuilder(column: $table.consumed, builder: (column) => column);

  GeneratedColumn<bool> get picked =>
      $composableBuilder(column: $table.picked, builder: (column) => column);

  GeneratedColumn<bool> get opened =>
      $composableBuilder(column: $table.opened, builder: (column) => column);

  $$MazeUndoSnapshotsTableAnnotationComposer get snapshotIndex {
    final $$MazeUndoSnapshotsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.snapshotIndex,
            referencedTable: $db.mazeUndoSnapshots,
            getReferencedColumn: (t) => t.snapshotIndex,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MazeUndoSnapshotsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.mazeUndoSnapshots,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$MazeUndoCellStatesTableTableManager extends RootTableManager<
    _$MoodisleDatabase,
    $MazeUndoCellStatesTable,
    MazeUndoCellState,
    $$MazeUndoCellStatesTableFilterComposer,
    $$MazeUndoCellStatesTableOrderingComposer,
    $$MazeUndoCellStatesTableAnnotationComposer,
    $$MazeUndoCellStatesTableCreateCompanionBuilder,
    $$MazeUndoCellStatesTableUpdateCompanionBuilder,
    (MazeUndoCellState, $$MazeUndoCellStatesTableReferences),
    MazeUndoCellState,
    PrefetchHooks Function({bool snapshotIndex})> {
  $$MazeUndoCellStatesTableTableManager(
      _$MoodisleDatabase db, $MazeUndoCellStatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MazeUndoCellStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MazeUndoCellStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MazeUndoCellStatesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> snapshotIndex = const Value.absent(),
            Value<int> floorIndex = const Value.absent(),
            Value<String> cellKey = const Value.absent(),
            Value<bool> consumed = const Value.absent(),
            Value<bool> picked = const Value.absent(),
            Value<bool> opened = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MazeUndoCellStatesCompanion(
            snapshotIndex: snapshotIndex,
            floorIndex: floorIndex,
            cellKey: cellKey,
            consumed: consumed,
            picked: picked,
            opened: opened,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int snapshotIndex,
            required int floorIndex,
            required String cellKey,
            required bool consumed,
            required bool picked,
            required bool opened,
            Value<int> rowid = const Value.absent(),
          }) =>
              MazeUndoCellStatesCompanion.insert(
            snapshotIndex: snapshotIndex,
            floorIndex: floorIndex,
            cellKey: cellKey,
            consumed: consumed,
            picked: picked,
            opened: opened,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$MazeUndoCellStatesTable, MazeUndoCellState>(
                        table),
                    $$MazeUndoCellStatesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({snapshotIndex = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (snapshotIndex) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.snapshotIndex,
                    referencedTable: $$MazeUndoCellStatesTableReferences
                        ._snapshotIndexTable(db),
                    referencedColumn: $$MazeUndoCellStatesTableReferences
                        ._snapshotIndexTable(db)
                        .snapshotIndex,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MazeUndoCellStatesTableProcessedTableManager = ProcessedTableManager<
    _$MoodisleDatabase,
    $MazeUndoCellStatesTable,
    MazeUndoCellState,
    $$MazeUndoCellStatesTableFilterComposer,
    $$MazeUndoCellStatesTableOrderingComposer,
    $$MazeUndoCellStatesTableAnnotationComposer,
    $$MazeUndoCellStatesTableCreateCompanionBuilder,
    $$MazeUndoCellStatesTableUpdateCompanionBuilder,
    (MazeUndoCellState, $$MazeUndoCellStatesTableReferences),
    MazeUndoCellState,
    PrefetchHooks Function({bool snapshotIndex})>;
typedef $$MazeSettlementsTableCreateCompanionBuilder = MazeSettlementsCompanion
    Function({
  Value<int> id,
  required int exp,
  required int clearingGain,
  required bool perfect,
});
typedef $$MazeSettlementsTableUpdateCompanionBuilder = MazeSettlementsCompanion
    Function({
  Value<int> id,
  Value<int> exp,
  Value<int> clearingGain,
  Value<bool> perfect,
});

class $$MazeSettlementsTableFilterComposer
    extends Composer<_$MoodisleDatabase, $MazeSettlementsTable> {
  $$MazeSettlementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get exp => $composableBuilder(
      column: $table.exp, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get clearingGain => $composableBuilder(
      column: $table.clearingGain, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get perfect => $composableBuilder(
      column: $table.perfect, builder: (column) => ColumnFilters(column));
}

class $$MazeSettlementsTableOrderingComposer
    extends Composer<_$MoodisleDatabase, $MazeSettlementsTable> {
  $$MazeSettlementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get exp => $composableBuilder(
      column: $table.exp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get clearingGain => $composableBuilder(
      column: $table.clearingGain,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get perfect => $composableBuilder(
      column: $table.perfect, builder: (column) => ColumnOrderings(column));
}

class $$MazeSettlementsTableAnnotationComposer
    extends Composer<_$MoodisleDatabase, $MazeSettlementsTable> {
  $$MazeSettlementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get exp =>
      $composableBuilder(column: $table.exp, builder: (column) => column);

  GeneratedColumn<int> get clearingGain => $composableBuilder(
      column: $table.clearingGain, builder: (column) => column);

  GeneratedColumn<bool> get perfect =>
      $composableBuilder(column: $table.perfect, builder: (column) => column);
}

class $$MazeSettlementsTableTableManager extends RootTableManager<
    _$MoodisleDatabase,
    $MazeSettlementsTable,
    MazeSettlement,
    $$MazeSettlementsTableFilterComposer,
    $$MazeSettlementsTableOrderingComposer,
    $$MazeSettlementsTableAnnotationComposer,
    $$MazeSettlementsTableCreateCompanionBuilder,
    $$MazeSettlementsTableUpdateCompanionBuilder,
    (
      MazeSettlement,
      BaseReferences<_$MoodisleDatabase, $MazeSettlementsTable, MazeSettlement>
    ),
    MazeSettlement,
    PrefetchHooks Function()> {
  $$MazeSettlementsTableTableManager(
      _$MoodisleDatabase db, $MazeSettlementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MazeSettlementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MazeSettlementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MazeSettlementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> exp = const Value.absent(),
            Value<int> clearingGain = const Value.absent(),
            Value<bool> perfect = const Value.absent(),
          }) =>
              MazeSettlementsCompanion(
            id: id,
            exp: exp,
            clearingGain: clearingGain,
            perfect: perfect,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int exp,
            required int clearingGain,
            required bool perfect,
          }) =>
              MazeSettlementsCompanion.insert(
            id: id,
            exp: exp,
            clearingGain: clearingGain,
            perfect: perfect,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$MazeSettlementsTable, MazeSettlement>(table),
                    BaseReferences<_$MoodisleDatabase, $MazeSettlementsTable,
                        MazeSettlement>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MazeSettlementsTableProcessedTableManager = ProcessedTableManager<
    _$MoodisleDatabase,
    $MazeSettlementsTable,
    MazeSettlement,
    $$MazeSettlementsTableFilterComposer,
    $$MazeSettlementsTableOrderingComposer,
    $$MazeSettlementsTableAnnotationComposer,
    $$MazeSettlementsTableCreateCompanionBuilder,
    $$MazeSettlementsTableUpdateCompanionBuilder,
    (
      MazeSettlement,
      BaseReferences<_$MoodisleDatabase, $MazeSettlementsTable, MazeSettlement>
    ),
    MazeSettlement,
    PrefetchHooks Function()>;
typedef $$MazeSettlementLootRowsTableCreateCompanionBuilder
    = MazeSettlementLootRowsCompanion Function({
  required String itemCode,
  required int quantity,
  Value<int> rowid,
});
typedef $$MazeSettlementLootRowsTableUpdateCompanionBuilder
    = MazeSettlementLootRowsCompanion Function({
  Value<String> itemCode,
  Value<int> quantity,
  Value<int> rowid,
});

final class $$MazeSettlementLootRowsTableReferences extends BaseReferences<
    _$MoodisleDatabase, $MazeSettlementLootRowsTable, MazeSettlementLootRow> {
  $$MazeSettlementLootRowsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ItemCatalogTable _itemCodeTable(_$MoodisleDatabase db) =>
      db.itemCatalog
          .createAlias('maze_settlement_loot__item_code__item_catalog__code');

  $$ItemCatalogTableProcessedTableManager get itemCode {
    final $_column = $_itemColumn<String>('item_code')!;

    final manager = $$ItemCatalogTableTableManager($_db, $_db.itemCatalog)
        .filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MazeSettlementLootRowsTableFilterComposer
    extends Composer<_$MoodisleDatabase, $MazeSettlementLootRowsTable> {
  $$MazeSettlementLootRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  $$ItemCatalogTableFilterComposer get itemCode {
    final $$ItemCatalogTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemCode,
        referencedTable: $db.itemCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemCatalogTableFilterComposer(
              $db: $db,
              $table: $db.itemCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MazeSettlementLootRowsTableOrderingComposer
    extends Composer<_$MoodisleDatabase, $MazeSettlementLootRowsTable> {
  $$MazeSettlementLootRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  $$ItemCatalogTableOrderingComposer get itemCode {
    final $$ItemCatalogTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemCode,
        referencedTable: $db.itemCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemCatalogTableOrderingComposer(
              $db: $db,
              $table: $db.itemCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MazeSettlementLootRowsTableAnnotationComposer
    extends Composer<_$MoodisleDatabase, $MazeSettlementLootRowsTable> {
  $$MazeSettlementLootRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  $$ItemCatalogTableAnnotationComposer get itemCode {
    final $$ItemCatalogTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemCode,
        referencedTable: $db.itemCatalog,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemCatalogTableAnnotationComposer(
              $db: $db,
              $table: $db.itemCatalog,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MazeSettlementLootRowsTableTableManager extends RootTableManager<
    _$MoodisleDatabase,
    $MazeSettlementLootRowsTable,
    MazeSettlementLootRow,
    $$MazeSettlementLootRowsTableFilterComposer,
    $$MazeSettlementLootRowsTableOrderingComposer,
    $$MazeSettlementLootRowsTableAnnotationComposer,
    $$MazeSettlementLootRowsTableCreateCompanionBuilder,
    $$MazeSettlementLootRowsTableUpdateCompanionBuilder,
    (MazeSettlementLootRow, $$MazeSettlementLootRowsTableReferences),
    MazeSettlementLootRow,
    PrefetchHooks Function({bool itemCode})> {
  $$MazeSettlementLootRowsTableTableManager(
      _$MoodisleDatabase db, $MazeSettlementLootRowsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MazeSettlementLootRowsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$MazeSettlementLootRowsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MazeSettlementLootRowsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> itemCode = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MazeSettlementLootRowsCompanion(
            itemCode: itemCode,
            quantity: quantity,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String itemCode,
            required int quantity,
            Value<int> rowid = const Value.absent(),
          }) =>
              MazeSettlementLootRowsCompanion.insert(
            itemCode: itemCode,
            quantity: quantity,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$MazeSettlementLootRowsTable,
                        MazeSettlementLootRow>(table),
                    $$MazeSettlementLootRowsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({itemCode = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (itemCode) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.itemCode,
                    referencedTable: $$MazeSettlementLootRowsTableReferences
                        ._itemCodeTable(db),
                    referencedColumn: $$MazeSettlementLootRowsTableReferences
                        ._itemCodeTable(db)
                        .code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MazeSettlementLootRowsTableProcessedTableManager
    = ProcessedTableManager<
        _$MoodisleDatabase,
        $MazeSettlementLootRowsTable,
        MazeSettlementLootRow,
        $$MazeSettlementLootRowsTableFilterComposer,
        $$MazeSettlementLootRowsTableOrderingComposer,
        $$MazeSettlementLootRowsTableAnnotationComposer,
        $$MazeSettlementLootRowsTableCreateCompanionBuilder,
        $$MazeSettlementLootRowsTableUpdateCompanionBuilder,
        (MazeSettlementLootRow, $$MazeSettlementLootRowsTableReferences),
        MazeSettlementLootRow,
        PrefetchHooks Function({bool itemCode})>;

class $MoodisleDatabaseManager {
  final _$MoodisleDatabase _db;
  $MoodisleDatabaseManager(this._db);
  $$EmotionCatalogTableTableManager get emotionCatalog =>
      $$EmotionCatalogTableTableManager(_db, _db.emotionCatalog);
  $$ItemCatalogTableTableManager get itemCatalog =>
      $$ItemCatalogTableTableManager(_db, _db.itemCatalog);
  $$DailyQuestCatalogTableTableManager get dailyQuestCatalog =>
      $$DailyQuestCatalogTableTableManager(_db, _db.dailyQuestCatalog);
  $$SouvenirCatalogTableTableManager get souvenirCatalog =>
      $$SouvenirCatalogTableTableManager(_db, _db.souvenirCatalog);
  $$PlayerProfilesTableTableManager get playerProfiles =>
      $$PlayerProfilesTableTableManager(_db, _db.playerProfiles);
  $$TaskRowsTableTableManager get taskRows =>
      $$TaskRowsTableTableManager(_db, _db.taskRows);
  $$PetRecordsTableTableManager get petRecords =>
      $$PetRecordsTableTableManager(_db, _db.petRecords);
  $$InventoryRowsTableTableManager get inventoryRows =>
      $$InventoryRowsTableTableManager(_db, _db.inventoryRows);
  $$GameStatisticsTableTableManager get gameStatistics =>
      $$GameStatisticsTableTableManager(_db, _db.gameStatistics);
  $$StreakStatesTableTableManager get streakStates =>
      $$StreakStatesTableTableManager(_db, _db.streakStates);
  $$KeeperStatesTableTableManager get keeperStates =>
      $$KeeperStatesTableTableManager(_db, _db.keeperStates);
  $$ResonanceStatesTableTableManager get resonanceStates =>
      $$ResonanceStatesTableTableManager(_db, _db.resonanceStates);
  $$ClimateStatesTableTableManager get climateStates =>
      $$ClimateStatesTableTableManager(_db, _db.climateStates);
  $$ClimateDaysTableTableManager get climateDays =>
      $$ClimateDaysTableTableManager(_db, _db.climateDays);
  $$FocusMetadataTableTableManager get focusMetadata =>
      $$FocusMetadataTableTableManager(_db, _db.focusMetadata);
  $$ActiveFocusSessionsTableTableManager get activeFocusSessions =>
      $$ActiveFocusSessionsTableTableManager(_db, _db.activeFocusSessions);
  $$DailyStatesTableTableManager get dailyStates =>
      $$DailyStatesTableTableManager(_db, _db.dailyStates);
  $$DailyQuestProgressRowsTableTableManager get dailyQuestProgressRows =>
      $$DailyQuestProgressRowsTableTableManager(
          _db, _db.dailyQuestProgressRows);
  $$AchievementUnlocksTableTableManager get achievementUnlocks =>
      $$AchievementUnlocksTableTableManager(_db, _db.achievementUnlocks);
  $$RoamSlotsTableTableManager get roamSlots =>
      $$RoamSlotsTableTableManager(_db, _db.roamSlots);
  $$SouvenirInventoryRowsTableTableManager get souvenirInventoryRows =>
      $$SouvenirInventoryRowsTableTableManager(_db, _db.souvenirInventoryRows);
  $$SocialProfilesTableTableManager get socialProfiles =>
      $$SocialProfilesTableTableManager(_db, _db.socialProfiles);
  $$PostcardsTableTableManager get postcards =>
      $$PostcardsTableTableManager(_db, _db.postcards);
  $$ActiveMazeRunsTableTableManager get activeMazeRuns =>
      $$ActiveMazeRunsTableTableManager(_db, _db.activeMazeRuns);
  $$MazeCellStatesTableTableManager get mazeCellStates =>
      $$MazeCellStatesTableTableManager(_db, _db.mazeCellStates);
  $$MazeUndoSnapshotsTableTableManager get mazeUndoSnapshots =>
      $$MazeUndoSnapshotsTableTableManager(_db, _db.mazeUndoSnapshots);
  $$MazeUndoCellStatesTableTableManager get mazeUndoCellStates =>
      $$MazeUndoCellStatesTableTableManager(_db, _db.mazeUndoCellStates);
  $$MazeSettlementsTableTableManager get mazeSettlements =>
      $$MazeSettlementsTableTableManager(_db, _db.mazeSettlements);
  $$MazeSettlementLootRowsTableTableManager get mazeSettlementLootRows =>
      $$MazeSettlementLootRowsTableTableManager(
          _db, _db.mazeSettlementLootRows);
}
