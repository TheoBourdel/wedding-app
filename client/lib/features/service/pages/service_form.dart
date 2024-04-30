import 'package:client/core/theme/app_colors.dart';
import 'package:client/model/service.dart';
import 'package:client/repository/auth_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:client/dto/service_dto.dart';
import 'package:client/repository/service_repository.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ServiceForm extends StatefulWidget {
  final Service? currentService;

  const ServiceForm({Key? key, this.currentService});

  @override
  State<ServiceForm> createState() => _ServiceFormState();
}

class _ServiceFormState extends State<ServiceForm> {
  final _formKey = GlobalKey<FormState>();
  final serviceRepository = ServiceRepository();
  final AuthRepository authRepository = AuthRepository();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _localisationController;
  late final TextEditingController _phoneController;
  late final TextEditingController _mailController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    // Initialize your TextEditingController's with the values from widget.service if it's not null
    _nameController = TextEditingController(text: widget.currentService?.name ?? '');
    _descriptionController = TextEditingController(text: widget.currentService?.description ?? '');
    _localisationController = TextEditingController(text: widget.currentService?.localisation ?? '');
    _phoneController = TextEditingController(text: widget.currentService?.phone ?? '');
    _mailController = TextEditingController(text: widget.currentService?.mail ?? '');
    _priceController = TextEditingController(text: widget.currentService?.price.toString() ?? '');
  }

  void serviceAction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    int userId = decodedToken['sub'];
    print("test userid");
    print(userId);
    if(widget.currentService == null) {
      ServiceDto service = ServiceDto(
        name: _nameController.text,
        description: _descriptionController.text,
        localisation: _localisationController.text,
        profileImage: "path/to/imgg",
        mail: _mailController.text,
        phone: _phoneController.text,
        price: int.tryParse(_priceController.text),
        UserID: userId,
        CategoryID: 1,
      );
      try {
        final createdService = await serviceRepository.createService(service);
        Navigator.pop(context, createdService);
      } catch (e) {
        print('Erreur lors de la creation de la prestation: $e');
      }
    } else {
      ServiceDto updatedServiceDto = ServiceDto(
        id: widget.currentService?.id,
        name: _nameController.text,
        description: _descriptionController.text,
        localisation: _localisationController.text,
        profileImage: "path/to/imgg",
        mail: _phoneController.text,
        phone: _mailController.text,
        price: int.tryParse(_priceController.text),
        UserID: userId,
      );
      try {
        final updatedService = await serviceRepository.updateService(updatedServiceDto);
        Navigator.pop(context, updatedService);
      } catch (e) {
        print('Erreur lors de la modification de la prestation: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    @override
    void initState() {
      super.initState();
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: Text('Créer une prestation',
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
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez nommer la prestation';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez décrire la prestation';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _localisationController,
                decoration: InputDecoration(labelText: 'Adresse'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une Adresse';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _mailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une adresse mail';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Prix d\'estimation'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une prix d\'estimation';
                  }
                  return null;
                },
              ),
              SizedBox(height: 100),
              ElevatedButton(
                onPressed: serviceAction,
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(double.maxFinite, 60),
                  backgroundColor: AppColors.pink,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  widget.currentService != null ? 'Modifier' : 'Créer',
                  style: TextStyle(
                    color: AppColors.textIcons,
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