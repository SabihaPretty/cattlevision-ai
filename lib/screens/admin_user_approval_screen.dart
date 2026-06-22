import 'package:flutter/material.dart';

import '../models/auth_user_model.dart';
import '../services/auth_service.dart';

class AdminUserApprovalScreen extends StatefulWidget {
  const AdminUserApprovalScreen({super.key});

  @override
  State<AdminUserApprovalScreen> createState() =>
      _AdminUserApprovalScreenState();
}

class _AdminUserApprovalScreenState extends State<AdminUserApprovalScreen> {
  late Future<List<AuthUserModel>> _pendingUsersFuture;
  final Set<String> _approvingIds = {};

  @override
  void initState() {
    super.initState();
    _pendingUsersFuture = _loadPendingUsers();
  }

  Future<List<AuthUserModel>> _loadPendingUsers() async {
    final users = await AuthService.getUsers();

    return users
        .where((user) =>
            !user.approved && user.role.toLowerCase() != 'admin')
        .toList();
  }

  Future<void> _refresh() async {
    setState(() {
      _pendingUsersFuture = _loadPendingUsers();
    });

    await _pendingUsersFuture;
  }

  Future<void> _approveUser(AuthUserModel user) async {
    setState(() {
      _approvingIds.add(user.id);
    });

    try {
      await AuthService.approveUser(user.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${user.name} has been approved.'),
          backgroundColor: Colors.green,
        ),
      );

      await _refresh();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Approval failed: $error'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _approvingIds.remove(user.id);
        });
      }
    }
  }

  String _roleLabel(String role) {
    return role
        .split('_')
        .map((word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Approval'),
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: FutureBuilder<List<AuthUserModel>>(
        future: _pendingUsersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.cyanAccent),
            );
          }

          if (snapshot.hasError) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                children: [
                  const SizedBox(height: 180),
                  Center(
                    child: Text(
                      'Could not load pending users.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            );
          }

          final users = snapshot.data ?? [];

          if (users.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                children: const [
                  SizedBox(height: 180),
                  Icon(
                    Icons.verified_user_outlined,
                    size: 70,
                    color: Colors.cyanAccent,
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      'No pending user approvals',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: users.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final user = users[index];
                final approving = _approvingIds.contains(user.id);

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.cyanAccent,
                          child: Text(
                            user.name.isEmpty
                                ? '?'
                                : user.name[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(user.email),
                              const SizedBox(height: 5),
                              Text(
                                _roleLabel(user.role),
                                style: const TextStyle(
                                  color: Colors.cyanAccent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton.icon(
                          onPressed:
                              approving ? null : () => _approveUser(user),
                          icon: approving
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.black,
                                  ),
                                )
                              : const Icon(Icons.check_circle_outline),
                          label: Text(approving ? 'Saving' : 'Approve'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}