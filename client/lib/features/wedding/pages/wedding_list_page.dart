import 'package:client/features/auth/bloc/auth_bloc.dart';
import 'package:client/features/auth/bloc/auth_state.dart';
import 'package:client/features/wedding/bloc/wedding_bloc.dart';
import 'package:client/features/wedding/pages/wedding_info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class WeddingListPage extends StatelessWidget {
  const WeddingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final userId = authState is Authenticated ? authState.userId : null;
    context.read<WeddingBloc>().add(WeddingDataLoaded(userId: userId!));
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Liste de vos mariages'),
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
            // no wedding page
          } else {
            return Padding(padding: const EdgeInsets.all(20), child: ListView.builder(
              itemCount: state.wedding.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => WeddingInfoPage(wedding: state.wedding[index])
                      )
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.wedding[index].date,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Iconsax.location, color: Colors.grey, size: 18),
                            const SizedBox(width: 5),
                            Text(
                              state.wedding[index].address,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                );
              },
            ));
          }
        }
        return const SizedBox();
      },
    ),
    );
  }
}