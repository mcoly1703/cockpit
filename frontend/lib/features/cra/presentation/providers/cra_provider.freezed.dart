// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cra_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CraState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(List<CompteRendu> rendus) charge,
    required TResult Function(Failure failure) erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<CompteRendu> rendus)? charge,
    TResult? Function(Failure failure)? erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<CompteRendu> rendus)? charge,
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
abstract class $CraStateCopyWith<$Res> {
  factory $CraStateCopyWith(CraState value, $Res Function(CraState) then) =
      _$CraStateCopyWithImpl<$Res, CraState>;
}

/// @nodoc
class _$CraStateCopyWithImpl<$Res, $Val extends CraState>
    implements $CraStateCopyWith<$Res> {
  _$CraStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CraState
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
    extends _$CraStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
    _$InitialImpl _value,
    $Res Function(_$InitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CraState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl extends _Initial {
  const _$InitialImpl() : super._();

  @override
  String toString() {
    return 'CraState.initial()';
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
    required TResult Function(List<CompteRendu> rendus) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<CompteRendu> rendus)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<CompteRendu> rendus)? charge,
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

abstract class _Initial extends CraState {
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
    extends _$CraStateCopyWithImpl<$Res, _$ChargementImpl>
    implements _$$ChargementImplCopyWith<$Res> {
  __$$ChargementImplCopyWithImpl(
    _$ChargementImpl _value,
    $Res Function(_$ChargementImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CraState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ChargementImpl extends _Chargement {
  const _$ChargementImpl() : super._();

  @override
  String toString() {
    return 'CraState.chargement()';
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
    required TResult Function(List<CompteRendu> rendus) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return chargement();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<CompteRendu> rendus)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return chargement?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<CompteRendu> rendus)? charge,
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

abstract class _Chargement extends CraState {
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
  $Res call({List<CompteRendu> rendus});
}

/// @nodoc
class __$$ChargeImplCopyWithImpl<$Res>
    extends _$CraStateCopyWithImpl<$Res, _$ChargeImpl>
    implements _$$ChargeImplCopyWith<$Res> {
  __$$ChargeImplCopyWithImpl(
    _$ChargeImpl _value,
    $Res Function(_$ChargeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CraState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? rendus = null}) {
    return _then(
      _$ChargeImpl(
        rendus: null == rendus
            ? _value._rendus
            : rendus // ignore: cast_nullable_to_non_nullable
                  as List<CompteRendu>,
      ),
    );
  }
}

/// @nodoc

class _$ChargeImpl extends _Charge {
  const _$ChargeImpl({required final List<CompteRendu> rendus})
    : _rendus = rendus,
      super._();

  final List<CompteRendu> _rendus;
  @override
  List<CompteRendu> get rendus {
    if (_rendus is EqualUnmodifiableListView) return _rendus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rendus);
  }

  @override
  String toString() {
    return 'CraState.charge(rendus: $rendus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChargeImpl &&
            const DeepCollectionEquality().equals(other._rendus, _rendus));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_rendus));

  /// Create a copy of CraState
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
    required TResult Function(List<CompteRendu> rendus) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return charge(rendus);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<CompteRendu> rendus)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return charge?.call(rendus);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<CompteRendu> rendus)? charge,
    TResult Function(Failure failure)? erreur,
    required TResult orElse(),
  }) {
    if (charge != null) {
      return charge(rendus);
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

abstract class _Charge extends CraState {
  const factory _Charge({required final List<CompteRendu> rendus}) =
      _$ChargeImpl;
  const _Charge._() : super._();

  List<CompteRendu> get rendus;

  /// Create a copy of CraState
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
    extends _$CraStateCopyWithImpl<$Res, _$ErreurImpl>
    implements _$$ErreurImplCopyWith<$Res> {
  __$$ErreurImplCopyWithImpl(
    _$ErreurImpl _value,
    $Res Function(_$ErreurImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CraState
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

  /// Create a copy of CraState
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
    return 'CraState.erreur(failure: $failure)';
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

  /// Create a copy of CraState
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
    required TResult Function(List<CompteRendu> rendus) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return erreur(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<CompteRendu> rendus)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return erreur?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<CompteRendu> rendus)? charge,
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

abstract class _Erreur extends CraState {
  const factory _Erreur({required final Failure failure}) = _$ErreurImpl;
  const _Erreur._() : super._();

  Failure get failure;

  /// Create a copy of CraState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErreurImplCopyWith<_$ErreurImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CraRecusState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(List<CompteRendu> rendus) charge,
    required TResult Function(Failure failure) erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<CompteRendu> rendus)? charge,
    TResult? Function(Failure failure)? erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<CompteRendu> rendus)? charge,
    TResult Function(Failure failure)? erreur,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_RInitial value) initial,
    required TResult Function(_RChargement value) chargement,
    required TResult Function(_RCharge value) charge,
    required TResult Function(_RErreur value) erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_RInitial value)? initial,
    TResult? Function(_RChargement value)? chargement,
    TResult? Function(_RCharge value)? charge,
    TResult? Function(_RErreur value)? erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RInitial value)? initial,
    TResult Function(_RChargement value)? chargement,
    TResult Function(_RCharge value)? charge,
    TResult Function(_RErreur value)? erreur,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CraRecusStateCopyWith<$Res> {
  factory $CraRecusStateCopyWith(
    CraRecusState value,
    $Res Function(CraRecusState) then,
  ) = _$CraRecusStateCopyWithImpl<$Res, CraRecusState>;
}

/// @nodoc
class _$CraRecusStateCopyWithImpl<$Res, $Val extends CraRecusState>
    implements $CraRecusStateCopyWith<$Res> {
  _$CraRecusStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CraRecusState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$RInitialImplCopyWith<$Res> {
  factory _$$RInitialImplCopyWith(
    _$RInitialImpl value,
    $Res Function(_$RInitialImpl) then,
  ) = __$$RInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RInitialImplCopyWithImpl<$Res>
    extends _$CraRecusStateCopyWithImpl<$Res, _$RInitialImpl>
    implements _$$RInitialImplCopyWith<$Res> {
  __$$RInitialImplCopyWithImpl(
    _$RInitialImpl _value,
    $Res Function(_$RInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CraRecusState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RInitialImpl implements _RInitial {
  const _$RInitialImpl();

  @override
  String toString() {
    return 'CraRecusState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(List<CompteRendu> rendus) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<CompteRendu> rendus)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<CompteRendu> rendus)? charge,
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
    required TResult Function(_RInitial value) initial,
    required TResult Function(_RChargement value) chargement,
    required TResult Function(_RCharge value) charge,
    required TResult Function(_RErreur value) erreur,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_RInitial value)? initial,
    TResult? Function(_RChargement value)? chargement,
    TResult? Function(_RCharge value)? charge,
    TResult? Function(_RErreur value)? erreur,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RInitial value)? initial,
    TResult Function(_RChargement value)? chargement,
    TResult Function(_RCharge value)? charge,
    TResult Function(_RErreur value)? erreur,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _RInitial implements CraRecusState {
  const factory _RInitial() = _$RInitialImpl;
}

/// @nodoc
abstract class _$$RChargementImplCopyWith<$Res> {
  factory _$$RChargementImplCopyWith(
    _$RChargementImpl value,
    $Res Function(_$RChargementImpl) then,
  ) = __$$RChargementImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RChargementImplCopyWithImpl<$Res>
    extends _$CraRecusStateCopyWithImpl<$Res, _$RChargementImpl>
    implements _$$RChargementImplCopyWith<$Res> {
  __$$RChargementImplCopyWithImpl(
    _$RChargementImpl _value,
    $Res Function(_$RChargementImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CraRecusState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RChargementImpl implements _RChargement {
  const _$RChargementImpl();

  @override
  String toString() {
    return 'CraRecusState.chargement()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RChargementImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(List<CompteRendu> rendus) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return chargement();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<CompteRendu> rendus)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return chargement?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<CompteRendu> rendus)? charge,
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
    required TResult Function(_RInitial value) initial,
    required TResult Function(_RChargement value) chargement,
    required TResult Function(_RCharge value) charge,
    required TResult Function(_RErreur value) erreur,
  }) {
    return chargement(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_RInitial value)? initial,
    TResult? Function(_RChargement value)? chargement,
    TResult? Function(_RCharge value)? charge,
    TResult? Function(_RErreur value)? erreur,
  }) {
    return chargement?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RInitial value)? initial,
    TResult Function(_RChargement value)? chargement,
    TResult Function(_RCharge value)? charge,
    TResult Function(_RErreur value)? erreur,
    required TResult orElse(),
  }) {
    if (chargement != null) {
      return chargement(this);
    }
    return orElse();
  }
}

abstract class _RChargement implements CraRecusState {
  const factory _RChargement() = _$RChargementImpl;
}

/// @nodoc
abstract class _$$RChargeImplCopyWith<$Res> {
  factory _$$RChargeImplCopyWith(
    _$RChargeImpl value,
    $Res Function(_$RChargeImpl) then,
  ) = __$$RChargeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<CompteRendu> rendus});
}

/// @nodoc
class __$$RChargeImplCopyWithImpl<$Res>
    extends _$CraRecusStateCopyWithImpl<$Res, _$RChargeImpl>
    implements _$$RChargeImplCopyWith<$Res> {
  __$$RChargeImplCopyWithImpl(
    _$RChargeImpl _value,
    $Res Function(_$RChargeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CraRecusState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? rendus = null}) {
    return _then(
      _$RChargeImpl(
        rendus: null == rendus
            ? _value._rendus
            : rendus // ignore: cast_nullable_to_non_nullable
                  as List<CompteRendu>,
      ),
    );
  }
}

/// @nodoc

class _$RChargeImpl implements _RCharge {
  const _$RChargeImpl({required final List<CompteRendu> rendus})
    : _rendus = rendus;

  final List<CompteRendu> _rendus;
  @override
  List<CompteRendu> get rendus {
    if (_rendus is EqualUnmodifiableListView) return _rendus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rendus);
  }

  @override
  String toString() {
    return 'CraRecusState.charge(rendus: $rendus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RChargeImpl &&
            const DeepCollectionEquality().equals(other._rendus, _rendus));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_rendus));

  /// Create a copy of CraRecusState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RChargeImplCopyWith<_$RChargeImpl> get copyWith =>
      __$$RChargeImplCopyWithImpl<_$RChargeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(List<CompteRendu> rendus) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return charge(rendus);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<CompteRendu> rendus)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return charge?.call(rendus);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<CompteRendu> rendus)? charge,
    TResult Function(Failure failure)? erreur,
    required TResult orElse(),
  }) {
    if (charge != null) {
      return charge(rendus);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_RInitial value) initial,
    required TResult Function(_RChargement value) chargement,
    required TResult Function(_RCharge value) charge,
    required TResult Function(_RErreur value) erreur,
  }) {
    return charge(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_RInitial value)? initial,
    TResult? Function(_RChargement value)? chargement,
    TResult? Function(_RCharge value)? charge,
    TResult? Function(_RErreur value)? erreur,
  }) {
    return charge?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RInitial value)? initial,
    TResult Function(_RChargement value)? chargement,
    TResult Function(_RCharge value)? charge,
    TResult Function(_RErreur value)? erreur,
    required TResult orElse(),
  }) {
    if (charge != null) {
      return charge(this);
    }
    return orElse();
  }
}

abstract class _RCharge implements CraRecusState {
  const factory _RCharge({required final List<CompteRendu> rendus}) =
      _$RChargeImpl;

  List<CompteRendu> get rendus;

  /// Create a copy of CraRecusState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RChargeImplCopyWith<_$RChargeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RErreurImplCopyWith<$Res> {
  factory _$$RErreurImplCopyWith(
    _$RErreurImpl value,
    $Res Function(_$RErreurImpl) then,
  ) = __$$RErreurImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Failure failure});

  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class __$$RErreurImplCopyWithImpl<$Res>
    extends _$CraRecusStateCopyWithImpl<$Res, _$RErreurImpl>
    implements _$$RErreurImplCopyWith<$Res> {
  __$$RErreurImplCopyWithImpl(
    _$RErreurImpl _value,
    $Res Function(_$RErreurImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CraRecusState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? failure = null}) {
    return _then(
      _$RErreurImpl(
        failure: null == failure
            ? _value.failure
            : failure // ignore: cast_nullable_to_non_nullable
                  as Failure,
      ),
    );
  }

  /// Create a copy of CraRecusState
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

class _$RErreurImpl implements _RErreur {
  const _$RErreurImpl({required this.failure});

  @override
  final Failure failure;

  @override
  String toString() {
    return 'CraRecusState.erreur(failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RErreurImpl &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failure);

  /// Create a copy of CraRecusState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RErreurImplCopyWith<_$RErreurImpl> get copyWith =>
      __$$RErreurImplCopyWithImpl<_$RErreurImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(List<CompteRendu> rendus) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return erreur(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<CompteRendu> rendus)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return erreur?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<CompteRendu> rendus)? charge,
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
    required TResult Function(_RInitial value) initial,
    required TResult Function(_RChargement value) chargement,
    required TResult Function(_RCharge value) charge,
    required TResult Function(_RErreur value) erreur,
  }) {
    return erreur(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_RInitial value)? initial,
    TResult? Function(_RChargement value)? chargement,
    TResult? Function(_RCharge value)? charge,
    TResult? Function(_RErreur value)? erreur,
  }) {
    return erreur?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RInitial value)? initial,
    TResult Function(_RChargement value)? chargement,
    TResult Function(_RCharge value)? charge,
    TResult Function(_RErreur value)? erreur,
    required TResult orElse(),
  }) {
    if (erreur != null) {
      return erreur(this);
    }
    return orElse();
  }
}

abstract class _RErreur implements CraRecusState {
  const factory _RErreur({required final Failure failure}) = _$RErreurImpl;

  Failure get failure;

  /// Create a copy of CraRecusState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RErreurImplCopyWith<_$RErreurImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
