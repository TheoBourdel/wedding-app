import 'package:client/core/theme/app_colors.dart';
import 'package:client/dto/organizer_dto.dart';
import 'package:client/features/organizer/widgets/organizer_list.dart';
import 'package:client/model/user.dart';
import 'package:client/repository/user_repository.dart';
import 'package:client/repository/wedding_repository.dart';
import 'package:client/shared/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrganizersPage extends StatefulWidget {
  const OrganizersPage({super.key});

  @override
  State<OrganizersPage> createState() => _OrganizersPageState();
}

class _OrganizersPageState extends State<OrganizersPage> {

  final UserRepository userRepository = UserRepository();
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  List organizers = [];
  int userId = 0;
  int weddingId = 0;

  void getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    userId = decodedToken['sub'];

    getUser();
  }

  void getUser() async {
    try {
      User user = await userRepository.getUser(userId);

      weddingId = user.weddings?.first.id ?? 0;

      setState(() {
        organizers = user.weddings?.first.organizers as List;
      });
    } catch (e) {
      //
    }
  }

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  void handleInviteOrganizer() async {
    if (formKey.currentState!.validate()) {
      
      OrganizerDto organizer = OrganizerDto(
        email: emailController.text,
        firstName: nameController.text,
      );

      try {
        User user = await WeddingRepository().addOrganizer(organizer, weddingId);

        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        
        setState(() {
          organizers.add(user);
        });

        emailController.clear();
        nameController.clear();
      } catch (e) {
        // toast error
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organisateurs'),
        centerTitle: false,
        backgroundColor: AppColors.pink50,
      ),
      bottomSheet: Container(
        color: AppColors.pink50,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(40),
        child: Button(
          text: 'Inviter un organisateur',
          onPressed: () => {
            showModalBottomSheet(
              context: context, 
              builder: (BuildContext context) {
                return Wrap(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Text(
                              'Invite un organisateur',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Invite une personne à rejoindre ton équipe d\'organisation.',
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
                                  TextFormField(
                                    controller: emailController,
                                    decoration: const InputDecoration(
                                      hintText: 'Email',
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Le mail est requis';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: nameController,
                                    decoration: const InputDecoration(
                                      hintText: 'Nom',
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Le nom est requis';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              )
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: handleInviteOrganizer,
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
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ]
                );
              }
            )
          }, 
        )
      ),
      body: SafeArea(
        child: Container(
          color: AppColors.pink50,
          child: OrganizerList(organizers: organizers),
        ),
      ),
    );
  }
}