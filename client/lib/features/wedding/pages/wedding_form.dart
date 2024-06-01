import 'package:client/dto/wedding_dto.dart';
import 'package:client/features/wedding/bloc/wedding_bloc.dart';
import 'package:client/model/wedding.dart';
import 'package:client/provider/user_provider.dart';
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

  @override
  void initState() {
    print("initState");
    print(widget.wedding!.budget);
    super.initState();
    if (widget.wedding != null) {
      _nameController.text = widget.wedding!.name;
      _descriptionController.text = widget.wedding!.description;
      _addressController.text = widget.wedding!.address;
      _phoneController.text = widget.wedding!.phone;
      _emailController.text = widget.wedding!.email;
      _budgetController.text = widget.wedding!.budget.toString();
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
                        Input(hintText: "Nom", controller: _nameController),
                        const SizedBox(height: 20),
                        Input(hintText: "Description", controller: _descriptionController),
                        const SizedBox(height: 20),
                        Input(hintText: "Adresse", controller: _addressController),
                        const SizedBox(height: 20),
                        Input(hintText: "Téléphone", controller: _phoneController),
                        const SizedBox(height: 20),
                        Input(hintText: "Email", controller: _emailController),
                        const SizedBox(height: 20),
                        Input(hintText: "Budget", controller: _budgetController),
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
                            context.read<WeddingBloc>().add(
                              WeddingCreated(
                                weddingDto: WeddingDto(
                                  name: _nameController.text,
                                  description: _descriptionController.text,
                                  address: _addressController.text,
                                  phone: _phoneController.text,
                                  email: _emailController.text,
                                  budget: int.parse(_budgetController.text),
                                ),
                                userId: context.read<UserProvider>().getUserId()
                              )
                            );
                          } else if (widget.title == "Modifier") {
                            context.read<WeddingBloc>().add(
                              WeddingUpdated(
                                wedding: Wedding(
                                  id: widget.wedding!.id,
                                  name: _nameController.text,
                                  description: _descriptionController.text,
                                  address: _addressController.text,
                                  phone: _phoneController.text,
                                  email: _emailController.text,
                                  budget: int.parse(_budgetController.text),
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

