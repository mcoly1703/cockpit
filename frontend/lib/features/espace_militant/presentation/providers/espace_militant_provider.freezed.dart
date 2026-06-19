// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'espace_militant_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$EspaceMilitantState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() verification,
    required TResult Function() chargement,
    required TResult Function(
      EspaceMilitantInfo militant,
      List<EspaceCotisationMois> cotisations,
      EspaceFinancesResume finances,
    )
    charge,
    required TResult Function(String message) erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? verification,
    TResult? Function()? chargement,
    TResult? Function(
      EspaceMilitantInfo militant,
      List<EspaceCotisationMois> cotisations,
      EspaceFinancesResume finances,
    )?
    charge,
    TResult? Function(String message)? erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? verification,
    TResult Function()? chargement,
    TResult Function(
      EspaceMilitantInfo militant,
      List<EspaceCotisationMois> cotisations,
      EspaceFinancesResume finances,
    )?
    charge,
    TResult Function(String message)? erreur,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Verification value) verification,
    required TResult Function(_Chargement value) chargement,
    required TResult Function(_Charge value) charge,
    required TResult Function(_Erreur value) erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Verification value)? verification,
    TResult? Function(_Chargement value)? chargement,
    TResult? Function(_Charge value)? charge,
    TResult? Function(_Erreur value)? erreur,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Verification value)? verification,
    TResult Function(_Chargement value)? chargement,
    TResult Function(_Charge value)? charge,
    TResult Function(_Erreur value)? erreur,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EspaceMilitantStateCopyWith<$Res> {
  factory $EspaceMilitantStateCopyWith(
    EspaceMilitantState value,
    $Res Function(EspaceMilitantState) then,
  ) = _$EspaceMilitantStateCopyWithImpl<$Res, EspaceMilitantState>;
}

/// @nodoc
class _$EspaceMilitantStateCopyWithImpl<$Res, $Val extends EspaceMilitantState>
    implements $EspaceMilitantStateCopyWith<$Res> {
  _$EspaceMilitantStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EspaceMilitantState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$VerificationImplCopyWith<$Res> {
  factory _$$VerificationImplCopyWith(
    _$VerificationImpl value,
    $Res Function(_$VerificationImpl) then,
  ) = __$$VerificationImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$VerificationImplCopyWithImpl<$Res>
    extends _$EspaceMilitantStateCopyWithImpl<$Res, _$VerificationImpl>
    implements _$$VerificationImplCopyWith<$Res> {
  __$$VerificationImplCopyWithImpl(
    _$VerificationImpl _value,
    $Res Function(_$VerificationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EspaceMilitantState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$VerificationImpl implements _Verification {
  const _$VerificationImpl();

  @override
  String toString() {
    return 'EspaceMilitantState.verification()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$VerificationImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() verification,
    required TResult Function() chargement,
    required TResult Function(
      EspaceMilitantInfo militant,
      List<EspaceCotisationMois> cotisations,
      EspaceFinancesResume finances,
    )
    charge,
    required TResult Function(String message) erreur,
  }) {
    return verification();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? verification,
    TResult? Function()? chargement,
    TResult? Function(
      EspaceMilitantInfo militant,
      List<EspaceCotisationMois> cotisations,
      EspaceFinancesResume finances,
    )?
    charge,
    TResult? Function(String message)? erreur,
  }) {
    return verification?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? verification,
    TResult Function()? chargement,
    TResult Function(
      EspaceMilitantInfo militant,
      List<EspaceCotisationMois> cotisations,
      EspaceFinancesResume finances,
    )?
    charge,
    TResult Function(String message)? erreur,
    required TResult orElse(),
  }) {
    if (verification != null) {
      return verification();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Verification value) verification,
    required TResult Function(_Chargement value) chargement,
    required TResult Function(_Charge value) charge,
    required TResult Function(_Erreur value) erreur,
  }) {
    return verification(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Verification value)? verification,
    TResult? Function(_Chargement value)? chargement,
    TResult? Function(_Charge value)? charge,
    TResult? Function(_Erreur value)? erreur,
  }) {
    return verification?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Verification value)? verification,
    TResult Function(_Chargement value)? chargement,
    TResult Function(_Charge value)? charge,
    TResult Function(_Erreur value)? erreur,
    required TResult orElse(),
  }) {
    if (verification != null) {
      return verification(this);
    }
    return orElse();
  }
}

abstract class _Verification implements EspaceMilitantState {
  const factory _Verification() = _$VerificationImpl;
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
    extends _$EspaceMilitantStateCopyWithImpl<$Res, _$ChargementImpl>
    implements _$$ChargementImplCopyWith<$Res> {
  __$$ChargementImplCopyWithImpl(
    _$ChargementImpl _value,
    $Res Function(_$ChargementImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EspaceMilitantState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ChargementImpl implements _Chargement {
  const _$ChargementImpl();

  @override
  String toString() {
    return 'EspaceMilitantState.chargement()';
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
    required TResult Function() verification,
    required TResult Function() chargement,
    required TResult Function(
      EspaceMilitantInfo militant,
      List<EspaceCotisationMois> cotisations,
      EspaceFinancesResume finances,
    )
    charge,
    required TResult Function(String message) erreur,
  }) {
    return chargement();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? verification,
    TResult? Function()? chargement,
    TResult? Function(
      EspaceMilitantInfo militant,
      List<EspaceCotisationMois> cotisations,
      EspaceFinancesResume finances,
    )?
    charge,
    TResult? Function(String message)? erreur,
  }) {
    return chargement?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? verification,
    TResult Function()? chargement,
    TResult Function(
      EspaceMilitantInfo militant,
      List<EspaceCotisationMois> cotisations,
      EspaceFinancesResume finances,
    )?
    charge,
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
    required TResult Function(_Verification value) verification,
    required TResult Function(_Chargement value) chargement,
    required TResult Function(_Charge value) charge,
    required TResult Function(_Erreur value) erreur,
  }) {
    return chargement(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Verification value)? verification,
    TResult? Function(_Chargement value)? chargement,
    TResult? Function(_Charge value)? charge,
    TResult? Function(_Erreur value)? erreur,
  }) {
    return chargement?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Verification value)? verification,
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

abstract class _Chargement implements EspaceMilitantState {
  const factory _Chargement() = _$ChargementImpl;
}

/// @nodoc
abstract class _$$ChargeImplCopyWith<$Res> {
  factory _$$ChargeImplCopyWith(
    _$ChargeImpl value,
    $Res Function(_$ChargeImpl) then,
  ) = __$$ChargeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    EspaceMilitantInfo militant,
    List<EspaceCotisationMois> cotisations,
    EspaceFinancesResume finances,
  });

  $EspaceMilitantInfoCopyWith<$Res> get militant;
  $EspaceFinancesResumeCopyWith<$Res> get finances;
}

/// @nodoc
class __$$ChargeImplCopyWithImpl<$Res>
    extends _$EspaceMilitantStateCopyWithImpl<$Res, _$ChargeImpl>
    implements _$$ChargeImplCopyWith<$Res> {
  __$$ChargeImplCopyWithImpl(
    _$ChargeImpl _value,
    $Res Function(_$ChargeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EspaceMilitantState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? militant = null,
    Object? cotisations = null,
    Object? finances = null,
  }) {
    return _then(
      _$ChargeImpl(
        militant: null == militant
            ? _value.militant
            : militant // ignore: cast_nullable_to_non_nullable
                  as EspaceMilitantInfo,
        cotisations: null == cotisations
            ? _value._cotisations
            : cotisations // ignore: cast_nullable_to_non_nullable
                  as List<EspaceCotisationMois>,
        finances: null == finances
            ? _value.finances
            : finances // ignore: cast_nullable_to_non_nullable
                  as EspaceFinancesResume,
      ),
    );
  }

  /// Create a copy of EspaceMilitantState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EspaceMilitantInfoCopyWith<$Res> get militant {
    return $EspaceMilitantInfoCopyWith<$Res>(_value.militant, (value) {
      return _then(_value.copyWith(militant: value));
    });
  }

  /// Create a copy of EspaceMilitantState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EspaceFinancesResumeCopyWith<$Res> get finances {
    return $EspaceFinancesResumeCopyWith<$Res>(_value.finances, (value) {
      return _then(_value.copyWith(finances: value));
    });
  }
}

/// @nodoc

class _$ChargeImpl implements _Charge {
  const _$ChargeImpl({
    required this.militant,
    required final List<EspaceCotisationMois> cotisations,
    required this.finances,
  }) : _cotisations = cotisations;

  @override
  final EspaceMilitantInfo militant;
  final List<EspaceCotisationMois> _cotisations;
  @override
  List<EspaceCotisationMois> get cotisations {
    if (_cotisations is EqualUnmodifiableListView) return _cotisations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cotisations);
  }

  @override
  final EspaceFinancesResume finances;

  @override
  String toString() {
    return 'EspaceMilitantState.charge(militant: $militant, cotisations: $cotisations, finances: $finances)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChargeImpl &&
            (identical(other.militant, militant) ||
                other.militant == militant) &&
            const DeepCollectionEquality().equals(
              other._cotisations,
              _cotisations,
            ) &&
            (identical(other.finances, finances) ||
                other.finances == finances));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    militant,
    const DeepCollectionEquality().hash(_cotisations),
    finances,
  );

  /// Create a copy of EspaceMilitantState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChargeImplCopyWith<_$ChargeImpl> get copyWith =>
      __$$ChargeImplCopyWithImpl<_$ChargeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() verification,
    required TResult Function() chargement,
    required TResult Function(
      EspaceMilitantInfo militant,
      List<EspaceCotisationMois> cotisations,
      EspaceFinancesResume finances,
    )
    charge,
    required TResult Function(String message) erreur,
  }) {
    return charge(militant, cotisations, finances);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? verification,
    TResult? Function()? chargement,
    TResult? Function(
      EspaceMilitantInfo militant,
      List<EspaceCotisationMois> cotisations,
      EspaceFinancesResume finances,
    )?
    charge,
    TResult? Function(String message)? erreur,
  }) {
    return charge?.call(militant, cotisations, finances);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? verification,
    TResult Function()? chargement,
    TResult Function(
      EspaceMilitantInfo militant,
      List<EspaceCotisationMois> cotisations,
      EspaceFinancesResume finances,
    )?
    charge,
    TResult Function(String message)? erreur,
    required TResult orElse(),
  }) {
    if (charge != null) {
      return charge(militant, cotisations, finances);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Verification value) verification,
    required TResult Function(_Chargement value) chargement,
    required TResult Function(_Charge value) charge,
    required TResult Function(_Erreur value) erreur,
  }) {
    return charge(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Verification value)? verification,
    TResult? Function(_Chargement value)? chargement,
    TResult? Function(_Charge value)? charge,
    TResult? Function(_Erreur value)? erreur,
  }) {
    return charge?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Verification value)? verification,
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

abstract class _Charge implements EspaceMilitantState {
  const factory _Charge({
    required final EspaceMilitantInfo militant,
    required final List<EspaceCotisationMois> cotisations,
    required final EspaceFinancesResume finances,
  }) = _$ChargeImpl;

  EspaceMilitantInfo get militant;
  List<EspaceCotisationMois> get cotisations;
  EspaceFinancesResume get finances;

  /// Create a copy of EspaceMilitantState
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
  $Res call({String message});
}

/// @nodoc
class __$$ErreurImplCopyWithImpl<$Res>
    extends _$EspaceMilitantStateCopyWithImpl<$Res, _$ErreurImpl>
    implements _$$ErreurImplCopyWith<$Res> {
  __$$ErreurImplCopyWithImpl(
    _$ErreurImpl _value,
    $Res Function(_$ErreurImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EspaceMilitantState
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
    return 'EspaceMilitantState.erreur(message: $message)';
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

  /// Create a copy of EspaceMilitantState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErreurImplCopyWith<_$ErreurImpl> get copyWith =>
      __$$ErreurImplCopyWithImpl<_$ErreurImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() verification,
    required TResult Function() chargement,
    required TResult Function(
      EspaceMilitantInfo militant,
      List<EspaceCotisationMois> cotisations,
      EspaceFinancesResume finances,
    )
    charge,
    required TResult Function(String message) erreur,
  }) {
    return erreur(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? verification,
    TResult? Function()? chargement,
    TResult? Function(
      EspaceMilitantInfo militant,
      List<EspaceCotisationMois> cotisations,
      EspaceFinancesResume finances,
    )?
    charge,
    TResult? Function(String message)? erreur,
  }) {
    return erreur?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? verification,
    TResult Function()? chargement,
    TResult Function(
      EspaceMilitantInfo militant,
      List<EspaceCotisationMois> cotisations,
      EspaceFinancesResume finances,
    )?
    charge,
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
    required TResult Function(_Verification value) verification,
    required TResult Function(_Chargement value) chargement,
    required TResult Function(_Charge value) charge,
    required TResult Function(_Erreur value) erreur,
  }) {
    return erreur(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Verification value)? verification,
    TResult? Function(_Chargement value)? chargement,
    TResult? Function(_Charge value)? charge,
    TResult? Function(_Erreur value)? erreur,
  }) {
    return erreur?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Verification value)? verification,
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

abstract class _Erreur implements EspaceMilitantState {
  const factory _Erreur({required final String message}) = _$ErreurImpl;

  String get message;

  /// Create a copy of EspaceMilitantState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErreurImplCopyWith<_$ErreurImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
