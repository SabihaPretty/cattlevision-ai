import { IsEmail, IsString, MinLength, IsIn } from 'class-validator';

export class RegisterDto {
  @IsString() name: string;
  @IsEmail() email: string;
  @IsString() @MinLength(6) password: string;
  @IsString() @IsIn(['admin','farmer','field_officer','researcher']) role: string;
}