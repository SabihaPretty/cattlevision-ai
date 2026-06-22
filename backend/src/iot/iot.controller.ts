import {
  BadRequestException,
  Body,
  Controller,
  Get,
  NotFoundException,
  Post,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { PrismaService } from '../prisma/prisma.service';

@Controller('iot')
export class IotController {
  constructor(private readonly prisma: PrismaService) {}

  @Post('reading')
  @UseInterceptors(FileInterceptor('image'))
  async postReading(@Body() body: any, @UploadedFile() image?: any) {
    const cattleId = String(body.cattleId ?? '').trim();
    const deviceId = String(body.deviceId ?? '').trim();
    const temperature = Number(body.temperature);

    if (!cattleId || !deviceId || !Number.isFinite(temperature)) {
      throw new BadRequestException(
        'cattleId, deviceId and a valid temperature are required.',
      );
    }

    const cattle = await this.prisma.cattle.findUnique({
      where: { id: cattleId },
      select: { id: true },
    });

    if (!cattle) {
      throw new NotFoundException('Selected cattle was not found.');
    }

    const healthStatus =
      temperature >= 40
        ? 'critical'
        : temperature >= 39.5
          ? 'warning'
          : 'ok';

    const note =
      typeof body.note === 'string' && body.note.trim().isNotEmpty
        ? body.note.trim()
        : null;

    const muzzleImage = image?.buffer
      ? `data:${image.mimetype ?? 'image/jpeg'};base64,${image.buffer.toString('base64')}`
      : '';

    const record = await this.prisma.$transaction(async (tx) => {
      const newRecord = await tx.scanRecord.create({
        data: {
          cattleId,
          deviceId,
          temperature,
          healthStatus,
          biometricConfidence: 100,
          muzzleImage,
          note,
        },
      });

      const cattleUpdate = {
        lastTemperature: temperature,
        healthStatus,
        lastScanTime: new Date().toISOString(),
        deviceId,
      };

      if (muzzleImage) {
        await tx.cattle.update({
          where: { id: cattleId },
          data: {
            ...cattleUpdate,
            muzzleImage,
          },
        });
      } else {
        await tx.cattle.update({
          where: { id: cattleId },
          data: cattleUpdate,
        });
      }

      return newRecord;
    });

    return {
      success: true,
      data: record,
    };
  }

  @Get('latest')
  async getLatest() {
    const latest = await this.prisma.scanRecord.findMany({
      take: 1,
      orderBy: { createdAt: 'desc' },
    });

    return {
      success: true,
      data: latest,
    };
  }
}