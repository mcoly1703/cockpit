import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/bureau_repository.dart';

class RetirerMembre {
  final BureauRepository repository;
  RetirerMembre(this.repository);

  Future<Either<Failure, void>> call(String id) =>
      repository.retirerMembre(id);
}