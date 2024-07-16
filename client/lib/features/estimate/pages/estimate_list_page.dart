import 'package:client/core/theme/app_colors.dart';
import 'package:client/features/estimate/widgets/estimate_card.dart';
import 'package:client/model/estimate.dart';
import 'package:flutter/material.dart';

class EstimateListPage extends StatelessWidget {
  final List<Estimate> estimates;
  const EstimateListPage({super.key, required this.estimates});

  @override
  Widget build(BuildContext context) {
    final List<Estimate> requestingEstimates = estimates.where((estimate) => estimate.status == "requesting").toList();
    final List<Estimate> pendingEstimates = estimates.where((estimate) => estimate.status == "pending").toList();
    final List<Estimate> confirmedEstimates = estimates.where((estimate) => estimate.status == "accepted").toList();
    final List<Estimate> canceledEstimates = estimates.where((estimate) => estimate.status == "canceled").toList();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Gérer vos devis",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Liste de vos devis",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          bottom: const TabBar(
            indicatorColor: AppColors.pink500,
            labelColor: AppColors.pink500,
            tabs: [
              Tab(
                text: "Demandes",
              ),
              Tab(
                text: "En attente",
              ),
              Tab(
                text: "Confirmés",
              ),
              Tab(
                text: "Annulés",
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, top: 8, right: 20, bottom: 0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  children: [
                    ListView.builder(
                      itemCount: requestingEstimates.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            EstimateCard(estimate: requestingEstimates[index]),
                            const SizedBox(height: 20),
                          ],
                        );
                      },
                    ),
                    ListView.builder(
                      itemCount: pendingEstimates.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            EstimateCard(estimate: pendingEstimates[index]),
                            const SizedBox(height: 20),
                          ],
                        );
                      },
                    ),
                    ListView.builder(
                      itemCount: confirmedEstimates.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            EstimateCard(estimate: confirmedEstimates[index]),
                            const SizedBox(height: 20),
                          ],
                        );
                      },
                    ),
                    ListView.builder(
                      itemCount: canceledEstimates.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            EstimateCard(estimate: canceledEstimates[index]),
                            const SizedBox(height: 20),
                          ],
                        );
                      },
                    ),               
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}