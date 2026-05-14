import { Injectable } from '@nestjs/common';

@Injectable()
export class DevicesService {
  private devices = [
    {
      id: 'DEV-001',
      deviceCode: 'ESP32-CAM-01',
      deviceName: 'Entrance Scanner',
      batteryLevel: 87,
      wifiStatus: 'Connected',
      cameraStatus: 'Active',
      sensorStatus: 'Ready',
      firmwareVersion: '1.0.0',
      lastSync: '5 minutes ago',
    },
    {
      id: 'DEV-002',
      deviceCode: 'ESP32-CAM-02',
      deviceName: 'Barn Scanner',
      batteryLevel: 64,
      wifiStatus: 'Connected',
      cameraStatus: 'Active',
      sensorStatus: 'Ready',
      firmwareVersion: '1.0.0',
      lastSync: '12 minutes ago',
    },
  ];

  findAll() {
    return this.devices;
  }
}