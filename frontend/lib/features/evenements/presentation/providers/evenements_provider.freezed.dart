// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'evenements_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$EvenementsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(List<Evenement> evenements) charge,
    required TResult Function(Failure failure) erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<Evenement> evenements)? charge,
    TResult? Function(Failure failure)? erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<Evenement> evenements)? charge,
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
abstract class $EvenementsStateCopyWith<$Res> {
  factory $EvenementsStateCopyWith(
    EvenementsState value,
    $Res Function(EvenementsState) then,
  ) = _$EvenementsStateCopyWithImpl<$Res, EvenementsState>;
}

/// @nodoc
class _$EvenementsStateCopyWithImpl<$Res, $Val extends EvenementsState>
    implements $EvenementsStateCopyWith<$Res> {
  _$EvenementsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EvenementsState
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
    extends _$EvenementsStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
    _$InitialImpl _value,
    $Res Function(_$InitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EvenementsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl extends _Initial {
  const _$InitialImpl() : super._();

  @override
  String toString() {
    return 'EvenementsState.initial()';
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
    required TResult Function(List<Evenement> evenements) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<Evenement> evenements)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<Evenement> evenements)? charge,
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

abstract class _Initial extends EvenementsState {
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
    extends _$EvenementsStateCopyWithImpl<$Res, _$ChargementImpl>
    implements _$$ChargementImplCopyWith<$Res> {
  __$$ChargementImplCopyWithImpl(
    _$ChargementImpl _value,
    $Res Function(_$ChargementImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EvenementsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ChargementImpl extends _Chargement {
  const _$ChargementImpl() : super._();

  @override
  String toString() {
    return 'EvenementsState.chargement()';
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
    required TResult Function(List<Evenement> evenements) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return chargement();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<Evenement> evenements)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return chargement?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<Evenement> evenements)? charge,
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

abstract class _Chargement extends EvenementsState {
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
  $Res call({List<Evenement> evenements});
}

/// @nodoc
class __$$ChargeImplCopyWithImpl<$Res>
    extends _$EvenementsStateCopyWithImpl<$Res, _$ChargeImpl>
    implements _$$ChargeImplCopyWith<$Res> {
  __$$ChargeImplCopyWithImpl(
    _$ChargeImpl _value,
    $Res Function(_$ChargeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EvenementsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? evenements = null}) {
    return _then(
      _$ChargeImpl(
        evenements: null == evenements
            ? _value._evenements
            : evenements // ignore: cast_nullable_to_non_nullable
                  as List<Evenement>,
      ),
    );
  }
}

/// @nodoc

class _$ChargeImpl extends _Charge {
  const _$ChargeImpl({required final List<Evenement> evenements})
    : _evenements = evenements,
      super._();

  final List<Evenement> _evenements;
  @override
  List<Evenement> get evenements {
    if (_evenements is EqualUnmodifiableListView) return _evenements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_evenements);
  }

  @override
  String toString() {
    return 'EvenementsState.charge(evenements: $evenements)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChargeImpl &&
            const DeepCollectionEquality().equals(
              other._evenements,
              _evenements,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_evenements),
  );

  /// Create a copy of EvenementsState
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
    required TResult Function(List<Evenement> evenements) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return charge(evenements);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<Evenement> evenements)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return charge?.call(evenements);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<Evenement> evenements)? charge,
    TResult Function(Failure failure)? erreur,
    required TResult orElse(),
  }) {
    if (charge != null) {
      return charge(evenements);
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

abstract class _Charge extends EvenementsState {
  const factory _Charge({required final List<Evenement> evenements}) =
      _$ChargeImpl;
  const _Charge._() : super._();

  List<Evenement> get evenements;

  /// Create a copy of EvenementsState
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
    extends _$EvenementsStateCopyWithImpl<$Res, _$ErreurImpl>
    implements _$$ErreurImplCopyWith<$Res> {
  __$$ErreurImplCopyWithImpl(
    _$ErreurImpl _value,
    $Res Function(_$ErreurImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EvenementsState
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

  /// Create a copy of EvenementsState
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
    return 'EvenementsState.erreur(failure: $failure)';
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

  /// Create a copy of EvenementsState
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
    required TResult Function(List<Evenement> evenements) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return erreur(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<Evenement> evenements)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return erreur?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<Evenement> evenements)? charge,
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

abstract class _Erreur extends EvenementsState {
  const factory _Erreur({required final Failure failure}) = _$ErreurImpl;
  const _Erreur._() : super._();

  Failure get failure;

  /// Create a copy of EvenementsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErreurImplCopyWith<_$ErreurImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PresencesState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(List<Presence> presences) charge,
    required TResult Function(Failure failure) erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<Presence> presences)? charge,
    TResult? Function(Failure failure)? erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<Presence> presences)? charge,
    TResult Function(Failure failure)? erreur,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PInitial value) initial,
    required TResult Function(_PChargement value) chargement,
    required TResult Function(_PCharge value) charge,
    required TResult Function(_PErreur value) erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PInitial value)? initial,
    TResult? Function(_PChargement value)? chargement,
    TResult? Function(_PCharge value)? charge,
    TResult? Function(_PErreur value)? erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PInitial value)? initial,
    TResult Function(_PChargement value)? chargement,
    TResult Function(_PCharge value)? charge,
    TResult Function(_PErreur value)? erreur,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PresencesStateCopyWith<$Res> {
  factory $PresencesStateCopyWith(
    PresencesState value,
    $Res Function(PresencesState) then,
  ) = _$PresencesStateCopyWithImpl<$Res, PresencesState>;
}

/// @nodoc
class _$PresencesStateCopyWithImpl<$Res, $Val extends PresencesState>
    implements $PresencesStateCopyWith<$Res> {
  _$PresencesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PresencesState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$PInitialImplCopyWith<$Res> {
  factory _$$PInitialImplCopyWith(
    _$PInitialImpl value,
    $Res Function(_$PInitialImpl) then,
  ) = __$$PInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PInitialImplCopyWithImpl<$Res>
    extends _$PresencesStateCopyWithImpl<$Res, _$PInitialImpl>
    implements _$$PInitialImplCopyWith<$Res> {
  __$$PInitialImplCopyWithImpl(
    _$PInitialImpl _value,
    $Res Function(_$PInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PresencesState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PInitialImpl implements _PInitial {
  const _$PInitialImpl();

  @override
  String toString() {
    return 'PresencesState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(List<Presence> presences) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<Presence> presences)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<Presence> presences)? charge,
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
    required TResult Function(_PInitial value) initial,
    required TResult Function(_PChargement value) chargement,
    required TResult Function(_PCharge value) charge,
    required TResult Function(_PErreur value) erreur,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PInitial value)? initial,
    TResult? Function(_PChargement value)? chargement,
    TResult? Function(_PCharge value)? charge,
    TResult? Function(_PErreur value)? erreur,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PInitial value)? initial,
    TResult Function(_PChargement value)? chargement,
    TResult Function(_PCharge value)? charge,
    TResult Function(_PErreur value)? erreur,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _PInitial implements PresencesState {
  const factory _PInitial() = _$PInitialImpl;
}

/// @nodoc
abstract class _$$PChargementImplCopyWith<$Res> {
  factory _$$PChargementImplCopyWith(
    _$PChargementImpl value,
    $Res Function(_$PChargementImpl) then,
  ) = __$$PChargementImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PChargementImplCopyWithImpl<$Res>
    extends _$PresencesStateCopyWithImpl<$Res, _$PChargementImpl>
    implements _$$PChargementImplCopyWith<$Res> {
  __$$PChargementImplCopyWithImpl(
    _$PChargementImpl _value,
    $Res Function(_$PChargementImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PresencesState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PChargementImpl implements _PChargement {
  const _$PChargementImpl();

  @override
  String toString() {
    return 'PresencesState.chargement()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PChargementImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(List<Presence> presences) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return chargement();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<Presence> presences)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return chargement?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<Presence> presences)? charge,
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
    required TResult Function(_PInitial value) initial,
    required TResult Function(_PChargement value) chargement,
    required TResult Function(_PCharge value) charge,
    required TResult Function(_PErreur value) erreur,
  }) {
    return chargement(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PInitial value)? initial,
    TResult? Function(_PChargement value)? chargement,
    TResult? Function(_PCharge value)? charge,
    TResult? Function(_PErreur value)? erreur,
  }) {
    return chargement?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PInitial value)? initial,
    TResult Function(_PChargement value)? chargement,
    TResult Function(_PCharge value)? charge,
    TResult Function(_PErreur value)? erreur,
    required TResult orElse(),
  }) {
    if (chargement != null) {
      return chargement(this);
    }
    return orElse();
  }
}

abstract class _PChargement implements PresencesState {
  const factory _PChargement() = _$PChargementImpl;
}

/// @nodoc
abstract class _$$PChargeImplCopyWith<$Res> {
  factory _$$PChargeImplCopyWith(
    _$PChargeImpl value,
    $Res Function(_$PChargeImpl) then,
  ) = __$$PChargeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Presence> presences});
}

/// @nodoc
class __$$PChargeImplCopyWithImpl<$Res>
    extends _$PresencesStateCopyWithImpl<$Res, _$PChargeImpl>
    implements _$$PChargeImplCopyWith<$Res> {
  __$$PChargeImplCopyWithImpl(
    _$PChargeImpl _value,
    $Res Function(_$PChargeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PresencesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? presences = null}) {
    return _then(
      _$PChargeImpl(
        presences: null == presences
            ? _value._presences
            : presences // ignore: cast_nullable_to_non_nullable
                  as List<Presence>,
      ),
    );
  }
}

/// @nodoc

class _$PChargeImpl implements _PCharge {
  const _$PChargeImpl({required final List<Presence> presences})
    : _presences = presences;

  final List<Presence> _presences;
  @override
  List<Presence> get presences {
    if (_presences is EqualUnmodifiableListView) return _presences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_presences);
  }

  @override
  String toString() {
    return 'PresencesState.charge(presences: $presences)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PChargeImpl &&
            const DeepCollectionEquality().equals(
              other._presences,
              _presences,
            ));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_presences));

  /// Create a copy of PresencesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PChargeImplCopyWith<_$PChargeImpl> get copyWith =>
      __$$PChargeImplCopyWithImpl<_$PChargeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(List<Presence> presences) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return charge(presences);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<Presence> presences)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return charge?.call(presences);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<Presence> presences)? charge,
    TResult Function(Failure failure)? erreur,
    required TResult orElse(),
  }) {
    if (charge != null) {
      return charge(presences);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PInitial value) initial,
    required TResult Function(_PChargement value) chargement,
    required TResult Function(_PCharge value) charge,
    required TResult Function(_PErreur value) erreur,
  }) {
    return charge(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PInitial value)? initial,
    TResult? Function(_PChargement value)? chargement,
    TResult? Function(_PCharge value)? charge,
    TResult? Function(_PErreur value)? erreur,
  }) {
    return charge?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PInitial value)? initial,
    TResult Function(_PChargement value)? chargement,
    TResult Function(_PCharge value)? charge,
    TResult Function(_PErreur value)? erreur,
    required TResult orElse(),
  }) {
    if (charge != null) {
      return charge(this);
    }
    return orElse();
  }
}

abstract class _PCharge implements PresencesState {
  const factory _PCharge({required final List<Presence> presences}) =
      _$PChargeImpl;

  List<Presence> get presences;

  /// Create a copy of PresencesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PChargeImplCopyWith<_$PChargeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PErreurImplCopyWith<$Res> {
  factory _$$PErreurImplCopyWith(
    _$PErreurImpl value,
    $Res Function(_$PErreurImpl) then,
  ) = __$$PErreurImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Failure failure});

  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class __$$PErreurImplCopyWithImpl<$Res>
    extends _$PresencesStateCopyWithImpl<$Res, _$PErreurImpl>
    implements _$$PErreurImplCopyWith<$Res> {
  __$$PErreurImplCopyWithImpl(
    _$PErreurImpl _value,
    $Res Function(_$PErreurImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PresencesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? failure = null}) {
    return _then(
      _$PErreurImpl(
        failure: null == failure
            ? _value.failure
            : failure // ignore: cast_nullable_to_non_nullable
                  as Failure,
      ),
    );
  }

  /// Create a copy of PresencesState
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

class _$PErreurImpl implements _PErreur {
  const _$PErreurImpl({required this.failure});

  @override
  final Failure failure;

  @override
  String toString() {
    return 'PresencesState.erreur(failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PErreurImpl &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failure);

  /// Create a copy of PresencesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PErreurImplCopyWith<_$PErreurImpl> get copyWith =>
      __$$PErreurImplCopyWithImpl<_$PErreurImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() chargement,
    required TResult Function(List<Presence> presences) charge,
    required TResult Function(Failure failure) erreur,
  }) {
    return erreur(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? chargement,
    TResult? Function(List<Presence> presences)? charge,
    TResult? Function(Failure failure)? erreur,
  }) {
    return erreur?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? chargement,
    TResult Function(List<Presence> presences)? charge,
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
    required TResult Function(_PInitial value) initial,
    required TResult Function(_PChargement value) chargement,
    required TResult Function(_PCharge value) charge,
    required TResult Function(_PErreur value) erreur,
  }) {
    return erreur(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PInitial value)? initial,
    TResult? Function(_PChargement value)? chargement,
    TResult? Function(_PCharge value)? charge,
    TResult? Function(_PErreur value)? erreur,
  }) {
    return erreur?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PInitial value)? initial,
    TResult Function(_PChargement value)? chargement,
    TResult Function(_PCharge value)? charge,
    TResult Function(_PErreur value)? erreur,
    required TResult orElse(),
  }) {
    if (erreur != null) {
      return erreur(this);
    }
    return orElse();
  }
}

abstract class _PErreur implements PresencesState {
  const factory _PErreur({required final Failure failure}) = _$PErreurImpl;

  Failure get failure;

  /// Create a copy of PresencesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PErreurImplCopyWith<_$PErreurImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
