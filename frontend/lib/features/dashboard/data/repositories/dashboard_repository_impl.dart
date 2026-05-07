import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/dashboard_stats.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardDatasource datasource;
  DashboardRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, DashboardStats>> getDashboardStats({
    required String role,
    String? uniteId,
  }) async {
    try {
      final stats = await datasource.getDashboardStats(
        role:    role,
        uniteId: uniteId,
      );
      return Right(stats);
    } on ServerException catch (e) {
      return Left(Failure.serveur(message: e.message));
    } on NetworkException {
      return const Left(Failure.reseau());
    }
  }
}