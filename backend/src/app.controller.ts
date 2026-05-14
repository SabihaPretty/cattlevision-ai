import { Controller, Get } from '@nestjs/common';

@Controller()
export class AppController {
  @Get()
  getHome() {
    return {
      success: true,
      app: 'CattleVision AI Backend',
      project:
        'AI Based Smart Cattle Biometric Identification & Health Monitoring System',
      message: 'Backend server is running successfully',
      version: '1.0.0',
      status: 'OK',
      backend: 'NestJS',
      database: 'PostgreSQL',
      orm: 'Prisma',
      baseUrl: 'http://localhost:5000',
      availableApis: [
        'GET /',
        'GET /cattle',
        'GET /cattle/:id',
        'POST /cattle',
        'GET /devices',
        'GET /scans',
        'GET /alerts',
        'GET /analytics/dashboard',
        'GET /team',
        'GET /team/supervisor',
      ],
    };
  }
}