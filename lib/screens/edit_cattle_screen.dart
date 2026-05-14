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

    setState(() => isLoading = true);

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
        setState(() => isLoading = false);
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator ?? requiredValidator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Cattle'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
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
            inputField(
              controller: imageController,
              label: 'Muzzle Image URL',
              icon: Icons.image,
            ),
            const SizedBox(height: 12),
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