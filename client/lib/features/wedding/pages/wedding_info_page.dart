import 'package:client/features/guest/pages/guest_page.dart';
import 'package:client/features/organizer/pages/organizers_page.dart';
import 'package:client/core/theme/app_colors.dart';
import 'package:client/features/wedding/pages/wedding_form.dart';
import 'package:client/model/wedding.dart';
import 'package:client/repository/wedding_repository.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeddingInfoPage extends StatefulWidget {
  const WeddingInfoPage({Key? key});

  @override
  State<WeddingInfoPage> createState() => _WeddingInfoPageState();
}

class _WeddingInfoPageState extends State<WeddingInfoPage> {
  bool _isWeddingExists = false;
  final weddingRepository = WeddingRepository();
  Wedding? _wedding;

  @override
  void initState() {
    super.initState();
    getWedding();
  }

  @override
  void deleteWedding(Wedding wedding) async {
    if (wedding.id != null) {
      final weddingId = wedding.id!;

      try {
        await weddingRepository.deleteWedding(weddingId);
        setState(() {
          _isWeddingExists = false;
          _wedding = null;
        });
      } catch (e) {
        print('Erreur lors de la suppression du wedding: $e');
      }
    }
  }

  @override
  void getWedding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    int userId = decodedToken['sub'];

    try {
      final wedding = await weddingRepository.getUserWedding(userId);
      bool isWeddingExists = wedding != null;

      setState(() {
        _isWeddingExists = isWeddingExists;
        _wedding = wedding;
      });
    } catch (e) {
      print('Erreur lors de la récupération du wedding !!: $e');
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
                      if (!_isWeddingExists)
                          ElevatedButton(
                        onPressed: () {
                          Navigator.push( context, MaterialPageRoute(
                              builder: (context) => const WeddingForm(),
                            ),
                          ).then((currentWedding) {
                          if (currentWedding != null) {
                              setState(() {
                                _wedding = currentWedding;
                                _isWeddingExists = true;
                              });
                            }
                          });
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
                          'Créer un Mariage',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (_isWeddingExists)
                          Expanded(
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            child: Card(
                              elevation: 9,
                              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  _wedding?.name ?? 'No wedding name available',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (_isWeddingExists)
                          Expanded(
                          child: Container(
                            width: double.infinity, // Définit la largeur maximale
                            height: 200, // Définit une hauteur spécifique
                            child: Card(
                              elevation: 9,
                              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              child: Padding(
                                padding: const EdgeInsets.all(20),

                                child: Text(
                                  _wedding?.description ?? 'No wedding name available',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (_isWeddingExists)
                          Row(
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity, // Définit la largeur maximale
                                height: 200, // Définit une hauteur spécifique
                                child: Card(
                                  elevation: 9,
                                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),

                                    child: Text(
                                      _wedding?.budget?.toString()  ?? 'No description available',
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
                                width: double.infinity, // Définit la largeur maximale
                                height: 200, // Définit une hauteur spécifique
                                child: Card(
                                  elevation: 9,
                                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),

                                    child: Text(
                                      _wedding?.name ?? 'No wedding name available',
                                      style: const TextStyle(
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
                      if (_isWeddingExists)
                          Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WeddingForm(currentWedding: _wedding),
                                ),
                              ).then((currentWedding) {
                                if (currentWedding != null) {
                                  setState(() {
                                    _wedding = currentWedding;
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
                              'Modifier le Mariage',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: ()  {
                              if (_wedding != null) {
                                try {
                                  deleteWedding(_wedding!);
                                  setState(() {
                                    _isWeddingExists = false;
                                  });
                                } catch (e) {
                                  //print('Erreur lors de la suppression du mariage: $e');
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
                                color: Colors.white,
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
            const Text('Wedding Info Page'),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GuestPage(),
                  ),
                );
              },
              child: const Text('Go to Guest Page'),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrganizersPage(),
                  ),
                );
              },
              child: const Text('Go to Organizer Page'),
            )
          ],
        ),
      ),
    );
  }
}
