import { Module } from '@nestjs/common';
import { AppController } from './app.controller';

import { PrismaModule } from './prisma/prisma.module';

import { CattleModule } from './cattle/cattle.module';
import { DevicesModule } from './devices/devices.module';
import { ScansModule } from './scans/scans.module';
import { AlertsModule } from './alerts/alerts.module';
import { AnalyticsModule } from './analytics/analytics.module';
import { TeamModule } from './team/team.module';
import { IotModule } from './iot/iot.module';
import { AuthModule } from './auth/auth.module';

@Module({
  imports: [
    PrismaModule,
    CattleModule,
    DevicesModule,
    ScansModule,
    AlertsModule,
    AnalyticsModule,
    TeamModule,
    IotModule,
    AuthModule,
  ],
  controllers: [AppController],
  providers: [],
})
export class AppModule {}