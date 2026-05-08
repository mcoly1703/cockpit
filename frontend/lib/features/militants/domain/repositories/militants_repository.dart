import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/militant.dart';
import '../entities/unite_organisationnelle.dart';

// Paramètres pour l'ajout / modification

class ParamsAjouterMilitant {
  final String nom;
  final String prenom;
  final String? telephone;
  final String? email;
  final DateTime? dateNaissance;
  final String? sexe;
  final String? ville;
  final String? codePostal;
  final String uniteId;
  final DateTime dateAdhesion;

  const ParamsAjouterMilitant({
    required this.nom,
    required this.prenom,
    this.telephone,
    this.email,
    this.dateNaissance,
    this.sexe,
    this.ville,
    this.codePostal,
    required this.uniteId,
    required this.dateAdhesion,
  });
}

class ParamsModifierMilitant {
  final String id;
  final String nom;
  final String prenom;
  final String? telephone;
  final String? email;
  final DateTime? dateNaissance;
  final String? sexe;
  final String? ville;
  final String? codePostal;
  final String uniteId;
  final DateTime dateAdhesion;

  const ParamsModifierMilitant({
    required this.id,
    required this.nom,
    required this.prenom,
    this.telephone,
    this.email,
    this.dateNaissance,
    this.sexe,
    this.ville,
    this.codePostal,
    required this.uniteId,
    required this.dateAdhesion,
  });
}

// Interface

abstract class MilitantsRepository {
  Future<Either<Failure, List<Militant>>> getMilitants({
    String? uniteId,
    String? filtreStatut,
  });

  Future<Either<Failure, List<UniteOrganisationnelle>>> getUnites();

  Future<Either<Failure, Militant>> ajouterMilitant(ParamsAjouterMilitant params);

  Future<Either<Failure, Militant>> modifierMilitant(ParamsModifierMilitant params);

  Future<Either<Failure, void>> toggleStatut(String id, String nouveauStatut);

  Future<Either<Failure, int>> importerMilitants(
      List<Map<String, dynamic>> rows);
}