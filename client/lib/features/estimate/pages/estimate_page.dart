import 'package:client/features/estimate/bloc/estimate_bloc.dart';
import 'package:client/features/estimate/bloc/estimate_state.dart';
import 'package:client/features/estimate/pages/estimate_list_page.dart';
import 'package:client/features/estimate/pages/no_estimate_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EstimatePage extends StatelessWidget {
  const EstimatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EstimateBloc, EstimateState>(
      builder:(context, state) {
        if(state.status == EstimateStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if(state.status == EstimateStatus.success) {
          if (state.estimates.isEmpty) {
            return const NoEstimatePage();
          } else {
            return EstimateListPage(estimates: state.estimates);
          }
        }

        if(state.status == EstimateStatus.failure) {
          return Center(
            child: Text(state.error.toString()),
          );
        }

        return const SizedBox();
      }
    );
  }
}