import 'package:flutter/material.dart';
import '../services/cattle_api_service.dart';

class AddCattleScreen extends StatefulWidget {
  const AddCattleScreen({super.key});

  @override
  State<AddCattleScreen> createState() => _AddCattleScreenState();
}

class _AddCattleScreenState extends State<AddCattleScreen> {
  final formKey = GlobalKey<FormState>();

  final idController = TextEditingController(text: 'COW-2026-004');
  final tagController = TextEditingController(text: 'TAG-004');
  final nameController = TextEditingController(text: 'New Cattle');
  final breedController = TextEditingController(text: 'Local');
  final ageController = TextEditingController(text: '3');
  final colorController = TextEditingController(text: 'Brown');
  final weightController = TextEditingController(text: '280');
  final ownerController = TextEditingController(text: 'Farmer D');
  final farmController = TextEditingController(text: 'Smart Agro Farm');
  final tempController = TextEditingController(text: '38.5');
  final healthStatusController = TextEditingController(text: 'Healthy');
  final healthScoreController = TextEditingController(text: '90');
  final confidenceController = TextEditingController(text: '94');
  final scanTimeController = TextEditingController(text: 'Today');
  final deviceIdController = TextEditingController(text: 'PHONE-SCAN-01');
  final imageController = TextEditingController(
    text: 'https://images.unsplash.com/photo-1500595046743-cd271d694d30',
  );

  bool isLoading = false;

  @override
  void dispose() {
    idController.dispose();
    tagController.dispose();
    nameController.dispose();
    breedController.dispose();
    ageController.dispose();
    colorController.dispose();
    weightController.dispose();
    ownerController.dispose();
    farmController.dispose();
    tempController.dispose();
    healthStatusController.dispose();
    healthScoreController.dispose();
    confidenceController.dispose();
    scanTimeController.dispose();
    deviceIdController.dispose();
    imageController.dispose();
    super.dispose();
  }

  Future<void> submitCattle() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    final data = {
      'id': idController.text.trim(),
      'cowTag': tagController.text.trim(),
      'name': nameController.text.trim(),
      'breed': breedController.text.trim(),
      'age': int.parse(ageController.text.trim()),
      'color': colorController.text.trim(),
      'weight': double.parse(weightController.text.trim()),
      'owner': ownerController.text.trim(),
      'farm': farmController.text.trim(),
      'lastTemperature': double.parse(tempController.text.trim()),
      'healthStatus': healthStatusController.text.trim(),
      'healthScore': int.parse(healthScoreController.text.trim()),
      'biometricConfidence': double.parse(confidenceController.text.trim()),
      'lastScanTime': scanTimeController.text.trim(),
      'deviceId': deviceIdController.text.trim(),
      'muzzleImage': imageController.text.trim(),
    };

    try {
      await CattleApiService.addCattle(data);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cattle added successfully'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String? requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? numberValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    final number = double.tryParse(value.trim());

    if (number == null) {
      return 'Enter a valid number';
    }

    return null;
  }

  Widget inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator ?? requiredValidator,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }

  Widget imagePreview() {
    final imageUrl = imageController.text.trim();

    if (imageUrl.isEmpty) {
      return const SizedBox.shrink();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        imageUrl,
        height: 190,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                'Image preview not available. Please check URL.',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Cattle'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF123B7A),
                    Color(0xFF075985),
                    Color(0xFF07111F),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white24),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.pets, size: 42, color: Colors.cyanAccent),
                  SizedBox(height: 12),
                  Text(
                    'Register Cattle Profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Use a stable image URL for cattle profile. Real phone or ESP32 images should be added from the Smart Scan page.',
                    style: TextStyle(color: Colors.white70, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            inputField(
              controller: idController,
              label: 'Cattle ID',
              icon: Icons.badge,
            ),
            inputField(
              controller: tagController,
              label: 'Cow Tag',
              icon: Icons.tag,
            ),
            inputField(
              controller: nameController,
              label: 'Name',
              icon: Icons.drive_file_rename_outline,
            ),
            inputField(
              controller: breedController,
              label: 'Breed',
              icon: Icons.category,
            ),
            inputField(
              controller: ageController,
              label: 'Age',
              icon: Icons.calendar_month,
              keyboardType: TextInputType.number,
              validator: numberValidator,
            ),
            inputField(
              controller: colorController,
              label: 'Color',
              icon: Icons.palette,
            ),
            inputField(
              controller: weightController,
              label: 'Weight KG',
              icon: Icons.monitor_weight,
              keyboardType: TextInputType.number,
              validator: numberValidator,
            ),
            inputField(
              controller: ownerController,
              label: 'Owner',
              icon: Icons.person,
            ),
            inputField(
              controller: farmController,
              label: 'Farm',
              icon: Icons.agriculture,
            ),
            inputField(
              controller: tempController,
              label: 'Temperature °C',
              icon: Icons.thermostat,
              keyboardType: TextInputType.number,
              validator: numberValidator,
            ),
            inputField(
              controller: healthStatusController,
              label: 'Health Status',
              icon: Icons.health_and_safety,
            ),
            inputField(
              controller: healthScoreController,
              label: 'Health Score',
              icon: Icons.percent,
              keyboardType: TextInputType.number,
              validator: numberValidator,
            ),
            inputField(
              controller: confidenceController,
              label: 'Biometric Confidence',
              icon: Icons.verified,
              keyboardType: TextInputType.number,
              validator: numberValidator,
            ),
            inputField(
              controller: scanTimeController,
              label: 'Last Scan Time',
              icon: Icons.access_time,
            ),
            inputField(
              controller: deviceIdController,
              label: 'Device ID',
              icon: Icons.memory,
            ),
            TextFormField(
              controller: imageController,
              validator: requiredValidator,
              maxLines: 2,
              onChanged: (_) {
                setState(() {});
              },
              decoration: const InputDecoration(
                labelText: 'Muzzle Image URL',
                prefixIcon: Icon(Icons.image),
                helperText:
                    'For real phone/ESP32 images, use the Smart Scan page.',
              ),
            ),
            const SizedBox(height: 14),
            imagePreview(),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 58),
                backgroundColor: Colors.cyanAccent,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: isLoading ? null : submitCattle,
              icon: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(
                isLoading ? 'Saving...' : 'Save Cattle',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}