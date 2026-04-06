import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/info_chip_model.dart';

class BarChartWidget extends StatelessWidget {
  final List<InfoChipModel> infoChips;
  const BarChartWidget({super.key, required this.infoChips});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.33,
      width: double.infinity,
      child: BarChart(
        BarChartData(
          // read about it in the BarChartData section
          barGroups: infoChips.map((e) {
            return BarChartGroupData(
              x: infoChips.indexOf(e) + 1,
              barRods: [
                BarChartRodData(
                  label: BarChartRodLabel(
                    show: true,
                    angle: 90,
                    text: e.courseTitle,
                    offset: Offset(0, -100),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),

                  // rodStackItems: [
                  //   BarChartRodStackItem(
                  //     e.countStudents.toDouble(),
                  //     e.countStudents.toDouble(),
                  //     Colors.grey.withAlpha(10),
                  //   ),
                  //   BarChartRodStackItem(
                  //     e.totalStudents.toDouble(),
                  //     e.totalStudents.toDouble(),
                  //     Colors.grey.withAlpha(10),
                  //   ),
                  // ],
                  toY: e.countStudents.toDouble(),
                  gradient: LinearGradient(
                    colors: [
                      // Color(int.parse(e.courseColor)).withAlpha(100),
                      Color(int.tryParse(e.courseColor) ?? 0xFF000000),
                      Color(int.tryParse(e.courseColor) ?? 0xFF000000),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  width: 16,
                  borderRadius: BorderRadius.circular(15),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: e.totalStudents.toDouble(),
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
    //   return AspectRatio(
    //     aspectRatio: 1.3,
    //     child: AspectRatio(
    //       aspectRatio: 1,
    //       child: PieChart(
    //         PieChartData(
    //           pieTouchData: PieTouchData(
    //             touchCallback: (FlTouchEvent event, pieTouchResponse) {
    //               setState(() {
    //                 if (!event.isInterestedForInteractions ||
    //                     pieTouchResponse == null ||
    //                     pieTouchResponse.touchedSection == null) {
    //                   touchedIndex = -1;
    //                   return;
    //                 }
    //                 touchedIndex =
    //                     pieTouchResponse.touchedSection!.touchedSectionIndex;
    //               });
    //             },
    //           ),
    //           borderData: FlBorderData(show: false),
    //           titleSunbeamLayout: true,
    //           sectionsSpace: 0,
    //           centerSpaceRadius: 0,
    //           sections: sections,
    //         ),
    //       ),
    //     ),
    //   );
    // }
  }
}
