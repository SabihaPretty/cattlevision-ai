import 'package:flutter/material.dart';

import '../models/scan_model.dart';
import '../services/scan_api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<ScanModel>> scansFuture;

  @override
  void initState() {
    super.initState();

    // Page open hole sudhu ekbar data load hobe.
    // 5 seconds auto update ekhane nei.
    scansFuture = ScanApiService.getRecentScans();
  }

  Future<void> refreshDashboard() async {
    setState(() {
      scansFuture = ScanApiService.getRecentScans();
    });
  }

  Color statusColor(String status) {
    final value = status.toLowerCase();

    if (value.contains('fever')) return Colors.redAccent;

    if (value.contains('healthy') ||
        value.contains('good') ||
        value.contains('ok')) {
      return Colors.greenAccent;
    }

    return Colors.orangeAccent;
  }

  double averageTemperature(List<ScanModel> scans) {
    if (scans.isEmpty) return 0;

    final total = scans.fold<double>(
      0,
      (sum, scan) => sum + scan.temperature,
    );

    return total / scans.length;
  }

  int feverCount(List<ScanModel> scans) {
    return scans
        .where((scan) => scan.healthStatus.toLowerCase().contains('fever'))
        .length;
  }

  int healthyCount(List<ScanModel> scans) {
    return scans.where((scan) {
      final status = scan.healthStatus.toLowerCase();

      return status.contains('healthy') ||
          status.contains('good') ||
          status.contains('ok');
    }).length;
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
            tooltip: 'Refresh Dashboard',
          ),
        ],
      ),
      body: FutureBuilder<List<ScanModel>>(
        future: scansFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.cyanAccent),
            );
          }

          if (snapshot.hasError) {
            return RefreshIndicator(
              onRefresh: refreshDashboard,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const SizedBox(height: 120),
                  Center(
                    child: Text(
                      'Dashboard load failed\n\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            );
          }

          final scans = snapshot.data ?? <ScanModel>[];

          return RefreshIndicator(
            onRefresh: refreshDashboard,
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                _heroSection(),
                const SizedBox(height: 22),
                _summaryCards(scans),
                const SizedBox(height: 22),
                _systemStatusCard(),
                const SizedBox(height: 22),
                _recentScanHistory(scans),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _heroSection() {
    return Container(
      padding: const EdgeInsets.all(22),
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
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Smart Farm Overview',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Cattle health, biometric scan, device monitoring and AI-ready farm management dashboard.',
            style: TextStyle(
              color: Colors.white70,
              height: 1.5,
            ),
          ),
          SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _HeroChip(text: 'AI Biometric'),
              _HeroChip(text: 'ESP32-CAM'),
              _HeroChip(text: 'Temperature Tracking'),
              _HeroChip(text: 'Health Alerts'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryCards(List<ScanModel> scans) {
    final latestScan = scans.isNotEmpty ? scans.first : null;
    final avgTemp = averageTemperature(scans);

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.15,
      children: [
        _summaryCard(
          title: 'Latest Temp',
          value: latestScan == null
              ? '--'
              : '${latestScan.temperature.toStringAsFixed(1)}°C',
          icon: Icons.thermostat,
          color: latestScan == null
              ? Colors.cyanAccent
              : statusColor(latestScan.healthStatus),
        ),
        _summaryCard(
          title: 'Avg Temp',
          value: scans.isEmpty ? '--' : '${avgTemp.toStringAsFixed(1)}°C',
          icon: Icons.analytics,
          color: Colors.cyanAccent,
        ),
        _summaryCard(
          title: 'Healthy',
          value: '${healthyCount(scans)}',
          icon: Icons.health_and_safety,
          color: Colors.greenAccent,
        ),
        _summaryCard(
          title: 'Fever Alerts',
          value: '${feverCount(scans)}',
          icon: Icons.warning_amber,
          color: Colors.orangeAccent,
        ),
      ],
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111C2E),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 30),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _systemStatusCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111C2E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System Status',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          _StatusRow(
            title: 'Backend API',
            value: 'Ready',
            icon: Icons.cloud_done,
            color: Colors.greenAccent,
          ),
          _StatusRow(
            title: 'ESP32 Device',
            value: 'Manual Scan',
            icon: Icons.memory,
            color: Colors.cyanAccent,
          ),
          _StatusRow(
            title: 'Scan Update',
            value: 'Refresh Only',
            icon: Icons.refresh,
            color: Colors.orangeAccent,
          ),
        ],
      ),
    );
  }

  Widget _recentScanHistory(List<ScanModel> scans) {
    if (scans.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF111C2E),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white12),
        ),
        child: const Text(
          'No scan records found yet. After ESP32 sends a scan, press refresh to see it here.',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    final recentScans = scans.length > 8 ? scans.take(8).toList() : scans;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111C2E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Scan History',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          Column(
            children: recentScans.map(_scanTile).toList(),
          ),
        ],
      ),
    );
  }

  Widget _scanTile(ScanModel scan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColor(scan.healthStatus).withOpacity(0.35),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.document_scanner,
            color: statusColor(scan.healthStatus),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${scan.name} • ${scan.temperature.toStringAsFixed(1)}°C • ${scan.deviceId}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Text(
            scan.healthStatus,
            style: TextStyle(
              color: statusColor(scan.healthStatus),
              fontWeight: FontWeight.bold,
            ),
          ),
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