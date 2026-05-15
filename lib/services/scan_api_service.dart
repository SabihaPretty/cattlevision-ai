import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../models/scan_model.dart';
import 'api_config.dart';

class ScanApiService {
  static Future<List<ScanModel>> getRecentScans() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/scans');

    final response = await http.get(url).timeout(ApiConfig.timeout);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List data = decoded['data'] ?? [];

      return data.map((e) => ScanModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load scans: ${response.body}');
    }
  }

  static Future<List<ScanModel>> getCattleScanHistory(String cattleId) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/scans/cattle/$cattleId');

    final response = await http.get(url).timeout(ApiConfig.timeout);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List data = decoded['data'] ?? [];

      return data.map((e) => ScanModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load cattle scan history: ${response.body}');
    }
  }

  static Future<void> sendIotReading({
    required String cattleId,
    required String deviceId,
    required double temperature,
    XFile? imageFile,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/iot/reading');

    final request = http.MultipartRequest('POST', url);

    request.fields['cattleId'] = cattleId;
    request.fields['deviceId'] = deviceId;
    request.fields['temperature'] = temperature.toString();

    if (imageFile != null) {
      final bytes = await imageFile.readAsBytes();

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: imageFile.name,
        ),
      );
    }

    final streamedResponse = await request.send().timeout(ApiConfig.timeout);
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to send IoT reading: ${response.body}');
    }
  }
}