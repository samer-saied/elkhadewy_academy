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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 1,
              color: AppColors.whiteColor,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: InkWell(
                  onTap: () => _selectDate(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Select Date : ${selectedDate.toString().split(' ')[0]}",
                        style: TextStyle(
                          color: AppColors.jonquil,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => _selectDate(context),
                        icon: Icon(
                          Icons.date_range,
                          color: AppColors.jonquil,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ////////////// RESULTS //////////////
            BlocBuilder<WatchingReportCubit, WatchingReportState>(
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
                  ////////////// RESULTS //////////////
                  return Column(
                    children: [
                      ////////////// TOTAL COUNT //////////////
                      Card(
                        elevation: 1,
                        color: AppColors.whiteColor,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Reports",
                                style: TextStyle(
                                  color: AppColors.jonquil,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.jonquil,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  state.reports.length.toString(),
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ////////////// RESULTS LIST //////////////
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.reports.length,
                        itemBuilder: (context, index) {
                          return WatchedReportCardWidget(
                            number: index.toString(),
                            report: state.reports[index],
                          );
                        },
                      ),
                    ],
                  );
                }
                return SizedBox(
                  height: 200,
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
