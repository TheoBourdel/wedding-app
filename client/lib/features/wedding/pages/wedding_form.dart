import 'package:client/dto/wedding_dto.dart';
import 'package:client/features/auth/bloc/auth_bloc.dart';
import 'package:client/features/auth/bloc/auth_state.dart';
import 'package:client/features/wedding/bloc/wedding_bloc.dart';
import 'package:client/model/wedding.dart';
import 'package:client/shared/widget/button.dart';
import 'package:client/shared/widget/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeddingFormPage extends StatefulWidget {
  final String title;
  final Wedding? wedding;
  const WeddingFormPage({super.key, required this.title, this.wedding});

  @override
  State<WeddingFormPage> createState() => _WeddingFormPageState();
}

class _WeddingFormPageState extends State<WeddingFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _budgetController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.wedding != null) {
      _addressController.text = widget.wedding!.address;
      _phoneController.text = widget.wedding!.phone;
      _emailController.text = widget.wedding!.email;
      _budgetController.text = widget.wedding!.budget.toString();
      _dateController.text = widget.wedding!.date.toString();
    }

  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeddingBloc, WeddingState>(
        builder: (context, state) {
          return Scaffold(
        appBar: AppBar(
          title: Text("${widget.title} un mariage"),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
              child: Form(
                key: _formKey,
                child: Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Input(hintText: "Date", controller: _dateController, icon: Icons.date_range, isDate: true),
                        const SizedBox(height: 20),
                        Input(hintText: "Adresse", controller: _addressController, keyboardType: TextInputType.streetAddress),
                        const SizedBox(height: 20),
                        Input(hintText: "Budget", controller: _budgetController, keyboardType: TextInputType.number),
                        const SizedBox(height: 20),
                        Input(hintText: "Email", controller: _emailController, keyboardType: TextInputType.emailAddress),
                        const SizedBox(height: 20),
                        Input(hintText: "Téléphone", controller: _phoneController, keyboardType: TextInputType.phone),
                      ],
                    )
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Button(
                        text: widget.title,
                        onPressed: () {
                          if (widget.title == "Créer") {
                            final authState = context.read<AuthBloc>().state;
                            final userId = authState is Authenticated ? authState.userId : null;
                            context.read<WeddingBloc>().add(
                              WeddingCreated(
                                weddingDto: WeddingDto(
                                  address: _addressController.text,
                                  phone: _phoneController.text,
                                  email: _emailController.text,
                                  budget: int.parse(_budgetController.text),
                                  date: _dateController.text,
                                ),
                                userId: userId!
                              )
                            );
                          } else if (widget.title == "Modifier" || widget.title == "Edit") {
                            context.read<WeddingBloc>().add(
                              WeddingUpdated(
                                wedding: Wedding(
                                  id: widget.wedding!.id,
                                  address: _addressController.text,
                                  phone: _phoneController.text,
                                  email: _emailController.text,
                                  budget: int.parse(_budgetController.text),
                                  date: _dateController.text,
                                )
                              )
                            );
                          }
                          Navigator.pop(context);
                        },
                      )
                    )
                  ),
                ],
              ),
              )
          )
        );
        },
      );
  }
}

