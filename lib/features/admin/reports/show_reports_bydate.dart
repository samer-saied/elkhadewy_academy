import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:unimind/features/watching_report/data/cubit/watching_report_cubit.dart';

import '../../../utils/colors.dart';
import '../../watching_report/widgets/watched_report_card_widget.dart';

class ShowReportsByDatePage extends StatefulWidget {
  const ShowReportsByDatePage({super.key});

  @override
  State<ShowReportsByDatePage> createState() => _ShowReportsByDatePageState();
}

class _ShowReportsByDatePageState extends State<ShowReportsByDatePage> {
  late DateTime selectedDate;

  // 2. The function that triggers the picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // The date highlighted when the picker opens
      firstDate: DateTime(2026), // The earliest date allowed
      lastDate: DateTime(2036), // The latest date allowed
    );
    // 3. Update the UI if a date was actually picked (not cancelled)
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Watching Report By Date'), centerTitle: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Text(
              "Select Date : ${selectedDate.toString().split(' ')[0]}",
              style: TextStyle(color: AppColors.jonquil, fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text('Select Date'),
            ),
          ),
          Expanded(
            child: BlocBuilder<WatchingReportCubit, WatchingReportState>(
              bloc: GetIt.I<WatchingReportCubit>()
                ..getWatchingReportsByDate(
                  selectedDate: selectedDate.toString().split(' ')[0],
                ),
              builder: (context, state) {
                if (state is WatchingReportLoaded) {
                  if (state.reports.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(child: Text('No Watching Reports Found')),
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
          ),
        ],
      ),
    );
  }
}
