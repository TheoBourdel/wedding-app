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
import 'package:google_fonts/google_fonts.dart';
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
    Key? key,
    required this.price,
    required this.defaultColor,
    required this.secondColor,
    required this.size,
    required this.serviceID,
    required this.service,
  }) : super(key: key);

  @override
  _SingleServiceDetailsBottomState createState() =>
      _SingleServiceDetailsBottomState();
}

class _SingleServiceDetailsBottomState
    extends State<SingleServiceDetailsBottom> {
  int userId = 0;

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
      print(e);
    }
  }

  Future<String?> getTokenOfOtherUser(int userId) async {
    try {
      User user = await userRepository.getUser(userId);
      String? token = user.androidToken;
      return token;
    } catch (e) {
      print('Error fetching user token: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoomBloc, RoomState>(
      listener: (context, state) async {
        if (state is RoomCreated) {
          final token = await getTokenOfOtherUser(widget.service.UserID);
          if (token != null) {
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
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          top: widget.size.height * 0.01,
          left: widget.size.width * 0.08,
          right: widget.size.width * 0.08,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'prix d\'estimation',
                  style: GoogleFonts.poppins(
                    color: widget.defaultColor,
                    fontSize: widget.size.height * 0.02,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "${widget.price} €",
                      style: GoogleFonts.poppins(
                        color: widget.defaultColor,
                        fontSize: widget.size.height * 0.035,
                        fontWeight: FontWeight.w600,
                        wordSpacing: -3.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 600,
                      width: widget.size.width,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
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
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                width: widget.size.width * 0.20,
                height: widget.size.height * 0.07,
                decoration: BoxDecoration(
                  color: AppColors.pink,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Align(
                  child: Text(
                    'Devis',
                    style: GoogleFonts.lato(
                      color: widget.secondColor,
                      fontSize: widget.size.height * 0.02,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                if (userId != 0) {
                  BlocProvider.of<RoomBloc>(context).add(CreateRoomEvent(
                    widget.service.name ?? 'No Name',
                    userId: userId,
                    otherUser: widget.service.UserID,
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User ID is not available')),
                  );
                }
              },
              child: Container(
                width: widget.size.width * 0.20,
                height: widget.size.height * 0.07,
                decoration: BoxDecoration(
                  color: AppColors.pink,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Align(
                  child: Text(
                    'CONTACT',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
