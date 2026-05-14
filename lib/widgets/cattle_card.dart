import 'package:flutter/material.dart';
import '../models/cattle_model.dart';

class CattleCard extends StatelessWidget {
  final CattleModel cattle;
  final VoidCallback onTap;

  const CattleCard({
    super.key,
    required this.cattle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isHealthy = cattle.healthStatus == 'Healthy';

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF111C2E),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isHealthy ? Colors.greenAccent : Colors.orangeAccent,
            width: 0.8,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                cattle.muzzleImage,
                width: 88,
                height: 88,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 88,
                    height: 88,
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
                    cattle.id,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('${cattle.breed} • ${cattle.age} years'),
                  Text('Weight: ${cattle.weight} kg'),
                  Text('Last Temp: ${cattle.lastTemperature}°C'),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(cattle.healthStatus),
                    backgroundColor:
                        isHealthy ? Colors.greenAccent : Colors.orangeAccent,
                    labelStyle: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }
}