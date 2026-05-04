import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../utils/colors.dart';
import '../../../auth/bloc/login_cubit.dart';
import '../../../courses/presentations/cubit/course_cubit.dart';

class BuildCourseDropDown extends StatelessWidget {
  final String? selectedCourseId;
  final Function(String) onChanged;
  const BuildCourseDropDown({
    super.key,
    required this.selectedCourseId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseCubit, CourseState>(
      bloc: GetIt.I<CourseCubit>(),
      builder: (context, state) {
        bool isAdmin = GetIt.I<LoginCubit>().currentUser!.role == "admin";
        if (state is CourseLoaded) {
          final courses = isAdmin
              ? GetIt.I<CourseCubit>().allCourses
              : GetIt.I<CourseCubit>().userCourses;
          courses.isEmpty && isAdmin
              ? GetIt.I<CourseCubit>().fetchCourseItems()
              : null;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(40),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: courses.any((c) => c.id == selectedCourseId)
                    ? selectedCourseId
                    : null,
                hint: Text(
                  'Select the appropriate course',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(color: AppColors.grey),
                ),
                items: courses.map((course) {
                  return DropdownMenuItem<String>(
                    value: course.id,
                    child: Text(course.title),
                  );
                }).toList(),
                onChanged: (v) => {onChanged(v!)},
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
