import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/cattle_model.dart';
import '../models/scan_model.dart';
import '../services/cattle_api_service.dart';
import '../services/scan_api_service.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late Future<List<ScanModel>> scansFuture;
  late Future<List<CattleModel>> cattleFuture;

  final ImagePicker imagePicker = ImagePicker();

  String? selectedCattleId;
  XFile? selectedImage;

  final TextEditingController temperatureController = TextEditingController();
  final TextEditingController deviceController =
      TextEditingController(text: 'PHONE-SCAN-01');

  bool isSending = false;

  @override
  void initState() {
    super.initState();

    // Page open hole sudhu ekbar data load hobe.
    scansFuture = ScanApiService.getRecentScans();
    cattleFuture = CattleApiService.getCattleList();
  }

  @override
  void dispose() {
    temperatureController.dispose();
    deviceController.dispose();
    super.dispose();
  }

  Future<void> refreshScans() async {
    setState(() {
      scansFuture = ScanApiService.getRecentScans();
      cattleFuture = CattleApiService.getCattleList();
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

  Future<void> pickImageFromCamera() async {
    final image = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (image == null) return;

    setState(() {
      selectedImage = image;
    });
  }

  Future<void> pickImageFromGallery() async {
    final image = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image == null) return;

    setState(() {
      selectedImage = image;
    });
  }

  Future<void> sendPhoneScan() async {
    if (selectedCattleId == null || selectedCattleId!.isEmpty) {
      showError('Please select a cattle first');
      return;
    }

    final temperature = double.tryParse(temperatureController.text.trim());

    if (temperature == null || temperature < 30 || temperature > 45) {
      showError('Temperature should be between 30°C and 45°C');
      return;
    }

    if (deviceController.text.trim().isEmpty) {
      showError('Device ID is required');
      return;
    }

    setState(() {
      isSending = true;
    });

    try {
      await ScanApiService.sendIotReading(
        cattleId: selectedCattleId!,
        deviceId: deviceController.text.trim(),
        temperature: temperature,
        imageFile: selectedImage,
      );

      if (!mounted) return;

      temperatureController.clear();

      setState(() {
        selectedImage = null;
        scansFuture = ScanApiService.getRecentScans();
        cattleFuture = CattleApiService.getCattleList();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Scan data saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      showError(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isSending = false;
        });
      }
    }
  }

  void showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Scan'),
        actions: [
          IconButton(
            onPressed: refreshScans,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Scan History',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshScans,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            _phoneScanPanel(),
            const SizedBox(height: 26),
            const Text(
              'AI Smart Scan History',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Phone scan, ESP32-CAM scan and IoT temperature records will appear here.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 24),
            _scanHistoryList(),
          ],
        ),
      ),
    );
  }

  Widget _phoneScanPanel() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF123B7A),
            Color(0xFF075985),
            Color(0xFF111C2E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phone / IoT Scan Entry',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select cattle, enter temperature, capture muzzle image and send data to online backend.',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 18),

          FutureBuilder<List<CattleModel>>(
            future: cattleFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LinearProgressIndicator(
                  color: Colors.cyanAccent,
                );
              }

              if (snapshot.hasError) {
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.redAccent),
                  ),
                  child: Text(
                    'Failed to load cattle list\n${snapshot.error}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                );
              }

              final cattleList = snapshot.data ?? <CattleModel>[];
              final validSelectedId = cattleList.any(
                (cattle) => cattle.id == selectedCattleId,
              )
                  ? selectedCattleId
                  : null;

              return DropdownButtonFormField<String>(
                value: validSelectedId,
                decoration: const InputDecoration(
                  labelText: 'Select Cattle',
                  prefixIcon: Icon(Icons.pets),
                ),
                items: cattleList.map((cattle) {
                  return DropdownMenuItem<String>(
                    value: cattle.id,
                    child: Text('${cattle.id} - ${cattle.name}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCattleId = value;
                  });
                },
              );
            },
          ),

          const SizedBox(height: 14),

          TextField(
            controller: temperatureController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Temperature °C',
              prefixIcon: Icon(Icons.thermostat),
            ),
          ),

          const SizedBox(height: 14),

          TextField(
            controller: deviceController,
            decoration: const InputDecoration(
              labelText: 'Device ID',
              prefixIcon: Icon(Icons.memory),
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: pickImageFromCamera,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: pickImageFromGallery,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: isSending ? null : sendPhoneScan,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              backgroundColor: Colors.cyanAccent,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            icon: isSending
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  )
                : const Icon(Icons.cloud_upload),
            label: Text(
              isSending ? 'Sending...' : 'Send Scan Data',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scanHistoryList() {
    return FutureBuilder<List<ScanModel>>(
      future: scansFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF111C2E),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.cyanAccent),
            ),
          );
        }

        if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.redAccent),
            ),
            child: Text(
              'Failed to load scans\n\n${snapshot.error}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
          );
        }

        final scans = snapshot.data ?? <ScanModel>[];

        if (scans.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF111C2E),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Text(
              'No scan records found yet.',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return Column(
          children: scans.map(_scanCard).toList(),
        );
      },
    );
  }

  Widget _scanCard(ScanModel scan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111C2E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: statusColor(scan.healthStatus).withOpacity(0.35),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              scan.muzzleImage,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 90,
                  height: 90,
                  color: Colors.white12,
                  child: const Icon(Icons.image_not_supported),
                );
              },
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scan.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  scan.cattleId,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 10),
                Text('Temperature: ${scan.temperature}°C'),
                Text('Device: ${scan.deviceId}'),
                Text('Confidence: ${scan.biometricConfidence}%'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor(scan.healthStatus),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    scan.healthStatus,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  scan.lastScanTime,
                  style: const TextStyle(color: Colors.white54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}