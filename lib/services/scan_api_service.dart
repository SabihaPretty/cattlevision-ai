import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/scan_model.dart';
import 'api_config.dart';

class ScanApiService {
  static Future<List<ScanModel>> getRecentScans() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/scans');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      final List data = decoded['data'];

      return data.map((e) => ScanModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load scans');
    }
  }
}