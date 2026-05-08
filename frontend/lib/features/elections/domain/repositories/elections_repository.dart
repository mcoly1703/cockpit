import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/candidat_election.dart';
import '../entities/scrutin.dart';

class ParamsAjouterScrutin {
  final String?  uniteId;
  final String   titre;
  final String   type;
  final DateTime dateScrutin;
  final String?  description;
  ParamsAjouterScrutin({
    this.uniteId,
    required this.titre,
    required this.type,
    required this.dateScrutin,
    this.description,
  });
}

class ParamsAjouterCandidat {
  final String  scrutinId;
  final String? militantId;
  final String  nom;
  final String  prenom;
  final String? poste;
  ParamsAjouterCandidat({
    required this.scrutinId,
    this.militantId,
    required this.nom,
    required this.prenom,
    this.poste,
  });
}

class ParamsSaisirResultat {
  final String candidatId;
  final int?   voix;
  final bool   elu;
  ParamsSaisirResultat({required this.candidatId, this.voix, required this.elu});
}

abstract class ElectionsRepository {
  Future<Either<Failure, List<Scrutin>>>          getScrutins({String? uniteId});
  Future<Either<Failure, List<CandidatElection>>> getCandidats(String scrutinId);
  Future<Either<Failure, void>>                   ajouterScrutin(ParamsAjouterScrutin params);
  Future<Either<Failure, void>>                   changerStatut(String scrutinId, String statut);
  Future<Either<Failure, void>>                   ajouterCandidat(ParamsAjouterCandidat params);
  Future<Either<Failure, void>>                   saisirResultat(ParamsSaisirResultat params);
  Future<Either<Failure, void>>                   retirerCandidat(String candidatId);
}