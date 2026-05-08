// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scrutin.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Scrutin {
  String get id => throw _privateConstructorUsedError;
  String? get uniteId => throw _privateConstructorUsedError;
  String get titre => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  DateTime get dateScrutin => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get statut => throw _privateConstructorUsedError;

  /// Create a copy of Scrutin
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScrutinCopyWith<Scrutin> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScrutinCopyWith<$Res> {
  factory $ScrutinCopyWith(Scrutin value, $Res Function(Scrutin) then) =
      _$ScrutinCopyWithImpl<$Res, Scrutin>;
  @useResult
  $Res call({
    String id,
    String? uniteId,
    String titre,
    String type,
    DateTime dateScrutin,
    String? description,
    String statut,
  });
}

/// @nodoc
class _$ScrutinCopyWithImpl<$Res, $Val extends Scrutin>
    implements $ScrutinCopyWith<$Res> {
  _$ScrutinCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Scrutin
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uniteId = freezed,
    Object? titre = null,
    Object? type = null,
    Object? dateScrutin = null,
    Object? description = freezed,
    Object? statut = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            uniteId: freezed == uniteId
                ? _value.uniteId
                : uniteId // ignore: cast_nullable_to_non_nullable
                      as String?,
            titre: null == titre
                ? _value.titre
                : titre // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            dateScrutin: null == dateScrutin
                ? _value.dateScrutin
                : dateScrutin // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            statut: null == statut
                ? _value.statut
                : statut // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScrutinImplCopyWith<$Res> implements $ScrutinCopyWith<$Res> {
  factory _$$ScrutinImplCopyWith(
    _$ScrutinImpl value,
    $Res Function(_$ScrutinImpl) then,
  ) = __$$ScrutinImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String? uniteId,
    String titre,
    String type,
    DateTime dateScrutin,
    String? description,
    String statut,
  });
}

/// @nodoc
class __$$ScrutinImplCopyWithImpl<$Res>
    extends _$ScrutinCopyWithImpl<$Res, _$ScrutinImpl>
    implements _$$ScrutinImplCopyWith<$Res> {
  __$$ScrutinImplCopyWithImpl(
    _$ScrutinImpl _value,
    $Res Function(_$ScrutinImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Scrutin
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uniteId = freezed,
    Object? titre = null,
    Object? type = null,
    Object? dateScrutin = null,
    Object? description = freezed,
    Object? statut = null,
  }) {
    return _then(
      _$ScrutinImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        uniteId: freezed == uniteId
            ? _value.uniteId
            : uniteId // ignore: cast_nullable_to_non_nullable
                  as String?,
        titre: null == titre
            ? _value.titre
            : titre // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        dateScrutin: null == dateScrutin
            ? _value.dateScrutin
            : dateScrutin // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        statut: null == statut
            ? _value.statut
            : statut // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ScrutinImpl implements _Scrutin {
  const _$ScrutinImpl({
    required this.id,
    this.uniteId,
    required this.titre,
    required this.type,
    required this.dateScrutin,
    this.description,
    required this.statut,
  });

  @override
  final String id;
  @override
  final String? uniteId;
  @override
  final String titre;
  @override
  final String type;
  @override
  final DateTime dateScrutin;
  @override
  final String? description;
  @override
  final String statut;

  @override
  String toString() {
    return 'Scrutin(id: $id, uniteId: $uniteId, titre: $titre, type: $type, dateScrutin: $dateScrutin, description: $description, statut: $statut)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScrutinImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uniteId, uniteId) || other.uniteId == uniteId) &&
            (identical(other.titre, titre) || other.titre == titre) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.dateScrutin, dateScrutin) ||
                other.dateScrutin == dateScrutin) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.statut, statut) || other.statut == statut));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    uniteId,
    titre,
    type,
    dateScrutin,
    description,
    statut,
  );

  /// Create a copy of Scrutin
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScrutinImplCopyWith<_$ScrutinImpl> get copyWith =>
      __$$ScrutinImplCopyWithImpl<_$ScrutinImpl>(this, _$identity);
}

abstract class _Scrutin implements Scrutin {
  const factory _Scrutin({
    required final String id,
    final String? uniteId,
    required final String titre,
    required final String type,
    required final DateTime dateScrutin,
    final String? description,
    required final String statut,
  }) = _$ScrutinImpl;

  @override
  String get id;
  @override
  String? get uniteId;
  @override
  String get titre;
  @override
  String get type;
  @override
  DateTime get dateScrutin;
  @override
  String? get description;
  @override
  String get statut;

  /// Create a copy of Scrutin
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScrutinImplCopyWith<_$ScrutinImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
