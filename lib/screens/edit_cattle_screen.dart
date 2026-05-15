import 'package:flutter/material.dart';
import '../models/cattle_model.dart';
import '../services/cattle_api_service.dart';

class EditCattleScreen extends StatefulWidget {
  final CattleModel cattle;

  const EditCattleScreen({
    super.key,
    required this.cattle,
  });

  @override
  State<EditCattleScreen> createState() => _EditCattleScreenState();
}

class _EditCattleScreenState extends State<EditCattleScreen> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  late TextEditingController nameController;
  late TextEditingController breedController;
  late TextEditingController ageController;
  late TextEditingController colorController;
  late TextEditingController weightController;
  late TextEditingController tempController;
  late TextEditingController healthStatusController;
  late TextEditingController healthScoreController;
  late TextEditingController confidenceController;
  late TextEditingController scanTimeController;
  late TextEditingController imageController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.cattle.name);
    breedController = TextEditingController(text: widget.cattle.breed);
    ageController = TextEditingController(text: widget.cattle.age.toString());
    colorController = TextEditingController(text: widget.cattle.color);
    weightController =
        TextEditingController(text: widget.cattle.weight.toString());
    tempController =
        TextEditingController(text: widget.cattle.lastTemperature.toString());
    healthStatusController =
        TextEditingController(text: widget.cattle.healthStatus);
    healthScoreController =
        TextEditingController(text: widget.cattle.healthScore.toString());
    confidenceController = TextEditingController(
      text: widget.cattle.biometricConfidence.toString(),
    );
    scanTimeController =
        TextEditingController(text: widget.cattle.lastScanTime);
    imageController = TextEditingController(text: widget.cattle.muzzleImage);
  }

  @override
  void dispose() {
    nameController.dispose();
    breedController.dispose();
    ageController.dispose();
    colorController.dispose();
    weightController.dispose();
    tempController.dispose();
    healthStatusController.dispose();
    healthScoreController.dispose();
    confidenceController.dispose();
    scanTimeController.dispose();
    imageController.dispose();
    super.dispose();
  }

  Future<void> updateCattle() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    final data = {
      'name': nameController.text.trim(),
      'breed': breedController.text.trim(),
      'age': int.parse(ageController.text.trim()),
      'color': colorController.text.trim(),
      'weight': double.parse(weightController.text.trim()),
      'lastTemperature': double.parse(tempController.text.trim()),
      'healthStatus': healthStatusController.text.trim(),
      'healthScore': int.parse(healthScoreController.text.trim()),
      'biometricConfidence': double.parse(confidenceController.text.trim()),
      'lastScanTime': scanTimeController.text.trim(),
      'muzzleImage': imageController.text.trim(),
    };

    try {
      await CattleApiService.updateCattle(widget.cattle.id, data);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cattle updated successfully'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
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

    if (double.tryParse(value.trim()) == null) {
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
        title: Text('Edit ${widget.cattle.id}'),
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
                  Icon(Icons.edit_note, size: 42, color: Colors.cyanAccent),
                  SizedBox(height: 12),
                  Text(
                    'Update Cattle Profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Profile image is kept as URL for stable APK and backend. Real device images are stored through Smart Scan.',
                    style: TextStyle(color: Colors.white70, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
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
              onPressed: isLoading ? null : updateCattle,
              icon: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(
                isLoading ? 'Updating...' : 'Update Cattle',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}