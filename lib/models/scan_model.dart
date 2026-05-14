class ScanModel {
  final String id;
  final String cattleId;
  final String name;
  final String deviceId;
  final double temperature;
  final String healthStatus;
  final double biometricConfidence;
  final String lastScanTime;
  final String muzzleImage;

  ScanModel({
    required this.id,
    required this.cattleId,
    required this.name,
    required this.deviceId,
    required this.temperature,
    required this.healthStatus,
    required this.biometricConfidence,
    required this.lastScanTime,
    required this.muzzleImage,
  });

  factory ScanModel.fromJson(Map<String, dynamic> json) {
    final cattle = json['cattle'];

    return ScanModel(
      id: json['id'] ?? '',
      cattleId: json['cattleId'] ?? json['id'] ?? '',
      name: cattle != null
          ? cattle['name'] ?? json['cattleId'] ?? ''
          : json['name'] ?? json['cattleId'] ?? '',
      deviceId: json['deviceId'] ?? '',
      temperature:
          (json['temperature'] ?? json['lastTemperature'] ?? 0).toDouble(),
      healthStatus: json['healthStatus'] ?? '',
      biometricConfidence:
          (json['biometricConfidence'] ?? 0).toDouble(),
      lastScanTime: json['createdAt'] ?? json['lastScanTime'] ?? '',
      muzzleImage: json['muzzleImage'] ?? '',
    );
  }
}