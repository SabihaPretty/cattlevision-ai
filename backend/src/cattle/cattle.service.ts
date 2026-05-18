import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class CattleService {
  constructor(private prisma: PrismaService) {}

  // Get all cattle
  async findAll() {
    return this.prisma.cattle.findMany({
      orderBy: { createdAt: 'desc' },
      include: { scanRecords: true },
    });
  }

  // Get single cattle by id
  async findOne(id: string) {
    const cattle = await this.prisma.cattle.findUnique({
      where: { id },
      include: { scanRecords: true },
    });

    if (!cattle) throw new NotFoundException('Cattle not found');
    return cattle;
  }

  // Add new cattle
  async create(data: any) {
    return this.prisma.cattle.create({ data });
  }

  // Update existing cattle
  async update(id: string, data: any) {
    await this.findOne(id);
    return this.prisma.cattle.update({ where: { id }, data });
  }

  // Delete cattle
  async remove(id: string) {
    await this.findOne(id);
    return this.prisma.cattle.delete({ where: { id } });
  }
}