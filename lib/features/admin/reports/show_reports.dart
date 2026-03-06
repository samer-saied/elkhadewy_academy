import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:unimind/features/watching_report/data/cubit/watching_report_cubit.dart';

import '../../../utils/colors.dart';
import '../../watching_report/widgets/watched_report_card_widget.dart';

String searchValue = "";

class ShowReportsPage extends StatelessWidget {
  const ShowReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Watching Report'), centerTitle: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Text(
              "Enter User Phone Number",
              style: TextStyle(color: AppColors.jonquil, fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              decoration: InputDecoration(
                hint: Text(
                  "User Phone Number",
                  style: TextStyle(color: AppColors.grey),
                ),
                filled: true,
                fillColor: AppColors.whiteColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                hintStyle: const TextStyle(color: AppColors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.lightGrey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.lightGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.jonquil),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
              onSubmitted: (value) {
                searchValue = value;
                GetIt.I<WatchingReportCubit>().getWatchingReportsByPhone(
                  phone: value,
                );
              },
            ),
          ),
          BlocBuilder<WatchingReportCubit, WatchingReportState>(
            bloc: GetIt.I<WatchingReportCubit>()
              ..getWatchingReportsByPhone(phone: searchValue),
            builder: (context, state) {
              if (state is WatchingReportLoaded) {
                if (state.reports.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(child: Text('No Watching Reports Found')),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.reports.length,
                    itemBuilder: (context, index) {
                      return WatchedReportCardWidget(
                        number: index.toString(),
                        report: state.reports[index],
                      );
                    },
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}
