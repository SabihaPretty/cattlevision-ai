import { Module } from '@nestjs/common';
import { AuthController } from './auth.controller'; // folder same level
import { AuthService } from './auth.service';
import { PrismaService } from '../prisma/prisma.service';

@Module({
  controllers: [AuthController],
  providers: [AuthService, PrismaService],
})
export class AuthModule {}