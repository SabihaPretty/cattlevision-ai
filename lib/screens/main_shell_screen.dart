// lib/screens/main_shell_screen.dart
import 'package:flutter/material.dart';
import '../models/auth_user_model.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';
import 'cattle_list_screen.dart';
import 'scan_screen.dart';
import 'alerts_screen.dart';
import 'project_info_screen.dart';
import 'change_password_screen.dart';
import '../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainShellScreen extends StatefulWidget {
  final AuthUserModel user;
  const MainShellScreen({super.key, required this.user});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int selectedIndex = 0;

  // ✅ Pages with type-safe cast
  List<Widget> get pages {
    final List<Widget> basePages = [
      DashboardScreen(),
      CattleListScreen(),
      ScanScreen(),
      AlertsScreen(),
      ProjectInfoScreen(),
    ];

    if (widget.user.role == 'farmer') return basePages.sublist(0, 3).cast<Widget>();
    if (widget.user.role == 'field_officer') return basePages.sublist(0, 4).cast<Widget>();
    return basePages.cast<Widget>();
  }

  // ✅ Bottom navigation destinations with type-safe cast
  List<NavigationDestination> get destinations {
    final baseDestinations = const [
      NavigationDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),
        label: 'Home',
      ),
      NavigationDestination(
        icon: Icon(Icons.pets_outlined),
        selectedIcon: Icon(Icons.pets),
        label: 'Cattle',
      ),
      NavigationDestination(
        icon: Icon(Icons.document_scanner_outlined),
        selectedIcon: Icon(Icons.document_scanner),
        label: 'Scan',
      ),
      NavigationDestination(
        icon: Icon(Icons.notifications_outlined),
        selectedIcon: Icon(Icons.notifications),
        label: 'Alerts',
      ),
      NavigationDestination(
        icon: Icon(Icons.info_outline),
        selectedIcon: Icon(Icons.info),
        label: 'Info',
      ),
    ];

    if (widget.user.role == 'farmer') return baseDestinations.sublist(0, 3).cast<NavigationDestination>();
    if (widget.user.role == 'field_officer') return baseDestinations.sublist(0, 4).cast<NavigationDestination>();
    return baseDestinations.cast<NavigationDestination>();
  }

  /// ✅ Real logout function
  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AuthService.userKey);

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CattleVision AI - ${widget.user.role.toUpperCase()}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
            tooltip: 'Logout',
          ),
          IconButton(
            icon: const Icon(Icons.lock_reset),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangePasswordScreen(user: widget.user),
                ),
              );
            },
            tooltip: 'Change Password',
          ),
        ],
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        backgroundColor: const Color(0xFF111C2E),
        indicatorColor: Colors.cyanAccent.withOpacity(0.25),
        onDestinationSelected: (index) => setState(() => selectedIndex = index),
        destinations: destinations,
      ),
    );
  }
}