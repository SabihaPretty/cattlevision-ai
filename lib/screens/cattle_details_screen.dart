import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../models/cattle_model.dart';
import '../services/cattle_api_service.dart';
import 'edit_cattle_screen.dart';

class CattleDetailsScreen extends StatelessWidget {
  final CattleModel cattle;

  const CattleDetailsScreen({
    super.key,
    required this.cattle,
  });

  Future<void> deleteCattle(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Cattle?'),
          content: Text('Are you sure you want to delete ${cattle.id}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      await CattleApiService.deleteCattle(cattle.id);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cattle deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> openEditScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditCattleScreen(cattle: cattle),
      ),
    );

    if (result == true && context.mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isHealthy = cattle.healthStatus == 'Healthy';

    return Scaffold(
      appBar: AppBar(
        title: Text(cattle.id),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => openEditScreen(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => deleteCattle(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.network(
              cattle.muzzleImage,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 220,
                  color: Colors.white12,
                  child: const Center(
                    child: Icon(Icons.image_not_supported, size: 45),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            cattle.name,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Text(
            cattle.id,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => openEditScreen(context),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => deleteCattle(context),
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircularPercentIndicator(
                radius: 55,
                lineWidth: 10,
                percent: (cattle.healthScore / 100).clamp(0.0, 1.0),
                center: Text('${cattle.healthScore}%'),
                progressColor:
                    isHealthy ? Colors.greenAccent : Colors.orangeAccent,
                backgroundColor: Colors.white12,
                header: const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text('Health Score'),
                ),
              ),
              CircularPercentIndicator(
                radius: 55,
                lineWidth: 10,
                percent: (cattle.biometricConfidence / 100).clamp(0.0, 1.0),
                center: Text('${cattle.biometricConfidence}%'),
                progressColor: Colors.cyanAccent,
                backgroundColor: Colors.white12,
                header: const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text('Biometric'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          _sectionTitle('Basic Information'),
          _infoTile('Breed', cattle.breed),
          _infoTile('Age', '${cattle.age} years'),
          _infoTile('Color', cattle.color),
          _infoTile('Weight', '${cattle.weight} kg'),
          const SizedBox(height: 22),
          _sectionTitle('Latest Health Reading'),
          _infoTile('Last Temperature', '${cattle.lastTemperature}°C'),
          _infoTile('Last Health Condition', cattle.healthStatus),
          _infoTile('Last Scan Time', cattle.lastScanTime),
          const SizedBox(height: 22),
          _sectionTitle('Last Muzzle Print'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.cyanAccent.withOpacity(0.08),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.4)),
            ),
            child: const Text(
              'Muzzle print image stored successfully. Real biometric ML model will be connected later.',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          const SizedBox(height: 28),
          _sectionTitle('Checkup History'),
          if (cattle.history.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF111C2E),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Text(
                'No scan history found yet. Scan records will be connected later.',
                style: TextStyle(color: Colors.white70),
              ),
            )
          else
            ...cattle.history.map(
              (scan) => Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF111C2E),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scan.date,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Temperature: ${scan.temperature}°C'),
                    Text('Health: ${scan.healthStatus}'),
                    Text('Device: ${scan.deviceId}'),
                    Text('Officer: ${scan.officer}'),
                    Text('Note: ${scan.note}'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111C2E),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}