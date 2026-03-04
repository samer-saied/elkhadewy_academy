import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:unimind/services/lang/app_localizations.dart';

import 'data/cubit/watching_report_cubit.dart';
import 'widgets/watched_report_card_widget.dart';

class WatchingReportPage extends StatelessWidget {
  const WatchingReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watching Report'.tr(context)),
        centerTitle: true,
      ),
      body: BlocBuilder<WatchingReportCubit, WatchingReportState>(
        bloc: GetIt.I<WatchingReportCubit>()..getWatchingReports(),
        builder: (context, state) {
          if (state is WatchingReportLoaded) {
            if (state.reports.isEmpty) {
              return Center(
                child: Text('No Watching Reports Found'.tr(context)),
              );
            }
            return ListView.builder(
              itemCount: state.reports.length,
              itemBuilder: (context, index) {
                return WatchedReportCardWidget(
                  number: index.toString(),
                  report: state.reports[index],
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
