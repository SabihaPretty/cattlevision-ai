import 'scan_history_model.dart';

class CattleModel {
  final String id;
  final String name;
  final String breed;
  final int age;
  final String color;
  final double weight;
  final double lastTemperature;
  final String healthStatus;
  final String lastScanTime;
  final String muzzleImage;
  final int healthScore;
  final double biometricConfidence;
  final List<ScanHistoryModel> history;

  CattleModel({
    required this.id,
    required this.name,
    required this.breed,
    required this.age,
    required this.color,
    required this.weight,
    required this.lastTemperature,
    required this.healthStatus,
    required this.lastScanTime,
    required this.muzzleImage,
    required this.healthScore,
    required this.biometricConfidence,
    required this.history,
  });

  factory CattleModel.fromJson(Map<String, dynamic> json) {
    return CattleModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      breed: json['breed'] ?? '',
      age: json['age'] ?? 0,
      color: json['color'] ?? '',
      weight: (json['weight'] ?? 0).toDouble(),
      lastTemperature: (json['lastTemperature'] ?? 0).toDouble(),
      healthStatus: json['healthStatus'] ?? '',
      lastScanTime: json['lastScanTime'] ?? '',
      muzzleImage: json['muzzleImage'] ?? '',
      healthScore: json['healthScore'] ?? 0,
      biometricConfidence: (json['biometricConfidence'] ?? 0).toDouble(),
      history: const [],
    );
  }
}