import { Controller, Post, Patch, Get, Body, Param } from '@nestjs/common';
import { AuthService } from './auth.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { ChangePasswordDto } from './dto/change-password.dto';

@Controller('auth')
export class AuthController {
  constructor(private auth: AuthService){}

  @Post('register') register(@Body() body:RegisterDto){return this.auth.register(body);}
  @Post('login') login(@Body() body:LoginDto){return this.auth.login(body);}
  @Patch('change-password') changePassword(@Body() body:ChangePasswordDto){return this.auth.changePassword(body);}
  @Get('users') getUsers(){return this.auth.getUsers();}
  @Patch('approve-user/:id') approve(@Param('id') id:string){return this.auth.approveUser(id);}
}