class ScanHistoryModel {
  final String date;
  final double temperature;
  final String healthStatus;
  final String deviceId;
  final String officer;
  final String note;

  ScanHistoryModel({
    required this.date,
    required this.temperature,
    required this.healthStatus,
    required this.deviceId,
    required this.officer,
    required this.note,
  });
}