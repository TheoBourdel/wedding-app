import 'dart:convert';
import 'package:client/features/auth/bloc/auth_bloc.dart';
import 'package:client/features/auth/bloc/auth_state.dart';
import 'package:client/features/estimate/bloc/estimate_bloc.dart';
import 'package:client/features/estimate/bloc/estimate_event.dart';
import 'package:client/features/estimate/widgets/estimate_bottom_modal_form.dart';
import 'package:client/model/estimate.dart';
import 'package:client/shared/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../core/constant/constant.dart';
import '../../../repository/estimate_repository.dart';

class EstimateInfoPage extends StatefulWidget {
  final Estimate estimate;
  const EstimateInfoPage({super.key, required this.estimate});

  @override
  _EstimateInfoPageState createState() => _EstimateInfoPageState();
}

class _EstimateInfoPageState extends State<EstimateInfoPage> {
  bool isPaymentEnabled = false;

  @override
  void initState() {
    super.initState();
    _fetchPaymentStatus();
  }

  Future<void> _fetchPaymentStatus() async {
    final response = await http.get(Uri.parse('$apiUrl/api/payment-status'));
    if (response.statusCode == 200) {
      setState(() {
        isPaymentEnabled = jsonDecode(response.body)['is_payment_enabled'];
      });
    }
  }

  Future<void> _startBraintreePayment(BuildContext context, userId) async {
    print("Starting Braintree payment...");
    var request = BraintreeDropInRequest(
      tokenizationKey: 'sandbox_jybm8wfr_qsn76kgd9qtrkyv5',
      collectDeviceData: true,
      requestThreeDSecureVerification: true,
      googlePaymentRequest: BraintreeGooglePaymentRequest(
        totalPrice: widget.estimate.price.toString(),
        currencyCode: 'EUR',
        billingAddressRequired: false,
      ),
      paypalRequest: BraintreePayPalRequest(
        amount: widget.estimate.price.toString(),
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
  }

  Future<void> _sendNonceToServer(BuildContext context, String nonce, userId) async {
    try {
      print('Sending nonce to server: $nonce');
      await EstimateRepository.payEstimate(widget.estimate.id, nonce);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment Successful')));
      context.read<EstimateBloc>().add(
          EstimateUpdateEvent(
            estimate: widget.estimate.copyWith(
              status: 'accepted',
              price: widget.estimate.price,
              content: widget.estimate.content,
            ),
            userId: userId,
          )
      );

      Navigator.pop(context);
    } catch (error) {
      print('Payment failed: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment Failed: $error')));
    }
  }

  Widget? buttons() {
    final authState = context.read<AuthBloc>().state;
    final userRole = authState is Authenticated ? authState.userRole : null;
    final userId = authState is Authenticated ? authState.userId : null;

    if (userRole == 'provider') {
      if (widget.estimate.status == 'requesting') {
        return Column(
          children: [
            Button(
              text: "Accepter",
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => EstimateBottomModalForm(
                      estimate: widget.estimate,
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
                      estimate: widget.estimate.copyWith(
                        status: 'canceled',
                        price: widget.estimate.price,
                        content: widget.estimate.content,
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

      if (widget.estimate.status == 'pending') {
        return Button(
            text: "Modifier",
            isOutlined: true,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => EstimateBottomModalForm(
                    estimate: widget.estimate,
                    userId: userId!,
                    title: 'Modifier'
                ),
              );
            }
        );
      }
    } else if (userRole == 'marry') {
      if (widget.estimate.status == 'requesting') {
        return Button(
            text: "Annuler",
            isOutlined: true,
            onPressed: () {
              context.read<EstimateBloc>().add(
                  EstimateDeleteEvent(
                    estimateId: widget.estimate.id,
                    userId: userId!,
                  )
              );
              Navigator.pop(context);
            }
        );
      }

      if (widget.estimate.status == 'pending') {
        return Column(
          children: [
            Button(
              text: "Confirmer et payer",
              onPressed: isPaymentEnabled ? () => _startBraintreePayment(context, userId) : null,
              color: isPaymentEnabled ? null : Colors.grey,
            ),
            if (!isPaymentEnabled)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Paiement n\'est pas possible, revenez plus tard',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 10),
            Button(
              text: "Refuser",
              isOutlined: true,
              onPressed: () {
                context.read<EstimateBloc>().add(
                    EstimateUpdateEvent(
                      estimate: widget.estimate.copyWith(
                        status: 'canceled',
                        price: widget.estimate.price,
                        content: widget.estimate.content,
                      ),
                      userId: userId!,
                    )
                );
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 20),
          ],
        );
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Information du devis"),
        actions: [
          if (widget.estimate.status != 'requesting')
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
                      widget.estimate.service!.name!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.estimate.createdAt.toString().substring(0, 10),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.estimate.content,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    if (widget.estimate.status != 'requesting')
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
                            "${widget.estimate.price} €",
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
