// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'utilisateur.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Utilisateur {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get nom => throw _privateConstructorUsedError;
  String get prenom => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String? get uniteOrganisationnelleId => throw _privateConstructorUsedError;
  String? get entite => throw _privateConstructorUsedError;

  /// Create a copy of Utilisateur
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UtilisateurCopyWith<Utilisateur> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UtilisateurCopyWith<$Res> {
  factory $UtilisateurCopyWith(
    Utilisateur value,
    $Res Function(Utilisateur) then,
  ) = _$UtilisateurCopyWithImpl<$Res, Utilisateur>;
  @useResult
  $Res call({
    String id,
    String email,
    String nom,
    String prenom,
    String role,
    String? uniteOrganisationnelleId,
    String? entite,
  });
}

/// @nodoc
class _$UtilisateurCopyWithImpl<$Res, $Val extends Utilisateur>
    implements $UtilisateurCopyWith<$Res> {
  _$UtilisateurCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Utilisateur
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? nom = null,
    Object? prenom = null,
    Object? role = null,
    Object? uniteOrganisationnelleId = freezed,
    Object? entite = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            nom: null == nom
                ? _value.nom
                : nom // ignore: cast_nullable_to_non_nullable
                      as String,
            prenom: null == prenom
                ? _value.prenom
                : prenom // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            uniteOrganisationnelleId: freezed == uniteOrganisationnelleId
                ? _value.uniteOrganisationnelleId
                : uniteOrganisationnelleId // ignore: cast_nullable_to_non_nullable
                      as String?,
            entite: freezed == entite
                ? _value.entite
                : entite // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UtilisateurImplCopyWith<$Res>
    implements $UtilisateurCopyWith<$Res> {
  factory _$$UtilisateurImplCopyWith(
    _$UtilisateurImpl value,
    $Res Function(_$UtilisateurImpl) then,
  ) = __$$UtilisateurImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String email,
    String nom,
    String prenom,
    String role,
    String? uniteOrganisationnelleId,
    String? entite,
  });
}

/// @nodoc
class __$$UtilisateurImplCopyWithImpl<$Res>
    extends _$UtilisateurCopyWithImpl<$Res, _$UtilisateurImpl>
    implements _$$UtilisateurImplCopyWith<$Res> {
  __$$UtilisateurImplCopyWithImpl(
    _$UtilisateurImpl _value,
    $Res Function(_$UtilisateurImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Utilisateur
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? nom = null,
    Object? prenom = null,
    Object? role = null,
    Object? uniteOrganisationnelleId = freezed,
    Object? entite = freezed,
  }) {
    return _then(
      _$UtilisateurImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        nom: null == nom
            ? _value.nom
            : nom // ignore: cast_nullable_to_non_nullable
                  as String,
        prenom: null == prenom
            ? _value.prenom
            : prenom // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        uniteOrganisationnelleId: freezed == uniteOrganisationnelleId
            ? _value.uniteOrganisationnelleId
            : uniteOrganisationnelleId // ignore: cast_nullable_to_non_nullable
                  as String?,
        entite: freezed == entite
            ? _value.entite
            : entite // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$UtilisateurImpl implements _Utilisateur {
  const _$UtilisateurImpl({
    required this.id,
    required this.email,
    required this.nom,
    required this.prenom,
    required this.role,
    this.uniteOrganisationnelleId,
    this.entite,
  });

  @override
  final String id;
  @override
  final String email;
  @override
  final String nom;
  @override
  final String prenom;
  @override
  final String role;
  @override
  final String? uniteOrganisationnelleId;
  @override
  final String? entite;

  @override
  String toString() {
    return 'Utilisateur(id: $id, email: $email, nom: $nom, prenom: $prenom, role: $role, uniteOrganisationnelleId: $uniteOrganisationnelleId, entite: $entite)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UtilisateurImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.nom, nom) || other.nom == nom) &&
            (identical(other.prenom, prenom) || other.prenom == prenom) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(
                  other.uniteOrganisationnelleId,
                  uniteOrganisationnelleId,
                ) ||
                other.uniteOrganisationnelleId == uniteOrganisationnelleId) &&
            (identical(other.entite, entite) || other.entite == entite));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    email,
    nom,
    prenom,
    role,
    uniteOrganisationnelleId,
    entite,
  );

  /// Create a copy of Utilisateur
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UtilisateurImplCopyWith<_$UtilisateurImpl> get copyWith =>
      __$$UtilisateurImplCopyWithImpl<_$UtilisateurImpl>(this, _$identity);
}

abstract class _Utilisateur implements Utilisateur {
  const factory _Utilisateur({
    required final String id,
    required final String email,
    required final String nom,
    required final String prenom,
    required final String role,
    final String? uniteOrganisationnelleId,
    final String? entite,
  }) = _$UtilisateurImpl;

  @override
  String get id;
  @override
  String get email;
  @override
  String get nom;
  @override
  String get prenom;
  @override
  String get role;
  @override
  String? get uniteOrganisationnelleId;
  @override
  String? get entite;

  /// Create a copy of Utilisateur
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UtilisateurImplCopyWith<_$UtilisateurImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
