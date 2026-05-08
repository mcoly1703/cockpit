import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/transaction.dart';
import '../repositories/finances_repository.dart';

class ParamsGetTransactions {
  final String? uniteId;
  const ParamsGetTransactions({this.uniteId});
}

class GetTransactions {
  final FinancesRepository repository;
  GetTransactions(this.repository);

  Future<Either<Failure, List<Transaction>>> call(ParamsGetTransactions params) =>
      repository.getTransactions(uniteId: params.uniteId);
}