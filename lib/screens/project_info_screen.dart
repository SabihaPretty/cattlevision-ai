import 'package:flutter/material.dart';
import '../data/project_team_data.dart';
import '../models/team_member_model.dart';

class ProjectInfoScreen extends StatelessWidget {
  const ProjectInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final teamMembers = ProjectTeamData.teamMembers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Information'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth > 800;

          return ListView(
            padding: EdgeInsets.all(isWide ? 28 : 18),
            children: [
              _headerCard(isWide),
              const SizedBox(height: 18),

              _sectionCard(
                title: 'Project Summary',
                child: const Text(
                  ProjectTeamData.projectSummary,
                  style: TextStyle(
                    color: Colors.white70,
                    height: 1.6,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _projectSupervisorCard()),
                    const SizedBox(width: 18),
                    Expanded(child: _projectLeadCard()),
                  ],
                )
              else ...[
                _projectSupervisorCard(),
                const SizedBox(height: 18),
                _projectLeadCard(),
              ],

              const SizedBox(height: 18),

              _sectionCard(
                title: 'Team Members',
                child: GridView.builder(
                  itemCount: teamMembers.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isWide ? 3 : 1,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: isWide ? 1.55 : 2.6,
                  ),
                  itemBuilder: (context, index) {
                    return _teamMemberCard(teamMembers[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _headerCard(bool isWide) {
    return Container(
      padding: EdgeInsets.all(isWide ? 28 : 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF123B7A),
            Color(0xFF075985),
            Color(0xFF07111F),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 34,
            backgroundColor: Colors.cyanAccent,
            child: Icon(
              Icons.biotech,
              color: Colors.black,
              size: 34,
            ),
          ),
          const SizedBox(width: 18),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ProjectTeamData.projectName,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  ProjectTeamData.projectFullName,
                  style: TextStyle(
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _projectSupervisorCard() {
    return _sectionCard(
      title: 'Project Supervisor',
      child: Column(
        children: const [
          _InfoRow(
            label: 'Name',
            value: ProjectTeamData.supervisorName,
          ),
          _InfoRow(
            label: 'Designation',
            value: ProjectTeamData.supervisorDesignation,
          ),
          _InfoRow(
            label: 'Department',
            value: ProjectTeamData.supervisorDepartment,
          ),
          _InfoRow(
            label: 'Institution',
            value: ProjectTeamData.supervisorInstitution,
          ),
        ],
      ),
    );
  }

  Widget _projectLeadCard() {
    return _sectionCard(
      title: 'Project Lead',
      child: Column(
        children: const [
          CircleAvatar(
            radius: 34,
            backgroundColor: Colors.cyanAccent,
            child: Icon(
              Icons.manage_accounts,
              color: Colors.black,
              size: 34,
            ),
          ),
          SizedBox(height: 14),
          Text(
            ProjectTeamData.projectLeadName,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            ProjectTeamData.projectLeadRole,
            style: TextStyle(
              color: Colors.cyanAccent,
            ),
          ),
          SizedBox(height: 14),
          Text(
            ProjectTeamData.projectLeadContribution,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _teamMemberCard(TeamMemberModel member) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.cyanAccent,
            child: Icon(
              Icons.person,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  member.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  member.role,
                  style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  member.contribution,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111C2E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white12,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}