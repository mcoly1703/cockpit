// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'espace_cotisation_mois.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$EspaceCotisationMois {
  int get mois => throw _privateConstructorUsedError;
  int get annee => throw _privateConstructorUsedError;
  double get montantPaye => throw _privateConstructorUsedError;
  double? get montantDu => throw _privateConstructorUsedError;
  String get statut => throw _privateConstructorUsedError;

  /// Create a copy of EspaceCotisationMois
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EspaceCotisationMoisCopyWith<EspaceCotisationMois> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EspaceCotisationMoisCopyWith<$Res> {
  factory $EspaceCotisationMoisCopyWith(
    EspaceCotisationMois value,
    $Res Function(EspaceCotisationMois) then,
  ) = _$EspaceCotisationMoisCopyWithImpl<$Res, EspaceCotisationMois>;
  @useResult
  $Res call({
    int mois,
    int annee,
    double montantPaye,
    double? montantDu,
    String statut,
  });
}

/// @nodoc
class _$EspaceCotisationMoisCopyWithImpl<
  $Res,
  $Val extends EspaceCotisationMois
>
    implements $EspaceCotisationMoisCopyWith<$Res> {
  _$EspaceCotisationMoisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EspaceCotisationMois
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mois = null,
    Object? annee = null,
    Object? montantPaye = null,
    Object? montantDu = freezed,
    Object? statut = null,
  }) {
    return _then(
      _value.copyWith(
            mois: null == mois
                ? _value.mois
                : mois // ignore: cast_nullable_to_non_nullable
                      as int,
            annee: null == annee
                ? _value.annee
                : annee // ignore: cast_nullable_to_non_nullable
                      as int,
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EspaceCotisationMoisImplCopyWith<$Res>
    implements $EspaceCotisationMoisCopyWith<$Res> {
  factory _$$EspaceCotisationMoisImplCopyWith(
    _$EspaceCotisationMoisImpl value,
    $Res Function(_$EspaceCotisationMoisImpl) then,
  ) = __$$EspaceCotisationMoisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int mois,
    int annee,
    double montantPaye,
    double? montantDu,
    String statut,
  });
}

/// @nodoc
class __$$EspaceCotisationMoisImplCopyWithImpl<$Res>
    extends _$EspaceCotisationMoisCopyWithImpl<$Res, _$EspaceCotisationMoisImpl>
    implements _$$EspaceCotisationMoisImplCopyWith<$Res> {
  __$$EspaceCotisationMoisImplCopyWithImpl(
    _$EspaceCotisationMoisImpl _value,
    $Res Function(_$EspaceCotisationMoisImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EspaceCotisationMois
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mois = null,
    Object? annee = null,
    Object? montantPaye = null,
    Object? montantDu = freezed,
    Object? statut = null,
  }) {
    return _then(
      _$EspaceCotisationMoisImpl(
        mois: null == mois
            ? _value.mois
            : mois // ignore: cast_nullable_to_non_nullable
                  as int,
        annee: null == annee
            ? _value.annee
            : annee // ignore: cast_nullable_to_non_nullable
                  as int,
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
      ),
    );
  }
}

/// @nodoc

class _$EspaceCotisationMoisImpl implements _EspaceCotisationMois {
  const _$EspaceCotisationMoisImpl({
    required this.mois,
    required this.annee,
    required this.montantPaye,
    this.montantDu,
    required this.statut,
  });

  @override
  final int mois;
  @override
  final int annee;
  @override
  final double montantPaye;
  @override
  final double? montantDu;
  @override
  final String statut;

  @override
  String toString() {
    return 'EspaceCotisationMois(mois: $mois, annee: $annee, montantPaye: $montantPaye, montantDu: $montantDu, statut: $statut)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EspaceCotisationMoisImpl &&
            (identical(other.mois, mois) || other.mois == mois) &&
            (identical(other.annee, annee) || other.annee == annee) &&
            (identical(other.montantPaye, montantPaye) ||
                other.montantPaye == montantPaye) &&
            (identical(other.montantDu, montantDu) ||
                other.montantDu == montantDu) &&
            (identical(other.statut, statut) || other.statut == statut));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, mois, annee, montantPaye, montantDu, statut);

  /// Create a copy of EspaceCotisationMois
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EspaceCotisationMoisImplCopyWith<_$EspaceCotisationMoisImpl>
  get copyWith =>
      __$$EspaceCotisationMoisImplCopyWithImpl<_$EspaceCotisationMoisImpl>(
        this,
        _$identity,
      );
}

abstract class _EspaceCotisationMois implements EspaceCotisationMois {
  const factory _EspaceCotisationMois({
    required final int mois,
    required final int annee,
    required final double montantPaye,
    final double? montantDu,
    required final String statut,
  }) = _$EspaceCotisationMoisImpl;

  @override
  int get mois;
  @override
  int get annee;
  @override
  double get montantPaye;
  @override
  double? get montantDu;
  @override
  String get statut;

  /// Create a copy of EspaceCotisationMois
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EspaceCotisationMoisImplCopyWith<_$EspaceCotisationMoisImpl>
  get copyWith => throw _privateConstructorUsedError;
}
