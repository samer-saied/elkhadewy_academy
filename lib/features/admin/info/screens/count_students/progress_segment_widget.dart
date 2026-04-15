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

                  toY: e.countStudents.toDouble(),
                  gradient: LinearGradient(
                    colors: [
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
  }
}
