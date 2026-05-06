// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AuthState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(Utilisateur utilisateur) connecte,
    required TResult Function() deconnecte,
    required TResult Function(Failure failure) erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(Utilisateur utilisateur)? connecte,
    TResult? Function()? deconnecte,
    TResult? Function(Failure failure)? erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(Utilisateur utilisateur)? connecte,
    TResult Function()? deconnecte,
    TResult Function(Failure failure)? erreur,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthChargement value) chargement,
    required TResult Function(AuthConnecte value) connecte,
    required TResult Function(AuthDeconnecte value) deconnecte,
    required TResult Function(AuthErreur value) erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthChargement value)? chargement,
    TResult? Function(AuthConnecte value)? connecte,
    TResult? Function(AuthDeconnecte value)? deconnecte,
    TResult? Function(AuthErreur value)? erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthChargement value)? chargement,
    TResult Function(AuthConnecte value)? connecte,
    TResult Function(AuthDeconnecte value)? deconnecte,
    TResult Function(AuthErreur value)? erreur,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$AuthInitialImplCopyWith<$Res> {
  factory _$$AuthInitialImplCopyWith(
    _$AuthInitialImpl value,
    $Res Function(_$AuthInitialImpl) then,
  ) = __$$AuthInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthInitialImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthInitialImpl>
    implements _$$AuthInitialImplCopyWith<$Res> {
  __$$AuthInitialImplCopyWithImpl(
    _$AuthInitialImpl _value,
    $Res Function(_$AuthInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AuthInitialImpl implements AuthInitial {
  const _$AuthInitialImpl();

  @override
  String toString() {
    return 'AuthState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AuthInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(Utilisateur utilisateur) connecte,
    required TResult Function() deconnecte,
    required TResult Function(Failure failure) erreur,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(Utilisateur utilisateur)? connecte,
    TResult? Function()? deconnecte,
    TResult? Function(Failure failure)? erreur,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(Utilisateur utilisateur)? connecte,
    TResult Function()? deconnecte,
    TResult Function(Failure failure)? erreur,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthChargement value) chargement,
    required TResult Function(AuthConnecte value) connecte,
    required TResult Function(AuthDeconnecte value) deconnecte,
    required TResult Function(AuthErreur value) erreur,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthChargement value)? chargement,
    TResult? Function(AuthConnecte value)? connecte,
    TResult? Function(AuthDeconnecte value)? deconnecte,
    TResult? Function(AuthErreur value)? erreur,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthChargement value)? chargement,
    TResult Function(AuthConnecte value)? connecte,
    TResult Function(AuthDeconnecte value)? deconnecte,
    TResult Function(AuthErreur value)? erreur,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class AuthInitial implements AuthState {
  const factory AuthInitial() = _$AuthInitialImpl;
}

/// @nodoc
abstract class _$$AuthChargementImplCopyWith<$Res> {
  factory _$$AuthChargementImplCopyWith(
    _$AuthChargementImpl value,
    $Res Function(_$AuthChargementImpl) then,
  ) = __$$AuthChargementImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthChargementImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthChargementImpl>
    implements _$$AuthChargementImplCopyWith<$Res> {
  __$$AuthChargementImplCopyWithImpl(
    _$AuthChargementImpl _value,
    $Res Function(_$AuthChargementImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AuthChargementImpl implements AuthChargement {
  const _$AuthChargementImpl();

  @override
  String toString() {
    return 'AuthState.chargement()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AuthChargementImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(Utilisateur utilisateur) connecte,
    required TResult Function() deconnecte,
    required TResult Function(Failure failure) erreur,
  }) {
    return chargement();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(Utilisateur utilisateur)? connecte,
    TResult? Function()? deconnecte,
    TResult? Function(Failure failure)? erreur,
  }) {
    return chargement?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(Utilisateur utilisateur)? connecte,
    TResult Function()? deconnecte,
    TResult Function(Failure failure)? erreur,
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
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthChargement value) chargement,
    required TResult Function(AuthConnecte value) connecte,
    required TResult Function(AuthDeconnecte value) deconnecte,
    required TResult Function(AuthErreur value) erreur,
  }) {
    return chargement(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthChargement value)? chargement,
    TResult? Function(AuthConnecte value)? connecte,
    TResult? Function(AuthDeconnecte value)? deconnecte,
    TResult? Function(AuthErreur value)? erreur,
  }) {
    return chargement?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthChargement value)? chargement,
    TResult Function(AuthConnecte value)? connecte,
    TResult Function(AuthDeconnecte value)? deconnecte,
    TResult Function(AuthErreur value)? erreur,
    required TResult orElse(),
  }) {
    if (chargement != null) {
      return chargement(this);
    }
    return orElse();
  }
}

abstract class AuthChargement implements AuthState {
  const factory AuthChargement() = _$AuthChargementImpl;
}

/// @nodoc
abstract class _$$AuthConnecteImplCopyWith<$Res> {
  factory _$$AuthConnecteImplCopyWith(
    _$AuthConnecteImpl value,
    $Res Function(_$AuthConnecteImpl) then,
  ) = __$$AuthConnecteImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Utilisateur utilisateur});

  $UtilisateurCopyWith<$Res> get utilisateur;
}

/// @nodoc
class __$$AuthConnecteImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthConnecteImpl>
    implements _$$AuthConnecteImplCopyWith<$Res> {
  __$$AuthConnecteImplCopyWithImpl(
    _$AuthConnecteImpl _value,
    $Res Function(_$AuthConnecteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? utilisateur = null}) {
    return _then(
      _$AuthConnecteImpl(
        utilisateur: null == utilisateur
            ? _value.utilisateur
            : utilisateur // ignore: cast_nullable_to_non_nullable
                  as Utilisateur,
      ),
    );
  }

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UtilisateurCopyWith<$Res> get utilisateur {
    return $UtilisateurCopyWith<$Res>(_value.utilisateur, (value) {
      return _then(_value.copyWith(utilisateur: value));
    });
  }
}

/// @nodoc

class _$AuthConnecteImpl implements AuthConnecte {
  const _$AuthConnecteImpl({required this.utilisateur});

  @override
  final Utilisateur utilisateur;

  @override
  String toString() {
    return 'AuthState.connecte(utilisateur: $utilisateur)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthConnecteImpl &&
            (identical(other.utilisateur, utilisateur) ||
                other.utilisateur == utilisateur));
  }

  @override
  int get hashCode => Object.hash(runtimeType, utilisateur);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthConnecteImplCopyWith<_$AuthConnecteImpl> get copyWith =>
      __$$AuthConnecteImplCopyWithImpl<_$AuthConnecteImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(Utilisateur utilisateur) connecte,
    required TResult Function() deconnecte,
    required TResult Function(Failure failure) erreur,
  }) {
    return connecte(utilisateur);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(Utilisateur utilisateur)? connecte,
    TResult? Function()? deconnecte,
    TResult? Function(Failure failure)? erreur,
  }) {
    return connecte?.call(utilisateur);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(Utilisateur utilisateur)? connecte,
    TResult Function()? deconnecte,
    TResult Function(Failure failure)? erreur,
    required TResult orElse(),
  }) {
    if (connecte != null) {
      return connecte(utilisateur);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthChargement value) chargement,
    required TResult Function(AuthConnecte value) connecte,
    required TResult Function(AuthDeconnecte value) deconnecte,
    required TResult Function(AuthErreur value) erreur,
  }) {
    return connecte(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthChargement value)? chargement,
    TResult? Function(AuthConnecte value)? connecte,
    TResult? Function(AuthDeconnecte value)? deconnecte,
    TResult? Function(AuthErreur value)? erreur,
  }) {
    return connecte?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthChargement value)? chargement,
    TResult Function(AuthConnecte value)? connecte,
    TResult Function(AuthDeconnecte value)? deconnecte,
    TResult Function(AuthErreur value)? erreur,
    required TResult orElse(),
  }) {
    if (connecte != null) {
      return connecte(this);
    }
    return orElse();
  }
}

abstract class AuthConnecte implements AuthState {
  const factory AuthConnecte({required final Utilisateur utilisateur}) =
      _$AuthConnecteImpl;

  Utilisateur get utilisateur;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthConnecteImplCopyWith<_$AuthConnecteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthDeconnecteImplCopyWith<$Res> {
  factory _$$AuthDeconnecteImplCopyWith(
    _$AuthDeconnecteImpl value,
    $Res Function(_$AuthDeconnecteImpl) then,
  ) = __$$AuthDeconnecteImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthDeconnecteImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthDeconnecteImpl>
    implements _$$AuthDeconnecteImplCopyWith<$Res> {
  __$$AuthDeconnecteImplCopyWithImpl(
    _$AuthDeconnecteImpl _value,
    $Res Function(_$AuthDeconnecteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AuthDeconnecteImpl implements AuthDeconnecte {
  const _$AuthDeconnecteImpl();

  @override
  String toString() {
    return 'AuthState.deconnecte()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AuthDeconnecteImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(Utilisateur utilisateur) connecte,
    required TResult Function() deconnecte,
    required TResult Function(Failure failure) erreur,
  }) {
    return deconnecte();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(Utilisateur utilisateur)? connecte,
    TResult? Function()? deconnecte,
    TResult? Function(Failure failure)? erreur,
  }) {
    return deconnecte?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(Utilisateur utilisateur)? connecte,
    TResult Function()? deconnecte,
    TResult Function(Failure failure)? erreur,
    required TResult orElse(),
  }) {
    if (deconnecte != null) {
      return deconnecte();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthChargement value) chargement,
    required TResult Function(AuthConnecte value) connecte,
    required TResult Function(AuthDeconnecte value) deconnecte,
    required TResult Function(AuthErreur value) erreur,
  }) {
    return deconnecte(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthChargement value)? chargement,
    TResult? Function(AuthConnecte value)? connecte,
    TResult? Function(AuthDeconnecte value)? deconnecte,
    TResult? Function(AuthErreur value)? erreur,
  }) {
    return deconnecte?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthChargement value)? chargement,
    TResult Function(AuthConnecte value)? connecte,
    TResult Function(AuthDeconnecte value)? deconnecte,
    TResult Function(AuthErreur value)? erreur,
    required TResult orElse(),
  }) {
    if (deconnecte != null) {
      return deconnecte(this);
    }
    return orElse();
  }
}

abstract class AuthDeconnecte implements AuthState {
  const factory AuthDeconnecte() = _$AuthDeconnecteImpl;
}

/// @nodoc
abstract class _$$AuthErreurImplCopyWith<$Res> {
  factory _$$AuthErreurImplCopyWith(
    _$AuthErreurImpl value,
    $Res Function(_$AuthErreurImpl) then,
  ) = __$$AuthErreurImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Failure failure});

  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class __$$AuthErreurImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthErreurImpl>
    implements _$$AuthErreurImplCopyWith<$Res> {
  __$$AuthErreurImplCopyWithImpl(
    _$AuthErreurImpl _value,
    $Res Function(_$AuthErreurImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? failure = null}) {
    return _then(
      _$AuthErreurImpl(
        failure: null == failure
            ? _value.failure
            : failure // ignore: cast_nullable_to_non_nullable
                  as Failure,
      ),
    );
  }

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FailureCopyWith<$Res> get failure {
    return $FailureCopyWith<$Res>(_value.failure, (value) {
      return _then(_value.copyWith(failure: value));
    });
  }
}

/// @nodoc

class _$AuthErreurImpl implements AuthErreur {
  const _$AuthErreurImpl({required this.failure});

  @override
  final Failure failure;

  @override
  String toString() {
    return 'AuthState.erreur(failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthErreurImpl &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failure);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthErreurImplCopyWith<_$AuthErreurImpl> get copyWith =>
      __$$AuthErreurImplCopyWithImpl<_$AuthErreurImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(Utilisateur utilisateur) connecte,
    required TResult Function() deconnecte,
    required TResult Function(Failure failure) erreur,
  }) {
    return erreur(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(Utilisateur utilisateur)? connecte,
    TResult? Function()? deconnecte,
    TResult? Function(Failure failure)? erreur,
  }) {
    return erreur?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(Utilisateur utilisateur)? connecte,
    TResult Function()? deconnecte,
    TResult Function(Failure failure)? erreur,
    required TResult orElse(),
  }) {
    if (erreur != null) {
      return erreur(failure);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthChargement value) chargement,
    required TResult Function(AuthConnecte value) connecte,
    required TResult Function(AuthDeconnecte value) deconnecte,
    required TResult Function(AuthErreur value) erreur,
  }) {
    return erreur(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthChargement value)? chargement,
    TResult? Function(AuthConnecte value)? connecte,
    TResult? Function(AuthDeconnecte value)? deconnecte,
    TResult? Function(AuthErreur value)? erreur,
  }) {
    return erreur?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthChargement value)? chargement,
    TResult Function(AuthConnecte value)? connecte,
    TResult Function(AuthDeconnecte value)? deconnecte,
    TResult Function(AuthErreur value)? erreur,
    required TResult orElse(),
  }) {
    if (erreur != null) {
      return erreur(this);
    }
    return orElse();
  }
}

abstract class AuthErreur implements AuthState {
  const factory AuthErreur({required final Failure failure}) = _$AuthErreurImpl;

  Failure get failure;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthErreurImplCopyWith<_$AuthErreurImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
