import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/cattle_model.dart';
import 'api_config.dart';

class CattleApiService {
  static Future<List<CattleModel>> getCattleList() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/cattle');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      final List data = decodedData['data'];

      return data.map((item) => CattleModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load cattle list: ${response.body}');
    }
  }

  static Future<CattleModel> getCattleDetails(String id) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/cattle/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      return CattleModel.fromJson(decodedData['data']);
    } else {
      throw Exception('Failed to load cattle details: ${response.body}');
    }
  }

  static Future<void> addCattle(Map<String, dynamic> data) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/cattle');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to add cattle: ${response.body}');
    }
  }

  static Future<void> updateCattle(
    String id,
    Map<String, dynamic> data,
  ) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/cattle/$id');

    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update cattle: ${response.body}');
    }
  }

  static Future<void> deleteCattle(String id) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/cattle/$id');

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete cattle: ${response.body}');
    }
  }
}