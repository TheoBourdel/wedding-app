import 'package:client/features/message/bloc_room/room_bloc.dart';
import 'package:client/features/message/pages/message_list_page.dart';
import 'package:client/features/message/pages/room_no_page.dart';
import 'package:client/repository/room_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/provider/user_provider.dart';

class RoomPage extends StatelessWidget {
  const RoomPage({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => RoomBloc(context.read<RoomRepository>())..add(
        FetchRoomsEvent(userId: context.read<UserProvider>().userId),
      ),

      child: BlocBuilder<RoomBloc, RoomState>(
        builder: (context, state) {
          if (state is RoomError) {

            return Center(
              child: Text(state.message),
            );
          }

          if (state is RoomsLoaded) {

            if (state.rooms.isEmpty) {
              return const NoRoomPage();
            } else {
              return const MessageListPage();
            }
          }

          return const SizedBox();
        },
      ),
    );
  }
}
