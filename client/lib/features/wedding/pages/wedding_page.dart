import 'package:client/features/wedding/bloc/wedding_bloc.dart';
import 'package:client/features/wedding/pages/no_wedding_page.dart';
import 'package:client/features/wedding/pages/wedding_form.dart';
import 'package:client/features/wedding/pages/wedding_info_page.dart';
import 'package:client/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeddingPage extends StatelessWidget {
  const WeddingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeddingBloc()..add(
        WeddingDataLoaded(userId: context.read<UserProvider>().userId)
      ),
      child: BlocBuilder<WeddingBloc, WeddingState>(
        builder: (context, state) {
          if (state is WeddingLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is WeddingDataLoadedFailure) {
            return Center(
              child: Text(state.error),
            );
          }

          if (state is WeddingDataLoadedSuccess) {
            if (state.wedding.isEmpty) {
              return const NoWeddingPage();
            } else {
              return WeddingInfoPage(wedding: state.wedding.first);
            }
          }
          return const SizedBox();
        },
      )
    );
  }
}
