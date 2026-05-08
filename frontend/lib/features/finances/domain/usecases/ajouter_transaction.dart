import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/transaction.dart';
import '../repositories/finances_repository.dart';

class AjouterTransaction {
  final FinancesRepository repository;
  AjouterTransaction(this.repository);

  Future<Either<Failure, Transaction>> call(ParamsAjouterTransaction params) =>
      repository.ajouterTransaction(params);
}