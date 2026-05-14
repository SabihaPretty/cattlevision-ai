class DeviceModel {
  final String id;
  final String deviceCode;
  final String deviceName;
  final int batteryLevel;
  final String wifiStatus;
  final String cameraStatus;
  final String sensorStatus;
  final String firmwareVersion;
  final String lastSync;

  DeviceModel({
    required this.id,
    required this.deviceCode,
    required this.deviceName,
    required this.batteryLevel,
    required this.wifiStatus,
    required this.cameraStatus,
    required this.sensorStatus,
    required this.firmwareVersion,
    required this.lastSync,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] ?? '',
      deviceCode: json['deviceCode'] ?? '',
      deviceName: json['deviceName'] ?? '',
      batteryLevel: json['batteryLevel'] ?? 0,
      wifiStatus: json['wifiStatus'] ?? '',
      cameraStatus: json['cameraStatus'] ?? '',
      sensorStatus: json['sensorStatus'] ?? '',
      firmwareVersion: json['firmwareVersion'] ?? '',
      lastSync: json['lastSync'] ?? '',
    );
  }
}