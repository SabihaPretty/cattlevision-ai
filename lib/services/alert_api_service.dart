import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/alert_model.dart';
import 'api_config.dart';

class AlertApiService {
  static Future<List<AlertModel>> getAlerts() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/alerts');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List data = decoded['data'];

      return data.map((item) => AlertModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load alerts: ${response.body}');
    }
  }
}