// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:unimind/services/lang/app_localizations.dart';

import '../../../../../general/widgets/headers_widgets.dart';
import '../../../../../general/widgets/loading_widget.dart';
import '../../../../../utils/colors.dart';
import '../../../../auth/bloc/login_cubit.dart';
import '../../../../course_details/data/chapter_model.dart';
import '../../../../course_details/presentations/cubit/chapters_cubit.dart';
import '../../../../courses/data/models/course_model.dart';
import '../../../../courses/presentations/cubit/course_cubit.dart';
import 'latest_chapter_card_widget.dart';

class LatestChapterSectionWidget extends StatefulWidget {
  const LatestChapterSectionWidget({super.key});

  @override
  State<LatestChapterSectionWidget> createState() =>
      _LatestChapterSectionWidgetState();
}

class _LatestChapterSectionWidgetState
    extends State<LatestChapterSectionWidget> {
  @override
  void initState() {
    super.initState();
    List<String> userMaterials = GetIt.I
        .get<LoginCubit>()
        .currentUser!
        .materials;
    GetIt.I.get<ChaptersCubit>().latestChaptersFunc(
      userMaterials: userMaterials,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<ChaptersCubit, ChaptersState>(
          bloc: GetIt.I.get<ChaptersCubit>(),
          builder: (context, state) {
            if (state is ChaptersLoaded) {
              List<Chapter> latestChapters = GetIt.I
                  .get<ChaptersCubit>()
                  .latestChapters;

              return Column(
                children: [
                  latestChapters.isNotEmpty
                      ? SectionHeaderWidget(
                          title: "Latest Chapters".tr(context),
                          action: "",
                        )
                      : SizedBox(),

                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: latestChapters.length,
                    itemBuilder: (context, index) {
                      CourseModel? course = GetIt.I<CourseCubit>().userCourses
                          .firstWhereOrNull(
                            (element) =>
                                element.id.toString() ==
                                latestChapters[index].courseId,
                          );

                      return LatestChapterCardWidget(
                        chapter: latestChapters[index],
                        cardColor:
                            course == null ||
                                course.color == null ||
                                course.color!.isEmpty ||
                                course.color == ""
                            ? AppColors.jonquil
                            : Color(int.parse(course.color.toString())),
                        course: course,
                      );
                    },
                  ),
                ],
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
        ),
      ],
    );
  }
}
