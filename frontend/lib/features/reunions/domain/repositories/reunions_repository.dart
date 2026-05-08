import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/decision.dart';
import '../entities/reunion.dart';

class ParamsAjouterReunion {
  final String   titre;
  final String   type;
  final DateTime date;
  final String   lieu;
  final String?  ordreJour;
  final String   uniteId;

  const ParamsAjouterReunion({
    required this.titre,
    required this.type,
    required this.date,
    required this.lieu,
    this.ordreJour,
    required this.uniteId,
  });
}

class ParamsAjouterDecision {
  final String    reunionId;
  final String    texte;
  final String?   responsable;
  final DateTime? echeance;

  const ParamsAjouterDecision({
    required this.reunionId,
    required this.texte,
    this.responsable,
    this.echeance,
  });
}

abstract class ReunionsRepository {
  Future<Either<Failure, List<Reunion>>>  getReunions({String? uniteId});
  Future<Either<Failure, Reunion>>        ajouterReunion(ParamsAjouterReunion params);
  Future<Either<Failure, List<Decision>>> getDecisions(String reunionId);
  Future<Either<Failure, Decision>>       ajouterDecision(ParamsAjouterDecision params);
  Future<Either<Failure, Decision>>       modifierStatutDecision({required String id, required String statut});
}