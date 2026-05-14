import { Controller, Get } from '@nestjs/common';
import { AnalyticsService } from './analytics.service';

@Controller('analytics')
export class AnalyticsController {
  constructor(private readonly analyticsService: AnalyticsService) {}

  @Get('dashboard')
  dashboard() {
    return {
      success: true,
      message: 'Dashboard analytics fetched successfully',
      data: this.analyticsService.getDashboardStats(),
    };
  }
}