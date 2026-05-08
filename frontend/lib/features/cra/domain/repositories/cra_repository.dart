import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/compte_rendu.dart';

class ParamsCreerCr {
  final String uniteId;
  final int    mois;
  final int    annee;
  final String descriptionActivites;
  final int    nouveauxContacts;
  final int    evenementsTenus;
  final int    presencesTotal;
  final double cotisationsCollectees;
  final String? difficultes;

  ParamsCreerCr({
    required this.uniteId,
    required this.mois,
    required this.annee,
    required this.descriptionActivites,
    required this.nouveauxContacts,
    required this.evenementsTenus,
    required this.presencesTotal,
    required this.cotisationsCollectees,
    this.difficultes,
  });
}

class ParamsMajCr {
  final String  id;
  final String  descriptionActivites;
  final int     nouveauxContacts;
  final int     evenementsTenus;
  final int     presencesTotal;
  final double  cotisationsCollectees;
  final String? difficultes;

  ParamsMajCr({
    required this.id,
    required this.descriptionActivites,
    required this.nouveauxContacts,
    required this.evenementsTenus,
    required this.presencesTotal,
    required this.cotisationsCollectees,
    this.difficultes,
  });
}

abstract class CraRepository {
  Future<Either<Failure, List<CompteRendu>>> getMesRendus(String uniteId);
  Future<Either<Failure, List<CompteRendu>>> getRendusRecus();
  Future<Either<Failure, void>> creerCr(ParamsCreerCr params);
  Future<Either<Failure, void>> mettreAJour(ParamsMajCr params);
  Future<Either<Failure, void>> soumettre(String crId);
  Future<Either<Failure, void>> valider(String crId);
  Future<Either<Failure, void>> retourner(String crId, String observations);
  Future<Either<Failure, void>> supprimer(String crId);
}