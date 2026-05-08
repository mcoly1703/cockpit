import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/poste_bureau.dart';
import '../repositories/bureau_repository.dart';

class NommerMembre {
  final BureauRepository repository;
  NommerMembre(this.repository);

  Future<Either<Failure, PosteBureau>> call(ParamsNommerMembre params) =>
      repository.nommerMembre(params);
}