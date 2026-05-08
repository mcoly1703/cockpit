import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/poste_bureau.dart';

class ParamsNommerMembre {
  final String   uniteId;
  final String   intitule;
  final String   militantId;
  final DateTime dateNomination;

  const ParamsNommerMembre({
    required this.uniteId,
    required this.intitule,
    required this.militantId,
    required this.dateNomination,
  });
}

abstract class BureauRepository {
  Future<Either<Failure, List<PosteBureau>>>    getPostesBureau(String uniteId);
  Future<Either<Failure, PosteBureau>>          nommerMembre(ParamsNommerMembre params);
  Future<Either<Failure, void>>                 retirerMembre(String id);
  Future<Either<Failure, List<MilitantResume>>> searchMilitants(String query, String uniteId);
}