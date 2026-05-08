// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resultat_scan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ResultatScan {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String? statutCotis,
    )
    valide,
    required TResult Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String periodeRetard,
    )
    retard,
    required TResult Function(String nom, String prenom) suspendu,
    required TResult Function() inconnu,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String? statutCotis,
    )?
    valide,
    TResult? Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String periodeRetard,
    )?
    retard,
    TResult? Function(String nom, String prenom)? suspendu,
    TResult? Function()? inconnu,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String? statutCotis,
    )?
    valide,
    TResult Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String periodeRetard,
    )?
    retard,
    TResult Function(String nom, String prenom)? suspendu,
    TResult Function()? inconnu,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Valide value) valide,
    required TResult Function(_Retard value) retard,
    required TResult Function(_Suspendu value) suspendu,
    required TResult Function(_Inconnu value) inconnu,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Valide value)? valide,
    TResult? Function(_Retard value)? retard,
    TResult? Function(_Suspendu value)? suspendu,
    TResult? Function(_Inconnu value)? inconnu,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Valide value)? valide,
    TResult Function(_Retard value)? retard,
    TResult Function(_Suspendu value)? suspendu,
    TResult Function(_Inconnu value)? inconnu,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResultatScanCopyWith<$Res> {
  factory $ResultatScanCopyWith(
    ResultatScan value,
    $Res Function(ResultatScan) then,
  ) = _$ResultatScanCopyWithImpl<$Res, ResultatScan>;
}

/// @nodoc
class _$ResultatScanCopyWithImpl<$Res, $Val extends ResultatScan>
    implements $ResultatScanCopyWith<$Res> {
  _$ResultatScanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResultatScan
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ValideImplCopyWith<$Res> {
  factory _$$ValideImplCopyWith(
    _$ValideImpl value,
    $Res Function(_$ValideImpl) then,
  ) = __$$ValideImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    String nom,
    String prenom,
    String? numeroCarte,
    String? statutCotis,
  });
}

/// @nodoc
class __$$ValideImplCopyWithImpl<$Res>
    extends _$ResultatScanCopyWithImpl<$Res, _$ValideImpl>
    implements _$$ValideImplCopyWith<$Res> {
  __$$ValideImplCopyWithImpl(
    _$ValideImpl _value,
    $Res Function(_$ValideImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ResultatScan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nom = null,
    Object? prenom = null,
    Object? numeroCarte = freezed,
    Object? statutCotis = freezed,
  }) {
    return _then(
      _$ValideImpl(
        nom: null == nom
            ? _value.nom
            : nom // ignore: cast_nullable_to_non_nullable
                  as String,
        prenom: null == prenom
            ? _value.prenom
            : prenom // ignore: cast_nullable_to_non_nullable
                  as String,
        numeroCarte: freezed == numeroCarte
            ? _value.numeroCarte
            : numeroCarte // ignore: cast_nullable_to_non_nullable
                  as String?,
        statutCotis: freezed == statutCotis
            ? _value.statutCotis
            : statutCotis // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$ValideImpl implements _Valide {
  const _$ValideImpl({
    required this.nom,
    required this.prenom,
    this.numeroCarte,
    this.statutCotis,
  });

  @override
  final String nom;
  @override
  final String prenom;
  @override
  final String? numeroCarte;
  @override
  final String? statutCotis;

  @override
  String toString() {
    return 'ResultatScan.valide(nom: $nom, prenom: $prenom, numeroCarte: $numeroCarte, statutCotis: $statutCotis)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValideImpl &&
            (identical(other.nom, nom) || other.nom == nom) &&
            (identical(other.prenom, prenom) || other.prenom == prenom) &&
            (identical(other.numeroCarte, numeroCarte) ||
                other.numeroCarte == numeroCarte) &&
            (identical(other.statutCotis, statutCotis) ||
                other.statutCotis == statutCotis));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, nom, prenom, numeroCarte, statutCotis);

  /// Create a copy of ResultatScan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ValideImplCopyWith<_$ValideImpl> get copyWith =>
      __$$ValideImplCopyWithImpl<_$ValideImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String? statutCotis,
    )
    valide,
    required TResult Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String periodeRetard,
    )
    retard,
    required TResult Function(String nom, String prenom) suspendu,
    required TResult Function() inconnu,
  }) {
    return valide(nom, prenom, numeroCarte, statutCotis);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String? statutCotis,
    )?
    valide,
    TResult? Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String periodeRetard,
    )?
    retard,
    TResult? Function(String nom, String prenom)? suspendu,
    TResult? Function()? inconnu,
  }) {
    return valide?.call(nom, prenom, numeroCarte, statutCotis);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String? statutCotis,
    )?
    valide,
    TResult Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String periodeRetard,
    )?
    retard,
    TResult Function(String nom, String prenom)? suspendu,
    TResult Function()? inconnu,
    required TResult orElse(),
  }) {
    if (valide != null) {
      return valide(nom, prenom, numeroCarte, statutCotis);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Valide value) valide,
    required TResult Function(_Retard value) retard,
    required TResult Function(_Suspendu value) suspendu,
    required TResult Function(_Inconnu value) inconnu,
  }) {
    return valide(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Valide value)? valide,
    TResult? Function(_Retard value)? retard,
    TResult? Function(_Suspendu value)? suspendu,
    TResult? Function(_Inconnu value)? inconnu,
  }) {
    return valide?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Valide value)? valide,
    TResult Function(_Retard value)? retard,
    TResult Function(_Suspendu value)? suspendu,
    TResult Function(_Inconnu value)? inconnu,
    required TResult orElse(),
  }) {
    if (valide != null) {
      return valide(this);
    }
    return orElse();
  }
}

abstract class _Valide implements ResultatScan {
  const factory _Valide({
    required final String nom,
    required final String prenom,
    final String? numeroCarte,
    final String? statutCotis,
  }) = _$ValideImpl;

  String get nom;
  String get prenom;
  String? get numeroCarte;
  String? get statutCotis;

  /// Create a copy of ResultatScan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ValideImplCopyWith<_$ValideImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RetardImplCopyWith<$Res> {
  factory _$$RetardImplCopyWith(
    _$RetardImpl value,
    $Res Function(_$RetardImpl) then,
  ) = __$$RetardImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    String nom,
    String prenom,
    String? numeroCarte,
    String periodeRetard,
  });
}

/// @nodoc
class __$$RetardImplCopyWithImpl<$Res>
    extends _$ResultatScanCopyWithImpl<$Res, _$RetardImpl>
    implements _$$RetardImplCopyWith<$Res> {
  __$$RetardImplCopyWithImpl(
    _$RetardImpl _value,
    $Res Function(_$RetardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ResultatScan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nom = null,
    Object? prenom = null,
    Object? numeroCarte = freezed,
    Object? periodeRetard = null,
  }) {
    return _then(
      _$RetardImpl(
        nom: null == nom
            ? _value.nom
            : nom // ignore: cast_nullable_to_non_nullable
                  as String,
        prenom: null == prenom
            ? _value.prenom
            : prenom // ignore: cast_nullable_to_non_nullable
                  as String,
        numeroCarte: freezed == numeroCarte
            ? _value.numeroCarte
            : numeroCarte // ignore: cast_nullable_to_non_nullable
                  as String?,
        periodeRetard: null == periodeRetard
            ? _value.periodeRetard
            : periodeRetard // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$RetardImpl implements _Retard {
  const _$RetardImpl({
    required this.nom,
    required this.prenom,
    this.numeroCarte,
    required this.periodeRetard,
  });

  @override
  final String nom;
  @override
  final String prenom;
  @override
  final String? numeroCarte;
  @override
  final String periodeRetard;

  @override
  String toString() {
    return 'ResultatScan.retard(nom: $nom, prenom: $prenom, numeroCarte: $numeroCarte, periodeRetard: $periodeRetard)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RetardImpl &&
            (identical(other.nom, nom) || other.nom == nom) &&
            (identical(other.prenom, prenom) || other.prenom == prenom) &&
            (identical(other.numeroCarte, numeroCarte) ||
                other.numeroCarte == numeroCarte) &&
            (identical(other.periodeRetard, periodeRetard) ||
                other.periodeRetard == periodeRetard));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, nom, prenom, numeroCarte, periodeRetard);

  /// Create a copy of ResultatScan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RetardImplCopyWith<_$RetardImpl> get copyWith =>
      __$$RetardImplCopyWithImpl<_$RetardImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String? statutCotis,
    )
    valide,
    required TResult Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String periodeRetard,
    )
    retard,
    required TResult Function(String nom, String prenom) suspendu,
    required TResult Function() inconnu,
  }) {
    return retard(nom, prenom, numeroCarte, periodeRetard);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String? statutCotis,
    )?
    valide,
    TResult? Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String periodeRetard,
    )?
    retard,
    TResult? Function(String nom, String prenom)? suspendu,
    TResult? Function()? inconnu,
  }) {
    return retard?.call(nom, prenom, numeroCarte, periodeRetard);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String? statutCotis,
    )?
    valide,
    TResult Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String periodeRetard,
    )?
    retard,
    TResult Function(String nom, String prenom)? suspendu,
    TResult Function()? inconnu,
    required TResult orElse(),
  }) {
    if (retard != null) {
      return retard(nom, prenom, numeroCarte, periodeRetard);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Valide value) valide,
    required TResult Function(_Retard value) retard,
    required TResult Function(_Suspendu value) suspendu,
    required TResult Function(_Inconnu value) inconnu,
  }) {
    return retard(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Valide value)? valide,
    TResult? Function(_Retard value)? retard,
    TResult? Function(_Suspendu value)? suspendu,
    TResult? Function(_Inconnu value)? inconnu,
  }) {
    return retard?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Valide value)? valide,
    TResult Function(_Retard value)? retard,
    TResult Function(_Suspendu value)? suspendu,
    TResult Function(_Inconnu value)? inconnu,
    required TResult orElse(),
  }) {
    if (retard != null) {
      return retard(this);
    }
    return orElse();
  }
}

abstract class _Retard implements ResultatScan {
  const factory _Retard({
    required final String nom,
    required final String prenom,
    final String? numeroCarte,
    required final String periodeRetard,
  }) = _$RetardImpl;

  String get nom;
  String get prenom;
  String? get numeroCarte;
  String get periodeRetard;

  /// Create a copy of ResultatScan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RetardImplCopyWith<_$RetardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SuspenduImplCopyWith<$Res> {
  factory _$$SuspenduImplCopyWith(
    _$SuspenduImpl value,
    $Res Function(_$SuspenduImpl) then,
  ) = __$$SuspenduImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String nom, String prenom});
}

/// @nodoc
class __$$SuspenduImplCopyWithImpl<$Res>
    extends _$ResultatScanCopyWithImpl<$Res, _$SuspenduImpl>
    implements _$$SuspenduImplCopyWith<$Res> {
  __$$SuspenduImplCopyWithImpl(
    _$SuspenduImpl _value,
    $Res Function(_$SuspenduImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ResultatScan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? nom = null, Object? prenom = null}) {
    return _then(
      _$SuspenduImpl(
        nom: null == nom
            ? _value.nom
            : nom // ignore: cast_nullable_to_non_nullable
                  as String,
        prenom: null == prenom
            ? _value.prenom
            : prenom // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SuspenduImpl implements _Suspendu {
  const _$SuspenduImpl({required this.nom, required this.prenom});

  @override
  final String nom;
  @override
  final String prenom;

  @override
  String toString() {
    return 'ResultatScan.suspendu(nom: $nom, prenom: $prenom)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuspenduImpl &&
            (identical(other.nom, nom) || other.nom == nom) &&
            (identical(other.prenom, prenom) || other.prenom == prenom));
  }

  @override
  int get hashCode => Object.hash(runtimeType, nom, prenom);

  /// Create a copy of ResultatScan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuspenduImplCopyWith<_$SuspenduImpl> get copyWith =>
      __$$SuspenduImplCopyWithImpl<_$SuspenduImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String? statutCotis,
    )
    valide,
    required TResult Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String periodeRetard,
    )
    retard,
    required TResult Function(String nom, String prenom) suspendu,
    required TResult Function() inconnu,
  }) {
    return suspendu(nom, prenom);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String? statutCotis,
    )?
    valide,
    TResult? Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String periodeRetard,
    )?
    retard,
    TResult? Function(String nom, String prenom)? suspendu,
    TResult? Function()? inconnu,
  }) {
    return suspendu?.call(nom, prenom);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String? statutCotis,
    )?
    valide,
    TResult Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String periodeRetard,
    )?
    retard,
    TResult Function(String nom, String prenom)? suspendu,
    TResult Function()? inconnu,
    required TResult orElse(),
  }) {
    if (suspendu != null) {
      return suspendu(nom, prenom);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Valide value) valide,
    required TResult Function(_Retard value) retard,
    required TResult Function(_Suspendu value) suspendu,
    required TResult Function(_Inconnu value) inconnu,
  }) {
    return suspendu(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Valide value)? valide,
    TResult? Function(_Retard value)? retard,
    TResult? Function(_Suspendu value)? suspendu,
    TResult? Function(_Inconnu value)? inconnu,
  }) {
    return suspendu?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Valide value)? valide,
    TResult Function(_Retard value)? retard,
    TResult Function(_Suspendu value)? suspendu,
    TResult Function(_Inconnu value)? inconnu,
    required TResult orElse(),
  }) {
    if (suspendu != null) {
      return suspendu(this);
    }
    return orElse();
  }
}

abstract class _Suspendu implements ResultatScan {
  const factory _Suspendu({
    required final String nom,
    required final String prenom,
  }) = _$SuspenduImpl;

  String get nom;
  String get prenom;

  /// Create a copy of ResultatScan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuspenduImplCopyWith<_$SuspenduImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InconnuImplCopyWith<$Res> {
  factory _$$InconnuImplCopyWith(
    _$InconnuImpl value,
    $Res Function(_$InconnuImpl) then,
  ) = __$$InconnuImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InconnuImplCopyWithImpl<$Res>
    extends _$ResultatScanCopyWithImpl<$Res, _$InconnuImpl>
    implements _$$InconnuImplCopyWith<$Res> {
  __$$InconnuImplCopyWithImpl(
    _$InconnuImpl _value,
    $Res Function(_$InconnuImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ResultatScan
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InconnuImpl implements _Inconnu {
  const _$InconnuImpl();

  @override
  String toString() {
    return 'ResultatScan.inconnu()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InconnuImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String? statutCotis,
    )
    valide,
    required TResult Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String periodeRetard,
    )
    retard,
    required TResult Function(String nom, String prenom) suspendu,
    required TResult Function() inconnu,
  }) {
    return inconnu();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String? statutCotis,
    )?
    valide,
    TResult? Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String periodeRetard,
    )?
    retard,
    TResult? Function(String nom, String prenom)? suspendu,
    TResult? Function()? inconnu,
  }) {
    return inconnu?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String? statutCotis,
    )?
    valide,
    TResult Function(
      String nom,
      String prenom,
      String? numeroCarte,
      String periodeRetard,
    )?
    retard,
    TResult Function(String nom, String prenom)? suspendu,
    TResult Function()? inconnu,
    required TResult orElse(),
  }) {
    if (inconnu != null) {
      return inconnu();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Valide value) valide,
    required TResult Function(_Retard value) retard,
    required TResult Function(_Suspendu value) suspendu,
    required TResult Function(_Inconnu value) inconnu,
  }) {
    return inconnu(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Valide value)? valide,
    TResult? Function(_Retard value)? retard,
    TResult? Function(_Suspendu value)? suspendu,
    TResult? Function(_Inconnu value)? inconnu,
  }) {
    return inconnu?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Valide value)? valide,
    TResult Function(_Retard value)? retard,
    TResult Function(_Suspendu value)? suspendu,
    TResult Function(_Inconnu value)? inconnu,
    required TResult orElse(),
  }) {
    if (inconnu != null) {
      return inconnu(this);
    }
    return orElse();
  }
}

abstract class _Inconnu implements ResultatScan {
  const factory _Inconnu() = _$InconnuImpl;
}
