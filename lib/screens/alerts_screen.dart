import 'package:flutter/material.dart';

import '../models/alert_model.dart';
import '../services/alert_api_service.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  late Future<List<AlertModel>> alertsFuture;

  @override
  void initState() {
    super.initState();
    alertsFuture = AlertApiService.getAlerts();
  }

  Future<void> refreshAlerts() async {
    setState(() {
      alertsFuture = AlertApiService.getAlerts();
    });
  }

  Color getAlertColor(AlertModel alert) {
    final severity = alert.severity.toLowerCase();

    if (severity.contains('critical') || severity.contains('high')) {
      return Colors.redAccent;
    }

    if (severity.contains('warning') || severity.contains('medium')) {
      return Colors.orangeAccent;
    }

    return Colors.cyanAccent;
  }

  IconData getAlertIcon(AlertModel alert) {
    final type = alert.type.toLowerCase();
    final title = alert.title.toLowerCase();

    if (type.contains('battery') || title.contains('battery')) {
      return Icons.battery_alert;
    }

    if (type.contains('image') || title.contains('image')) {
      return Icons.image_not_supported;
    }

    if (type.contains('fever') || title.contains('fever')) {
      return Icons.warning_amber;
    }

    if (type.contains('device') || title.contains('device')) {
      return Icons.memory;
    }

    return Icons.notifications_active;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Alerts'),
        actions: [
          IconButton(
            onPressed: refreshAlerts,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<AlertModel>>(
        future: alertsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.cyanAccent),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Text(
                  'Alerts load failed.\n\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            );
          }

          final alerts = snapshot.data ?? [];

          return RefreshIndicator(
            onRefresh: refreshAlerts,
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                const Text(
                  'Alert Center',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Monitor fever, device issues, scan quality and health warnings.',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 24),
                if (alerts.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111C2E),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Text(
                      'No alerts found.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                else
                  ...alerts.map(
                    (alert) {
                      final color = getAlertColor(alert);
                      final icon = getAlertIcon(alert);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111C2E),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: color.withOpacity(0.4)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(icon, color: color, size: 34),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    alert.title,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    alert.message,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    alert.time,
                                    style: TextStyle(color: color),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}