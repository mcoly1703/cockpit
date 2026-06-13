import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/rapport_genere.dart';

class ParamsRapportCra {
  final String   uniteId;
  final DateTime debut;
  final DateTime fin;
  ParamsRapportCra({required this.uniteId, required this.debut, required this.fin});
}

class ParamsRapportFinancier {
  final String   uniteId;
  final DateTime debut;
  final DateTime fin;
  ParamsRapportFinancier({required this.uniteId, required this.debut, required this.fin});
}

class ParamsRapportReunion {
  final String reunionId;
  final String titre;
  ParamsRapportReunion({required this.reunionId, required this.titre});
}

class ParamsRapportEvenement {
  final String evenementId;
  final String titre;
  ParamsRapportEvenement({required this.evenementId, required this.titre});
}

class ParamsRapportCotisations {
  final String uniteId;
  final int    annee;
  final int    mois;
  ParamsRapportCotisations({required this.uniteId, required this.annee, required this.mois});
}

class ParamsRapportActivite {
  final String?  uniteId; // null = global (BEX)
  final DateTime debut;
  final DateTime fin;
  final bool inclureMilitants;
  final bool inclureProspects;
  final bool inclureFinances;
  final bool inclureEvenements;
  final bool inclureReunions;
  final bool inclureBureau;
  ParamsRapportActivite({
    this.uniteId,
    required this.debut,
    required this.fin,
    this.inclureMilitants  = true,
    this.inclureProspects  = true,
    this.inclureFinances   = true,
    this.inclureEvenements = true,
    this.inclureReunions   = true,
    this.inclureBureau     = true,
  });
}

abstract class RapportsRepository {
  Future<Either<Failure, RapportGenere>> genererCra(ParamsRapportCra params);
  Future<Either<Failure, RapportGenere>> genererFinancier(ParamsRapportFinancier params);
  Future<Either<Failure, RapportGenere>> genererReunion(ParamsRapportReunion params);
  Future<Either<Failure, RapportGenere>> genererEvenement(ParamsRapportEvenement params);
  Future<Either<Failure, RapportGenere>> genererCotisations(ParamsRapportCotisations params);
  Future<Either<Failure, RapportGenere>> genererActivite(ParamsRapportActivite params);
}