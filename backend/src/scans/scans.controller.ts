import {
  Body,
  Controller,
  Get,
  Param,
  Post,
} from '@nestjs/common';

import { ScansService } from './scans.service';
import { CreateScanDto } from './dto/create-scan.dto';

@Controller('scans')
export class ScansController {
  constructor(
    private readonly scansService: ScansService,
  ) {}

  @Post()
  async createScan(
    @Body() body: CreateScanDto,
  ) {
    return {
      success: true,
      message: 'Scan saved successfully',
      data: await this.scansService.createScan(body),
    };
  }

  @Get()
  async getRecentScans() {
    return {
      success: true,
      data: await this.scansService.getRecentScans(),
    };
  }

  @Get('cattle/:cattleId')
  async getCattleScanHistory(
    @Param('cattleId') cattleId: string,
  ) {
    return {
      success: true,
      data: await this.scansService.getCattleScanHistory(cattleId),
    };
  }
}