import 'package:client/core/theme/app_colors.dart';
import 'package:client/features/estimate/bloc/estimate_bloc.dart';
import 'package:client/features/estimate/bloc/estimate_event.dart';
import 'package:client/model/estimate.dart';
import 'package:client/shared/widget/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EstimateBottomModalForm extends StatefulWidget {
  final Estimate estimate;
  final int userId;
  final String title;

  const EstimateBottomModalForm({super.key, required this.estimate, required this.userId, required this.title});

  @override
  State<EstimateBottomModalForm> createState() => _EstimateBottomModalFormState();
}

class _EstimateBottomModalFormState extends State<EstimateBottomModalForm> {
  final formKey = GlobalKey<FormState>();

  final priceController = TextEditingController();
  final contentController = TextEditingController();


  @override
  void initState() {
    super.initState();

    contentController.text = widget.estimate.content;
    priceController.text = widget.estimate.price.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20),
      child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${widget.title} un devis',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Veuillez remplir les champs ci-dessous pour ${widget.title} un devis.',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Input(
                            hintText: 'Prix',
                            controller: priceController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      maxLines: 6,
                      controller: contentController,
                      decoration: const InputDecoration(
                        hintText: 'Contenu',
                        labelText: 'Contenu',
                        labelStyle: TextStyle(
                          color: AppColors.pink500,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Le contenu est requis';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    context.read<EstimateBloc>().add(
                      EstimateUpdateEvent(
                        estimate: widget.estimate.copyWith(
                          price: int.parse(priceController.text),
                          content: contentController.text,
                          status: 'pending',
                        ),
                        userId: widget.userId,
                      ),
                    );
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(double.maxFinite, 60),
                  backgroundColor: AppColors.pink,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}