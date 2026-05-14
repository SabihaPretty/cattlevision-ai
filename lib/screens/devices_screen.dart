import 'package:flutter/material.dart';

import '../models/device_model.dart';
import '../services/device_api_service.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  late Future<List<DeviceModel>> devicesFuture;

  @override
  void initState() {
    super.initState();
    devicesFuture = DeviceApiService.getDevices();
  }

  Future<void> refreshDevices() async {
    setState(() {
      devicesFuture = DeviceApiService.getDevices();
    });
  }

  Color batteryColor(int battery) {
    if (battery >= 70) return Colors.greenAccent;
    if (battery >= 40) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connected Devices'),
        actions: [
          IconButton(
            onPressed: refreshDevices,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<DeviceModel>>(
        future: devicesFuture,
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
                  'Device loading failed\n\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            );
          }

          final devices = snapshot.data ?? [];

          return RefreshIndicator(
            onRefresh: refreshDevices,
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                const Text(
                  'ESP32 Device Center',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Monitor ESP32-CAM device health, connectivity and sensor readiness.',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 24),

                if (devices.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111C2E),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Text(
                      'No devices connected.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                else
                  ...devices.map(
                    (device) => Container(
                      margin: const EdgeInsets.only(bottom: 18),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111C2E),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.cyanAccent.withOpacity(0.25),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.memory,
                                color: Colors.cyanAccent,
                                size: 34,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      device.deviceName,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      device.deviceCode,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${device.batteryLevel}%',
                                style: TextStyle(
                                  color: batteryColor(device.batteryLevel),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          _infoRow(
                            'WiFi Status',
                            device.wifiStatus,
                            Colors.greenAccent,
                          ),

                          _infoRow(
                            'Camera',
                            device.cameraStatus,
                            Colors.cyanAccent,
                          ),

                          _infoRow(
                            'Sensor',
                            device.sensorStatus,
                            Colors.orangeAccent,
                          ),

                          _infoRow(
                            'Firmware',
                            device.firmwareVersion,
                            Colors.purpleAccent,
                          ),

                          _infoRow(
                            'Last Sync',
                            device.lastSync,
                            Colors.white70,
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

  Widget _infoRow(String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
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