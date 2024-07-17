import 'package:client/features/message/pages/chat_page.dart';
import 'package:client/model/user.dart';
import 'package:client/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/features/message/bloc_room/room_bloc.dart';
import 'package:client/repository/room_repository.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class RoomsView extends StatelessWidget {
  final UserRepository userRepository = UserRepository();

  RoomsView({super.key});

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
    return FutureBuilder<int>(
      future: getUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final userId = snapshot.data!;
          return BlocProvider(
            create: (context) => RoomBloc(context.read<RoomRepository>())
              ..add(FetchRoomsEvent(userId: userId)),
            child: BlocBuilder<RoomBloc, RoomState>(
              builder: (context, state) {
                if (state is RoomInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RoomsLoaded) {
                  if(state.rooms.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/no-messages.png',
                            width: 350,
                            height: 350,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.noConversation,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  AppLocalizations.of(context)!.noConversationSubtitle,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            )
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: state.rooms.length,
                    itemBuilder: (context, index) {
                      final roomOfUser = state.rooms[index];
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Colors.pink[100],
                          child: const Icon(Icons.person, color: Colors.white, size: 30.0),
                        ),
                        title: Text(
                          '${roomOfUser.firstname} ${roomOfUser.lastname}',
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                        subtitle: Text(
                          roomOfUser.email,
                          style: const TextStyle(color: Colors.black54, fontSize: 16.0),
                        ),
                        onTap: () async {
                          final token = await getTokenOfOtherUser(roomOfUser.userId);
                          Navigator.push(
                            // ignore: use_build_context_synchronously
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatForm(
                                currentChat: roomOfUser.firstname,
                                roomId: roomOfUser.roomId.toString(),
                                userId: userId,
                                token: token ?? '',
                              ),
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                      indent: 16.0,
                      endIndent: 16.0,
                    ),
                  );
                } else if (state is RoomError) {
                  return Center(child: Text('Failed to load rooms: ${state.message}'));
                }
                return Container();
              },
            ),
          );
        }
      },
    );
  }

  Future<int> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    return decodedToken['sub'];
  }
}
