import 'package:client/features/auth/bloc/auth_bloc.dart';
import 'package:client/features/auth/bloc/auth_state.dart';
import 'package:client/features/message/bloc_room/room_bloc.dart';
import 'package:client/features/message/pages/message_list_page.dart';
import 'package:client/features/message/pages/room_no_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoomPage extends StatelessWidget {
  const RoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final userId = authState is Authenticated ? authState.userId : null;
    context.read<RoomBloc>().add(FetchRoomsEvent(userId: userId!));

    return BlocBuilder<RoomBloc, RoomState>(
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
    );
  }
}
