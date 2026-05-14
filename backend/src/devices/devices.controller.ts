import { Controller, Get } from '@nestjs/common';
import { DevicesService } from './devices.service';

@Controller('devices')
export class DevicesController {
  constructor(private readonly devicesService: DevicesService) {}

  @Get()
  findAll() {
    return {
      success: true,
      message: 'Devices fetched successfully',
      total: this.devicesService.findAll().length,
      data: this.devicesService.findAll(),
    };
  }
}