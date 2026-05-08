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
  int? get mois =>
      throw _privateConstructorUsedError; // 1-12 ; null = enregistrement annuel (legacy)
  double get montantPaye => throw _privateConstructorUsedError;
  double? get montantDu =>
      throw _privateConstructorUsedError; // montant attendu pour ce mois (ex. 10 €)
  String get statut =>
      throw _privateConstructorUsedError; // payee | partiel | en_retard | en_attente
  String get createdBy => throw _privateConstructorUsedError;
  String? get uniteId =>
      throw _privateConstructorUsedError; // dénormalisé depuis militants.unite_id
  String? get modePaiement =>
      throw _privateConstructorUsedError; // espèces | virement | paypal | lydia...
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
    int? mois,
    double montantPaye,
    double? montantDu,
    String statut,
    String createdBy,
    String? uniteId,
    String? modePaiement,
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
    Object? mois = freezed,
    Object? montantPaye = null,
    Object? montantDu = freezed,
    Object? statut = null,
    Object? createdBy = null,
    Object? uniteId = freezed,
    Object? modePaiement = freezed,
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
            mois: freezed == mois
                ? _value.mois
                : mois // ignore: cast_nullable_to_non_nullable
                      as int?,
            montantPaye: null == montantPaye
                ? _value.montantPaye
                : montantPaye // ignore: cast_nullable_to_non_nullable
                      as double,
            montantDu: freezed == montantDu
                ? _value.montantDu
                : montantDu // ignore: cast_nullable_to_non_nullable
                      as double?,
            statut: null == statut
                ? _value.statut
                : statut // ignore: cast_nullable_to_non_nullable
                      as String,
            createdBy: null == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as String,
            uniteId: freezed == uniteId
                ? _value.uniteId
                : uniteId // ignore: cast_nullable_to_non_nullable
                      as String?,
            modePaiement: freezed == modePaiement
                ? _value.modePaiement
                : modePaiement // ignore: cast_nullable_to_non_nullable
                      as String?,
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
    int? mois,
    double montantPaye,
    double? montantDu,
    String statut,
    String createdBy,
    String? uniteId,
    String? modePaiement,
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
    Object? mois = freezed,
    Object? montantPaye = null,
    Object? montantDu = freezed,
    Object? statut = null,
    Object? createdBy = null,
    Object? uniteId = freezed,
    Object? modePaiement = freezed,
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
        mois: freezed == mois
            ? _value.mois
            : mois // ignore: cast_nullable_to_non_nullable
                  as int?,
        montantPaye: null == montantPaye
            ? _value.montantPaye
            : montantPaye // ignore: cast_nullable_to_non_nullable
                  as double,
        montantDu: freezed == montantDu
            ? _value.montantDu
            : montantDu // ignore: cast_nullable_to_non_nullable
                  as double?,
        statut: null == statut
            ? _value.statut
            : statut // ignore: cast_nullable_to_non_nullable
                  as String,
        createdBy: null == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String,
        uniteId: freezed == uniteId
            ? _value.uniteId
            : uniteId // ignore: cast_nullable_to_non_nullable
                  as String?,
        modePaiement: freezed == modePaiement
            ? _value.modePaiement
            : modePaiement // ignore: cast_nullable_to_non_nullable
                  as String?,
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
    this.mois,
    required this.montantPaye,
    this.montantDu,
    required this.statut,
    required this.createdBy,
    this.uniteId,
    this.modePaiement,
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
  final int? mois;
  // 1-12 ; null = enregistrement annuel (legacy)
  @override
  final double montantPaye;
  @override
  final double? montantDu;
  // montant attendu pour ce mois (ex. 10 €)
  @override
  final String statut;
  // payee | partiel | en_retard | en_attente
  @override
  final String createdBy;
  @override
  final String? uniteId;
  // dénormalisé depuis militants.unite_id
  @override
  final String? modePaiement;
  // espèces | virement | paypal | lydia...
  @override
  final DateTime? datePaiement;
  @override
  final String? transactionId;

  @override
  String toString() {
    return 'Cotisation(id: $id, militantId: $militantId, annee: $annee, mois: $mois, montantPaye: $montantPaye, montantDu: $montantDu, statut: $statut, createdBy: $createdBy, uniteId: $uniteId, modePaiement: $modePaiement, datePaiement: $datePaiement, transactionId: $transactionId)';
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
            (identical(other.mois, mois) || other.mois == mois) &&
            (identical(other.montantPaye, montantPaye) ||
                other.montantPaye == montantPaye) &&
            (identical(other.montantDu, montantDu) ||
                other.montantDu == montantDu) &&
            (identical(other.statut, statut) || other.statut == statut) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.uniteId, uniteId) || other.uniteId == uniteId) &&
            (identical(other.modePaiement, modePaiement) ||
                other.modePaiement == modePaiement) &&
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
    mois,
    montantPaye,
    montantDu,
    statut,
    createdBy,
    uniteId,
    modePaiement,
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
    final int? mois,
    required final double montantPaye,
    final double? montantDu,
    required final String statut,
    required final String createdBy,
    final String? uniteId,
    final String? modePaiement,
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
  int? get mois; // 1-12 ; null = enregistrement annuel (legacy)
  @override
  double get montantPaye;
  @override
  double? get montantDu; // montant attendu pour ce mois (ex. 10 €)
  @override
  String get statut; // payee | partiel | en_retard | en_attente
  @override
  String get createdBy;
  @override
  String? get uniteId; // dénormalisé depuis militants.unite_id
  @override
  String? get modePaiement; // espèces | virement | paypal | lydia...
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
