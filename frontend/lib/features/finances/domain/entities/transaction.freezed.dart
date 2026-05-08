// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Transaction {
  String get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get categorie => throw _privateConstructorUsedError;
  double get montant => throw _privateConstructorUsedError;
  DateTime get dateTransaction => throw _privateConstructorUsedError;
  String get uniteId => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get beneficiaire => throw _privateConstructorUsedError;
  String? get pieceJustificativeUrl => throw _privateConstructorUsedError;
  String? get militantId => throw _privateConstructorUsedError;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionCopyWith<Transaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionCopyWith<$Res> {
  factory $TransactionCopyWith(
    Transaction value,
    $Res Function(Transaction) then,
  ) = _$TransactionCopyWithImpl<$Res, Transaction>;
  @useResult
  $Res call({
    String id,
    String type,
    String categorie,
    double montant,
    DateTime dateTransaction,
    String uniteId,
    String createdBy,
    String? description,
    String? beneficiaire,
    String? pieceJustificativeUrl,
    String? militantId,
  });
}

/// @nodoc
class _$TransactionCopyWithImpl<$Res, $Val extends Transaction>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? categorie = null,
    Object? montant = null,
    Object? dateTransaction = null,
    Object? uniteId = null,
    Object? createdBy = null,
    Object? description = freezed,
    Object? beneficiaire = freezed,
    Object? pieceJustificativeUrl = freezed,
    Object? militantId = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            categorie: null == categorie
                ? _value.categorie
                : categorie // ignore: cast_nullable_to_non_nullable
                      as String,
            montant: null == montant
                ? _value.montant
                : montant // ignore: cast_nullable_to_non_nullable
                      as double,
            dateTransaction: null == dateTransaction
                ? _value.dateTransaction
                : dateTransaction // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            uniteId: null == uniteId
                ? _value.uniteId
                : uniteId // ignore: cast_nullable_to_non_nullable
                      as String,
            createdBy: null == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            beneficiaire: freezed == beneficiaire
                ? _value.beneficiaire
                : beneficiaire // ignore: cast_nullable_to_non_nullable
                      as String?,
            pieceJustificativeUrl: freezed == pieceJustificativeUrl
                ? _value.pieceJustificativeUrl
                : pieceJustificativeUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            militantId: freezed == militantId
                ? _value.militantId
                : militantId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransactionImplCopyWith<$Res>
    implements $TransactionCopyWith<$Res> {
  factory _$$TransactionImplCopyWith(
    _$TransactionImpl value,
    $Res Function(_$TransactionImpl) then,
  ) = __$$TransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String type,
    String categorie,
    double montant,
    DateTime dateTransaction,
    String uniteId,
    String createdBy,
    String? description,
    String? beneficiaire,
    String? pieceJustificativeUrl,
    String? militantId,
  });
}

/// @nodoc
class __$$TransactionImplCopyWithImpl<$Res>
    extends _$TransactionCopyWithImpl<$Res, _$TransactionImpl>
    implements _$$TransactionImplCopyWith<$Res> {
  __$$TransactionImplCopyWithImpl(
    _$TransactionImpl _value,
    $Res Function(_$TransactionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? categorie = null,
    Object? montant = null,
    Object? dateTransaction = null,
    Object? uniteId = null,
    Object? createdBy = null,
    Object? description = freezed,
    Object? beneficiaire = freezed,
    Object? pieceJustificativeUrl = freezed,
    Object? militantId = freezed,
  }) {
    return _then(
      _$TransactionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        categorie: null == categorie
            ? _value.categorie
            : categorie // ignore: cast_nullable_to_non_nullable
                  as String,
        montant: null == montant
            ? _value.montant
            : montant // ignore: cast_nullable_to_non_nullable
                  as double,
        dateTransaction: null == dateTransaction
            ? _value.dateTransaction
            : dateTransaction // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        uniteId: null == uniteId
            ? _value.uniteId
            : uniteId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdBy: null == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        beneficiaire: freezed == beneficiaire
            ? _value.beneficiaire
            : beneficiaire // ignore: cast_nullable_to_non_nullable
                  as String?,
        pieceJustificativeUrl: freezed == pieceJustificativeUrl
            ? _value.pieceJustificativeUrl
            : pieceJustificativeUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        militantId: freezed == militantId
            ? _value.militantId
            : militantId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$TransactionImpl implements _Transaction {
  const _$TransactionImpl({
    required this.id,
    required this.type,
    required this.categorie,
    required this.montant,
    required this.dateTransaction,
    required this.uniteId,
    required this.createdBy,
    this.description,
    this.beneficiaire,
    this.pieceJustificativeUrl,
    this.militantId,
  });

  @override
  final String id;
  @override
  final String type;
  @override
  final String categorie;
  @override
  final double montant;
  @override
  final DateTime dateTransaction;
  @override
  final String uniteId;
  @override
  final String createdBy;
  @override
  final String? description;
  @override
  final String? beneficiaire;
  @override
  final String? pieceJustificativeUrl;
  @override
  final String? militantId;

  @override
  String toString() {
    return 'Transaction(id: $id, type: $type, categorie: $categorie, montant: $montant, dateTransaction: $dateTransaction, uniteId: $uniteId, createdBy: $createdBy, description: $description, beneficiaire: $beneficiaire, pieceJustificativeUrl: $pieceJustificativeUrl, militantId: $militantId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.categorie, categorie) ||
                other.categorie == categorie) &&
            (identical(other.montant, montant) || other.montant == montant) &&
            (identical(other.dateTransaction, dateTransaction) ||
                other.dateTransaction == dateTransaction) &&
            (identical(other.uniteId, uniteId) || other.uniteId == uniteId) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.beneficiaire, beneficiaire) ||
                other.beneficiaire == beneficiaire) &&
            (identical(other.pieceJustificativeUrl, pieceJustificativeUrl) ||
                other.pieceJustificativeUrl == pieceJustificativeUrl) &&
            (identical(other.militantId, militantId) ||
                other.militantId == militantId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    categorie,
    montant,
    dateTransaction,
    uniteId,
    createdBy,
    description,
    beneficiaire,
    pieceJustificativeUrl,
    militantId,
  );

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      __$$TransactionImplCopyWithImpl<_$TransactionImpl>(this, _$identity);
}

abstract class _Transaction implements Transaction {
  const factory _Transaction({
    required final String id,
    required final String type,
    required final String categorie,
    required final double montant,
    required final DateTime dateTransaction,
    required final String uniteId,
    required final String createdBy,
    final String? description,
    final String? beneficiaire,
    final String? pieceJustificativeUrl,
    final String? militantId,
  }) = _$TransactionImpl;

  @override
  String get id;
  @override
  String get type;
  @override
  String get categorie;
  @override
  double get montant;
  @override
  DateTime get dateTransaction;
  @override
  String get uniteId;
  @override
  String get createdBy;
  @override
  String? get description;
  @override
  String? get beneficiaire;
  @override
  String? get pieceJustificativeUrl;
  @override
  String? get militantId;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
