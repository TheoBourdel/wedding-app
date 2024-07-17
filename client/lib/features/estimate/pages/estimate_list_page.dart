import 'package:client/core/theme/app_colors.dart';
import 'package:client/features/estimate/widgets/estimate_card.dart';
import 'package:client/model/estimate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

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
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.estimateHeader,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.estimateHeaderSubtitle,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          bottom: TabBar(
            indicatorColor: AppColors.pink500,
            labelColor: AppColors.pink500,
            tabs: [
              Tab(
                text: AppLocalizations.of(context)!.request,
              ),
              Tab(
                text: AppLocalizations.of(context)!.pending,
              ),
              Tab(
                text: AppLocalizations.of(context)!.confirmed,
              ),
              Tab(
                text: AppLocalizations.of(context)!.canceled,
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