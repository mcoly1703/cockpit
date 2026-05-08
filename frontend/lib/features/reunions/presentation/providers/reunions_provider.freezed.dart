// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reunions_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ReunionsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(List<Reunion> reunions) charge,
    required TResult Function(Failure failure) erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<Reunion> reunions)? charge,
    TResult? Function(Failure failure)? erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<Reunion> reunions)? charge,
    TResult Function(Failure failure)? erreur,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Chargement value) chargement,
    required TResult Function(_Charge value) charge,
    required TResult Function(_Erreur value) erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Chargement value)? chargement,
    TResult? Function(_Charge value)? charge,
    TResult? Function(_Erreur value)? erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Chargement value)? chargement,
    TResult Function(_Charge value)? charge,
    TResult Function(_Erreur value)? erreur,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReunionsStateCopyWith<$Res> {
  factory $ReunionsStateCopyWith(
    ReunionsState value,
    $Res Function(ReunionsState) then,
  ) = _$ReunionsStateCopyWithImpl<$Res, ReunionsState>;
}

/// @nodoc
class _$ReunionsStateCopyWithImpl<$Res, $Val extends ReunionsState>
    implements $ReunionsStateCopyWith<$Res> {
  _$ReunionsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReunionsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
    _$InitialImpl value,
    $Res Function(_$InitialImpl) then,
  ) = __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$ReunionsStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
    _$InitialImpl _value,
    $Res Function(_$InitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReunionsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl extends _Initial {
  const _$InitialImpl() : super._();

  @override
  String toString() {
    return 'ReunionsState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(List<Reunion> reunions) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<Reunion> reunions)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<Reunion> reunions)? charge,
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
    required TResult Function(_Initial value) initial,
    required TResult Function(_Chargement value) chargement,
    required TResult Function(_Charge value) charge,
    required TResult Function(_Erreur value) erreur,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Chargement value)? chargement,
    TResult? Function(_Charge value)? charge,
    TResult? Function(_Erreur value)? erreur,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Chargement value)? chargement,
    TResult Function(_Charge value)? charge,
    TResult Function(_Erreur value)? erreur,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial extends ReunionsState {
  const factory _Initial() = _$InitialImpl;
  const _Initial._() : super._();
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
    extends _$ReunionsStateCopyWithImpl<$Res, _$ChargementImpl>
    implements _$$ChargementImplCopyWith<$Res> {
  __$$ChargementImplCopyWithImpl(
    _$ChargementImpl _value,
    $Res Function(_$ChargementImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReunionsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ChargementImpl extends _Chargement {
  const _$ChargementImpl() : super._();

  @override
  String toString() {
    return 'ReunionsState.chargement()';
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
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(List<Reunion> reunions) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return chargement();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<Reunion> reunions)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return chargement?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<Reunion> reunions)? charge,
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
    required TResult Function(_Initial value) initial,
    required TResult Function(_Chargement value) chargement,
    required TResult Function(_Charge value) charge,
    required TResult Function(_Erreur value) erreur,
  }) {
    return chargement(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Chargement value)? chargement,
    TResult? Function(_Charge value)? charge,
    TResult? Function(_Erreur value)? erreur,
  }) {
    return chargement?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Chargement value)? chargement,
    TResult Function(_Charge value)? charge,
    TResult Function(_Erreur value)? erreur,
    required TResult orElse(),
  }) {
    if (chargement != null) {
      return chargement(this);
    }
    return orElse();
  }
}

abstract class _Chargement extends ReunionsState {
  const factory _Chargement() = _$ChargementImpl;
  const _Chargement._() : super._();
}

/// @nodoc
abstract class _$$ChargeImplCopyWith<$Res> {
  factory _$$ChargeImplCopyWith(
    _$ChargeImpl value,
    $Res Function(_$ChargeImpl) then,
  ) = __$$ChargeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Reunion> reunions});
}

/// @nodoc
class __$$ChargeImplCopyWithImpl<$Res>
    extends _$ReunionsStateCopyWithImpl<$Res, _$ChargeImpl>
    implements _$$ChargeImplCopyWith<$Res> {
  __$$ChargeImplCopyWithImpl(
    _$ChargeImpl _value,
    $Res Function(_$ChargeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReunionsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reunions = null}) {
    return _then(
      _$ChargeImpl(
        reunions: null == reunions
            ? _value._reunions
            : reunions // ignore: cast_nullable_to_non_nullable
                  as List<Reunion>,
      ),
    );
  }
}

/// @nodoc

class _$ChargeImpl extends _Charge {
  const _$ChargeImpl({required final List<Reunion> reunions})
    : _reunions = reunions,
      super._();

  final List<Reunion> _reunions;
  @override
  List<Reunion> get reunions {
    if (_reunions is EqualUnmodifiableListView) return _reunions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reunions);
  }

  @override
  String toString() {
    return 'ReunionsState.charge(reunions: $reunions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChargeImpl &&
            const DeepCollectionEquality().equals(other._reunions, _reunions));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_reunions));

  /// Create a copy of ReunionsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChargeImplCopyWith<_$ChargeImpl> get copyWith =>
      __$$ChargeImplCopyWithImpl<_$ChargeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(List<Reunion> reunions) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return charge(reunions);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<Reunion> reunions)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return charge?.call(reunions);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<Reunion> reunions)? charge,
    TResult Function(Failure failure)? erreur,
    required TResult orElse(),
  }) {
    if (charge != null) {
      return charge(reunions);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Chargement value) chargement,
    required TResult Function(_Charge value) charge,
    required TResult Function(_Erreur value) erreur,
  }) {
    return charge(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Chargement value)? chargement,
    TResult? Function(_Charge value)? charge,
    TResult? Function(_Erreur value)? erreur,
  }) {
    return charge?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Chargement value)? chargement,
    TResult Function(_Charge value)? charge,
    TResult Function(_Erreur value)? erreur,
    required TResult orElse(),
  }) {
    if (charge != null) {
      return charge(this);
    }
    return orElse();
  }
}

abstract class _Charge extends ReunionsState {
  const factory _Charge({required final List<Reunion> reunions}) = _$ChargeImpl;
  const _Charge._() : super._();

  List<Reunion> get reunions;

  /// Create a copy of ReunionsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChargeImplCopyWith<_$ChargeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErreurImplCopyWith<$Res> {
  factory _$$ErreurImplCopyWith(
    _$ErreurImpl value,
    $Res Function(_$ErreurImpl) then,
  ) = __$$ErreurImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Failure failure});

  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class __$$ErreurImplCopyWithImpl<$Res>
    extends _$ReunionsStateCopyWithImpl<$Res, _$ErreurImpl>
    implements _$$ErreurImplCopyWith<$Res> {
  __$$ErreurImplCopyWithImpl(
    _$ErreurImpl _value,
    $Res Function(_$ErreurImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReunionsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? failure = null}) {
    return _then(
      _$ErreurImpl(
        failure: null == failure
            ? _value.failure
            : failure // ignore: cast_nullable_to_non_nullable
                  as Failure,
      ),
    );
  }

  /// Create a copy of ReunionsState
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

class _$ErreurImpl extends _Erreur {
  const _$ErreurImpl({required this.failure}) : super._();

  @override
  final Failure failure;

  @override
  String toString() {
    return 'ReunionsState.erreur(failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErreurImpl &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failure);

  /// Create a copy of ReunionsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErreurImplCopyWith<_$ErreurImpl> get copyWith =>
      __$$ErreurImplCopyWithImpl<_$ErreurImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(List<Reunion> reunions) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return erreur(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<Reunion> reunions)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return erreur?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<Reunion> reunions)? charge,
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
    required TResult Function(_Initial value) initial,
    required TResult Function(_Chargement value) chargement,
    required TResult Function(_Charge value) charge,
    required TResult Function(_Erreur value) erreur,
  }) {
    return erreur(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Chargement value)? chargement,
    TResult? Function(_Charge value)? charge,
    TResult? Function(_Erreur value)? erreur,
  }) {
    return erreur?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Chargement value)? chargement,
    TResult Function(_Charge value)? charge,
    TResult Function(_Erreur value)? erreur,
    required TResult orElse(),
  }) {
    if (erreur != null) {
      return erreur(this);
    }
    return orElse();
  }
}

abstract class _Erreur extends ReunionsState {
  const factory _Erreur({required final Failure failure}) = _$ErreurImpl;
  const _Erreur._() : super._();

  Failure get failure;

  /// Create a copy of ReunionsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErreurImplCopyWith<_$ErreurImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DecisionsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(List<Decision> decisions) charge,
    required TResult Function(Failure failure) erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<Decision> decisions)? charge,
    TResult? Function(Failure failure)? erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<Decision> decisions)? charge,
    TResult Function(Failure failure)? erreur,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DInitial value) initial,
    required TResult Function(_DChargement value) chargement,
    required TResult Function(_DCharge value) charge,
    required TResult Function(_DErreur value) erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DInitial value)? initial,
    TResult? Function(_DChargement value)? chargement,
    TResult? Function(_DCharge value)? charge,
    TResult? Function(_DErreur value)? erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DInitial value)? initial,
    TResult Function(_DChargement value)? chargement,
    TResult Function(_DCharge value)? charge,
    TResult Function(_DErreur value)? erreur,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DecisionsStateCopyWith<$Res> {
  factory $DecisionsStateCopyWith(
    DecisionsState value,
    $Res Function(DecisionsState) then,
  ) = _$DecisionsStateCopyWithImpl<$Res, DecisionsState>;
}

/// @nodoc
class _$DecisionsStateCopyWithImpl<$Res, $Val extends DecisionsState>
    implements $DecisionsStateCopyWith<$Res> {
  _$DecisionsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DecisionsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$DInitialImplCopyWith<$Res> {
  factory _$$DInitialImplCopyWith(
    _$DInitialImpl value,
    $Res Function(_$DInitialImpl) then,
  ) = __$$DInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DInitialImplCopyWithImpl<$Res>
    extends _$DecisionsStateCopyWithImpl<$Res, _$DInitialImpl>
    implements _$$DInitialImplCopyWith<$Res> {
  __$$DInitialImplCopyWithImpl(
    _$DInitialImpl _value,
    $Res Function(_$DInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DecisionsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DInitialImpl extends _DInitial {
  const _$DInitialImpl() : super._();

  @override
  String toString() {
    return 'DecisionsState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(List<Decision> decisions) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<Decision> decisions)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<Decision> decisions)? charge,
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
    required TResult Function(_DInitial value) initial,
    required TResult Function(_DChargement value) chargement,
    required TResult Function(_DCharge value) charge,
    required TResult Function(_DErreur value) erreur,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DInitial value)? initial,
    TResult? Function(_DChargement value)? chargement,
    TResult? Function(_DCharge value)? charge,
    TResult? Function(_DErreur value)? erreur,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DInitial value)? initial,
    TResult Function(_DChargement value)? chargement,
    TResult Function(_DCharge value)? charge,
    TResult Function(_DErreur value)? erreur,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _DInitial extends DecisionsState {
  const factory _DInitial() = _$DInitialImpl;
  const _DInitial._() : super._();
}

/// @nodoc
abstract class _$$DChargementImplCopyWith<$Res> {
  factory _$$DChargementImplCopyWith(
    _$DChargementImpl value,
    $Res Function(_$DChargementImpl) then,
  ) = __$$DChargementImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DChargementImplCopyWithImpl<$Res>
    extends _$DecisionsStateCopyWithImpl<$Res, _$DChargementImpl>
    implements _$$DChargementImplCopyWith<$Res> {
  __$$DChargementImplCopyWithImpl(
    _$DChargementImpl _value,
    $Res Function(_$DChargementImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DecisionsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DChargementImpl extends _DChargement {
  const _$DChargementImpl() : super._();

  @override
  String toString() {
    return 'DecisionsState.chargement()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DChargementImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(List<Decision> decisions) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return chargement();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<Decision> decisions)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return chargement?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<Decision> decisions)? charge,
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
    required TResult Function(_DInitial value) initial,
    required TResult Function(_DChargement value) chargement,
    required TResult Function(_DCharge value) charge,
    required TResult Function(_DErreur value) erreur,
  }) {
    return chargement(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DInitial value)? initial,
    TResult? Function(_DChargement value)? chargement,
    TResult? Function(_DCharge value)? charge,
    TResult? Function(_DErreur value)? erreur,
  }) {
    return chargement?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DInitial value)? initial,
    TResult Function(_DChargement value)? chargement,
    TResult Function(_DCharge value)? charge,
    TResult Function(_DErreur value)? erreur,
    required TResult orElse(),
  }) {
    if (chargement != null) {
      return chargement(this);
    }
    return orElse();
  }
}

abstract class _DChargement extends DecisionsState {
  const factory _DChargement() = _$DChargementImpl;
  const _DChargement._() : super._();
}

/// @nodoc
abstract class _$$DChargeImplCopyWith<$Res> {
  factory _$$DChargeImplCopyWith(
    _$DChargeImpl value,
    $Res Function(_$DChargeImpl) then,
  ) = __$$DChargeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Decision> decisions});
}

/// @nodoc
class __$$DChargeImplCopyWithImpl<$Res>
    extends _$DecisionsStateCopyWithImpl<$Res, _$DChargeImpl>
    implements _$$DChargeImplCopyWith<$Res> {
  __$$DChargeImplCopyWithImpl(
    _$DChargeImpl _value,
    $Res Function(_$DChargeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DecisionsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? decisions = null}) {
    return _then(
      _$DChargeImpl(
        decisions: null == decisions
            ? _value._decisions
            : decisions // ignore: cast_nullable_to_non_nullable
                  as List<Decision>,
      ),
    );
  }
}

/// @nodoc

class _$DChargeImpl extends _DCharge {
  const _$DChargeImpl({required final List<Decision> decisions})
    : _decisions = decisions,
      super._();

  final List<Decision> _decisions;
  @override
  List<Decision> get decisions {
    if (_decisions is EqualUnmodifiableListView) return _decisions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_decisions);
  }

  @override
  String toString() {
    return 'DecisionsState.charge(decisions: $decisions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DChargeImpl &&
            const DeepCollectionEquality().equals(
              other._decisions,
              _decisions,
            ));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_decisions));

  /// Create a copy of DecisionsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DChargeImplCopyWith<_$DChargeImpl> get copyWith =>
      __$$DChargeImplCopyWithImpl<_$DChargeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(List<Decision> decisions) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return charge(decisions);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<Decision> decisions)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return charge?.call(decisions);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<Decision> decisions)? charge,
    TResult Function(Failure failure)? erreur,
    required TResult orElse(),
  }) {
    if (charge != null) {
      return charge(decisions);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DInitial value) initial,
    required TResult Function(_DChargement value) chargement,
    required TResult Function(_DCharge value) charge,
    required TResult Function(_DErreur value) erreur,
  }) {
    return charge(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DInitial value)? initial,
    TResult? Function(_DChargement value)? chargement,
    TResult? Function(_DCharge value)? charge,
    TResult? Function(_DErreur value)? erreur,
  }) {
    return charge?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DInitial value)? initial,
    TResult Function(_DChargement value)? chargement,
    TResult Function(_DCharge value)? charge,
    TResult Function(_DErreur value)? erreur,
    required TResult orElse(),
  }) {
    if (charge != null) {
      return charge(this);
    }
    return orElse();
  }
}

abstract class _DCharge extends DecisionsState {
  const factory _DCharge({required final List<Decision> decisions}) =
      _$DChargeImpl;
  const _DCharge._() : super._();

  List<Decision> get decisions;

  /// Create a copy of DecisionsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DChargeImplCopyWith<_$DChargeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DErreurImplCopyWith<$Res> {
  factory _$$DErreurImplCopyWith(
    _$DErreurImpl value,
    $Res Function(_$DErreurImpl) then,
  ) = __$$DErreurImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Failure failure});

  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class __$$DErreurImplCopyWithImpl<$Res>
    extends _$DecisionsStateCopyWithImpl<$Res, _$DErreurImpl>
    implements _$$DErreurImplCopyWith<$Res> {
  __$$DErreurImplCopyWithImpl(
    _$DErreurImpl _value,
    $Res Function(_$DErreurImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DecisionsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? failure = null}) {
    return _then(
      _$DErreurImpl(
        failure: null == failure
            ? _value.failure
            : failure // ignore: cast_nullable_to_non_nullable
                  as Failure,
      ),
    );
  }

  /// Create a copy of DecisionsState
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

class _$DErreurImpl extends _DErreur {
  const _$DErreurImpl({required this.failure}) : super._();

  @override
  final Failure failure;

  @override
  String toString() {
    return 'DecisionsState.erreur(failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DErreurImpl &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failure);

  /// Create a copy of DecisionsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DErreurImplCopyWith<_$DErreurImpl> get copyWith =>
      __$$DErreurImplCopyWithImpl<_$DErreurImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(List<Decision> decisions) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return erreur(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<Decision> decisions)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return erreur?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<Decision> decisions)? charge,
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
    required TResult Function(_DInitial value) initial,
    required TResult Function(_DChargement value) chargement,
    required TResult Function(_DCharge value) charge,
    required TResult Function(_DErreur value) erreur,
  }) {
    return erreur(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DInitial value)? initial,
    TResult? Function(_DChargement value)? chargement,
    TResult? Function(_DCharge value)? charge,
    TResult? Function(_DErreur value)? erreur,
  }) {
    return erreur?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DInitial value)? initial,
    TResult Function(_DChargement value)? chargement,
    TResult Function(_DCharge value)? charge,
    TResult Function(_DErreur value)? erreur,
    required TResult orElse(),
  }) {
    if (erreur != null) {
      return erreur(this);
    }
    return orElse();
  }
}

abstract class _DErreur extends DecisionsState {
  const factory _DErreur({required final Failure failure}) = _$DErreurImpl;
  const _DErreur._() : super._();

  Failure get failure;

  /// Create a copy of DecisionsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DErreurImplCopyWith<_$DErreurImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
