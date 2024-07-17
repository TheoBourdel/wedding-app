import 'package:client/features/auth/bloc/auth_bloc.dart';
import 'package:client/features/auth/bloc/auth_state.dart';
import 'package:client/features/wedding/bloc/wedding_bloc.dart';
import 'package:client/features/wedding/pages/no_wedding_page.dart';
import 'package:client/features/wedding/pages/wedding_info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class WeddingPage extends StatelessWidget {
  const WeddingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final userId = authState is Authenticated ? authState.userId : null;
    context.read<WeddingBloc>().add(WeddingDataLoaded(userId: userId!));

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.weddingHeader,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.weddingHeaderSubtitle,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey[300],
            height: 1.0,
          ),
        ),
      ),
      body: BlocBuilder<WeddingBloc, WeddingState>(
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
      )
    );
  }
}
