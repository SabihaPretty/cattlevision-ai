import { Injectable } from '@nestjs/common';

@Injectable()
export class AlertsService {
  private alerts = [
    {
      id: 'ALERT-001',
      cattleId: 'COW-2026-002',
      type: 'Fever',
      severity: 'High',
      message: 'High temperature detected',
      status: 'Pending',
      createdAt: '11 May 2026 4:25 PM',
    },
  ];

  findAll() {
    return this.alerts;
  }
}