import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/poste_bureau.dart';
import '../repositories/bureau_repository.dart';

class SearchMilitantsBureau {
  final BureauRepository repository;
  SearchMilitantsBureau(this.repository);

  Future<Either<Failure, List<MilitantResume>>> call(String query, String uniteId) =>
      repository.searchMilitants(query, uniteId);
}