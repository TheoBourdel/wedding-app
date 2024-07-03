import 'package:flutter/material.dart';
import 'package:client/services/statglobal_service.dart';
import 'package:client/model/statglobal_model.dart';
import 'package:client/util/responsive.dart';
import 'package:client/widgets/custom_card_widget.dart';

class ActivityDetailsCard extends StatefulWidget {
  const ActivityDetailsCard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ActivityDetailsCardState createState() => _ActivityDetailsCardState();
}

class _ActivityDetailsCardState extends State<ActivityDetailsCard> {
  late Future<List<StatglobalModel>> _statglobalDataFuture;

  @override
  void initState() {
    super.initState();
    _statglobalDataFuture = _fetchStatglobalData();
  }

  Future<List<StatglobalModel>> _fetchStatglobalData() async {
    final statglobalService = StatglobalService();
    final totalProviders = await statglobalService.fetchTotalProviders();
    final totalWeddings = await statglobalService.fetchTotalWeddings();
    final totalGuests = await statglobalService.fetchTotalGuests();
    final averageBudget = await statglobalService.fetchAverageBudget();

    return [
      StatglobalModel(
        icon: 'assets/images/prestataire.png',
        value: totalProviders.toString(),
        title: 'Prestataire',
      ),
      StatglobalModel(
        icon: 'assets/images/couple2.png',
        value: totalWeddings.toString(),
        title: 'Mariage',
      ),
      StatglobalModel(
        icon: 'assets/images/inviter.png',
        value: totalGuests.toString(),
        title: 'Invité',
      ),
      StatglobalModel(
        icon: 'assets/images/budget.png',
        value: '${averageBudget.toStringAsFixed(2)}€',
        title: 'Moyenne budgétaire',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<StatglobalModel>>(
      future: _statglobalDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Aucune donnée trouvée'));
        } else {
          final statglobalData = snapshot.data!;
          return GridView.builder(
            itemCount: statglobalData.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
              crossAxisSpacing: Responsive.isMobile(context) ? 12 : 15,
              mainAxisSpacing: 12.0,
            ),
            itemBuilder: (context, index) => CustomCard(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    statglobalData[index].icon,
                    width: 30,
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 4),
                    child: Text(
                      statglobalData[index].value,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.pink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    statglobalData[index].title,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
