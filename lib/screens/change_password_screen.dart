import 'package:flutter/material.dart';

import '../models/auth_user_model.dart';
import '../services/auth_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  final AuthUserModel user;

  const ChangePasswordScreen({
    super.key,
    required this.user,
  });

  @override
  State<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final formKey = GlobalKey<FormState>();

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  bool isLoading = false;
  bool obscureOld = true;
  bool obscureNew = true;

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  Future<void> changePassword() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await AuthService.changePassword(
        email: widget.user.email,
        oldPassword: oldPasswordController.text,
        newPassword: newPasswordController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password changed successfully'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  String? passwordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }

    if (value.trim().length < 6) {
      return 'Minimum 6 characters required';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF111C2E),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.lock_reset,
                    size: 55,
                    color: Colors.cyanAccent,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.user.email,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            TextFormField(
              controller: oldPasswordController,
              validator: passwordValidator,
              obscureText: obscureOld,
              decoration: InputDecoration(
                labelText: 'Old Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureOld ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      obscureOld = !obscureOld;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: newPasswordController,
              validator: passwordValidator,
              obscureText: obscureNew,
              decoration: InputDecoration(
                labelText: 'New Password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureNew ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      obscureNew = !obscureNew;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 58),
                backgroundColor: Colors.cyanAccent,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: isLoading ? null : changePassword,
              icon: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : const Icon(Icons.save),
              label: Text(
                isLoading ? 'Updating...' : 'Change Password',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}