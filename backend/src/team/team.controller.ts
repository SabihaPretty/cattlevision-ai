import { Controller, Get } from '@nestjs/common';
import { TeamService } from './team.service';

@Controller('team')
export class TeamController {
  constructor(private readonly teamService: TeamService) {}

  @Get()
  getTeam() {
    return {
      success: true,
      data: this.teamService.getTeam(),
    };
  }

  @Get('supervisor')
  getSupervisor() {
    return {
      success: true,
      data: this.teamService.getSupervisor(),
    };
  }
}