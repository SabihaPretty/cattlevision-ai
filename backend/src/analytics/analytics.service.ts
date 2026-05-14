import { Injectable } from '@nestjs/common';

@Injectable()
export class AnalyticsService {
  getDashboardStats() {
    return {
      totalCattle: 2,
      healthyCattle: 1,
      feverAlerts: 1,
      todayScans: 7,
      activeDevices: 2,
      averageTemperature: 38.9,
      biometricAccuracy: 91.8,
    };
  }
}