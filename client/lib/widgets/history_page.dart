import 'package:flutter/material.dart';
import 'package:client/services/history_service.dart';

class HistoryPage extends StatelessWidget {
  final int year;

  const HistoryPage({super.key, required this.year});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historique des Mariages - $year'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: HistoryService().fetchWeddingsByYear(year),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune donnée trouvée pour l\'année $year'));
          } else {
            final weddings = snapshot.data!;
            return ListView.builder(
              itemCount: weddings.length,
              itemBuilder: (context, index) {
                final wedding = weddings[index];
                return ListTile(
                  title: Text(wedding['name']),
                  subtitle: Text('Budget: ${wedding['budget']} €'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
