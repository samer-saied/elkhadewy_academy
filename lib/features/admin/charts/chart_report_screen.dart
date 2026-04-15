import 'package:flutter/material.dart';
import 'package:unimind/features/admin/info/models/info_chip_model.dart';

import '../../../utils/colors.dart';
import '../info/screens/count_students/progress_segment_widget.dart';

class ChartReportScreen extends StatelessWidget {
  const ChartReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chart Report")),
      body: Center(
        child: BarChartWidget(
          infoChips: [
            InfoChipModel(
              countStudents: 20,
              courseTitle: "Course Title",
              courseColor: "0xFFF44336",
              courseId: "Course ID",
              totalStudents: 100,
            ),
            InfoChipModel(
              countStudents: 70,
              courseTitle: "Course Title",
              courseColor: "0xFFF44336",
              courseId: "Course ID",
              totalStudents: 100,
            ),
            InfoChipModel(
              countStudents: 55,
              courseTitle: "Course Title",
              courseColor: "0xFFF44336",
              courseId: "Course ID",
              totalStudents: 100,
            ),
          ],
        ),
      ),
    );
  }
}
