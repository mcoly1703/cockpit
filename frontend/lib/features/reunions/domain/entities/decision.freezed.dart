// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'decision.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Decision {
  String get id => throw _privateConstructorUsedError;
  String get reunionId => throw _privateConstructorUsedError;
  String get texte => throw _privateConstructorUsedError;
  String? get responsable => throw _privateConstructorUsedError;
  DateTime? get echeance => throw _privateConstructorUsedError;
  String get statut => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of Decision
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DecisionCopyWith<Decision> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DecisionCopyWith<$Res> {
  factory $DecisionCopyWith(Decision value, $Res Function(Decision) then) =
      _$DecisionCopyWithImpl<$Res, Decision>;
  @useResult
  $Res call({
    String id,
    String reunionId,
    String texte,
    String? responsable,
    DateTime? echeance,
    String statut,
    DateTime createdAt,
  });
}

/// @nodoc
class _$DecisionCopyWithImpl<$Res, $Val extends Decision>
    implements $DecisionCopyWith<$Res> {
  _$DecisionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Decision
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reunionId = null,
    Object? texte = null,
    Object? responsable = freezed,
    Object? echeance = freezed,
    Object? statut = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            reunionId: null == reunionId
                ? _value.reunionId
                : reunionId // ignore: cast_nullable_to_non_nullable
                      as String,
            texte: null == texte
                ? _value.texte
                : texte // ignore: cast_nullable_to_non_nullable
                      as String,
            responsable: freezed == responsable
                ? _value.responsable
                : responsable // ignore: cast_nullable_to_non_nullable
                      as String?,
            echeance: freezed == echeance
                ? _value.echeance
                : echeance // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            statut: null == statut
                ? _value.statut
                : statut // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DecisionImplCopyWith<$Res>
    implements $DecisionCopyWith<$Res> {
  factory _$$DecisionImplCopyWith(
    _$DecisionImpl value,
    $Res Function(_$DecisionImpl) then,
  ) = __$$DecisionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String reunionId,
    String texte,
    String? responsable,
    DateTime? echeance,
    String statut,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$DecisionImplCopyWithImpl<$Res>
    extends _$DecisionCopyWithImpl<$Res, _$DecisionImpl>
    implements _$$DecisionImplCopyWith<$Res> {
  __$$DecisionImplCopyWithImpl(
    _$DecisionImpl _value,
    $Res Function(_$DecisionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Decision
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reunionId = null,
    Object? texte = null,
    Object? responsable = freezed,
    Object? echeance = freezed,
    Object? statut = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$DecisionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        reunionId: null == reunionId
            ? _value.reunionId
            : reunionId // ignore: cast_nullable_to_non_nullable
                  as String,
        texte: null == texte
            ? _value.texte
            : texte // ignore: cast_nullable_to_non_nullable
                  as String,
        responsable: freezed == responsable
            ? _value.responsable
            : responsable // ignore: cast_nullable_to_non_nullable
                  as String?,
        echeance: freezed == echeance
            ? _value.echeance
            : echeance // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        statut: null == statut
            ? _value.statut
            : statut // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$DecisionImpl implements _Decision {
  const _$DecisionImpl({
    required this.id,
    required this.reunionId,
    required this.texte,
    this.responsable,
    this.echeance,
    required this.statut,
    required this.createdAt,
  });

  @override
  final String id;
  @override
  final String reunionId;
  @override
  final String texte;
  @override
  final String? responsable;
  @override
  final DateTime? echeance;
  @override
  final String statut;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Decision(id: $id, reunionId: $reunionId, texte: $texte, responsable: $responsable, echeance: $echeance, statut: $statut, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DecisionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reunionId, reunionId) ||
                other.reunionId == reunionId) &&
            (identical(other.texte, texte) || other.texte == texte) &&
            (identical(other.responsable, responsable) ||
                other.responsable == responsable) &&
            (identical(other.echeance, echeance) ||
                other.echeance == echeance) &&
            (identical(other.statut, statut) || other.statut == statut) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    reunionId,
    texte,
    responsable,
    echeance,
    statut,
    createdAt,
  );

  /// Create a copy of Decision
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DecisionImplCopyWith<_$DecisionImpl> get copyWith =>
      __$$DecisionImplCopyWithImpl<_$DecisionImpl>(this, _$identity);
}

abstract class _Decision implements Decision {
  const factory _Decision({
    required final String id,
    required final String reunionId,
    required final String texte,
    final String? responsable,
    final DateTime? echeance,
    required final String statut,
    required final DateTime createdAt,
  }) = _$DecisionImpl;

  @override
  String get id;
  @override
  String get reunionId;
  @override
  String get texte;
  @override
  String? get responsable;
  @override
  DateTime? get echeance;
  @override
  String get statut;
  @override
  DateTime get createdAt;

  /// Create a copy of Decision
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DecisionImplCopyWith<_$DecisionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
