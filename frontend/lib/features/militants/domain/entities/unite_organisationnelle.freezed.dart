// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unite_organisationnelle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$UniteOrganisationnelle {
  String get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get nom => throw _privateConstructorUsedError;
  String? get code => throw _privateConstructorUsedError;
  String? get parentId => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Create a copy of UniteOrganisationnelle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UniteOrganisationnelleCopyWith<UniteOrganisationnelle> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UniteOrganisationnelleCopyWith<$Res> {
  factory $UniteOrganisationnelleCopyWith(
    UniteOrganisationnelle value,
    $Res Function(UniteOrganisationnelle) then,
  ) = _$UniteOrganisationnelleCopyWithImpl<$Res, UniteOrganisationnelle>;
  @useResult
  $Res call({
    String id,
    String type,
    String nom,
    String? code,
    String? parentId,
    bool isActive,
  });
}

/// @nodoc
class _$UniteOrganisationnelleCopyWithImpl<
  $Res,
  $Val extends UniteOrganisationnelle
>
    implements $UniteOrganisationnelleCopyWith<$Res> {
  _$UniteOrganisationnelleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UniteOrganisationnelle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? nom = null,
    Object? code = freezed,
    Object? parentId = freezed,
    Object? isActive = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            nom: null == nom
                ? _value.nom
                : nom // ignore: cast_nullable_to_non_nullable
                      as String,
            code: freezed == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String?,
            parentId: freezed == parentId
                ? _value.parentId
                : parentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UniteOrganisationnelleImplCopyWith<$Res>
    implements $UniteOrganisationnelleCopyWith<$Res> {
  factory _$$UniteOrganisationnelleImplCopyWith(
    _$UniteOrganisationnelleImpl value,
    $Res Function(_$UniteOrganisationnelleImpl) then,
  ) = __$$UniteOrganisationnelleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String type,
    String nom,
    String? code,
    String? parentId,
    bool isActive,
  });
}

/// @nodoc
class __$$UniteOrganisationnelleImplCopyWithImpl<$Res>
    extends
        _$UniteOrganisationnelleCopyWithImpl<$Res, _$UniteOrganisationnelleImpl>
    implements _$$UniteOrganisationnelleImplCopyWith<$Res> {
  __$$UniteOrganisationnelleImplCopyWithImpl(
    _$UniteOrganisationnelleImpl _value,
    $Res Function(_$UniteOrganisationnelleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UniteOrganisationnelle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? nom = null,
    Object? code = freezed,
    Object? parentId = freezed,
    Object? isActive = null,
  }) {
    return _then(
      _$UniteOrganisationnelleImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        nom: null == nom
            ? _value.nom
            : nom // ignore: cast_nullable_to_non_nullable
                  as String,
        code: freezed == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String?,
        parentId: freezed == parentId
            ? _value.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$UniteOrganisationnelleImpl implements _UniteOrganisationnelle {
  const _$UniteOrganisationnelleImpl({
    required this.id,
    required this.type,
    required this.nom,
    this.code,
    this.parentId,
    required this.isActive,
  });

  @override
  final String id;
  @override
  final String type;
  @override
  final String nom;
  @override
  final String? code;
  @override
  final String? parentId;
  @override
  final bool isActive;

  @override
  String toString() {
    return 'UniteOrganisationnelle(id: $id, type: $type, nom: $nom, code: $code, parentId: $parentId, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UniteOrganisationnelleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.nom, nom) || other.nom == nom) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, type, nom, code, parentId, isActive);

  /// Create a copy of UniteOrganisationnelle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UniteOrganisationnelleImplCopyWith<_$UniteOrganisationnelleImpl>
  get copyWith =>
      __$$UniteOrganisationnelleImplCopyWithImpl<_$UniteOrganisationnelleImpl>(
        this,
        _$identity,
      );
}

abstract class _UniteOrganisationnelle implements UniteOrganisationnelle {
  const factory _UniteOrganisationnelle({
    required final String id,
    required final String type,
    required final String nom,
    final String? code,
    final String? parentId,
    required final bool isActive,
  }) = _$UniteOrganisationnelleImpl;

  @override
  String get id;
  @override
  String get type;
  @override
  String get nom;
  @override
  String? get code;
  @override
  String? get parentId;
  @override
  bool get isActive;

  /// Create a copy of UniteOrganisationnelle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UniteOrganisationnelleImplCopyWith<_$UniteOrganisationnelleImpl>
  get copyWith => throw _privateConstructorUsedError;
}
