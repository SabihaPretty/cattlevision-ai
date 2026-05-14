import 'package:flutter/material.dart';

import '../services/dashboard_service.dart';
import '../widgets/stat_card.dart';
import 'cattle_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<DashboardStats> statsFuture;

  @override
  void initState() {
    super.initState();
    statsFuture = DashboardService.getDashboardStats();
  }

  Future<void> refreshDashboard() async {
    setState(() {
      statsFuture = DashboardService.getDashboardStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CattleVision Dashboard'),
        actions: [
          IconButton(
            onPressed: refreshDashboard,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<DashboardStats>(
        future: statsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.cyanAccent,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Text(
                  'Dashboard load failed\n\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            );
          }

          final stats = snapshot.data!;

          return LayoutBuilder(
            builder: (context, constraints) {
              final bool isWide = constraints.maxWidth > 800;

              return RefreshIndicator(
                onRefresh: refreshDashboard,
                child: ListView(
                  padding: EdgeInsets.all(isWide ? 28 : 18),
                  children: [
                    _heroSection(context, isWide),

                    const SizedBox(height: 24),

                    GridView.count(
                      crossAxisCount: isWide ? 4 : 2,
                      shrinkWrap: true,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: isWide ? 1.35 : 1.05,
                      children: [
                        StatCard(
                          title: 'Total Cattle',
                          value: '${stats.totalCattle}',
                          icon: Icons.pets,
                          color: Colors.cyanAccent,
                        ),
                        StatCard(
                          title: 'Healthy Cattle',
                          value: '${stats.healthyCattle}',
                          icon: Icons.health_and_safety,
                          color: Colors.greenAccent,
                        ),
                        StatCard(
                          title: 'Fever Alerts',
                          value: '${stats.feverAlerts}',
                          icon: Icons.warning_amber,
                          color: Colors.orangeAccent,
                        ),
                        const StatCard(
                          title: 'Devices Online',
                          value: '02',
                          icon: Icons.memory,
                          color: Colors.purpleAccent,
                        ),
                      ],
                    ),

                    const SizedBox(height: 26),

                    if (isWide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _systemStatusCard(),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: _todayActivityCard(stats),
                          ),
                        ],
                      )
                    else ...[
                      _systemStatusCard(),
                      const SizedBox(height: 18),
                      _todayActivityCard(stats),
                    ],

                    const SizedBox(height: 26),

                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 58),
                        backgroundColor: Colors.cyanAccent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(Icons.list_alt),
                      label: const Text(
                        'View My Cattle Cards',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CattleListScreen(),
                          ),
                        );

                        refreshDashboard();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _heroSection(BuildContext context, bool isWide) {
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Smart Farm Overview',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Real-time cattle health, biometric scan, device monitoring and AI-ready farm management dashboard.',
                  style: TextStyle(
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: const [
                    _HeroChip(text: 'AI Biometric'),
                    _HeroChip(text: 'ESP32-CAM'),
                    _HeroChip(text: 'Temperature Tracking'),
                    _HeroChip(text: 'Health Alerts'),
                  ],
                ),
              ],
            ),
          ),
          if (isWide) ...[
            const SizedBox(width: 20),
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white12,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.cyanAccent),
              ),
              child: const Icon(
                Icons.pets,
                size: 70,
                color: Colors.cyanAccent,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _systemStatusCard() {
    return _dashboardPanel(
      title: 'System Status',
      children: const [
        _StatusRow(
          title: 'ESP32-CAM Device',
          value: 'Online',
          icon: Icons.memory,
          color: Colors.greenAccent,
        ),
        _StatusRow(
          title: 'MLX90614 Sensor',
          value: 'Ready',
          icon: Icons.thermostat,
          color: Colors.cyanAccent,
        ),
        _StatusRow(
          title: 'Backend API',
          value: 'Connected',
          icon: Icons.cloud_done,
          color: Colors.greenAccent,
        ),
        _StatusRow(
          title: 'AI Model',
          value: 'Later',
          icon: Icons.psychology,
          color: Colors.purpleAccent,
        ),
      ],
    );
  }

  Widget _todayActivityCard(DashboardStats stats) {
    return _dashboardPanel(
      title: 'Today Activity',
      children: [
        _StatusRow(
          title: 'Total Cattle',
          value: '${stats.totalCattle}',
          icon: Icons.pets,
          color: Colors.cyanAccent,
        ),
        _StatusRow(
          title: 'Healthy',
          value: '${stats.healthyCattle}',
          icon: Icons.health_and_safety,
          color: Colors.greenAccent,
        ),
        _StatusRow(
          title: 'Average Temperature',
          value:
              '${stats.averageTemperature.toStringAsFixed(1)}°C',
          icon: Icons.device_thermostat,
          color: Colors.orangeAccent,
        ),
        const _StatusRow(
          title: 'Image Quality',
          value: 'Good',
          icon: Icons.image_search,
          color: Colors.purpleAccent,
        ),
      ],
    );
  }

  Widget _dashboardPanel({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111C2E),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white12),
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
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  final String text;

  const _HeroChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(text),
      backgroundColor: Colors.white12,
      labelStyle: const TextStyle(color: Colors.white),
      side: const BorderSide(color: Colors.white24),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatusRow({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}