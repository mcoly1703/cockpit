// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ScanState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() attente,
    required TResult Function() chargement,
    required TResult Function(ResultatScan resultat) resultat,
    required TResult Function(String message) erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? attente,
    TResult? Function()? chargement,
    TResult? Function(ResultatScan resultat)? resultat,
    TResult? Function(String message)? erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? attente,
    TResult Function()? chargement,
    TResult Function(ResultatScan resultat)? resultat,
    TResult Function(String message)? erreur,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Attente value) attente,
    required TResult Function(_Chargement value) chargement,
    required TResult Function(_Resultat value) resultat,
    required TResult Function(_Erreur value) erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Attente value)? attente,
    TResult? Function(_Chargement value)? chargement,
    TResult? Function(_Resultat value)? resultat,
    TResult? Function(_Erreur value)? erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Attente value)? attente,
    TResult Function(_Chargement value)? chargement,
    TResult Function(_Resultat value)? resultat,
    TResult Function(_Erreur value)? erreur,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScanStateCopyWith<$Res> {
  factory $ScanStateCopyWith(ScanState value, $Res Function(ScanState) then) =
      _$ScanStateCopyWithImpl<$Res, ScanState>;
}

/// @nodoc
class _$ScanStateCopyWithImpl<$Res, $Val extends ScanState>
    implements $ScanStateCopyWith<$Res> {
  _$ScanStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScanState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$AttenteImplCopyWith<$Res> {
  factory _$$AttenteImplCopyWith(
    _$AttenteImpl value,
    $Res Function(_$AttenteImpl) then,
  ) = __$$AttenteImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AttenteImplCopyWithImpl<$Res>
    extends _$ScanStateCopyWithImpl<$Res, _$AttenteImpl>
    implements _$$AttenteImplCopyWith<$Res> {
  __$$AttenteImplCopyWithImpl(
    _$AttenteImpl _value,
    $Res Function(_$AttenteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScanState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AttenteImpl implements _Attente {
  const _$AttenteImpl();

  @override
  String toString() {
    return 'ScanState.attente()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AttenteImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() attente,
    required TResult Function() chargement,
    required TResult Function(ResultatScan resultat) resultat,
    required TResult Function(String message) erreur,
  }) {
    return attente();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? attente,
    TResult? Function()? chargement,
    TResult? Function(ResultatScan resultat)? resultat,
    TResult? Function(String message)? erreur,
  }) {
    return attente?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? attente,
    TResult Function()? chargement,
    TResult Function(ResultatScan resultat)? resultat,
    TResult Function(String message)? erreur,
    required TResult orElse(),
  }) {
    if (attente != null) {
      return attente();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Attente value) attente,
    required TResult Function(_Chargement value) chargement,
    required TResult Function(_Resultat value) resultat,
    required TResult Function(_Erreur value) erreur,
  }) {
    return attente(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Attente value)? attente,
    TResult? Function(_Chargement value)? chargement,
    TResult? Function(_Resultat value)? resultat,
    TResult? Function(_Erreur value)? erreur,
  }) {
    return attente?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Attente value)? attente,
    TResult Function(_Chargement value)? chargement,
    TResult Function(_Resultat value)? resultat,
    TResult Function(_Erreur value)? erreur,
    required TResult orElse(),
  }) {
    if (attente != null) {
      return attente(this);
    }
    return orElse();
  }
}

abstract class _Attente implements ScanState {
  const factory _Attente() = _$AttenteImpl;
}

/// @nodoc
abstract class _$$ChargementImplCopyWith<$Res> {
  factory _$$ChargementImplCopyWith(
    _$ChargementImpl value,
    $Res Function(_$ChargementImpl) then,
  ) = __$$ChargementImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ChargementImplCopyWithImpl<$Res>
    extends _$ScanStateCopyWithImpl<$Res, _$ChargementImpl>
    implements _$$ChargementImplCopyWith<$Res> {
  __$$ChargementImplCopyWithImpl(
    _$ChargementImpl _value,
    $Res Function(_$ChargementImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScanState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ChargementImpl implements _Chargement {
  const _$ChargementImpl();

  @override
  String toString() {
    return 'ScanState.chargement()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ChargementImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() attente,
    required TResult Function() chargement,
    required TResult Function(ResultatScan resultat) resultat,
    required TResult Function(String message) erreur,
  }) {
    return chargement();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? attente,
    TResult? Function()? chargement,
    TResult? Function(ResultatScan resultat)? resultat,
    TResult? Function(String message)? erreur,
  }) {
    return chargement?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? attente,
    TResult Function()? chargement,
    TResult Function(ResultatScan resultat)? resultat,
    TResult Function(String message)? erreur,
    required TResult orElse(),
  }) {
    if (chargement != null) {
      return chargement();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Attente value) attente,
    required TResult Function(_Chargement value) chargement,
    required TResult Function(_Resultat value) resultat,
    required TResult Function(_Erreur value) erreur,
  }) {
    return chargement(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Attente value)? attente,
    TResult? Function(_Chargement value)? chargement,
    TResult? Function(_Resultat value)? resultat,
    TResult? Function(_Erreur value)? erreur,
  }) {
    return chargement?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Attente value)? attente,
    TResult Function(_Chargement value)? chargement,
    TResult Function(_Resultat value)? resultat,
    TResult Function(_Erreur value)? erreur,
    required TResult orElse(),
  }) {
    if (chargement != null) {
      return chargement(this);
    }
    return orElse();
  }
}

abstract class _Chargement implements ScanState {
  const factory _Chargement() = _$ChargementImpl;
}

/// @nodoc
abstract class _$$ResultatImplCopyWith<$Res> {
  factory _$$ResultatImplCopyWith(
    _$ResultatImpl value,
    $Res Function(_$ResultatImpl) then,
  ) = __$$ResultatImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ResultatScan resultat});

  $ResultatScanCopyWith<$Res> get resultat;
}

/// @nodoc
class __$$ResultatImplCopyWithImpl<$Res>
    extends _$ScanStateCopyWithImpl<$Res, _$ResultatImpl>
    implements _$$ResultatImplCopyWith<$Res> {
  __$$ResultatImplCopyWithImpl(
    _$ResultatImpl _value,
    $Res Function(_$ResultatImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScanState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? resultat = null}) {
    return _then(
      _$ResultatImpl(
        resultat: null == resultat
            ? _value.resultat
            : resultat // ignore: cast_nullable_to_non_nullable
                  as ResultatScan,
      ),
    );
  }

  /// Create a copy of ScanState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ResultatScanCopyWith<$Res> get resultat {
    return $ResultatScanCopyWith<$Res>(_value.resultat, (value) {
      return _then(_value.copyWith(resultat: value));
    });
  }
}

/// @nodoc

class _$ResultatImpl implements _Resultat {
  const _$ResultatImpl({required this.resultat});

  @override
  final ResultatScan resultat;

  @override
  String toString() {
    return 'ScanState.resultat(resultat: $resultat)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResultatImpl &&
            (identical(other.resultat, resultat) ||
                other.resultat == resultat));
  }

  @override
  int get hashCode => Object.hash(runtimeType, resultat);

  /// Create a copy of ScanState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResultatImplCopyWith<_$ResultatImpl> get copyWith =>
      __$$ResultatImplCopyWithImpl<_$ResultatImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() attente,
    required TResult Function() chargement,
    required TResult Function(ResultatScan resultat) resultat,
    required TResult Function(String message) erreur,
  }) {
    return resultat(this.resultat);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? attente,
    TResult? Function()? chargement,
    TResult? Function(ResultatScan resultat)? resultat,
    TResult? Function(String message)? erreur,
  }) {
    return resultat?.call(this.resultat);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? attente,
    TResult Function()? chargement,
    TResult Function(ResultatScan resultat)? resultat,
    TResult Function(String message)? erreur,
    required TResult orElse(),
  }) {
    if (resultat != null) {
      return resultat(this.resultat);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Attente value) attente,
    required TResult Function(_Chargement value) chargement,
    required TResult Function(_Resultat value) resultat,
    required TResult Function(_Erreur value) erreur,
  }) {
    return resultat(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Attente value)? attente,
    TResult? Function(_Chargement value)? chargement,
    TResult? Function(_Resultat value)? resultat,
    TResult? Function(_Erreur value)? erreur,
  }) {
    return resultat?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Attente value)? attente,
    TResult Function(_Chargement value)? chargement,
    TResult Function(_Resultat value)? resultat,
    TResult Function(_Erreur value)? erreur,
    required TResult orElse(),
  }) {
    if (resultat != null) {
      return resultat(this);
    }
    return orElse();
  }
}

abstract class _Resultat implements ScanState {
  const factory _Resultat({required final ResultatScan resultat}) =
      _$ResultatImpl;

  ResultatScan get resultat;

  /// Create a copy of ScanState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResultatImplCopyWith<_$ResultatImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErreurImplCopyWith<$Res> {
  factory _$$ErreurImplCopyWith(
    _$ErreurImpl value,
    $Res Function(_$ErreurImpl) then,
  ) = __$$ErreurImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErreurImplCopyWithImpl<$Res>
    extends _$ScanStateCopyWithImpl<$Res, _$ErreurImpl>
    implements _$$ErreurImplCopyWith<$Res> {
  __$$ErreurImplCopyWithImpl(
    _$ErreurImpl _value,
    $Res Function(_$ErreurImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScanState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ErreurImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ErreurImpl implements _Erreur {
  const _$ErreurImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'ScanState.erreur(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErreurImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ScanState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErreurImplCopyWith<_$ErreurImpl> get copyWith =>
      __$$ErreurImplCopyWithImpl<_$ErreurImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() attente,
    required TResult Function() chargement,
    required TResult Function(ResultatScan resultat) resultat,
    required TResult Function(String message) erreur,
  }) {
    return erreur(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? attente,
    TResult? Function()? chargement,
    TResult? Function(ResultatScan resultat)? resultat,
    TResult? Function(String message)? erreur,
  }) {
    return erreur?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? attente,
    TResult Function()? chargement,
    TResult Function(ResultatScan resultat)? resultat,
    TResult Function(String message)? erreur,
    required TResult orElse(),
  }) {
    if (erreur != null) {
      return erreur(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Attente value) attente,
    required TResult Function(_Chargement value) chargement,
    required TResult Function(_Resultat value) resultat,
    required TResult Function(_Erreur value) erreur,
  }) {
    return erreur(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Attente value)? attente,
    TResult? Function(_Chargement value)? chargement,
    TResult? Function(_Resultat value)? resultat,
    TResult? Function(_Erreur value)? erreur,
  }) {
    return erreur?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Attente value)? attente,
    TResult Function(_Chargement value)? chargement,
    TResult Function(_Resultat value)? resultat,
    TResult Function(_Erreur value)? erreur,
    required TResult orElse(),
  }) {
    if (erreur != null) {
      return erreur(this);
    }
    return orElse();
  }
}

abstract class _Erreur implements ScanState {
  const factory _Erreur({required final String message}) = _$ErreurImpl;

  String get message;

  /// Create a copy of ScanState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErreurImplCopyWith<_$ErreurImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
