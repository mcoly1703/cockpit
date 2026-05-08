import '../../domain/entities/unite_organisationnelle.dart';

class UniteOrganisationnelleModel {
  final String id;
  final String type;
  final String nom;
  final String? code;
  final String? parentId;
  final bool isActive;

  const UniteOrganisationnelleModel({
    required this.id,
    required this.type,
    required this.nom,
    this.code,
    this.parentId,
    required this.isActive,
  });

  factory UniteOrganisationnelleModel.fromJson(Map<String, dynamic> json) =>
      UniteOrganisationnelleModel(
        id:       json['id'] as String,
        type:     json['type'] as String,
        nom:      json['nom'] as String,
        code:     json['code'] as String?,
        parentId: json['parent_id'] as String?,
        isActive: json['is_active'] as bool,
      );

  UniteOrganisationnelle toEntity() => UniteOrganisationnelle(
        id:       id,
        type:     type,
        nom:      nom,
        code:     code,
        parentId: parentId,
        isActive: isActive,
      );
}