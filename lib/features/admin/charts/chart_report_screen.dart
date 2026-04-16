import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../utils/colors.dart';
import '../../watching_report/data/cubit/watching_report_cubit.dart';
import '../info/screens/count_students/progress_segment_widget.dart';

class ChartReportScreen extends StatelessWidget {
  const ChartReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chart Report")),
      body: Center(
        child: BlocBuilder<WatchingReportCubit, WatchingReportState>(
          bloc: GetIt.I<WatchingReportCubit>()..getWeeklyCountReport(),
          builder: (context, state) {
            List<Map<String, dynamic>> infoChartBars =
                GetIt.I<WatchingReportCubit>().dailyCounts;
            if (state is WatchingReportLoaded) {
              return SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.5,
                width: double.infinity,
                child: BarChart(
                  BarChartData(
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return FittedBox(
                              child: Text(
                                "${infoChartBars[value.toInt() - 1]["date"].toString().split("-")[1]}-${infoChartBars[value.toInt() - 1]["date"].toString().split("-")[2]}",
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // read about it in the BarChartData section
                    barGroups: infoChartBars.map((e) {
                      return BarChartGroupData(
                        x: infoChartBars.indexOf(e) + 1,
                        barRods: [
                          BarChartRodData(
                            label: BarChartRodLabel(
                              show: true,
                              angle: -90,
                              text: e["date"],
                              offset: Offset(0, -50),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),

                            toY: e["counts"].toDouble(),
                            gradient: LinearGradient(
                              colors: [
                                AppColors.jonquil,
                                AppColors.jonquilLight,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            width: 16,
                            borderRadius: BorderRadius.circular(15),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: e["counts"].toDouble() * 1.5,
                              color: Colors.grey.withAlpha(20),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  duration: Duration(milliseconds: 150), // Optional
                  curve: Curves.bounceInOut, // Optional
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
