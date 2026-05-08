import 'package:freezed_annotation/freezed_annotation.dart';

part 'compte_rendu.freezed.dart';

@freezed
class CompteRendu with _$CompteRendu {
  const factory CompteRendu({
    required String   id,
    required String   uniteId,
    String?           uniteCode,
    required int      mois,
    required int      annee,
    required String   statut,
    required String   descriptionActivites,
    required int      nouveauxContacts,
    required int      evenementsTenus,
    required int      presencesTotal,
    required double   cotisationsCollectees,
    String?           difficultes,
    String?           observationsCoord,
    DateTime?         soumisAt,
    DateTime?         valideAt,
    required DateTime createdAt,
  }) = _CompteRendu;
}