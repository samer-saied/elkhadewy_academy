import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:unimind/features/courses/data/models/course_model.dart';
import 'package:unimind/utils/colors.dart';

import '../../../../auth/bloc/login_cubit.dart';
import '../../../../courses/presentations/cubit/course_cubit.dart';
import '../../../chapters/manage_chapters/simple_title_widget.dart';
import '../../../users/show_users.dart';
import '../../cubit/statistic_cubit.dart';
import '../../models/info_chip_model.dart';

class CountStudMaterialsTeacherScreen extends StatefulWidget {
  final bool? isAdmin;
  const CountStudMaterialsTeacherScreen({super.key, this.isAdmin = false});

  @override
  State<CountStudMaterialsTeacherScreen> createState() =>
      _CountStudMaterialsScreenState();
}

class _CountStudMaterialsScreenState
    extends State<CountStudMaterialsTeacherScreen> {
  late final StatisticCubit _statisticCubit;

  @override
  void initState() {
    super.initState();
    _statisticCubit = GetIt.I<StatisticCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Students by Materials')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //////////  Filter CARD    ///////////////////
            /////////////   SELECT WIDGET   ////////////////////////
            SimpleTitleWidget(title: "Select the course"),

            //////////  RESULTS AND CHART AREA   /////////
            BlocBuilder<StatisticCubit, StatisticState>(
              bloc: _statisticCubit,
              builder: (context, state) {
                if (state is StatisticInitial) {
                  return const Center(child: Text('Choose a Course To Start'));
                }
                if (state is StatisticLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (state is StatisticLoaded) {
                  final courses =
                      GetIt.I<LoginCubit>().currentUser!.role == "admin"
                      ? GetIt.I<CourseCubit>().allCourses
                      : GetIt.I<CourseCubit>().userCourses;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      final colorValue =
                          int.tryParse(course.color!) ??
                          0xFF000000; // Fallback to black if parsing fails

                      return GestureDetector(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShowUsersPage(
                                field: "materials",
                                value: course.id,
                                title: course.title,
                                isDelete: true,
                                isAll: false,
                              ),
                            ),
                          );
                        },
                        child: SimpleMaterialCardInfoWidget(
                          color: Color(colorValue),
                          index: index,
                          course: course,
                        ),
                      );
                    },
                  );
                }
                return const Center(child: Text('Choose a Course To Start'));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MaterialCardInfoWidget extends StatelessWidget {
  final Color color;
  final int index;
  final InfoChipModel infoChip;

  const MaterialCardInfoWidget({
    super.key,
    required this.color,
    required this.index,
    required this.infoChip,
  });

  @override
  Widget build(BuildContext context) {
    num countStudents = infoChip.countStudents;
    num totalStudents = infoChip.totalStudents;
    double percent = totalStudents == 0 ? 0.0 : countStudents / totalStudents;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(20),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 90,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: color),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                (index + 1).toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    infoChip.courseTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$countStudents / $totalStudents",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: percent.isNaN || percent.isInfinite ? 0.0 : percent,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeCap: StrokeCap.round,
                  constraints: const BoxConstraints(
                    maxHeight: 65,
                    maxWidth: 65,
                    minHeight: 50,
                    minWidth: 50,
                  ),
                ),
                Text(
                  "${(percent.isNaN || percent.isInfinite ? 0 : percent * 100).toInt()}%",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SimpleMaterialCardInfoWidget extends StatelessWidget {
  final Color color;
  final int index;
  final CourseModel course;

  const SimpleMaterialCardInfoWidget({
    super.key,
    required this.color,
    required this.index,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(20),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 90,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: color),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                (index + 1).toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Faculty: ${course.collegeTitle} - Year: ${course.yearId}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MaterialCardInfoHeaderWidget extends StatelessWidget {
  final String desc;
  final String value;

  const MaterialCardInfoHeaderWidget({
    super.key,
    required this.desc,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(20),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(height: 90, width: 20, color: AppColors.jonquil),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: AppColors.jonquil,
                    ),
                  ),
                  Text(
                    desc,
                    style: const TextStyle(
                      color: AppColors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
