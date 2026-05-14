class AlertModel {
  final String title;
  final String message;
  final String time;
  final String severity;
  final String type;

  AlertModel({
    required this.title,
    required this.message,
    required this.time,
    required this.severity,
    required this.type,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      time: json['time'] ?? '',
      severity: json['severity'] ?? 'info',
      type: json['type'] ?? 'general',
    );
  }
}