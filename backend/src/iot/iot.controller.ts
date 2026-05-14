import {
  Body,
  Controller,
  Get,
  Post,
  Req,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import type { Request } from 'express';
import { diskStorage } from 'multer';
import { extname } from 'path';
import { IotService } from './iot.service';

@Controller('iot')
export class IotController {
  constructor(private readonly iotService: IotService) {}

  @Post('reading')
  @UseInterceptors(
    FileInterceptor('image', {
      storage: diskStorage({
        destination: './uploads',
        filename: (req, file, cb) => {
          const uniqueName =
            Date.now() + '-' + Math.round(Math.random() * 1000000000);

          cb(null, uniqueName + extname(file.originalname));
        },
      }),
    }),
  )
  async receiveReading(
    @Body() body: any,
    @UploadedFile() file: Express.Multer.File,
    @Req() request: Request,
  ) {
    return this.iotService.saveReading(body, file, request);
  }

  @Get('latest')
  async getLatestReading() {
    return this.iotService.getLatestReading();
  }
}