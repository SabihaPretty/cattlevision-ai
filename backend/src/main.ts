import { ValidationPipe } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { NestExpressApplication } from '@nestjs/platform-express';
import { join } from 'path';
import { AppModule } from './app.module';

async function bootstrap() {
  const app =
    await NestFactory.create<NestExpressApplication>(
      AppModule,
    );

  app.enableCors();

  app.useStaticAssets(
    join(__dirname, '..', 'uploads'),
    {
      prefix: '/uploads/',
    },
  );

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: false,
      transform: true,
    }),
  );

  // IMPORTANT FOR RENDER
  const port = process.env.PORT || 5000;

  await app.listen(port as number);

  console.log('===================================');
  console.log('CattleVision AI Backend Running');
  console.log(`Backend URL Running On Port: ${port}`);
  console.log('===================================');
}

bootstrap();