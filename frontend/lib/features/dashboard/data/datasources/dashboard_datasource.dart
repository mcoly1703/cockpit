import '../../domain/entities/dashboard_stats.dart';

abstract class DashboardDatasource {
  Future<DashboardStats> getDashboardStats({
    required String role,
    String? uniteId,
  });
}








