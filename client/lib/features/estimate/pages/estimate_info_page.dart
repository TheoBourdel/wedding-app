// ignore_for_file: use_build_context_synchronously
import 'package:client/features/auth/bloc/auth_bloc.dart';
import 'package:client/features/auth/bloc/auth_state.dart';
import 'package:client/features/estimate/bloc/estimate_bloc.dart';
import 'package:client/features/estimate/bloc/estimate_event.dart';
import 'package:client/features/estimate/widgets/estimate_bottom_modal_form.dart';
import 'package:client/model/budget_model.dart';
import 'package:client/model/category.dart';
import 'package:client/model/estimate.dart';
import 'package:client/model/wedding.dart';
import 'package:client/provider/token_utils.dart';
import 'package:client/repository/wedding_repository.dart';
import 'package:client/services/budget_service.dart';
import 'package:client/services/category_service.dart';
import 'package:client/shared/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../repository/estimate_repository.dart';

class EstimateInfoPage extends StatelessWidget {
  final Estimate estimate;
  const EstimateInfoPage({super.key, required this.estimate});

  Future<void> _startBraintreePayment(BuildContext context, userId) async {
    final suffisantAmount = await isAmountSufficient();
   if(suffisantAmount) {
     print("Starting Braintree payment...");
      var request = BraintreeDropInRequest(
        // a mettre dans le .env
        tokenizationKey: 'sandbox_jybm8wfr_qsn76kgd9qtrkyv5',
        collectDeviceData: true,
        requestThreeDSecureVerification: true,
        googlePaymentRequest: BraintreeGooglePaymentRequest(
          totalPrice: estimate.price.toString(),
          currencyCode: 'EUR',
          billingAddressRequired: false,
        ),
        paypalRequest: BraintreePayPalRequest(
          amount: estimate.price.toString(),
          displayName: 'Example company',
        ),
        cardEnabled: true,
      );

      BraintreeDropInResult? result = await BraintreeDropIn.start(request);
      if (result != null) {
        print('Nonce received: ${result.paymentMethodNonce.nonce}');
        await _sendNonceToServer(context, result.paymentMethodNonce.nonce, userId);
      } else {
        print('Payment was cancelled or failed.');
      }
    } else {
      print('Insufficient overall budget for this payment.');
    }
  }

  Future<bool> isAmountSufficient() async {
    final BudgetService budgetService = BudgetService();
    int userId = await TokenUtils.getUserId();
    final priceToPay = estimate.price;
    final List<Wedding> weddings = await WeddingRepository.getUserWedding(userId);

    if (weddings.isNotEmpty) {
      final Wedding wedding = weddings.first;
      final budgets = await budgetService.getBudgets(wedding.id);
      double totalAllocatedBudget = budgets.fold(0, (sum, budget) => sum + budget.amount);

      if (wedding.budget < totalAllocatedBudget + priceToPay) {
        print('Insufficient overall budget for this payment.');
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  Future<void> _fetchCurrentBalance() async {
    final BudgetService budgetService = BudgetService();
    int userId = await TokenUtils.getUserId();
    final categorieId = estimate.service?.CategoryID;
    final priceToPay = estimate.price;
    final List<Wedding> weddings = await WeddingRepository.getUserWedding(userId);

    if (categorieId == null) {
      print('No category ID found for the estimate.');
      return;
    }

    if (weddings.isNotEmpty) {
      final Wedding wedding = weddings.first;
      final budgets = await budgetService.getBudgets(wedding.id);

      double totalAllocatedBudget = budgets.fold(0, (sum, budget) => sum + budget.amount);

      if (wedding.budget < totalAllocatedBudget + priceToPay) {
        print('Insufficient overall budget for this payment.');
        return;
      }

      WeddingBudget? budgetToUpdate;
      try {
        budgetToUpdate = budgets.firstWhere(
              (budget) => budget.categoryId == categorieId,
        );
      } catch (e) {
        budgetToUpdate = null;
      }

      if (budgetToUpdate != null) {
       // if (budgetToUpdate.amount >= priceToPay && budgetToUpdate.paid == false ) {
        if ( budgetToUpdate.paid == false ) {
          final updatedBudget = WeddingBudget(
            id: budgetToUpdate.id,
            weddingId: budgetToUpdate.weddingId,
            categoryId: budgetToUpdate.categoryId,
            amount: budgetToUpdate.amount ,
            amountPaid: priceToPay.toDouble(),
            paid: true,
          );
          await budgetService.updateBudget(updatedBudget);
          print('Payment successful. Updated budget amount: ${updatedBudget.amount}');
        }
      } else {
        print('No budget found for category ID: ${estimate.service?.name}. Created new budget.');
        final createBudget = WeddingBudget(
          id: 0,
          weddingId: wedding.id,
          categoryId: categorieId,
          amount: priceToPay.toDouble(),
          amountPaid: priceToPay.toDouble(),
          paid: true,
        );
        await budgetService.createBudget(createBudget);
      }
    } else {
      print("No weddings found for user");

    }
  }

  Future<void> _sendNonceToServer(BuildContext context, String nonce, userId) async {
    try {
      await EstimateRepository.payEstimate(estimate.id, nonce);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment Successful')));
      context.read<EstimateBloc>().add(
          EstimateUpdateEvent(
            estimate: estimate.copyWith(
              status: 'accepted',
              price: estimate.price,
              content: estimate.content,
            ),
            userId: userId,
          )
      );
      _fetchCurrentBalance();
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment Failed: $error')));
    }
  }

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
                    isScrollControlled: true,
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
                text: "Confirmer et payer",
                onPressed: () => _startBraintreePayment(context, userId),
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
              const SizedBox(height: 20),
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
                    Text(
                      estimate.service!.name!,
                      style: const TextStyle(
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
