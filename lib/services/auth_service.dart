import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_user_model.dart';
import 'api_config.dart';

class AuthService {
  static const String userKey = 'current_user';

  // Login user
  static Future<AuthUserModel> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email.trim(), 'password': password.trim()}),
    ).timeout(ApiConfig.timeout);

    final decoded = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final user = AuthUserModel.fromJson(decoded['data']);
      await saveUser(user);
      return user;
    }
    throw Exception(decoded['message'] ?? 'Login failed');
  }

  // Register / Create Account
  static Future<AuthUserModel> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name.trim(),
        'email': email.trim(),
        'password': password.trim(),
        'role': role,
      }),
    ).timeout(ApiConfig.timeout);

    final decoded = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final user = AuthUserModel.fromJson(decoded['data']);
      await saveUser(user);
      return user;
    }
    throw Exception(decoded['message'] ?? 'Registration failed');
  }

  // Change Password
  static Future<void> changePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/auth/change-password');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email.trim(),
        'oldPassword': oldPassword.trim(),
        'newPassword': newPassword.trim()
      }),
    ).timeout(ApiConfig.timeout);

    final decoded = jsonDecode(response.body);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(decoded['message'] ?? 'Password change failed');
    }
  }

  // Save user locally
  static Future<void> saveUser(AuthUserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, jsonEncode(user.toJson()));
  }

  // Get current logged in user
  static Future<AuthUserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(userKey);
    if (data == null) return null;
    return AuthUserModel.fromJson(jsonDecode(data));
  }

  // Logout user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userKey);
  }
}