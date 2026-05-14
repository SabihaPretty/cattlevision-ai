import 'package:flutter/material.dart';
import '../models/cattle_model.dart';
import '../services/cattle_api_service.dart';
import '../widgets/cattle_card.dart';
import 'add_cattle_screen.dart';
import 'cattle_details_screen.dart';

class CattleListScreen extends StatefulWidget {
  const CattleListScreen({super.key});

  @override
  State<CattleListScreen> createState() => _CattleListScreenState();
}

class _CattleListScreenState extends State<CattleListScreen> {
  late Future<List<CattleModel>> cattleFuture;

  @override
  void initState() {
    super.initState();
    cattleFuture = CattleApiService.getCattleList();
  }

  Future<void> refreshData() async {
    setState(() {
      cattleFuture = CattleApiService.getCattleList();
    });
  }

  Future<void> openAddCattleScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddCattleScreen(),
      ),
    );

    if (result == true) {
      refreshData();
    }
  }

  Future<void> openDetailsScreen(CattleModel cattle) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CattleDetailsScreen(cattle: cattle),
      ),
    );

    if (result == true) {
      refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cattle Records'),
        actions: [
          IconButton(
            onPressed: refreshData,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: openAddCattleScreen,
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openAddCattleScreen,
        backgroundColor: Colors.cyanAccent,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text('Add Cattle'),
      ),
      body: FutureBuilder<List<CattleModel>>(
        future: cattleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.cyanAccent),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Text(
                  'Backend connection failed.\n\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            );
          }

          final cattleList = snapshot.data ?? [];

          if (cattleList.isEmpty) {
            return const Center(
              child: Text('No cattle found in database'),
            );
          }

          return RefreshIndicator(
            onRefresh: refreshData,
            child: ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: cattleList.length,
              itemBuilder: (context, index) {
                final cattle = cattleList[index];

                return CattleCard(
                  cattle: cattle,
                  onTap: () => openDetailsScreen(cattle),
                );
              },
            ),
          );
        },
      ),
    );
  }
}