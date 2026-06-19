import 'package:freezed_annotation/freezed_annotation.dart';

part 'espace_militant_info.freezed.dart';

@freezed
class EspaceMilitantInfo with _$EspaceMilitantInfo {
  const factory EspaceMilitantInfo({
    required String militantId,
    required String nom,
    required String prenom,
    required String numeroCarte,
    required String statut,
    required DateTime dateAdhesion,
    required String uniteId,
    required String uniteNom,
    required String uniteType,
    String? parentUniteId,
    String? parentUniteNom,
    String? parentUniteType,
  }) = _EspaceMilitantInfo;
}
