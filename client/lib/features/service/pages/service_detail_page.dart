import 'package:client/model/user.dart';
import 'package:client/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/model/service.dart';
import 'package:client/features/message/bloc_room/room_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:client/features/message/pages/chat_page.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ServiceDetailPage extends StatefulWidget {
  final Service service;

  const ServiceDetailPage({Key? key, required this.service}) : super(key: key);

  @override
  _ServiceDetailPageState createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  int userId = 0;
  final UserRepository userRepository = UserRepository ();

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    setState(() {
      userId = decodedToken['sub'];
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.service.name ?? 'Service Detail'),
      ),
      body: BlocListener<RoomBloc, RoomState>(
        listener: (context, state) {
          if (state is RoomCreated) {
          /*  Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatForm(
                  currentChat: state.room.name,
                  roomId: state.room.id.toString(),
                  //userId: widget.service.UserID,
                  userId: userId,

                ),
              ),
            );*/
          } else if (state is RoomError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to join room: ${state.message}')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${widget.service.name ?? 'No Name'}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Description: ${widget.service.description ?? 'No Description'}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('Price: ${widget.service.price ?? 'No Price'}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('Location: ${widget.service.localisation ?? 'No Location'}', style: TextStyle(fontSize: 16)),
              // Add more fields as needed
              SizedBox(height: 20),
              ElevatedButton(
                child: Text("Envoyer un message"),
                onPressed: () {
                  if (userId != 0) {
                    BlocProvider.of<RoomBloc>(context).add(CreateRoomEvent(widget.service.name ?? 'No Name', userId: userId, otherUser: widget.service.UserID,));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('User ID is not available')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
