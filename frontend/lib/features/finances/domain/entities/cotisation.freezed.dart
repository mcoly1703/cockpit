// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cotisation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Cotisation {
  String get id => throw _privateConstructorUsedError;
  String get militantId => throw _privateConstructorUsedError;
  int get annee => throw _privateConstructorUsedError;
  double get montant => throw _privateConstructorUsedError;
  String get statut => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  DateTime? get datePaiement => throw _privateConstructorUsedError;
  String? get transactionId => throw _privateConstructorUsedError;

  /// Create a copy of Cotisation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CotisationCopyWith<Cotisation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CotisationCopyWith<$Res> {
  factory $CotisationCopyWith(
    Cotisation value,
    $Res Function(Cotisation) then,
  ) = _$CotisationCopyWithImpl<$Res, Cotisation>;
  @useResult
  $Res call({
    String id,
    String militantId,
    int annee,
    double montant,
    String statut,
    String createdBy,
    DateTime? datePaiement,
    String? transactionId,
  });
}

/// @nodoc
class _$CotisationCopyWithImpl<$Res, $Val extends Cotisation>
    implements $CotisationCopyWith<$Res> {
  _$CotisationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Cotisation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? militantId = null,
    Object? annee = null,
    Object? montant = null,
    Object? statut = null,
    Object? createdBy = null,
    Object? datePaiement = freezed,
    Object? transactionId = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            militantId: null == militantId
                ? _value.militantId
                : militantId // ignore: cast_nullable_to_non_nullable
                      as String,
            annee: null == annee
                ? _value.annee
                : annee // ignore: cast_nullable_to_non_nullable
                      as int,
            montant: null == montant
                ? _value.montant
                : montant // ignore: cast_nullable_to_non_nullable
                      as double,
            statut: null == statut
                ? _value.statut
                : statut // ignore: cast_nullable_to_non_nullable
                      as String,
            createdBy: null == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as String,
            datePaiement: freezed == datePaiement
                ? _value.datePaiement
                : datePaiement // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            transactionId: freezed == transactionId
                ? _value.transactionId
                : transactionId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CotisationImplCopyWith<$Res>
    implements $CotisationCopyWith<$Res> {
  factory _$$CotisationImplCopyWith(
    _$CotisationImpl value,
    $Res Function(_$CotisationImpl) then,
  ) = __$$CotisationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String militantId,
    int annee,
    double montant,
    String statut,
    String createdBy,
    DateTime? datePaiement,
    String? transactionId,
  });
}

/// @nodoc
class __$$CotisationImplCopyWithImpl<$Res>
    extends _$CotisationCopyWithImpl<$Res, _$CotisationImpl>
    implements _$$CotisationImplCopyWith<$Res> {
  __$$CotisationImplCopyWithImpl(
    _$CotisationImpl _value,
    $Res Function(_$CotisationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Cotisation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? militantId = null,
    Object? annee = null,
    Object? montant = null,
    Object? statut = null,
    Object? createdBy = null,
    Object? datePaiement = freezed,
    Object? transactionId = freezed,
  }) {
    return _then(
      _$CotisationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        militantId: null == militantId
            ? _value.militantId
            : militantId // ignore: cast_nullable_to_non_nullable
                  as String,
        annee: null == annee
            ? _value.annee
            : annee // ignore: cast_nullable_to_non_nullable
                  as int,
        montant: null == montant
            ? _value.montant
            : montant // ignore: cast_nullable_to_non_nullable
                  as double,
        statut: null == statut
            ? _value.statut
            : statut // ignore: cast_nullable_to_non_nullable
                  as String,
        createdBy: null == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String,
        datePaiement: freezed == datePaiement
            ? _value.datePaiement
            : datePaiement // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        transactionId: freezed == transactionId
            ? _value.transactionId
            : transactionId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$CotisationImpl implements _Cotisation {
  const _$CotisationImpl({
    required this.id,
    required this.militantId,
    required this.annee,
    required this.montant,
    required this.statut,
    required this.createdBy,
    this.datePaiement,
    this.transactionId,
  });

  @override
  final String id;
  @override
  final String militantId;
  @override
  final int annee;
  @override
  final double montant;
  @override
  final String statut;
  @override
  final String createdBy;
  @override
  final DateTime? datePaiement;
  @override
  final String? transactionId;

  @override
  String toString() {
    return 'Cotisation(id: $id, militantId: $militantId, annee: $annee, montant: $montant, statut: $statut, createdBy: $createdBy, datePaiement: $datePaiement, transactionId: $transactionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CotisationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.militantId, militantId) ||
                other.militantId == militantId) &&
            (identical(other.annee, annee) || other.annee == annee) &&
            (identical(other.montant, montant) || other.montant == montant) &&
            (identical(other.statut, statut) || other.statut == statut) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.datePaiement, datePaiement) ||
                other.datePaiement == datePaiement) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    militantId,
    annee,
    montant,
    statut,
    createdBy,
    datePaiement,
    transactionId,
  );

  /// Create a copy of Cotisation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CotisationImplCopyWith<_$CotisationImpl> get copyWith =>
      __$$CotisationImplCopyWithImpl<_$CotisationImpl>(this, _$identity);
}

abstract class _Cotisation implements Cotisation {
  const factory _Cotisation({
    required final String id,
    required final String militantId,
    required final int annee,
    required final double montant,
    required final String statut,
    required final String createdBy,
    final DateTime? datePaiement,
    final String? transactionId,
  }) = _$CotisationImpl;

  @override
  String get id;
  @override
  String get militantId;
  @override
  int get annee;
  @override
  double get montant;
  @override
  String get statut;
  @override
  String get createdBy;
  @override
  DateTime? get datePaiement;
  @override
  String? get transactionId;

  /// Create a copy of Cotisation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CotisationImplCopyWith<_$CotisationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
