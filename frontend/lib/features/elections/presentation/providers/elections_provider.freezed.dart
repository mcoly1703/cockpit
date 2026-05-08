// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'elections_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ElectionsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(List<Scrutin> scrutins) charge,
    required TResult Function(Failure failure) erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<Scrutin> scrutins)? charge,
    TResult? Function(Failure failure)? erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<Scrutin> scrutins)? charge,
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
abstract class $ElectionsStateCopyWith<$Res> {
  factory $ElectionsStateCopyWith(
    ElectionsState value,
    $Res Function(ElectionsState) then,
  ) = _$ElectionsStateCopyWithImpl<$Res, ElectionsState>;
}

/// @nodoc
class _$ElectionsStateCopyWithImpl<$Res, $Val extends ElectionsState>
    implements $ElectionsStateCopyWith<$Res> {
  _$ElectionsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ElectionsState
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
    extends _$ElectionsStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
    _$InitialImpl _value,
    $Res Function(_$InitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ElectionsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl extends _Initial {
  const _$InitialImpl() : super._();

  @override
  String toString() {
    return 'ElectionsState.initial()';
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
    required TResult Function(List<Scrutin> scrutins) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<Scrutin> scrutins)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<Scrutin> scrutins)? charge,
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

abstract class _Initial extends ElectionsState {
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
    extends _$ElectionsStateCopyWithImpl<$Res, _$ChargementImpl>
    implements _$$ChargementImplCopyWith<$Res> {
  __$$ChargementImplCopyWithImpl(
    _$ChargementImpl _value,
    $Res Function(_$ChargementImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ElectionsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ChargementImpl extends _Chargement {
  const _$ChargementImpl() : super._();

  @override
  String toString() {
    return 'ElectionsState.chargement()';
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
    required TResult Function(List<Scrutin> scrutins) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return chargement();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<Scrutin> scrutins)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return chargement?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<Scrutin> scrutins)? charge,
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

abstract class _Chargement extends ElectionsState {
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
  $Res call({List<Scrutin> scrutins});
}

/// @nodoc
class __$$ChargeImplCopyWithImpl<$Res>
    extends _$ElectionsStateCopyWithImpl<$Res, _$ChargeImpl>
    implements _$$ChargeImplCopyWith<$Res> {
  __$$ChargeImplCopyWithImpl(
    _$ChargeImpl _value,
    $Res Function(_$ChargeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ElectionsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? scrutins = null}) {
    return _then(
      _$ChargeImpl(
        scrutins: null == scrutins
            ? _value._scrutins
            : scrutins // ignore: cast_nullable_to_non_nullable
                  as List<Scrutin>,
      ),
    );
  }
}

/// @nodoc

class _$ChargeImpl extends _Charge {
  const _$ChargeImpl({required final List<Scrutin> scrutins})
    : _scrutins = scrutins,
      super._();

  final List<Scrutin> _scrutins;
  @override
  List<Scrutin> get scrutins {
    if (_scrutins is EqualUnmodifiableListView) return _scrutins;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scrutins);
  }

  @override
  String toString() {
    return 'ElectionsState.charge(scrutins: $scrutins)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChargeImpl &&
            const DeepCollectionEquality().equals(other._scrutins, _scrutins));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_scrutins));

  /// Create a copy of ElectionsState
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
    required TResult Function(List<Scrutin> scrutins) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return charge(scrutins);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<Scrutin> scrutins)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return charge?.call(scrutins);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<Scrutin> scrutins)? charge,
    TResult Function(Failure failure)? erreur,
    required TResult orElse(),
  }) {
    if (charge != null) {
      return charge(scrutins);
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

abstract class _Charge extends ElectionsState {
  const factory _Charge({required final List<Scrutin> scrutins}) = _$ChargeImpl;
  const _Charge._() : super._();

  List<Scrutin> get scrutins;

  /// Create a copy of ElectionsState
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
    extends _$ElectionsStateCopyWithImpl<$Res, _$ErreurImpl>
    implements _$$ErreurImplCopyWith<$Res> {
  __$$ErreurImplCopyWithImpl(
    _$ErreurImpl _value,
    $Res Function(_$ErreurImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ElectionsState
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

  /// Create a copy of ElectionsState
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
    return 'ElectionsState.erreur(failure: $failure)';
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

  /// Create a copy of ElectionsState
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
    required TResult Function(List<Scrutin> scrutins) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return erreur(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<Scrutin> scrutins)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return erreur?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<Scrutin> scrutins)? charge,
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

abstract class _Erreur extends ElectionsState {
  const factory _Erreur({required final Failure failure}) = _$ErreurImpl;
  const _Erreur._() : super._();

  Failure get failure;

  /// Create a copy of ElectionsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErreurImplCopyWith<_$ErreurImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CandidatsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(List<CandidatElection> candidats) charge,
    required TResult Function(Failure failure) erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<CandidatElection> candidats)? charge,
    TResult? Function(Failure failure)? erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<CandidatElection> candidats)? charge,
    TResult Function(Failure failure)? erreur,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_CInitial value) initial,
    required TResult Function(_CChargement value) chargement,
    required TResult Function(_CCharge value) charge,
    required TResult Function(_CErreur value) erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_CInitial value)? initial,
    TResult? Function(_CChargement value)? chargement,
    TResult? Function(_CCharge value)? charge,
    TResult? Function(_CErreur value)? erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_CInitial value)? initial,
    TResult Function(_CChargement value)? chargement,
    TResult Function(_CCharge value)? charge,
    TResult Function(_CErreur value)? erreur,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CandidatsStateCopyWith<$Res> {
  factory $CandidatsStateCopyWith(
    CandidatsState value,
    $Res Function(CandidatsState) then,
  ) = _$CandidatsStateCopyWithImpl<$Res, CandidatsState>;
}

/// @nodoc
class _$CandidatsStateCopyWithImpl<$Res, $Val extends CandidatsState>
    implements $CandidatsStateCopyWith<$Res> {
  _$CandidatsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CandidatsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$CInitialImplCopyWith<$Res> {
  factory _$$CInitialImplCopyWith(
    _$CInitialImpl value,
    $Res Function(_$CInitialImpl) then,
  ) = __$$CInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CInitialImplCopyWithImpl<$Res>
    extends _$CandidatsStateCopyWithImpl<$Res, _$CInitialImpl>
    implements _$$CInitialImplCopyWith<$Res> {
  __$$CInitialImplCopyWithImpl(
    _$CInitialImpl _value,
    $Res Function(_$CInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CandidatsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CInitialImpl implements _CInitial {
  const _$CInitialImpl();

  @override
  String toString() {
    return 'CandidatsState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(List<CandidatElection> candidats) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<CandidatElection> candidats)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<CandidatElection> candidats)? charge,
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
    required TResult Function(_CInitial value) initial,
    required TResult Function(_CChargement value) chargement,
    required TResult Function(_CCharge value) charge,
    required TResult Function(_CErreur value) erreur,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_CInitial value)? initial,
    TResult? Function(_CChargement value)? chargement,
    TResult? Function(_CCharge value)? charge,
    TResult? Function(_CErreur value)? erreur,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_CInitial value)? initial,
    TResult Function(_CChargement value)? chargement,
    TResult Function(_CCharge value)? charge,
    TResult Function(_CErreur value)? erreur,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _CInitial implements CandidatsState {
  const factory _CInitial() = _$CInitialImpl;
}

/// @nodoc
abstract class _$$CChargementImplCopyWith<$Res> {
  factory _$$CChargementImplCopyWith(
    _$CChargementImpl value,
    $Res Function(_$CChargementImpl) then,
  ) = __$$CChargementImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CChargementImplCopyWithImpl<$Res>
    extends _$CandidatsStateCopyWithImpl<$Res, _$CChargementImpl>
    implements _$$CChargementImplCopyWith<$Res> {
  __$$CChargementImplCopyWithImpl(
    _$CChargementImpl _value,
    $Res Function(_$CChargementImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CandidatsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CChargementImpl implements _CChargement {
  const _$CChargementImpl();

  @override
  String toString() {
    return 'CandidatsState.chargement()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CChargementImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(List<CandidatElection> candidats) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return chargement();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<CandidatElection> candidats)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return chargement?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<CandidatElection> candidats)? charge,
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
    required TResult Function(_CInitial value) initial,
    required TResult Function(_CChargement value) chargement,
    required TResult Function(_CCharge value) charge,
    required TResult Function(_CErreur value) erreur,
  }) {
    return chargement(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_CInitial value)? initial,
    TResult? Function(_CChargement value)? chargement,
    TResult? Function(_CCharge value)? charge,
    TResult? Function(_CErreur value)? erreur,
  }) {
    return chargement?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_CInitial value)? initial,
    TResult Function(_CChargement value)? chargement,
    TResult Function(_CCharge value)? charge,
    TResult Function(_CErreur value)? erreur,
    required TResult orElse(),
  }) {
    if (chargement != null) {
      return chargement(this);
    }
    return orElse();
  }
}

abstract class _CChargement implements CandidatsState {
  const factory _CChargement() = _$CChargementImpl;
}

/// @nodoc
abstract class _$$CChargeImplCopyWith<$Res> {
  factory _$$CChargeImplCopyWith(
    _$CChargeImpl value,
    $Res Function(_$CChargeImpl) then,
  ) = __$$CChargeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<CandidatElection> candidats});
}

/// @nodoc
class __$$CChargeImplCopyWithImpl<$Res>
    extends _$CandidatsStateCopyWithImpl<$Res, _$CChargeImpl>
    implements _$$CChargeImplCopyWith<$Res> {
  __$$CChargeImplCopyWithImpl(
    _$CChargeImpl _value,
    $Res Function(_$CChargeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CandidatsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? candidats = null}) {
    return _then(
      _$CChargeImpl(
        candidats: null == candidats
            ? _value._candidats
            : candidats // ignore: cast_nullable_to_non_nullable
                  as List<CandidatElection>,
      ),
    );
  }
}

/// @nodoc

class _$CChargeImpl implements _CCharge {
  const _$CChargeImpl({required final List<CandidatElection> candidats})
    : _candidats = candidats;

  final List<CandidatElection> _candidats;
  @override
  List<CandidatElection> get candidats {
    if (_candidats is EqualUnmodifiableListView) return _candidats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_candidats);
  }

  @override
  String toString() {
    return 'CandidatsState.charge(candidats: $candidats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CChargeImpl &&
            const DeepCollectionEquality().equals(
              other._candidats,
              _candidats,
            ));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_candidats));

  /// Create a copy of CandidatsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CChargeImplCopyWith<_$CChargeImpl> get copyWith =>
      __$$CChargeImplCopyWithImpl<_$CChargeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(List<CandidatElection> candidats) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return charge(candidats);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<CandidatElection> candidats)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return charge?.call(candidats);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<CandidatElection> candidats)? charge,
    TResult Function(Failure failure)? erreur,
    required TResult orElse(),
  }) {
    if (charge != null) {
      return charge(candidats);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_CInitial value) initial,
    required TResult Function(_CChargement value) chargement,
    required TResult Function(_CCharge value) charge,
    required TResult Function(_CErreur value) erreur,
  }) {
    return charge(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_CInitial value)? initial,
    TResult? Function(_CChargement value)? chargement,
    TResult? Function(_CCharge value)? charge,
    TResult? Function(_CErreur value)? erreur,
  }) {
    return charge?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_CInitial value)? initial,
    TResult Function(_CChargement value)? chargement,
    TResult Function(_CCharge value)? charge,
    TResult Function(_CErreur value)? erreur,
    required TResult orElse(),
  }) {
    if (charge != null) {
      return charge(this);
    }
    return orElse();
  }
}

abstract class _CCharge implements CandidatsState {
  const factory _CCharge({required final List<CandidatElection> candidats}) =
      _$CChargeImpl;

  List<CandidatElection> get candidats;

  /// Create a copy of CandidatsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CChargeImplCopyWith<_$CChargeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CErreurImplCopyWith<$Res> {
  factory _$$CErreurImplCopyWith(
    _$CErreurImpl value,
    $Res Function(_$CErreurImpl) then,
  ) = __$$CErreurImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Failure failure});

  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class __$$CErreurImplCopyWithImpl<$Res>
    extends _$CandidatsStateCopyWithImpl<$Res, _$CErreurImpl>
    implements _$$CErreurImplCopyWith<$Res> {
  __$$CErreurImplCopyWithImpl(
    _$CErreurImpl _value,
    $Res Function(_$CErreurImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CandidatsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? failure = null}) {
    return _then(
      _$CErreurImpl(
        failure: null == failure
            ? _value.failure
            : failure // ignore: cast_nullable_to_non_nullable
                  as Failure,
      ),
    );
  }

  /// Create a copy of CandidatsState
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

class _$CErreurImpl implements _CErreur {
  const _$CErreurImpl({required this.failure});

  @override
  final Failure failure;

  @override
  String toString() {
    return 'CandidatsState.erreur(failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CErreurImpl &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failure);

  /// Create a copy of CandidatsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CErreurImplCopyWith<_$CErreurImpl> get copyWith =>
      __$$CErreurImplCopyWithImpl<_$CErreurImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(List<CandidatElection> candidats) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return erreur(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<CandidatElection> candidats)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return erreur?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<CandidatElection> candidats)? charge,
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
    required TResult Function(_CInitial value) initial,
    required TResult Function(_CChargement value) chargement,
    required TResult Function(_CCharge value) charge,
    required TResult Function(_CErreur value) erreur,
  }) {
    return erreur(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_CInitial value)? initial,
    TResult? Function(_CChargement value)? chargement,
    TResult? Function(_CCharge value)? charge,
    TResult? Function(_CErreur value)? erreur,
  }) {
    return erreur?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_CInitial value)? initial,
    TResult Function(_CChargement value)? chargement,
    TResult Function(_CCharge value)? charge,
    TResult Function(_CErreur value)? erreur,
    required TResult orElse(),
  }) {
    if (erreur != null) {
      return erreur(this);
    }
    return orElse();
  }
}

abstract class _CErreur implements CandidatsState {
  const factory _CErreur({required final Failure failure}) = _$CErreurImpl;

  Failure get failure;

  /// Create a copy of CandidatsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CErreurImplCopyWith<_$CErreurImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
