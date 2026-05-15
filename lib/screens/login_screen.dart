import 'package:flutter/material.dart';
import 'main_shell_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;

  final Map<String, String> demoUsers = const {
    'admin@cattlevision.ai': '123456',
    'farmer@cattlevision.ai': '123456',
    'field@cattlevision.ai': '123456',
    'researcher@cattlevision.ai': '123456',
  };

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void fillDemoLogin(String email) {
    setState(() {
      emailController.text = email;
      passwordController.text = '123456';
    });
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 700));

    final email = emailController.text.trim().toLowerCase();
    final password = passwordController.text.trim();

    final validPassword = demoUsers[email];

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (validPassword == null || validPassword != password) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login successful'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MainShellScreen(),
      ),
    );
  }

  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    if (!value.contains('@') || !value.contains('.')) {
      return 'Enter a valid email';
    }

    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }

    if (value.trim().length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF07111F),
              Color(0xFF0F2A4D),
              Color(0xFF075985),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 460),
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF111C2E).withOpacity(0.92),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.cyanAccent.withOpacity(0.12),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.cyanAccent),
                      ),
                      child: const Icon(
                        Icons.verified_user,
                        size: 60,
                        color: Colors.cyanAccent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'CattleVision AI',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Secure login for cattle monitoring dashboard',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: emailController,
                      validator: emailValidator,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: passwordController,
                      validator: passwordValidator,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Demo Accounts',
                        style: TextStyle(
                          color: Colors.cyanAccent.shade100,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ActionChip(
                          label: const Text('Admin'),
                          onPressed: () {
                            fillDemoLogin('admin@cattlevision.ai');
                          },
                        ),
                        ActionChip(
                          label: const Text('Farmer'),
                          onPressed: () {
                            fillDemoLogin('farmer@cattlevision.ai');
                          },
                        ),
                        ActionChip(
                          label: const Text('Field Officer'),
                          onPressed: () {
                            fillDemoLogin('field@cattlevision.ai');
                          },
                        ),
                        ActionChip(
                          label: const Text('Researcher'),
                          onPressed: () {
                            fillDemoLogin('researcher@cattlevision.ai');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Password for all demo accounts: 123456',
                      style: TextStyle(color: Colors.white54),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 58),
                        backgroundColor: Colors.cyanAccent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: isLoading ? null : login,
                      icon: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : const Icon(Icons.login),
                      label: Text(
                        isLoading ? 'Checking...' : 'Login',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}