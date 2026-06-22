import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth_user_model.dart';
import 'api_config.dart';

class AuthService {
  static const String userKey = 'current_user';

  static Future<AuthUserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await http
        .post(
          Uri.parse('${ApiConfig.baseUrl}/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email.trim(),
            'password': password.trim(),
          }),
        )
        .timeout(ApiConfig.timeout);

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final user = AuthUserModel.fromJson(
        Map<String, dynamic>.from(decoded['data']),
      );
      await saveUser(user);
      return user;
    }

    throw Exception(decoded['message'] ?? 'Login failed');
  }

  static Future<AuthUserModel> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await http
        .post(
          Uri.parse('${ApiConfig.baseUrl}/auth/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': name.trim(),
            'email': email.trim(),
            'password': password.trim(),
            'role': role,
          }),
        )
        .timeout(ApiConfig.timeout);

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AuthUserModel.fromJson(
        Map<String, dynamic>.from(decoded['data']),
      );
    }

    throw Exception(decoded['message'] ?? 'Registration failed');
  }

  static Future<List<AuthUserModel>> getUsers() async {
    final response = await http
        .get(Uri.parse('${ApiConfig.baseUrl}/auth/users'))
        .timeout(ApiConfig.timeout);

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final users = (decoded['data'] as List? ?? []);
      return users
          .map((item) => AuthUserModel.fromJson(
                Map<String, dynamic>.from(item as Map),
              ))
          .toList();
    }

    throw Exception(decoded['message'] ?? 'Failed to load users');
  }

  static Future<AuthUserModel> approveUser(String userId) async {
    final response = await http
        .patch(
          Uri.parse('${ApiConfig.baseUrl}/auth/approve-user/$userId'),
          headers: {'Content-Type': 'application/json'},
        )
        .timeout(ApiConfig.timeout);

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AuthUserModel.fromJson(
        Map<String, dynamic>.from(decoded['data']),
      );
    }

    throw Exception(decoded['message'] ?? 'Failed to approve user');
  }

  static Future<void> changePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    final response = await http
        .patch(
          Uri.parse('${ApiConfig.baseUrl}/auth/change-password'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email.trim(),
            'oldPassword': oldPassword.trim(),
            'newPassword': newPassword.trim(),
          }),
        )
        .timeout(ApiConfig.timeout);

    final decoded = jsonDecode(response.body);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(decoded['message'] ?? 'Password change failed');
    }
  }

  static Future<void> saveUser(AuthUserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, jsonEncode(user.toJson()));
  }

  static Future<AuthUserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(userKey);

    if (data == null) return null;

    return AuthUserModel.fromJson(
      Map<String, dynamic>.from(jsonDecode(data)),
    );
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userKey);
  }
}