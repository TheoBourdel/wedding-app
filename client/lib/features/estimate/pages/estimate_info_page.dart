import 'package:client/features/auth/bloc/auth_bloc.dart';
import 'package:client/features/auth/bloc/auth_state.dart';
import 'package:client/features/estimate/bloc/estimate_bloc.dart';
import 'package:client/features/estimate/bloc/estimate_event.dart';
import 'package:client/features/estimate/widgets/estimate_bottom_modal_form.dart';
import 'package:client/model/estimate.dart';
import 'package:client/shared/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class EstimateInfoPage extends StatelessWidget {
  final Estimate estimate;
  const EstimateInfoPage({super.key, required this.estimate});
  @override
  Widget build(BuildContext context) {
    Widget? buttons() {
      final authState = context.read<AuthBloc>().state;
      final userRole = authState is Authenticated ? authState.userRole : null;
      final userId = authState is Authenticated ? authState.userId : null;

      if (userRole == 'provider') {
        if (estimate.status == 'requesting') {
          return Column(
            children: [
              Button(
                text: "Accepter",
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => EstimateBottomModalForm(
                      estimate: estimate,
                      userId: userId!,
                      title: 'Creer'
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              Button(
                text: "Refuser",
                isOutlined: true,
                onPressed: () {
                  context.read<EstimateBloc>().add(
                    EstimateUpdateEvent(
                      estimate: estimate.copyWith(
                        status: 'canceled',
                        price: estimate.price,
                        content: estimate.content,
                      ),
                      userId: userId!,
                    )
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }

        if (estimate.status == 'pending') {
          return Button(
            text: "Modifier",
            isOutlined: true,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => EstimateBottomModalForm(
                  estimate: estimate,
                  userId: userId!,
                  title: 'Modifier'
                ),
              );
            }
          );
        }
      } else if (userRole == 'marry') {
        if (estimate.status == 'requesting') {
          return Button(
            text: "Annuler",
            isOutlined: true,
            onPressed: () {
              context.read<EstimateBloc>().add(
                EstimateDeleteEvent(
                  estimateId: estimate.id,
                  userId: userId!,
                )
              );
              Navigator.pop(context);
            }
          );
        }

        if (estimate.status == 'pending') {
          return Column(
            children: [
              Button(
                text: "Accepter",
                onPressed: () {
                  context.read<EstimateBloc>().add(
                    EstimateUpdateEvent(
                      estimate: estimate.copyWith(
                        status: 'accepted',
                        price: estimate.price,
                        content: estimate.content,
                      ),
                      userId: userId!,
                    )
                  );
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 10),
              Button(
                text: "Refuser",
                isOutlined: true,
                onPressed: () {
                  context.read<EstimateBloc>().add(
                    EstimateUpdateEvent(
                      estimate: estimate.copyWith(
                        status: 'canceled',
                        price: estimate.price,
                        content: estimate.content,
                      ),
                      userId: userId!,
                    )
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
      }
      return null;
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Information du devis"),
        actions: [
          if (estimate.status != 'requesting')
            IconButton(
            icon: const Icon(Iconsax.document_download),
            onPressed: () {}
          )
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.only(left: 20, top: 8, right: 20, bottom: 0),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Service",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      estimate.createdAt.toString().substring(0, 10),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      estimate.content,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    if (estimate.status != 'requesting')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Prix",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${estimate.price} €",
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 10),
                    buttons() ?? const SizedBox(),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}