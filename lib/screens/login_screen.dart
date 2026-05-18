import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'main_shell_screen.dart';
import 'register_screen.dart';
import '../models/auth_user_model.dart';
import '../core/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void setDemo(String role){
    switch(role){
      case 'admin': emailController.text='admin@cattlevision.ai'; passwordController.text='123456'; break;
      case 'farmer': emailController.text='farmer@cattlevision.ai'; passwordController.text='123456'; break;
      case 'field_officer': emailController.text='fo@cattlevision.ai'; passwordController.text='123456'; break;
      case 'researcher': emailController.text='researcher@cattlevision.ai'; passwordController.text='123456'; break;
    }
  }

  void login() async {
    try{
      final user = await AuthService.login(
        email: emailController.text,
        password: passwordController.text
      );
      if(!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>MainShellScreen(user: user)));
    } catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()))
      );
    }
  }

  @override
  Widget build(BuildContext context){
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
            children:[
              const Icon(Icons.verified_user, size:64, color:Colors.cyanAccent),
              const SizedBox(height:16),
              const Text('CattleVision AI', style:TextStyle(fontSize:24,color:Colors.white)),
              const SizedBox(height:16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.email), hintText:'Email'),
              ),
              const SizedBox(height:8),
              TextField(
                controller: passwordController,
                obscureText:true,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.lock), hintText:'Password'),
              ),
              const SizedBox(height:8),
              Wrap(
                spacing:8,
                children:[
                  ElevatedButton(onPressed:()=>setDemo('admin'), child: const Text('Admin')),
                  ElevatedButton(onPressed:()=>setDemo('farmer'), child: const Text('Farmer')),
                  ElevatedButton(onPressed:()=>setDemo('field_officer'), child: const Text('Field Officer')),
                  ElevatedButton(onPressed:()=>setDemo('researcher'), child: const Text('Researcher')),
                ],
              ),
              const SizedBox(height:8),
              ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  minimumSize: const Size(double.infinity,48)
                ),
                child: const Text('Login'),
              ),
              const SizedBox(height:8),
              ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=> const RegisterScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
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