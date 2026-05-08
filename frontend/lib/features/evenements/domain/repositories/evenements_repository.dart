import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/evenement.dart';
import '../entities/presence.dart';

class ParamsAjouterEvenement {
  final String   titre;
  final String?  description;
  final DateTime dateDebut;
  final DateTime? dateFin;
  final String   lieu;
  final String   type;
  final String   uniteId;

  const ParamsAjouterEvenement({
    required this.titre,
    this.description,
    required this.dateDebut,
    this.dateFin,
    required this.lieu,
    required this.type,
    required this.uniteId,
  });
}

class ParamsEnregistrerPresence {
  final String  evenementId;
  final String? militantId;
  final String  nom;
  final String  prenom;
  final String? telephone;

  const ParamsEnregistrerPresence({
    required this.evenementId,
    this.militantId,
    required this.nom,
    required this.prenom,
    this.telephone,
  });
}

abstract class EvenementsRepository {
  Future<Either<Failure, List<Evenement>>> getEvenements({String? uniteId});
  Future<Either<Failure, Evenement>>       ajouterEvenement(ParamsAjouterEvenement params);
  Future<Either<Failure, List<Presence>>>  getPresences(String evenementId);
  Future<Either<Failure, Presence>>        enregistrerPresence(ParamsEnregistrerPresence params);
}