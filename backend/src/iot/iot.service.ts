import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { Request } from 'express';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class IotService {
  constructor(private prisma: PrismaService) {}

  async saveReading(
    body: any,
    file: Express.Multer.File,
    request: Request,
  ) {
    const cattleId = body.cattleId;
    const deviceId = body.deviceId;
    const temperature = Number(body.temperature);

    if (!cattleId) {
      throw new BadRequestException('cattleId is required');
    }

    if (!deviceId) {
      throw new BadRequestException('deviceId is required');
    }

    if (Number.isNaN(temperature)) {
      throw new BadRequestException('Valid temperature is required');
    }

    const cattle = await this.prisma.cattle.findUnique({
      where: {
        id: cattleId,
      },
    });

    if (!cattle) {
      throw new NotFoundException(
        `Cattle not found with id: ${cattleId}`,
      );
    }

    const forwardedProto = request.headers['x-forwarded-proto'];
    const protocol =
      typeof forwardedProto === 'string'
        ? forwardedProto
        : request.protocol;

    const host = request.get('host');

    const imageUrl = file
      ? `${protocol}://${host}/uploads/${file.filename}`
      : cattle.muzzleImage;

    const healthStatus =
      temperature >= 39 ? 'Fever Detected' : 'Healthy';

    const healthScore = temperature >= 39 ? 65 : 92;

    const scanRecord = await this.prisma.scanRecord.create({
      data: {
        cattleId,
        deviceId,
        temperature,
        healthStatus,
        biometricConfidence: 95,
        muzzleImage: imageUrl,
        note:
          temperature >= 39
            ? 'High temperature detected from ESP32-CAM device.'
            : 'Normal temperature reading from ESP32-CAM device.',
      },
    });

    const updatedCattle = await this.prisma.cattle.update({
      where: {
        id: cattleId,
      },
      data: {
        lastTemperature: temperature,
        healthStatus,
        healthScore,
        biometricConfidence: 95,
        lastScanTime: new Date().toLocaleString(),
        deviceId,
        muzzleImage: imageUrl,
      },
    });

    console.log('===================================');
    console.log('New IoT Reading Received');
    console.log('Cattle ID:', cattleId);
    console.log('Device ID:', deviceId);
    console.log('Temperature:', temperature);
    console.log('Image URL:', imageUrl);
    console.log('===================================');

    return {
      success: true,
      message: 'IoT data received successfully',
      data: {
        scanRecord,
        updatedCattle,
      },
    };
  }

  async getLatestReading() {
    const latest = await this.prisma.scanRecord.findFirst({
      orderBy: {
        createdAt: 'desc',
      },
      include: {
        cattle: true,
      },
    });

    return {
      success: true,
      data: latest,
    };
  }
}