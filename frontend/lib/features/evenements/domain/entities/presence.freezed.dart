// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'presence.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Presence {
  String get id => throw _privateConstructorUsedError;
  String get evenementId => throw _privateConstructorUsedError;
  String? get militantId => throw _privateConstructorUsedError;
  String get nom => throw _privateConstructorUsedError;
  String get prenom => throw _privateConstructorUsedError;
  String? get telephone => throw _privateConstructorUsedError;
  DateTime get checkedAt => throw _privateConstructorUsedError;

  /// Create a copy of Presence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PresenceCopyWith<Presence> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PresenceCopyWith<$Res> {
  factory $PresenceCopyWith(Presence value, $Res Function(Presence) then) =
      _$PresenceCopyWithImpl<$Res, Presence>;
  @useResult
  $Res call({
    String id,
    String evenementId,
    String? militantId,
    String nom,
    String prenom,
    String? telephone,
    DateTime checkedAt,
  });
}

/// @nodoc
class _$PresenceCopyWithImpl<$Res, $Val extends Presence>
    implements $PresenceCopyWith<$Res> {
  _$PresenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Presence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? evenementId = null,
    Object? militantId = freezed,
    Object? nom = null,
    Object? prenom = null,
    Object? telephone = freezed,
    Object? checkedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            evenementId: null == evenementId
                ? _value.evenementId
                : evenementId // ignore: cast_nullable_to_non_nullable
                      as String,
            militantId: freezed == militantId
                ? _value.militantId
                : militantId // ignore: cast_nullable_to_non_nullable
                      as String?,
            nom: null == nom
                ? _value.nom
                : nom // ignore: cast_nullable_to_non_nullable
                      as String,
            prenom: null == prenom
                ? _value.prenom
                : prenom // ignore: cast_nullable_to_non_nullable
                      as String,
            telephone: freezed == telephone
                ? _value.telephone
                : telephone // ignore: cast_nullable_to_non_nullable
                      as String?,
            checkedAt: null == checkedAt
                ? _value.checkedAt
                : checkedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PresenceImplCopyWith<$Res>
    implements $PresenceCopyWith<$Res> {
  factory _$$PresenceImplCopyWith(
    _$PresenceImpl value,
    $Res Function(_$PresenceImpl) then,
  ) = __$$PresenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String evenementId,
    String? militantId,
    String nom,
    String prenom,
    String? telephone,
    DateTime checkedAt,
  });
}

/// @nodoc
class __$$PresenceImplCopyWithImpl<$Res>
    extends _$PresenceCopyWithImpl<$Res, _$PresenceImpl>
    implements _$$PresenceImplCopyWith<$Res> {
  __$$PresenceImplCopyWithImpl(
    _$PresenceImpl _value,
    $Res Function(_$PresenceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Presence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? evenementId = null,
    Object? militantId = freezed,
    Object? nom = null,
    Object? prenom = null,
    Object? telephone = freezed,
    Object? checkedAt = null,
  }) {
    return _then(
      _$PresenceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        evenementId: null == evenementId
            ? _value.evenementId
            : evenementId // ignore: cast_nullable_to_non_nullable
                  as String,
        militantId: freezed == militantId
            ? _value.militantId
            : militantId // ignore: cast_nullable_to_non_nullable
                  as String?,
        nom: null == nom
            ? _value.nom
            : nom // ignore: cast_nullable_to_non_nullable
                  as String,
        prenom: null == prenom
            ? _value.prenom
            : prenom // ignore: cast_nullable_to_non_nullable
                  as String,
        telephone: freezed == telephone
            ? _value.telephone
            : telephone // ignore: cast_nullable_to_non_nullable
                  as String?,
        checkedAt: null == checkedAt
            ? _value.checkedAt
            : checkedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$PresenceImpl implements _Presence {
  const _$PresenceImpl({
    required this.id,
    required this.evenementId,
    this.militantId,
    required this.nom,
    required this.prenom,
    this.telephone,
    required this.checkedAt,
  });

  @override
  final String id;
  @override
  final String evenementId;
  @override
  final String? militantId;
  @override
  final String nom;
  @override
  final String prenom;
  @override
  final String? telephone;
  @override
  final DateTime checkedAt;

  @override
  String toString() {
    return 'Presence(id: $id, evenementId: $evenementId, militantId: $militantId, nom: $nom, prenom: $prenom, telephone: $telephone, checkedAt: $checkedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PresenceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.evenementId, evenementId) ||
                other.evenementId == evenementId) &&
            (identical(other.militantId, militantId) ||
                other.militantId == militantId) &&
            (identical(other.nom, nom) || other.nom == nom) &&
            (identical(other.prenom, prenom) || other.prenom == prenom) &&
            (identical(other.telephone, telephone) ||
                other.telephone == telephone) &&
            (identical(other.checkedAt, checkedAt) ||
                other.checkedAt == checkedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    evenementId,
    militantId,
    nom,
    prenom,
    telephone,
    checkedAt,
  );

  /// Create a copy of Presence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PresenceImplCopyWith<_$PresenceImpl> get copyWith =>
      __$$PresenceImplCopyWithImpl<_$PresenceImpl>(this, _$identity);
}

abstract class _Presence implements Presence {
  const factory _Presence({
    required final String id,
    required final String evenementId,
    final String? militantId,
    required final String nom,
    required final String prenom,
    final String? telephone,
    required final DateTime checkedAt,
  }) = _$PresenceImpl;

  @override
  String get id;
  @override
  String get evenementId;
  @override
  String? get militantId;
  @override
  String get nom;
  @override
  String get prenom;
  @override
  String? get telephone;
  @override
  DateTime get checkedAt;

  /// Create a copy of Presence
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PresenceImplCopyWith<_$PresenceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
