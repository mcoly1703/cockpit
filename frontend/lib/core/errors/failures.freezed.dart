// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Failure {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serveur,
    required TResult Function() reseau,
    required TResult Function() nonAutorise,
    required TResult Function() nonTrouve,
    required TResult Function(String message) validation,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serveur,
    TResult? Function()? reseau,
    TResult? Function()? nonAutorise,
    TResult? Function()? nonTrouve,
    TResult? Function(String message)? validation,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serveur,
    TResult Function()? reseau,
    TResult Function()? nonAutorise,
    TResult Function()? nonTrouve,
    TResult Function(String message)? validation,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FailureServeur value) serveur,
    required TResult Function(FailureReseau value) reseau,
    required TResult Function(FailureNonAutorise value) nonAutorise,
    required TResult Function(FailureNonTrouve value) nonTrouve,
    required TResult Function(FailureValidation value) validation,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FailureServeur value)? serveur,
    TResult? Function(FailureReseau value)? reseau,
    TResult? Function(FailureNonAutorise value)? nonAutorise,
    TResult? Function(FailureNonTrouve value)? nonTrouve,
    TResult? Function(FailureValidation value)? validation,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FailureServeur value)? serveur,
    TResult Function(FailureReseau value)? reseau,
    TResult Function(FailureNonAutorise value)? nonAutorise,
    TResult Function(FailureNonTrouve value)? nonTrouve,
    TResult Function(FailureValidation value)? validation,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FailureCopyWith<$Res> {
  factory $FailureCopyWith(Failure value, $Res Function(Failure) then) =
      _$FailureCopyWithImpl<$Res, Failure>;
}

/// @nodoc
class _$FailureCopyWithImpl<$Res, $Val extends Failure>
    implements $FailureCopyWith<$Res> {
  _$FailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$FailureServeurImplCopyWith<$Res> {
  factory _$$FailureServeurImplCopyWith(
    _$FailureServeurImpl value,
    $Res Function(_$FailureServeurImpl) then,
  ) = __$$FailureServeurImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$FailureServeurImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$FailureServeurImpl>
    implements _$$FailureServeurImplCopyWith<$Res> {
  __$$FailureServeurImplCopyWithImpl(
    _$FailureServeurImpl _value,
    $Res Function(_$FailureServeurImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$FailureServeurImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$FailureServeurImpl implements FailureServeur {
  const _$FailureServeurImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.serveur(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FailureServeurImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FailureServeurImplCopyWith<_$FailureServeurImpl> get copyWith =>
      __$$FailureServeurImplCopyWithImpl<_$FailureServeurImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serveur,
    required TResult Function() reseau,
    required TResult Function() nonAutorise,
    required TResult Function() nonTrouve,
    required TResult Function(String message) validation,
  }) {
    return serveur(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serveur,
    TResult? Function()? reseau,
    TResult? Function()? nonAutorise,
    TResult? Function()? nonTrouve,
    TResult? Function(String message)? validation,
  }) {
    return serveur?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serveur,
    TResult Function()? reseau,
    TResult Function()? nonAutorise,
    TResult Function()? nonTrouve,
    TResult Function(String message)? validation,
    required TResult orElse(),
  }) {
    if (serveur != null) {
      return serveur(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FailureServeur value) serveur,
    required TResult Function(FailureReseau value) reseau,
    required TResult Function(FailureNonAutorise value) nonAutorise,
    required TResult Function(FailureNonTrouve value) nonTrouve,
    required TResult Function(FailureValidation value) validation,
  }) {
    return serveur(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FailureServeur value)? serveur,
    TResult? Function(FailureReseau value)? reseau,
    TResult? Function(FailureNonAutorise value)? nonAutorise,
    TResult? Function(FailureNonTrouve value)? nonTrouve,
    TResult? Function(FailureValidation value)? validation,
  }) {
    return serveur?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FailureServeur value)? serveur,
    TResult Function(FailureReseau value)? reseau,
    TResult Function(FailureNonAutorise value)? nonAutorise,
    TResult Function(FailureNonTrouve value)? nonTrouve,
    TResult Function(FailureValidation value)? validation,
    required TResult orElse(),
  }) {
    if (serveur != null) {
      return serveur(this);
    }
    return orElse();
  }
}

abstract class FailureServeur implements Failure {
  const factory FailureServeur({required final String message}) =
      _$FailureServeurImpl;

  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FailureServeurImplCopyWith<_$FailureServeurImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FailureReseauImplCopyWith<$Res> {
  factory _$$FailureReseauImplCopyWith(
    _$FailureReseauImpl value,
    $Res Function(_$FailureReseauImpl) then,
  ) = __$$FailureReseauImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FailureReseauImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$FailureReseauImpl>
    implements _$$FailureReseauImplCopyWith<$Res> {
  __$$FailureReseauImplCopyWithImpl(
    _$FailureReseauImpl _value,
    $Res Function(_$FailureReseauImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$FailureReseauImpl implements FailureReseau {
  const _$FailureReseauImpl();

  @override
  String toString() {
    return 'Failure.reseau()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$FailureReseauImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serveur,
    required TResult Function() reseau,
    required TResult Function() nonAutorise,
    required TResult Function() nonTrouve,
    required TResult Function(String message) validation,
  }) {
    return reseau();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serveur,
    TResult? Function()? reseau,
    TResult? Function()? nonAutorise,
    TResult? Function()? nonTrouve,
    TResult? Function(String message)? validation,
  }) {
    return reseau?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serveur,
    TResult Function()? reseau,
    TResult Function()? nonAutorise,
    TResult Function()? nonTrouve,
    TResult Function(String message)? validation,
    required TResult orElse(),
  }) {
    if (reseau != null) {
      return reseau();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FailureServeur value) serveur,
    required TResult Function(FailureReseau value) reseau,
    required TResult Function(FailureNonAutorise value) nonAutorise,
    required TResult Function(FailureNonTrouve value) nonTrouve,
    required TResult Function(FailureValidation value) validation,
  }) {
    return reseau(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FailureServeur value)? serveur,
    TResult? Function(FailureReseau value)? reseau,
    TResult? Function(FailureNonAutorise value)? nonAutorise,
    TResult? Function(FailureNonTrouve value)? nonTrouve,
    TResult? Function(FailureValidation value)? validation,
  }) {
    return reseau?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FailureServeur value)? serveur,
    TResult Function(FailureReseau value)? reseau,
    TResult Function(FailureNonAutorise value)? nonAutorise,
    TResult Function(FailureNonTrouve value)? nonTrouve,
    TResult Function(FailureValidation value)? validation,
    required TResult orElse(),
  }) {
    if (reseau != null) {
      return reseau(this);
    }
    return orElse();
  }
}

abstract class FailureReseau implements Failure {
  const factory FailureReseau() = _$FailureReseauImpl;
}

/// @nodoc
abstract class _$$FailureNonAutoriseImplCopyWith<$Res> {
  factory _$$FailureNonAutoriseImplCopyWith(
    _$FailureNonAutoriseImpl value,
    $Res Function(_$FailureNonAutoriseImpl) then,
  ) = __$$FailureNonAutoriseImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FailureNonAutoriseImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$FailureNonAutoriseImpl>
    implements _$$FailureNonAutoriseImplCopyWith<$Res> {
  __$$FailureNonAutoriseImplCopyWithImpl(
    _$FailureNonAutoriseImpl _value,
    $Res Function(_$FailureNonAutoriseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$FailureNonAutoriseImpl implements FailureNonAutorise {
  const _$FailureNonAutoriseImpl();

  @override
  String toString() {
    return 'Failure.nonAutorise()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$FailureNonAutoriseImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serveur,
    required TResult Function() reseau,
    required TResult Function() nonAutorise,
    required TResult Function() nonTrouve,
    required TResult Function(String message) validation,
  }) {
    return nonAutorise();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serveur,
    TResult? Function()? reseau,
    TResult? Function()? nonAutorise,
    TResult? Function()? nonTrouve,
    TResult? Function(String message)? validation,
  }) {
    return nonAutorise?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serveur,
    TResult Function()? reseau,
    TResult Function()? nonAutorise,
    TResult Function()? nonTrouve,
    TResult Function(String message)? validation,
    required TResult orElse(),
  }) {
    if (nonAutorise != null) {
      return nonAutorise();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FailureServeur value) serveur,
    required TResult Function(FailureReseau value) reseau,
    required TResult Function(FailureNonAutorise value) nonAutorise,
    required TResult Function(FailureNonTrouve value) nonTrouve,
    required TResult Function(FailureValidation value) validation,
  }) {
    return nonAutorise(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FailureServeur value)? serveur,
    TResult? Function(FailureReseau value)? reseau,
    TResult? Function(FailureNonAutorise value)? nonAutorise,
    TResult? Function(FailureNonTrouve value)? nonTrouve,
    TResult? Function(FailureValidation value)? validation,
  }) {
    return nonAutorise?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FailureServeur value)? serveur,
    TResult Function(FailureReseau value)? reseau,
    TResult Function(FailureNonAutorise value)? nonAutorise,
    TResult Function(FailureNonTrouve value)? nonTrouve,
    TResult Function(FailureValidation value)? validation,
    required TResult orElse(),
  }) {
    if (nonAutorise != null) {
      return nonAutorise(this);
    }
    return orElse();
  }
}

abstract class FailureNonAutorise implements Failure {
  const factory FailureNonAutorise() = _$FailureNonAutoriseImpl;
}

/// @nodoc
abstract class _$$FailureNonTrouveImplCopyWith<$Res> {
  factory _$$FailureNonTrouveImplCopyWith(
    _$FailureNonTrouveImpl value,
    $Res Function(_$FailureNonTrouveImpl) then,
  ) = __$$FailureNonTrouveImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FailureNonTrouveImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$FailureNonTrouveImpl>
    implements _$$FailureNonTrouveImplCopyWith<$Res> {
  __$$FailureNonTrouveImplCopyWithImpl(
    _$FailureNonTrouveImpl _value,
    $Res Function(_$FailureNonTrouveImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$FailureNonTrouveImpl implements FailureNonTrouve {
  const _$FailureNonTrouveImpl();

  @override
  String toString() {
    return 'Failure.nonTrouve()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$FailureNonTrouveImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serveur,
    required TResult Function() reseau,
    required TResult Function() nonAutorise,
    required TResult Function() nonTrouve,
    required TResult Function(String message) validation,
  }) {
    return nonTrouve();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serveur,
    TResult? Function()? reseau,
    TResult? Function()? nonAutorise,
    TResult? Function()? nonTrouve,
    TResult? Function(String message)? validation,
  }) {
    return nonTrouve?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serveur,
    TResult Function()? reseau,
    TResult Function()? nonAutorise,
    TResult Function()? nonTrouve,
    TResult Function(String message)? validation,
    required TResult orElse(),
  }) {
    if (nonTrouve != null) {
      return nonTrouve();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FailureServeur value) serveur,
    required TResult Function(FailureReseau value) reseau,
    required TResult Function(FailureNonAutorise value) nonAutorise,
    required TResult Function(FailureNonTrouve value) nonTrouve,
    required TResult Function(FailureValidation value) validation,
  }) {
    return nonTrouve(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FailureServeur value)? serveur,
    TResult? Function(FailureReseau value)? reseau,
    TResult? Function(FailureNonAutorise value)? nonAutorise,
    TResult? Function(FailureNonTrouve value)? nonTrouve,
    TResult? Function(FailureValidation value)? validation,
  }) {
    return nonTrouve?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FailureServeur value)? serveur,
    TResult Function(FailureReseau value)? reseau,
    TResult Function(FailureNonAutorise value)? nonAutorise,
    TResult Function(FailureNonTrouve value)? nonTrouve,
    TResult Function(FailureValidation value)? validation,
    required TResult orElse(),
  }) {
    if (nonTrouve != null) {
      return nonTrouve(this);
    }
    return orElse();
  }
}

abstract class FailureNonTrouve implements Failure {
  const factory FailureNonTrouve() = _$FailureNonTrouveImpl;
}

/// @nodoc
abstract class _$$FailureValidationImplCopyWith<$Res> {
  factory _$$FailureValidationImplCopyWith(
    _$FailureValidationImpl value,
    $Res Function(_$FailureValidationImpl) then,
  ) = __$$FailureValidationImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$FailureValidationImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$FailureValidationImpl>
    implements _$$FailureValidationImplCopyWith<$Res> {
  __$$FailureValidationImplCopyWithImpl(
    _$FailureValidationImpl _value,
    $Res Function(_$FailureValidationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$FailureValidationImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$FailureValidationImpl implements FailureValidation {
  const _$FailureValidationImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.validation(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FailureValidationImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FailureValidationImplCopyWith<_$FailureValidationImpl> get copyWith =>
      __$$FailureValidationImplCopyWithImpl<_$FailureValidationImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) serveur,
    required TResult Function() reseau,
    required TResult Function() nonAutorise,
    required TResult Function() nonTrouve,
    required TResult Function(String message) validation,
  }) {
    return validation(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? serveur,
    TResult? Function()? reseau,
    TResult? Function()? nonAutorise,
    TResult? Function()? nonTrouve,
    TResult? Function(String message)? validation,
  }) {
    return validation?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? serveur,
    TResult Function()? reseau,
    TResult Function()? nonAutorise,
    TResult Function()? nonTrouve,
    TResult Function(String message)? validation,
    required TResult orElse(),
  }) {
    if (validation != null) {
      return validation(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FailureServeur value) serveur,
    required TResult Function(FailureReseau value) reseau,
    required TResult Function(FailureNonAutorise value) nonAutorise,
    required TResult Function(FailureNonTrouve value) nonTrouve,
    required TResult Function(FailureValidation value) validation,
  }) {
    return validation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FailureServeur value)? serveur,
    TResult? Function(FailureReseau value)? reseau,
    TResult? Function(FailureNonAutorise value)? nonAutorise,
    TResult? Function(FailureNonTrouve value)? nonTrouve,
    TResult? Function(FailureValidation value)? validation,
  }) {
    return validation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FailureServeur value)? serveur,
    TResult Function(FailureReseau value)? reseau,
    TResult Function(FailureNonAutorise value)? nonAutorise,
    TResult Function(FailureNonTrouve value)? nonTrouve,
    TResult Function(FailureValidation value)? validation,
    required TResult orElse(),
  }) {
    if (validation != null) {
      return validation(this);
    }
    return orElse();
  }
}

abstract class FailureValidation implements Failure {
  const factory FailureValidation({required final String message}) =
      _$FailureValidationImpl;

  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FailureValidationImplCopyWith<_$FailureValidationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
