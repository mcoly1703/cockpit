import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/prospect.dart';

class ParamsAjouterProspect {
  final String  nom;
  final String  prenom;
  final String  telephone;
  final String? email;
  final String  ville;
  final String? sexe;
  final String? mouvementInteret;
  final String? notes;
  final String  uniteId;

  const ParamsAjouterProspect({
    required this.nom,
    required this.prenom,
    required this.telephone,
    this.email,
    required this.ville,
    this.sexe,
    this.mouvementInteret,
    this.notes,
    required this.uniteId,
  });
}

abstract class ProspectsRepository {
  Future<Either<Failure, List<Prospect>>> getProspects({String? uniteId});
  Future<Either<Failure, Prospect>>      ajouterProspect(ParamsAjouterProspect params);
  Future<Either<Failure, Prospect>>      modifierEtapeProspect({required String id, required String etape});
}