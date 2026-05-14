import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class CattleService {
  constructor(private prisma: PrismaService) {}

  async findAll() {
    return this.prisma.cattle.findMany({
      orderBy: {
        createdAt: 'desc',
      },
    });
  }

  async findOne(id: string) {
    const cattle = await this.prisma.cattle.findUnique({
      where: { id },
    });

    if (!cattle) {
      throw new NotFoundException('Cattle not found');
    }

    return cattle;
  }

  async create(data: any) {
    return this.prisma.cattle.create({
      data,
    });
  }

  async update(id: string, data: any) {
    await this.findOne(id);

    return this.prisma.cattle.update({
      where: { id },
      data,
    });
  }

  async remove(id: string) {
    await this.findOne(id);

    return this.prisma.cattle.delete({
      where: { id },
    });
  }
}