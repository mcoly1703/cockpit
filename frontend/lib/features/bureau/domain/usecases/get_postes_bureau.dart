import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/poste_bureau.dart';
import '../repositories/bureau_repository.dart';

class GetPostesBureau {
  final BureauRepository repository;
  GetPostesBureau(this.repository);

  Future<Either<Failure, List<PosteBureau>>> call(String uniteId) =>
      repository.getPostesBureau(uniteId);
}