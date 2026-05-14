import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateScanDto } from './dto/create-scan.dto';

@Injectable()
export class ScansService {
  constructor(private prisma: PrismaService) {}

  async createScan(data: CreateScanDto) {
    const cattle = await this.prisma.cattle.findUnique({
      where: {
        id: data.cattleId,
      },
    });

    if (!cattle) {
      throw new NotFoundException('Cattle not found');
    }

    const healthScore = data.temperature >= 39 ? 65 : 92;

    const scanRecord = await this.prisma.scanRecord.create({
      data: {
        cattleId: data.cattleId,
        deviceId: data.deviceId,
        temperature: data.temperature,
        healthStatus: data.healthStatus,
        biometricConfidence: data.biometricConfidence,
        muzzleImage: data.muzzleImage,
        note:
          data.temperature >= 39
            ? 'High temperature detected.'
            : 'Normal scan completed.',
      },
    });

    const updatedCattle = await this.prisma.cattle.update({
      where: {
        id: data.cattleId,
      },
      data: {
        lastTemperature: data.temperature,
        healthStatus: data.healthStatus,
        biometricConfidence: data.biometricConfidence,
        muzzleImage: data.muzzleImage,
        lastScanTime: new Date().toLocaleString(),
        deviceId: data.deviceId,
        healthScore,
      },
    });

    return {
      scanRecord,
      updatedCattle,
    };
  }

  async getRecentScans() {
    return this.prisma.scanRecord.findMany({
      orderBy: {
        createdAt: 'desc',
      },
      take: 20,
      include: {
        cattle: {
          select: {
            id: true,
            name: true,
            breed: true,
            color: true,
          },
        },
      },
    });
  }

  async getCattleScanHistory(cattleId: string) {
    const cattle = await this.prisma.cattle.findUnique({
      where: {
        id: cattleId,
      },
    });

    if (!cattle) {
      throw new NotFoundException('Cattle not found');
    }

    return this.prisma.scanRecord.findMany({
      where: {
        cattleId,
      },
      orderBy: {
        createdAt: 'desc',
      },
    });
  }
}