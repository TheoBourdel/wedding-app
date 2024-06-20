import 'package:client/core/theme/app_colors.dart';
import 'package:client/model/service.dart';
import 'package:client/model/category.dart';
import 'package:client/repository/auth_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:client/dto/service_dto.dart';
import 'package:client/repository/service_repository.dart';
import 'package:client/repository/image_repository.dart';
import 'package:client/dto/image_dto.dart';
import 'package:client/repository/category_repository.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ServiceForm extends StatefulWidget {
  final Service? currentService;

  const ServiceForm({super.key, this.currentService});

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

  List<Category> categories = [];
  int? selectedCategoryId;
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFiles;
  List<String>? _imagePaths;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentService?.name ?? '');
    _descriptionController = TextEditingController(text: widget.currentService?.description ?? '');
    _localisationController = TextEditingController(text: widget.currentService?.localisation ?? '');
    _phoneController = TextEditingController(text: widget.currentService?.phone ?? '');
    _mailController = TextEditingController(text: widget.currentService?.mail ?? '');
    _priceController = TextEditingController(text: widget.currentService?.price.toString() ?? '');
    _loadCategories();
  }

  void pickImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      List<String> filePaths = [];
      final directory = await getApplicationDocumentsDirectory();
      final imageDirectory = Directory('${directory.path}/images');
      if (!await imageDirectory.exists()) {
        await imageDirectory.create(recursive: true);
      }
      for (var image in selectedImages) {
        final imagePath = path.join(imageDirectory.path, path.basename(image.path));
        final File newImage = await File(image.path).copy(imagePath);
        filePaths.add(newImage.path);
      }
      setState(() {
        _imageFiles = selectedImages;
        _imagePaths = filePaths;
      });
    }
  }

  void _loadCategories() async {
    categories = await CategoryRepository().getCategorys();
    if (widget.currentService != null) {
      selectedCategoryId = widget.currentService?.CategoryID;
    } else if (categories.isNotEmpty) {
      selectedCategoryId = categories.first.id;
    }
    setState(() {});
  }

  void serviceAction() async {
    if (!_formKey.currentState!.validate()) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    int userId = decodedToken['sub'];

    ServiceDto serviceDto = ServiceDto(
      id: widget.currentService?.id,
      name: _nameController.text,
      description: _descriptionController.text,
      localisation: _localisationController.text,
      mail: _mailController.text,
      phone: _phoneController.text,
      price: int.tryParse(_priceController.text),
      UserID: userId,
      CategoryID: selectedCategoryId,
      profileImage: "/path/to/img",
    );

    try {
      Service? response = widget.currentService == null ?
      await serviceRepository.createService(serviceDto) :
      await serviceRepository.updateService(serviceDto);

      if (response == null) {
        if (_imageFiles != null && _imageFiles!.isNotEmpty) {
          await serviceRepository.uploadImages(response!.id!, _imageFiles!);
        }
        Navigator.pop(context, response);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Service ${widget.currentService == null ? 'créé' : 'mis à jour'} avec succès!'))
        );
      } else {
        throw Exception('Aucune réponse du serveur');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur lors de la ${widget.currentService == null ? 'création' : 'mise à jour'}'),
            content: Text('Erreur: $e'),
            actions: <Widget>[
              TextButton(
                child: Text('Fermer'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
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
        title: Text(widget.currentService == null ? 'Créer une prestation' : 'Modifier la prestation'),
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
                    return 'Veuillez nommer la prestation';
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
                    return 'Veuillez décrire la prestation';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _localisationController,
                decoration: const InputDecoration(labelText: 'Adresse'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une adresse';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Téléphone'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _mailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une adresse email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Prix'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prix';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<int>(
                value: selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Catégorie',
                  border: OutlineInputBorder(),
                ),
                onChanged: (int? newValue) {
                  setState(() {
                    selectedCategoryId = newValue;
                  });
                },
                items: categories.map<DropdownMenuItem<int>>((Category category) {
                  return DropdownMenuItem<int>(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez sélectionner une catégorie';
                  }
                  return null;
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Sélectionner des images"),
                onTap: pickImages,
              ),
              if (_imageFiles != null)
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: _imageFiles!.map((file) => Image.file(File(file.path), width: 100, height: 100)).toList(),
                ),
              const SizedBox(height: 100),
              ElevatedButton(
                onPressed: serviceAction,
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(double.infinity, 60),
                  backgroundColor: AppColors.pink,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  widget.currentService != null ? 'Modifier' : 'Créer',
                  style: const TextStyle(
                    color: Colors.black,
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
