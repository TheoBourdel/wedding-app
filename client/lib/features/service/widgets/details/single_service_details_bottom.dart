import 'package:client/core/theme/app_colors.dart';
import 'package:client/dto/create_estimate_dto.dart';
import 'package:client/features/auth/bloc/auth_bloc.dart';
import 'package:client/features/auth/bloc/auth_state.dart';
import 'package:client/features/estimate/bloc/estimate_bloc.dart';
import 'package:client/features/estimate/bloc/estimate_event.dart';
import 'package:client/model/user.dart';
import 'package:client/repository/user_repository.dart';
import 'package:client/shared/widget/button.dart';
import 'package:client/shared/widget/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BuildDetailsBottomBar extends StatefulWidget {
  int price;
  Color defaultColor;
  Color secondColor;
  Size size;
  int serviceID;

  BuildDetailsBottomBar({super.key, required this.price,  required this.defaultColor, required this.secondColor, required this.size, required this.serviceID});

  @override
  State<BuildDetailsBottomBar> createState() => _BuildDetailsBottomBar();
}

class _BuildDetailsBottomBar extends State<BuildDetailsBottomBar> {

  final UserRepository userRepository = UserRepository();

  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final contentController = TextEditingController();

  getUser() async {
    try {
      final authState = context.read<AuthBloc>().state;
      final userId = authState is Authenticated ? authState.userId : null;
      User user = await userRepository.getUser(userId!);

      setState(() {
        firstNameController.text = user.firstName!;
        lastNameController.text = user.lastName!;
      });
    } catch (e) {
      print(e);
    }
  }

  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: widget.size.height * 0.01,
        left: widget.size.width * 0.08,
        right: widget.size.width * 0.08,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'prix d\'estimation',
              ),
              Row(
                children: [
                  Text(
                    widget.price.toString(),
                  ),
                ],
              ),
            ],
          ),
          InkWell(
            onTap: () => {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 600,
                      width: widget.size.width,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              const Text(
                                'Demandez un devis',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Présisez votre demande pour obtenir un devis personnalisé',
                                style: TextStyle(
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
                                                hintText: 'Prénom',
                                                controller: firstNameController,
                                              )
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                              child: Input(
                                                hintText: 'Nom',
                                                controller: lastNameController,
                                              )
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
                                            return 'Le contenue est requis';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  )
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () => {
                                  if (formKey.currentState!.validate()) {
                                    context.read<EstimateBloc>().add(EstimateCreateEvent(
                                        userId: 48,
                                        createEstimateDto: CreateEstimateDto(
                                          firstName: firstNameController.text,
                                          lastName: lastNameController.text,
                                          content: contentController.text,
                                          serviceId: widget.serviceID,
                                        )
                                    )),
                                    Navigator.pop(context)
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
                                child: const Text(
                                  'Envoyer',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
              )
            },
            child: Container(
              width: widget.size.width * 0.35,
              height: widget.size.height * 0.07,
              decoration: BoxDecoration(
                color: AppColors.pink,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Align(
                  child: Text(
                    'Devis',
                  )
              ),
            ),
          )
        ],
      ),
    );
  }
}


