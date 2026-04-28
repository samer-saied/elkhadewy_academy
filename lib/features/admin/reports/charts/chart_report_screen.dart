import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:unimind/general/widgets/headers_widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import '../../../../utils/colors.dart';
import '../../../watching_report/data/cubit/watching_report_cubit.dart';

class ChartReportScreen extends StatelessWidget {
  const ChartReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Weekly Report")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<WatchingReportCubit, WatchingReportState>(
            bloc: GetIt.I<WatchingReportCubit>()..getWeeklyCountReport(),
            builder: (context, state) {
              List<Map<String, dynamic>> infoChartBars =
                  GetIt.I<WatchingReportCubit>().dailyCounts;
              if (state is WatchingReportLoaded) {
                return Column(
                  children: [
                    Row(
                      children: [
                        SectionHeaderSmallWidget(
                          title: "Weekly Chart",
                          color: AppColors.jonquil,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.5,
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
                                      AppColors.jonquilLight,
                                      AppColors.jonquil,
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
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        SectionHeaderSmallWidget(
                          title: "Weekly Reports",
                          color: AppColors.jonquil,
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: infoChartBars.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> element = infoChartBars[index];
                        DateTime dateTime = DateTime.parse(element["date"]);
                        String formattedDate = DateFormat(
                          'EEE d MMMM y',
                        ).format(dateTime);
                        return TotalInfoWidget(
                          infoTotaltxt: element["counts"].toString(),
                          infoTxt: formattedDate,
                          color: AppColors.jonquil,
                        );
                      },
                    ),
                  ],
                );
              }
              return SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.4,
                child: Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ),
      ),
    );
  }
}

class TotalInfoWidget extends StatelessWidget {
  final String infoTxt;
  final String infoTotaltxt;
  final Color? color;
  const TotalInfoWidget({
    super.key,
    required this.infoTxt,
    required this.infoTotaltxt,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: AppColors.whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              infoTxt,
              style: TextStyle(
                color: color ?? AppColors.prussianBlue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: color ?? AppColors.prussianBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                infoTotaltxt,
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
    );
  }
}
