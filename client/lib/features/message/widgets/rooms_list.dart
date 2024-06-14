import 'package:client/features/message/pages/chat_page.dart';
import 'package:client/model/user.dart';
import 'package:client/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/features/message/bloc_room/room_bloc.dart';
import 'package:client/repository/room_repository.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomsView extends StatelessWidget {
  final UserRepository userRepository = UserRepository();

  Future<String?> getTokenOfOtherUser(int userId) async {
    try {
      User user = await userRepository.getUser(userId);
      String? token = user.androidToken;
      print('User ID: ${user.id}, Email: ${user.email}, Token: $token');
      return token;
    } catch (e) {
      print('Error fetching user token: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: getUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
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
                  return Center(child: CircularProgressIndicator());
                } else if (state is RoomsLoaded) {
                  return ListView.builder(
                    itemCount: state.rooms.length,
                    itemBuilder: (context, index) {
                      final roomOfUser = state.rooms[index];
                      return ListTile(
                        leading: CircleAvatar(),
                        title: Text('${roomOfUser.firstname} ${roomOfUser.lastname}'),
                        subtitle: Text('${roomOfUser.email}'),
                        onTap: () async {
                          final token = await getTokenOfOtherUser(roomOfUser.userId);
                          print(token);
                          Navigator.push(
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
