import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/dashboard_stats.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardStats implements UseCase<DashboardStats, ParamsGetDashboardStats> {
  final DashboardRepository repository;
  GetDashboardStats(this.repository);

  @override
  Future<Either<Failure, DashboardStats>> call(ParamsGetDashboardStats params) =>
      repository.getDashboardStats(
        role:    params.role,
        uniteId: params.uniteId,
      );
}

class ParamsGetDashboardStats {
  final String role;
  final String? uniteId;
  const ParamsGetDashboardStats({required this.role, this.uniteId});
}
