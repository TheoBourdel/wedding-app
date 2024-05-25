import 'package:client/core/theme/app_colors.dart';
import 'package:client/model/service.dart';
import 'package:client/model/category.dart';
import 'package:client/repository/auth_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:client/dto/service_dto.dart';
import 'package:client/dto/category_dto.dart';
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
    try {
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

        print("Images selected: ${_imagePaths}");
      } else {
        print("No images selected or permission denied.");
      }
    } catch (e) {
      print("Failed to pick images: $e");
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    int userId = decodedToken['sub'];

    ServiceDto serviceDto = ServiceDto(
      name: _nameController.text,
      description: _descriptionController.text,
      localisation: _localisationController.text,
      profileImage: "/path/to/img",
      mail: _mailController.text,
      phone: _phoneController.text,
      price: int.tryParse(_priceController.text),
      UserID: userId,
      CategoryID: selectedCategoryId,
    );

    try {
      Service? response = widget.currentService == null ?
      await serviceRepository.createService(serviceDto) :
      await serviceRepository.updateService(serviceDto);

      print("hors if");
      if (response != null && response.id != null) {
        print("dans if");
        if (_imageFiles != null && _imageFiles!.isNotEmpty) {
          await serviceRepository.uploadImages(response.id!, _imageFiles!);
        }
        Navigator.pop(context, response);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erreur'),
              content: Text('Impossible de créer ou de mettre à jour le service.'),
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
    } catch (e) {
      //remplacer par alerte de l'appli
      print('Error processing service action: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur de réseau'),
            content: Text(
                'Une erreur est survenue lors de la communication avec le serveur. Veuillez réessayer.'),
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

  Future<void> saveImagePaths(List<String> imagePaths, int serviceId) async {
    for (String path in imagePaths) {
      await ImageRepository().createImage(ImageDto(path: path, ServiceID: serviceId));
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
              SizedBox(height: 20),
              DropdownButtonFormField<int>(
                value: selectedCategoryId,
                decoration: InputDecoration(
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
              //SizedBox(height: 100),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("Sélectionner des images"),
                onTap: pickImages,
              ),
              if (_imageFiles != null)
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: _imageFiles!.map((file) => Image.file(File(file.path), width: 100, height: 100)).toList(),
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