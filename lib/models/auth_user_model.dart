// lib/models/auth_user_model.dart
class AuthUserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool approved;

  AuthUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.approved = true,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) => AuthUserModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        role: json['role'] ?? '',
        approved: json['approved'] ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'approved': approved,
      };
}