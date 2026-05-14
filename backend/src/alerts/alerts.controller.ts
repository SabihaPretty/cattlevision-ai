import { Controller, Get } from '@nestjs/common';
import { AlertsService } from './alerts.service';

@Controller('alerts')
export class AlertsController {
  constructor(private readonly alertsService: AlertsService) {}

  @Get()
  findAll() {
    return {
      success: true,
      message: 'Alerts fetched successfully',
      total: this.alertsService.findAll().length,
      data: this.alertsService.findAll(),
    };
  }
}