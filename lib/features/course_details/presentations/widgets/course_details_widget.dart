import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:unimind/services/lang/app_localizations.dart';

import '../../../courses/data/models/course_model.dart';

class CourseDetailsWidget extends StatelessWidget {
  const CourseDetailsWidget({
    super.key,
    required this.course,
    required this.courseColor,
  });

  final CourseModel course;
  final Color courseColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 5, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: ListTile(
              title: Text("${"Last updated at".tr(context)} : "),
              trailing: Text(
                timeago.format(
                  DateTime.parse(course.dateTime ?? DateTime.now().toString()),
                ),
              ),
            ),
          ),
          SizedBox(height: 7),
          Card(
            child: ListTile(
              title: Text("${"Description".tr(context)} : "),
              subtitle: Text(course.description),
            ),
          ),
        ],
      ),
    );
  }
}
