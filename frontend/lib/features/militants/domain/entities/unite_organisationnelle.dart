import 'package:freezed_annotation/freezed_annotation.dart';

part 'unite_organisationnelle.freezed.dart';

@freezed
class UniteOrganisationnelle with _$UniteOrganisationnelle {
  const factory UniteOrganisationnelle({
    required String id,
    required String type,
    required String nom,
    String? code,
    String? parentId,
    required bool isActive,
  }) = _UniteOrganisationnelle;
}