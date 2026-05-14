import '../models/team_member_model.dart';

class ProjectTeamData {
  static const String projectName = 'CattleVision AI';

  static const String projectFullName =
      'AI Based Smart Cattle Biometric Identification & Health Monitoring System';

  static const String projectSummary =
      'This system uses cattle muzzle biometric identification, ESP32-CAM image capture, MLX90614 contactless temperature sensor and a smart dashboard to monitor cattle identity and health condition.';

  static const String supervisorName = 'Supervisor Name';
  static const String supervisorDesignation = 'Designation Here';
  static const String supervisorDepartment = 'Department Name';
  static const String supervisorInstitution = 'Institution Name';

  static const String projectLeadName = 'Your Name';
  static const String projectLeadRole = 'Project Lead / Team Coordinator';
  static const String projectLeadContribution =
      'Responsible for managing the project workflow, coordinating team members, planning system architecture and guiding the overall implementation.';

  static List<TeamMemberModel> teamMembers = [
    TeamMemberModel(
      name: 'Team Member 1',
      role: 'Frontend / UI Support',
      contribution: 'Supports Flutter UI design and screen implementation.',
      email: 'member1@example.com',
      phone: '+8801XXXXXXXXX',
    ),
    TeamMemberModel(
      name: 'Team Member 2',
      role: 'Backend Support',
      contribution: 'Supports API planning, backend logic and database work.',
      email: 'member2@example.com',
      phone: '+8801XXXXXXXXX',
    ),
    TeamMemberModel(
      name: 'Team Member 3',
      role: 'Hardware Support',
      contribution: 'Works with ESP32-CAM, MLX90614 sensor and device setup.',
      email: 'member3@example.com',
      phone: '+8801XXXXXXXXX',
    ),
    TeamMemberModel(
      name: 'Team Member 4',
      role: 'Data Collection Support',
      contribution: 'Supports cattle image and health data collection.',
      email: 'member4@example.com',
      phone: '+8801XXXXXXXXX',
    ),
    TeamMemberModel(
      name: 'Team Member 5',
      role: 'Documentation Support',
      contribution: 'Supports report writing, project documentation and slides.',
      email: 'member5@example.com',
      phone: '+8801XXXXXXXXX',
    ),
    TeamMemberModel(
      name: 'Team Member 6',
      role: 'Testing Support',
      contribution: 'Supports app testing, bug finding and feature validation.',
      email: 'member6@example.com',
      phone: '+8801XXXXXXXXX',
    ),
  ];
}