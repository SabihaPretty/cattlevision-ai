import { Injectable, UnauthorizedException, BadRequestException } from '@nestjs/common';
import * as bcrypt from 'bcryptjs';
import { PrismaService } from '../prisma/prisma.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { ChangePasswordDto } from './dto/change-password.dto';

@Injectable()
export class AuthService {
  constructor(private prisma: PrismaService){}

  private safeUser(user:any){
    return { id:user.id, name:user.name, email:user.email, role:user.role, approved:user.approved, createdAt:user.createdAt };
  }

  async register(data:RegisterDto){
    const exists = await this.prisma.user.findUnique({where:{email:data.email}});
    if(exists) throw new BadRequestException('Email already registered');

    const hashed = await bcrypt.hash(data.password,10);
    const user = await this.prisma.user.create({
      data:{...data,password:hashed,approved:data.role==='admin'?true:false}
    });
    return {success:true,message:'Registration successful',data:this.safeUser(user)};
  }

  async login(data:LoginDto){
    const user = await this.prisma.user.findUnique({where:{email:data.email}});
    if(!user || !await bcrypt.compare(data.password,user.password))
      throw new UnauthorizedException('Invalid email or password');
    if(!user.approved) throw new UnauthorizedException('Admin approval required');
    return {success:true,message:'Login successful',data:this.safeUser(user)};
  }

  async changePassword(data:ChangePasswordDto){
    const user = await this.prisma.user.findUnique({where:{email:data.email}});
    if(!user) throw new UnauthorizedException('Invalid email');
    if(!await bcrypt.compare(data.oldPassword,user.password))
      throw new UnauthorizedException('Old password incorrect');
    await this.prisma.user.update({where:{email:data.email},data:{password:await bcrypt.hash(data.newPassword,10)}});
    return {success:true,message:'Password changed successfully'};
  }

  async getUsers(){
    const users = await this.prisma.user.findMany({orderBy:{createdAt:'desc'}});
    return {success:true,total:users.length,data:users.map(u=>this.safeUser(u))};
  }

  async approveUser(id:string){
    const user = await this.prisma.user.update({where:{id},data:{approved:true}});
    return {success:true,message:'User approved',data:this.safeUser(user)};
  }
}