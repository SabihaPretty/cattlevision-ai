import '../models/cattle_model.dart';
import '../models/scan_history_model.dart';

class MockData {
  static List<CattleModel> cattleList = [
    CattleModel(
      id: 'COW-2026-001',
      name: 'Sundori',
      breed: 'Sahiwal',
      age: 3,
      color: 'Brown',
      weight: 280,
      lastTemperature: 38.5,
      healthStatus: 'Healthy',
      lastScanTime: 'Today, 10:30 AM',
      muzzleImage:
          'https://images.unsplash.com/photo-1500595046743-cd271d694d30',
      healthScore: 92,
      biometricConfidence: 94.5,
      history: [
        ScanHistoryModel(
          date: '12 May 2026',
          temperature: 38.5,
          healthStatus: 'Healthy',
          deviceId: 'ESP32-CAM-01',
          officer: 'Field Officer 1',
          note: 'Regular checkup completed.',
        ),
        ScanHistoryModel(
          date: '10 May 2026',
          temperature: 39.2,
          healthStatus: 'Slightly High',
          deviceId: 'ESP32-CAM-01',
          officer: 'Field Officer 1',
          note: 'Temperature slightly high. Recheck recommended.',
        ),
      ],
    ),
    CattleModel(
      id: 'COW-2026-002',
      name: 'Rani',
      breed: 'Friesian',
      age: 4,
      color: 'Black & White',
      weight: 320,
      lastTemperature: 40.1,
      healthStatus: 'Fever Alert',
      lastScanTime: 'Yesterday, 4:20 PM',
      muzzleImage:
          'https://images.unsplash.com/photo-1527153857715-3908f2bae5e8',
      healthScore: 68,
      biometricConfidence: 89.2,
      history: [
        ScanHistoryModel(
          date: '11 May 2026',
          temperature: 40.1,
          healthStatus: 'Fever Alert',
          deviceId: 'ESP32-CAM-02',
          officer: 'Field Officer 2',
          note: 'High temperature detected. Health observation needed.',
        ),
      ],
    ),
  ];
}