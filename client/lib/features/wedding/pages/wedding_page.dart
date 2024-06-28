import 'package:client/features/wedding/bloc/wedding_bloc.dart';
import 'package:client/features/wedding/pages/no_wedding_page.dart';
import 'package:client/features/wedding/pages/wedding_info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeddingPage extends StatelessWidget {
  const WeddingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeddingBloc, WeddingState>(
      builder: (context, state) {
        if (state.status == WeddingStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.status == WeddingStatus.failure) {
          return Center(
            child: Text(state.error ?? "Unknown error"),
          );
        }

        if (state.status == WeddingStatus.success) {
          if (state.wedding.isEmpty) {
            return const NoWeddingPage();
          } else {
            return WeddingInfoPage(wedding: state.wedding.first);
          }
        }
        return const SizedBox();
      },
    );
  }
}
