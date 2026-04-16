import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:timelines_plus/timelines_plus.dart';
import 'package:unimind/core/databases/cache/cache_helper.dart';
import 'package:unimind/features/course_details/presentations/cubit/request_show_course_cubit.dart';
import 'package:unimind/services/lang/app_localizations.dart';

import '../../../../../utils/helper.dart';
import '../../../../general/widgets/loading_widget.dart';
import '../../../../utils/colors.dart';
import '../../../auth/bloc/login_cubit.dart';
import '../../../courses/data/models/course_model.dart';
import '../../../single_chapter_view/chapter_view.dart';
import '../cubit/chapters_cubit.dart';

class ChaptersCourseWidget extends StatelessWidget {
  const ChaptersCourseWidget({super.key, required this.course});

  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    final color = Helper.getCourseColor(course.color);

    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        color: AppColors.whiteColor,
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              GetIt.I<LoginCubit>().currentUser!.materials.contains(course.id)
              ? ChaptersChipsWidget(
                  color: color,
                  courseId: course.id.toString(),
                )
              : ListTile(
                  title: Text("access_course".tr(context)),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child:
                        BlocConsumer<
                          RequestShowCourseCubit,
                          RequestShowCourseState
                        >(
                          bloc: GetIt.I<RequestShowCourseCubit>(),
                          listener: (context, state) {
                            if (state is RequestShowCourseLoaded) {
                              if (state.isSuccess) {
                                CacheHelper().saveData(
                                  key: 'requested_course_${course.id}',
                                  value: true,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.message),
                                    backgroundColor: AppColors.emerald,
                                  ),
                                );
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.message),
                                  backgroundColor: AppColors.redWood,
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            final bool hasRequested =
                                CacheHelper().getData(
                                  key: 'requested_course_${course.id}',
                                ) ??
                                false;

                            if (state is RequestShowCourseInitial) {
                              return ElevatedButton(
                                onPressed: hasRequested
                                    ? null
                                    : () {
                                        GetIt.I<RequestShowCourseCubit>()
                                            .requestShowCourse(course: course);
                                      },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0,
                                      ),
                                      child: HugeIcon(
                                        icon: HugeIcons
                                            .strokeRoundedShoppingBag02,
                                        color: AppColors.whiteColor,
                                      ),
                                    ),
                                    Text(
                                      hasRequested
                                          ? "pending request".tr(context)
                                          : "Request it now".tr(context),
                                    ),
                                  ],
                                ),
                              );
                            }
                            if (state is RequestShowCourseLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ElevatedButton(
                              onPressed: hasRequested
                                  ? null
                                  : () {
                                      GetIt.I<RequestShowCourseCubit>()
                                          .requestShowCourse(course: course);
                                    },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0,
                                    ),
                                    child: HugeIcon(
                                      icon:
                                          HugeIcons.strokeRoundedShoppingBag02,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                  Text(
                                    hasRequested
                                        ? "pending request".tr(context)
                                        : "Request it now".tr(context),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                  ),
                ),
        ),
      ),
    );
  }
}

class ChaptersChipsWidget extends StatefulWidget {
  final String courseId;
  final Color color;

  const ChaptersChipsWidget({
    super.key,
    required this.color,
    required this.courseId,
  });

  @override
  State<ChaptersChipsWidget> createState() => _ChaptersChipsWidgetState();
}

class _ChaptersChipsWidgetState extends State<ChaptersChipsWidget> {
  late final ChaptersCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = GetIt.instance<ChaptersCubit>();
    _cubit.fetchChapters(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChaptersCubit, ChaptersState>(
      bloc: _cubit,
      builder: (context, state) {
        if (state is ChaptersLoaded) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ////////////  CHAPTERS COUNT   ////////////
              Text(
                '${"Chapters".tr(context)}: ${state.items.length}',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: widget.color,
                  fontWeight: FontWeight.bold,
                ),
              ),

              ////////////  CHAPTERS TIMELINE   ////////////
              TimeLineWidget(color: widget.color, items: state.items),
            ],
          );
        }
        return Card(
          color: AppColors.whiteColor,
          child: SizedBox(
            height: 300,
            child: LoadingWidget(isFullWidth: true, numRows: 4),
          ),
        );
      },
    );
  }
}

class TimeLineWidget extends StatelessWidget {
  const TimeLineWidget({super.key, required this.color, required this.items});

  final Color color;
  final List items;

  @override
  Widget build(BuildContext context) {
    return Timeline.tileBuilder(
      reverse: true,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      theme: TimelineThemeData(
        nodePosition: 0.1,
        nodeItemOverlap: true,
        color: color,
        indicatorTheme: const IndicatorThemeData(position: 0, size: 20.0),
        connectorTheme: const ConnectorThemeData(thickness: 2.5),
        indicatorPosition: 0.20,
      ),
      builder: TimelineTileBuilder.connected(
        indicatorBuilder: (context, index) {
          return Column(
            children: const [
              SizedBox(height: 30.0, child: SolidLineConnector()),
              DotIndicator(),
              SizedBox(height: 50.0, child: SolidLineConnector()),
            ],
          );
        },
        oppositeContentsBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(7.0),
          child: Text(
            '${index + 1}',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        contentsBuilder: (context, index) {
          final chapter = items[index];
          final title = chapter.title;
          final desc = chapter.content;

          return Padding(
            padding: const EdgeInsets.all(7.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SingleChapterScreen(singleChapter: chapter),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                decoration: BoxDecoration(
                  color: color.withAlpha(10),
                  borderRadius: BorderRadius.circular(7),
                  border: BoxBorder.all(color: color),
                  boxShadow: [
                    BoxShadow(
                      color: color.withAlpha(10),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      desc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${"Since".tr(context)}: ${timeago.format(chapter.createdAt.toDate())}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall!.copyWith(color: color),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: items.length,
      ),
    );
  }
}
