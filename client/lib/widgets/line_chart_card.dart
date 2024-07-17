import 'package:flutter/material.dart';
import 'package:client/services/revenue_service.dart';
import 'package:client/widgets/history_page.dart';
import 'package:client/widgets/main_scaffold.dart';

class RevenueTable extends StatefulWidget {
  const RevenueTable({super.key});

  @override
  _RevenueTableState createState() => _RevenueTableState();
}

class _RevenueTableState extends State<RevenueTable> {
  late Future<List<Map<String, dynamic>>> _revenueDataFuture;
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _revenueDataFuture = RevenueService().fetchMonthlyRevenueByYear(_selectedYear);
  }

  void _filterByYear(int year) {
    setState(() {
      _selectedYear = year;
      _revenueDataFuture = RevenueService().fetchMonthlyRevenueByYear(_selectedYear);
    });
  }

  void _navigateToHistory(BuildContext context, int year) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainScaffold(
          currentPage: 'Historique',
          content: HistoryPage(year: year),
          onPageSelected: (String value) {
            // Logique de changement de page, si nécessaire
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int currentYear = DateTime.now().year;
    List<int> years = List<int>.generate(2, (index) => currentYear - index).reversed.toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: years.map((year) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  onPressed: () => _filterByYear(year),
                  child: Text(year.toString()),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 400,
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _revenueDataFuture,
            builder: (context, snapshot) {
            //  print( snapshot.data!.isEmpty);
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Aucune donnée trouvée'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Aucune donnée trouvée'));
              } else {
                final revenueData = snapshot.data!;
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Année')),
                        DataColumn(label: Text('Mois')),
                        DataColumn(label: Text('Chiffre d\'affaires')),
                        DataColumn(label: Text('Plus de détails')),
                      ],
                      rows: revenueData.map((data) {
                        return DataRow(
                          cells: [
                            DataCell(Text(data['year']?.toString() ?? 'N/A')),
                            DataCell(Text(_monthName(data['month'] ?? 0))),
                            DataCell(Text('${data['revenue']} €')),
                            DataCell(
                              TextButton(
                                onPressed: () => _navigateToHistory(context, data['year']),
                                child: const Text('Voir détails'),
                              ),
                            ), // Cellule de la nouvelle colonne
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  String _monthName(int month) {
    switch (month) {
      case 1:
        return 'Janvier';
      case 2:
        return 'Février';
      case 3:
        return 'Mars';
      case 4:
        return 'Avril';
      case 5:
        return 'Mai';
      case 6:
        return 'Juin';
      case 7:
        return 'Juillet';
      case 8:
        return 'Août';
      case 9:
        return 'Septembre';
      case 10:
        return 'Octobre';
      case 11:
        return 'Novembre';
      case 12:
        return 'Décembre';
      default:
        return 'Inconnu';
    }
  }
}
