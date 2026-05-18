import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import '../core/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String selectedRole = 'farmer';

  void createAccount() async {
    try {
      await AuthService.register(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        role: selectedRole,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created. Please login.'))
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(16)
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Create Account', style: TextStyle(fontSize:24,color:Colors.white)),
              const SizedBox(height:16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText:'Name',
                  prefixIcon: Icon(Icons.person)
                ),
              ),
              const SizedBox(height:8),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText:'Email',
                  prefixIcon: Icon(Icons.email)
                ),
              ),
              const SizedBox(height:8),
              TextField(
                controller: passwordController,
                obscureText:true,
                decoration: const InputDecoration(
                  hintText:'Password',
                  prefixIcon: Icon(Icons.lock)
                ),
              ),
              const SizedBox(height:8),
              DropdownButton<String>(
                value: selectedRole,
                items: ['admin','farmer','field_officer','researcher']
                  .map((r)=>DropdownMenuItem(
                    value:r,
                    child: Text(r[0].toUpperCase() + r.substring(1))
                  ))
                  .toList(),
                onChanged:(v)=>setState(()=>selectedRole=v!)
              ),
              const SizedBox(height:16),
              ElevatedButton(
                onPressed:createAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  minimumSize: const Size(double.infinity,48)
                ),
                child: const Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}