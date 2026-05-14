import 'package:flutter/material.dart';

import '../models/scan_model.dart';
import '../services/scan_api_service.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late Future<List<ScanModel>> scansFuture;

  @override
  void initState() {
    super.initState();
    scansFuture = ScanApiService.getRecentScans();
  }

  Future<void> refreshScans() async {
    setState(() {
      scansFuture = ScanApiService.getRecentScans();
    });
  }

  Color statusColor(String status) {
    if (status.toLowerCase().contains('fever')) {
      return Colors.redAccent;
    }

    if (status.toLowerCase().contains('healthy')) {
      return Colors.greenAccent;
    }

    return Colors.orangeAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent AI Scans'),
        actions: [
          IconButton(
            onPressed: refreshScans,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<ScanModel>>(
        future: scansFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
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
                  'Failed to load scans\n\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
              ),
            );
          }

          final scans = snapshot.data ?? [];

          return RefreshIndicator(
            onRefresh: refreshScans,
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                const Text(
                  'AI Smart Scan History',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Latest cattle biometric scans and health monitoring records.',
                  style: TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 24),

                if (scans.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111C2E),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Text(
                      'No scan records found.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                else
                  ...scans.map(
                    (scan) => Container(
                      margin: const EdgeInsets.only(bottom: 18),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111C2E),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: statusColor(
                            scan.healthStatus,
                          ).withOpacity(0.35),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(16),
                            child: Image.network(
                              scan.muzzleImage,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) {
                                return Container(
                                  width: 90,
                                  height: 90,
                                  color: Colors.white12,
                                  child: const Icon(
                                    Icons.image_not_supported,
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  scan.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                Text(
                                  scan.id,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  'Temperature: ${scan.temperature}°C',
                                ),

                                Text(
                                  'Confidence: ${scan.biometricConfidence}%',
                                ),

                                const SizedBox(height: 8),

                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor(
                                      scan.healthStatus,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(
                                      12,
                                    ),
                                  ),
                                  child: Text(
                                    scan.healthStatus,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  scan.lastScanTime,
                                  style: const TextStyle(
                                    color: Colors.white54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}