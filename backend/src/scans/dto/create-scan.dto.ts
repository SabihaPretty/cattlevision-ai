import {
  IsNumber,
  IsString,
  IsNotEmpty,
  IsUrl,
} from 'class-validator';

export class CreateScanDto {
  @IsString()
  @IsNotEmpty()
  cattleId: string;

  @IsString()
  @IsNotEmpty()
  deviceId: string;

  @IsNumber()
  temperature: number;

  @IsString()
  @IsNotEmpty()
  healthStatus: string;

  @IsNumber()
  biometricConfidence: number;

  @IsUrl()
  muzzleImage: string;
}