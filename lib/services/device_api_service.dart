import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/device_model.dart';
import 'api_config.dart';

class DeviceApiService {
  static Future<List<DeviceModel>> getDevices() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/devices');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      final List data = decoded['data'];

      return data.map((item) => DeviceModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load devices');
    }
  }
}