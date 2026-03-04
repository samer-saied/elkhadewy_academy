// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../../general/widgets/loading_widget.dart';
import '../../../../../utils/colors.dart';
import '../../../../auth/bloc/login_cubit.dart';
import '../../../../course_details/data/chapter_model.dart';
import '../../../../course_details/presentations/cubit/chapters_cubit.dart';
import '../../../../courses/data/models/course_model.dart';
import '../../../../courses/presentations/cubit/course_cubit.dart';
import 'latest_chapter_card_widget.dart';

class LatestChapterSectionWidget extends StatelessWidget {
  const LatestChapterSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;
    // final textTheme = Theme.of(context).textTheme;
    List<String> userMaterials = GetIt.I
        .get<LoginCubit>()
        .currentUser!
        .materials;
    return BlocBuilder<ChaptersCubit, ChaptersState>(
      bloc: GetIt.I.get<ChaptersCubit>()
        ..latestChaptersFunc(userMaterials: userMaterials),
      builder: (context, state) {
        if (state is ChaptersLoaded) {
          List<Chapter> latestChapters = GetIt.I
              .get<ChaptersCubit>()
              .latestChapters;

          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: latestChapters.length,
            itemBuilder: (context, index) {
              CourseModel? course = GetIt.I<CourseCubit>().userCourses
                  .firstWhereOrNull(
                    (element) =>
                        element.id.toString() == latestChapters[index].courseId,
                  );

              return LatestChapterCardWidget(
                chapter: latestChapters[index],
                cardColor: course!.color == null || course.color!.isEmpty
                    ? AppColors.jonquil
                    : Color(int.parse(course.color.toString())),
                course: course,
              );
            },
          );
        }
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, index) {
            return LoadingWidget(isFullWidth: true, numRows: 2);
          },
        );
      },
    );
  }
}
