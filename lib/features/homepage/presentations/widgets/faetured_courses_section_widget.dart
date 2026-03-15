import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:unimind/services/lang/app_localizations.dart';

import '../../../../general/presentations/cubits/navigation_cubit.dart';
import '../../../../general/widgets/loading_widget.dart';
import '../../../../utils/colors.dart';
import '../../../auth/bloc/login_cubit.dart';
import '../../../courses/data/models/course_model.dart';
import '../../../../features/courses/presentations/cubit/course_cubit.dart';
import '../../../../features/courses/presentations/widgets/course_gird_card_widget.dart';

class FaeturedCoursesSectionWidget extends StatefulWidget {
  const FaeturedCoursesSectionWidget({super.key});

  @override
  State<FaeturedCoursesSectionWidget> createState() =>
      _FaeturedCoursesSectionWidgetState();
}

class _FaeturedCoursesSectionWidgetState
    extends State<FaeturedCoursesSectionWidget> {
  @override
  void initState() {
    super.initState();
    final materials = GetIt.I.get<LoginCubit>().currentUser!.materials;
    print(materials);
    GetIt.I.get<CourseCubit>().fetchUsersCourse(materials: materials);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 220),
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height / 3,
      child: BlocBuilder<CourseCubit, CourseState>(
        builder: (context, state) {
          if (state is CourseLoaded) {
            List<CourseModel> courses = GetIt.I.get<CourseCubit>().userCourses;
            if (courses.isNotEmpty) {
              return ListView.builder(
                itemCount: courses.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return CourseGridCardWidget(course: courses[index]);
                  //FeaturedCourseCardWidget(currentCourse: courses[index]);
                },
              );
            } else {
              return Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: const Color(0xFFD49E3C),
                      child: const HugeIcon(
                        icon: HugeIcons.strokeRoundedVideoOff,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "You don't have Courses until now".tr(context),
                      style: TextStyle(
                        color: Color(0xFFD49E3C),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: FilledButton(
                        onPressed: () {
                          GetIt.I<NavigationCubit>().updateIndex(1);
                        },
                        child: Text(
                          "Start learning now!".tr(context),
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          return ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              LoadingWidget(isFullWidth: false, numRows: 1),
              LoadingWidget(isFullWidth: false, numRows: 1),
              LoadingWidget(isFullWidth: false, numRows: 1),
            ],
          );
        },
      ),
    );
  }
}
