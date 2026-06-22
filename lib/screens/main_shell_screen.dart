import 'package:flutter/material.dart';

import '../models/auth_user_model.dart';
import '../services/auth_service.dart';
import 'admin_user_approval_screen.dart';
import 'alerts_screen.dart';
import 'cattle_list_screen.dart';
import 'change_password_screen.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';
import 'project_info_screen.dart';
import 'scan_screen.dart';

class MainShellScreen extends StatefulWidget {
  final AuthUserModel user;

  const MainShellScreen({super.key, required this.user});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  late AuthUserModel _user;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  bool get _isAdmin => _user.role.toLowerCase() == 'admin';

  List<Widget> get pages {
    final basePages = <Widget>[
      DashboardScreen(),
      CattleListScreen(),
      ScanScreen(),
      AlertsScreen(),
      ProjectInfoScreen(),
    ];

    if (_user.role == 'farmer') return basePages.sublist(0, 3);
    if (_user.role == 'field_officer') return basePages.sublist(0, 4);

    return basePages;
  }

  List<NavigationDestination> get destinations {
    const baseDestinations = <NavigationDestination>[
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

    if (_user.role == 'farmer') return baseDestinations.sublist(0, 3);
    if (_user.role == 'field_officer') return baseDestinations.sublist(0, 4);

    return baseDestinations;
  }

  Future<void> _logout() async {
    await AuthService.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _refreshApprovalStatus() async {
    try {
      final users = await AuthService.getUsers();
      AuthUserModel? refreshedUser;

      for (final user in users) {
        if (user.id == _user.id) {
          refreshedUser = user;
          break;
        }
      }

      if (refreshedUser == null) {
        throw Exception('Account was not found.');
      }

      await AuthService.saveUser(refreshedUser);

      if (!mounted) return;

      setState(() {
        _user = refreshedUser!;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _user.approved
                ? 'Your account has been approved. Welcome!'
                : 'Your account is still waiting for admin approval.',
          ),
          backgroundColor: _user.approved ? Colors.green : Colors.orange,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not refresh status: $error'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Widget _pendingApprovalPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Pending Approval'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.hourglass_top_rounded,
                color: Colors.cyanAccent,
                size: 80,
              ),
              const SizedBox(height: 20),
              const Text(
                'Waiting for Admin Approval',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your ${_user.role.replaceAll('_', ' ')} account has been created. An admin must approve it before you can use CattleVision AI.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _refreshApprovalStatus,
                icon: const Icon(Icons.refresh),
                label: const Text('Check Approval Status'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_user.approved) {
      return _pendingApprovalPage();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('CattleVision AI - ${_user.role.toUpperCase()}'),
        actions: [
          if (_isAdmin)
            IconButton(
              icon: const Icon(Icons.verified_user_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminUserApprovalScreen(),
                  ),
                );
              },
              tooltip: 'User Approval',
            ),
          IconButton(
            icon: const Icon(Icons.lock_reset),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangePasswordScreen(user: _user),
                ),
              );
            },
            tooltip: 'Change Password',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        backgroundColor: const Color(0xFF111C2E),
        indicatorColor: Colors.cyanAccent.withOpacity(0.25),
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: destinations,
      ),
    );
  }
}