import 'package:client/core/theme/app_colors.dart';
import 'package:client/features/service/pages/service_form.dart';
import 'package:client/model/service.dart';
import 'package:client/repository/service_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceInfoPage extends StatefulWidget {
  const ServiceInfoPage({Key? key});

  @override
  State<ServiceInfoPage> createState() => _ServiceInfoPageState();
}

class _ServiceInfoPageState extends State<ServiceInfoPage> {
  bool _isServiceExists = false;
  final serviceRepository = ServiceRepository();
  Service? _service;

  @override
  void initState() {
    super.initState();
    getService();
  }


  @override
  void deleteService(Service service) async {
    if (service.id != null) {
      final serviceId = service.id!;

      try {
        await serviceRepository.deleteService(serviceId);
        setState(() {
          _isServiceExists = false;
          _service = null;
        });
      } catch (e) {
        print('Erreur lors de la suppression du service: $e');
      }
    }
  }

  void getService() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    int userId = decodedToken['sub'];

    try {
      final service = await serviceRepository.getUserService(userId);
      bool isServiceExists = service != null;
      print(service.id);

      setState(() {
        _isServiceExists = isServiceExists;
        _service = service;
      });
    } catch (e) {
      print('Erreur lors de la récupération du service !!: $e');
    }


  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (_isServiceExists)
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            child: Card(
                              elevation: 9,
                              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  _service?.name ?? 'No service name available',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (_isServiceExists)
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            child: Card(
                              elevation: 9,
                              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              child: Padding(
                                padding: EdgeInsets.all(20),

                                child: Text(
                                  _service?.description ?? 'No service name available',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (_isServiceExists)
                        Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 200,
                                  child: Card(
                                    elevation: 9,
                                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),

                                      child: Text(
                                        _service?.price?.toString()  ?? 'No description available',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  height: 200,
                                  child: Card(
                                    elevation: 9,
                                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    child: Padding(
                                      padding: EdgeInsets.all(20),

                                      child: Text(
                                        _service?.name ?? 'No service name available',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]
                        ),
                      if (_isServiceExists)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ServiceForm(currentService: _service),
                                  ),
                                ).then((currentService) {
                                  if (currentService != null) {
                                    setState(() {
                                      _service = currentService;
                                    });
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(250, 60),
                                backgroundColor: AppColors.pink,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                'Modifier la prestation',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: ()  {
                                if (_service != null) {
                                  try {
                                    deleteService(_service!);
                                    setState(() {
                                      _isServiceExists = false;
                                    });
                                  } catch (e) {
                                    print('Erreur lors de la suppression du service: $e');
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(70, 60),
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                'Supprimer ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ServiceForm()),
          ).then((currentService) {
            if (currentService != null) {
              setState(() {
                _service = currentService;
                _isServiceExists = true;
              });
            }
          });
        },
        backgroundColor: AppColors.pink,
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}