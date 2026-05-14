import {
  IsInt,
  IsNotEmpty,
  IsNumber,
  IsString,
  IsUrl,
  Min,
  Max,
} from 'class-validator';

export class CreateCattleDto {
  @IsString()
  @IsNotEmpty()
  id: string;

  @IsString()
  @IsNotEmpty()
  cowTag: string;

  @IsString()
  @IsNotEmpty()
  name: string;

  @IsString()
  @IsNotEmpty()
  breed: string;

  @IsInt()
  @Min(0)
  @Max(30)
  age: number;

  @IsString()
  @IsNotEmpty()
  color: string;

  @IsNumber()
  @Min(1)
  weight: number;

  @IsString()
  @IsNotEmpty()
  owner: string;

  @IsString()
  @IsNotEmpty()
  farm: string;

  @IsNumber()
  @Min(30)
  @Max(45)
  lastTemperature: number;

  @IsString()
  @IsNotEmpty()
  healthStatus: string;

  @IsInt()
  @Min(0)
  @Max(100)
  healthScore: number;

  @IsNumber()
  @Min(0)
  @Max(100)
  biometricConfidence: number;

  @IsString()
  @IsNotEmpty()
  lastScanTime: string;

  @IsString()
  @IsNotEmpty()
  deviceId: string;

  @IsUrl()
  muzzleImage: string;
}