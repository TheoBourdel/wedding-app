import 'package:client/core/theme/app_colors.dart';
import 'package:client/model/wedding.dart';
import 'package:client/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:client/dto/wedding_dto.dart';
import 'package:client/repository/wedding_repository.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';



class WeddingForm extends StatefulWidget {
  final Wedding? currentWedding;

  const WeddingForm({Key? key, this.currentWedding});

  @override
  State<WeddingForm> createState() => _WeddingFormState();
}

class _WeddingFormState extends State<WeddingForm> {
  final _formKey = GlobalKey<FormState>();
  final weddingRepository = WeddingRepository();
  final AuthRepository authRepository = AuthRepository();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _budgetController;

  @override
  void initState() {
    super.initState();
    // Initialize your TextEditingController's with the values from widget.wedding if it's not null
    _nameController = TextEditingController(text: widget.currentWedding?.name ?? '');
    _descriptionController = TextEditingController(text: widget.currentWedding?.description ?? '');
    _addressController = TextEditingController(text: widget.currentWedding?.address ?? '');
    _phoneController = TextEditingController(text: widget.currentWedding?.phone ?? '');
    _emailController = TextEditingController(text: widget.currentWedding?.email ?? '');
    _budgetController = TextEditingController(text: widget.currentWedding?.budget.toString() ?? '');
  }

  void weddingAction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    int userId = decodedToken['sub'];

    if(widget.currentWedding == null) {
      WeddingDto wedding = WeddingDto(
        name: _nameController.text,
        description: _descriptionController.text,
        address: _addressController.text,
        email: _phoneController.text,
        phone: _emailController.text,
        budget: int.tryParse(_budgetController.text),
        UserID: userId,
      );
      try {
        final createdWedding = await weddingRepository.createWedding(wedding);
        Navigator.pop(context, createdWedding);
      } catch (e) {
        //print('Erreur lors de la creation du mariage: $e');
      }
    } else {
      WeddingDto updatedWeddingDto = WeddingDto(
        id: widget.currentWedding?.id,
        name: _nameController.text,
        description: _descriptionController.text,
        address: _addressController.text,
        email: _phoneController.text,
        phone: _emailController.text,
        budget: int.tryParse(_budgetController.text),
        UserID: userId,
      );
      try {
        final updatedWedding = await weddingRepository.updateWedding(updatedWeddingDto);
        Navigator.pop(context, updatedWedding);
      } catch (e) {
        //print('Erreur lors de la modification du mariage: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: const Text('Créer Votre Mariage',
          style:TextStyle(
            fontSize: 20,
          ) ,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom du mariage';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Adresse'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une Adresse';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une Email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _budgetController,
                decoration: const InputDecoration(labelText: 'Budget'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une Budget';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 100),
              ElevatedButton(
                onPressed: weddingAction,
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(double.maxFinite, 60),
                  backgroundColor: AppColors.pink,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  widget.currentWedding != null ? 'Modifier' : 'Créer',
                  style: const TextStyle(
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
}
