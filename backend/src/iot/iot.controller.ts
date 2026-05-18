import { Controller, Post, Body, Get } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Controller('iot')
export class IotController {
  constructor(private prisma: PrismaService) {}

  @Post('reading')
  async postReading(@Body() body: any) {
    const { deviceId, temperature, ambient, note, muzzleImage } = body;
    const record = await this.prisma.scanRecord.create({
      data: {
        cattleId: body.cattleId ?? 'demo-cattle',
        deviceId,
        temperature,
        healthStatus: 'ok',
        biometricConfidence: 100,
        muzzleImage: muzzleImage ?? '',
        note: note ?? '',
      },
    });
    return { success: true, data: record };
  }

  @Get('latest')
  async getLatest() {
    const latest = await this.prisma.scanRecord.findMany({
      take: 1,
      orderBy: { createdAt: 'desc' },
    });
    return { success: true, data: latest };
  }
}