import { Injectable } from '@nestjs/common';

@Injectable()
export class TeamService {
  getTeam() {
    return [
      {
        name: 'Team Member 1',
        role: 'Frontend Developer',
      },
      {
        name: 'Team Member 2',
        role: 'Backend Support',
      },
      {
        name: 'Team Member 3',
        role: 'Hardware Support',
      },
    ];
  }

  getSupervisor() {
    return {
      name: 'Supervisor Name',
      designation: 'Professor',
      department: 'CSE',
      institution: 'University Name',
    };
  }
}