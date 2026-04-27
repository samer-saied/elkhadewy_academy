import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../general/widgets/loading_widget.dart';
import '../../../../general/widgets/no_data_widget.dart';
import '../cubit/course_cubit.dart';
import 'course_gird_card_widget.dart';

class CoursesGirdSectionWidget extends StatelessWidget {
  const CoursesGirdSectionWidget({
    super.key,
    required this.collegeId,
    required this.yearId,
  });
  final String collegeId;
  final String yearId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseCubit, CourseState>(
      bloc: GetIt.I.get<CourseCubit>()
        ..fetchSpecificCoursesByCollegeId(collegeId, yearId),
      buildWhen: (previous, current) =>
          current is CourseLoaded || current is CourseLoading,
      builder: (context, state) {
        if (state is CourseLoaded) {
          final items = state.items;
          if (items.isEmpty) {
            return NoDataWidget();
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: .75,
              ),
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return CourseGridCardWidget(course: items[index]);
                // return FeaturedCourseCardWidget(
                //   currentCourse: items[index],
                //   index: index,
                // );
              },
            ),
          );
        }

        // Loading placeholders
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15.0,
            mainAxisSpacing: 15.0,
            childAspectRatio: 3 / 4,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return const LoadingWidget(isFullWidth: false, numRows: 1);
          },
        );
      },
    );
  }
}
