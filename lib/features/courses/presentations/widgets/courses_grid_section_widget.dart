import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:unimind/services/lang/app_localizations.dart';

import '../../../../general/widgets/loading_widget.dart';
import '../../../../utils/colors.dart';
import '../cubit/course_cubit.dart';
import 'featured_course_card_widget.dart';

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
      bloc: GetIt.I.get<CourseCubit>()..fetchSpecificCourses(collegeId, yearId),
      builder: (context, state) {
        if (state is CourseLoaded) {
          final items = state.items;
          if (items.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 7.0,
                vertical: 14,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedAlbumNotFound02,
                    color: AppColors.jonquil,
                    size: 60,
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    title: Text(
                      "No Courses Available Now, Please Try Again Later".tr(
                        context,
                      ),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
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
                return FeaturedCourseCardWidget(
                  currentCourse: items[index],
                  index: index,
                );
              },
            ),
          );
        }

        // Loading placeholders
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
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
