import 'package:client/features/estimate/pages/estimate_info_page.dart';
import 'package:client/model/estimate.dart';
import 'package:client/shared/widget/badge.dart' as custom_badge;
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class EstimateCard extends StatelessWidget {
  final Estimate estimate;
  const EstimateCard({super.key, required this.estimate});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EstimateInfoPage(estimate: estimate)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red[50],
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Iconsax.document_text,
                    size: 30,
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          estimate.service!.name!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        custom_badge.Badge(
                          badgeColor: estimate.status == "requesting" ? Colors.grey : estimate.status == "pending" ? Colors.orange : estimate.status == "accepted" ? Colors.green : Colors.red,
                          badgeText: estimate.status,
                        ),
                      ],
                    ),
                    Text(
                      estimate.createdAt.toString().substring(0, 10),
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
