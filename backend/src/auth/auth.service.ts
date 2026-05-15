import {
  BadRequestException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import * as bcrypt from 'bcryptjs';
import { PrismaService } from '../prisma/prisma.service';
import { ChangePasswordDto } from './dto/change-password.dto';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';

@Injectable()
export class AuthService {
  constructor(private prisma: PrismaService) {}

  private safeUser(user: any) {
    return {
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
      createdAt: user.createdAt,
    };
  }

  async register(data: RegisterDto) {
    const exists = await this.prisma.user.findUnique({
      where: {
        email: data.email.toLowerCase(),
      },
    });

    if (exists) {
      throw new BadRequestException('Email already registered');
    }

    const hashedPassword = await bcrypt.hash(data.password, 10);

    const user = await this.prisma.user.create({
      data: {
        name: data.name.trim(),
        email: data.email.toLowerCase().trim(),
        password: hashedPassword,
        role: data.role,
      },
    });

    return {
      success: true,
      message: 'Registration successful',
      data: this.safeUser(user),
    };
  }

  async login(data: LoginDto) {
    const user = await this.prisma.user.findUnique({
      where: {
        email: data.email.toLowerCase().trim(),
      },
    });

    if (!user) {
      throw new UnauthorizedException('Invalid email or password');
    }

    const isPasswordValid = await bcrypt.compare(
      data.password,
      user.password,
    );

    if (!isPasswordValid) {
      throw new UnauthorizedException('Invalid email or password');
    }

    return {
      success: true,
      message: 'Login successful',
      data: this.safeUser(user),
    };
  }

  async changePassword(data: ChangePasswordDto) {
    const user = await this.prisma.user.findUnique({
      where: {
        email: data.email.toLowerCase().trim(),
      },
    });

    if (!user) {
      throw new UnauthorizedException('Invalid email');
    }

    const isOldPasswordValid = await bcrypt.compare(
      data.oldPassword,
      user.password,
    );

    if (!isOldPasswordValid) {
      throw new UnauthorizedException('Old password is incorrect');
    }

    const hashedPassword = await bcrypt.hash(data.newPassword, 10);

    await this.prisma.user.update({
      where: {
        email: data.email.toLowerCase().trim(),
      },
      data: {
        password: hashedPassword,
      },
    });

    return {
      success: true,
      message: 'Password changed successfully',
    };
  }

  async getUsers() {
    const users = await this.prisma.user.findMany({
      orderBy: {
        createdAt: 'desc',
      },
    });

    return {
      success: true,
      total: users.length,
      data: users.map((user) => this.safeUser(user)),
    };
  }
}