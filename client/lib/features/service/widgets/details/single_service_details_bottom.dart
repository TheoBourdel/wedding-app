// ignore_for_file: use_build_context_synchronously
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
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:client/model/service.dart';
import 'package:client/features/message/bloc_room/room_bloc.dart';
import 'package:client/features/message/pages/chat_page.dart';

class SingleServiceDetailsBottom extends StatefulWidget {
  final int price;
  final Color defaultColor;
  final Color secondColor;
  final Size size;
  final Service service;
  final int serviceID;

  const SingleServiceDetailsBottom({
    super.key,
    required this.price,
    required this.defaultColor,
    required this.secondColor,
    required this.size,
    required this.serviceID,
    required this.service,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SingleServiceDetailsBottomState createState() => _SingleServiceDetailsBottomState();
}

class _SingleServiceDetailsBottomState
    extends State<SingleServiceDetailsBottom> {
  int userId = 0;
  late Future<String> role;
  bool _isNavigated = false;


  final UserRepository userRepository = UserRepository();
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserId();
    getUser();
    role = _getUserRole();
  }

  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      setState(() {
        userId = decodedToken['sub'];
      });
    }
  }

  Future<String> _getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    return decodedToken['role'] ?? 'unknown';
  }

  Future<void> getUser() async {
    try {
      final authState = context.read<AuthBloc>().state;
      final userId = authState is Authenticated ? authState.userId : null;
      if (userId != null) {
        User user = await userRepository.getUser(userId);
        setState(() {
          firstNameController.text = user.firstName!;
          lastNameController.text = user.lastName!;
        });
      }
    } catch (e) {
      return;
    }
  }

  Future<String?> getTokenOfOtherUser(int userId) async {
    try {
      User user = await userRepository.getUser(userId);
      String? token = user.androidToken;
      return token;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: role,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        bool isProvider = snapshot.hasData && snapshot.data == "provider";
        return BlocListener<RoomBloc, RoomState>(
          listener: (context, state) async {
            if(!_isNavigated){
              if (state is RoomCreated) {
                final token = await getTokenOfOtherUser(widget.service.UserID);
                if (token != null) {
                  setState(() {
                    _isNavigated = true;
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatForm(
                        currentChat: state.room.name,
                        roomId: state.room.id.toString(),
                        userId: userId,
                        token: token,
                      ),
                    ),
                  );
                }
              } else if (state is RoomError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to join room: ${state.message}')),
                );
              } else if (state is RoomJoined) {
                print('uuuuuuuu${state.room.id.toString()}');
                final token = await getTokenOfOtherUser(widget.service.UserID);
                if (token != null) {
                  setState(() {
                    _isNavigated = true;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatForm(
                        currentChat: state.room.name,
                        roomId: state.room.id.toString(),
                        userId: userId,
                        token: token,
                      ),
                    ),
                  );
                }
              }
            }

          },
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.size.width * 0.05,
                vertical: widget.size.height * 0.02,
              ),
              child: Column(
                children: [
                  if (!isProvider)
                  Button(
                    text: 'Demander un devis',
                    onPressed: () => {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: Wrap(
                                children: [
                                  Center(
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
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Input(
                                                      hintText: 'Nom',
                                                      controller: lastNameController,
                                                    ),
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
                                                    return 'Le contenu est requis';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (formKey.currentState!.validate()) {
                                              context.read<EstimateBloc>().add(
                                                EstimateCreateEvent(
                                                  userId: userId,
                                                  createEstimateDto: CreateEstimateDto(
                                                    firstName: firstNameController.text,
                                                    lastName: lastNameController.text,
                                                    content: contentController.text,
                                                    serviceId: widget.serviceID,
                                                  ),
                                                ),
                                              );
                                              Navigator.pop(context);
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
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      },
                  )
                ],
              )
            )
          )
        );
      },
    );
  }
}