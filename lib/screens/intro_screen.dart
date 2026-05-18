import 'package:flutter/material.dart';
import 'login_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  void goToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: size.width < 420 ? 34 : 44,
          vertical: 34,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF07111F),
              Color(0xFF123B7A),
              Color(0xFF075985),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),

              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(34),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 22,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.pets,
                  color: Colors.cyanAccent,
                  size: 68,
                ),
              ),

              const SizedBox(height: 46),

              const Text(
                'CattleVision AI',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -1.2,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'AI Biometric Cattle Monitoring System',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 40),

              const _FeatureRow(text: 'Muzzle biometric identification'),
              const SizedBox(height: 18),
              const _FeatureRow(text: 'Body temperature tracking'),
              const SizedBox(height: 18),
              const _FeatureRow(text: 'Smart health alerts'),
              const SizedBox(height: 18),
              const _FeatureRow(text: 'ESP32-CAM device sync'),
              const SizedBox(height: 18),
              const _FeatureRow(text: 'Professional farm dashboard'),

              const Spacer(flex: 3),

              SizedBox(
                width: double.infinity,
                height: 62,
                child: ElevatedButton(
                  onPressed: () => goToLogin(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String text;

  const _FeatureRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF63F3A7),
          ),
          child: const Icon(
            Icons.check,
            color: Color(0xFF075985),
            size: 22,
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}