import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../general/widgets/loading_widget.dart';
import '../cubit/course_cubit.dart';
import 'course_list_card_widget.dart';

class CoursesVListSectionWidget extends StatelessWidget {
  const CoursesVListSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseCubit, CourseState>(
      bloc: GetIt.I.get<CourseCubit>(),
      buildWhen: (previous, current) =>
          current is CourseLoaded || current is CourseLoading,
      builder: (context, state) {
        if (state is CourseLoaded) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.items.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return CourseListCardWidget(course: state.items[index]);
            },
          );
        }

        // Loading placeholders: shrink-wrap and disable internal scrolling so
        // the parent scrollable handles scrolling.
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          itemBuilder: (context, index) {
            return LoadingWidget(isFullWidth: true, numRows: 5);
          },
        );
      },
    );
  }
}
