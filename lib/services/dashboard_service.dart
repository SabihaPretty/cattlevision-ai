import 'cattle_api_service.dart';
import '../models/cattle_model.dart';

class DashboardStats {
  final int totalCattle;
  final int healthyCattle;
  final int feverAlerts;
  final double averageTemperature;

  DashboardStats({
    required this.totalCattle,
    required this.healthyCattle,
    required this.feverAlerts,
    required this.averageTemperature,
  });
}

class DashboardService {
  static Future<DashboardStats> getDashboardStats() async {
    final List<CattleModel> cattleList =
        await CattleApiService.getCattleList();

    final total = cattleList.length;

    final healthy = cattleList
        .where((c) => c.healthStatus == 'Healthy')
        .length;

    final fever = cattleList
        .where(
          (c) =>
              c.healthStatus.toLowerCase().contains('fever') ||
              c.lastTemperature >= 39,
        )
        .length;

    double avgTemp = 0;

    if (cattleList.isNotEmpty) {
      avgTemp = cattleList
              .map((e) => e.lastTemperature)
              .reduce((a, b) => a + b) /
          cattleList.length;
    }

    return DashboardStats(
      totalCattle: total,
      healthyCattle: healthy,
      feverAlerts: fever,
      averageTemperature: avgTemp,
    );
  }
}