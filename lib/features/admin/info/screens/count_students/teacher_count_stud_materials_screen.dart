import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:unimind/features/courses/data/models/course_model.dart';
import 'package:unimind/utils/colors.dart';

import '../../../chapters/add_chapter/drop_down_widget.dart';
import '../../../chapters/manage_chapters/simple_title_widget.dart';
import '../../../users/widgets/user_card_widget.dart';
import '../../cubit/statistic_cubit.dart';
import '../../models/info_chip_model.dart';

class CountStudMaterialsTeacherScreen extends StatefulWidget {
  const CountStudMaterialsTeacherScreen({super.key});

  @override
  State<CountStudMaterialsTeacherScreen> createState() =>
      _CountStudMaterialsScreenState();
}

class _CountStudMaterialsScreenState
    extends State<CountStudMaterialsTeacherScreen> {
  String _selectedCourseId = '';

  @override
  void initState() {
    super.initState();
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
            BuildCourseDropDown(
              selectedCourseId: _selectedCourseId,
              onChanged: (v) {
                _selectedCourseId = v;
                GetIt.I<StatisticCubit>().getUsersDataByMaterial(
                  materialId: _selectedCourseId,
                );
                setState(() {});
              },
            ),
            //////////  RESULTS AND CHART AREA   /////////
            BlocBuilder<StatisticCubit, StatisticState>(
              bloc: GetIt.I<StatisticCubit>(),
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

                if (state is StatisticLoaded && _selectedCourseId != '') {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                            right: 10,
                            top: 5,
                          ),
                          child: Divider(),
                        ),
                        TotalReportWidget(
                          text: "Total Reports",
                          totalNum: GetIt.I<StatisticCubit>().users.length
                              .toString(),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: GetIt.I<StatisticCubit>().users.length,
                          itemBuilder: (context, index) {
                            return UserCardWidget(
                              index: index,
                              student: GetIt.I<StatisticCubit>().users[index],
                              isDelete: true,
                              isAdmin: false,
                              // GetIt.I<LoginCubit>().currentUser!.role ==
                              // "admin",
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }
                return Center(
                  child: Padding(
                    padding: EdgeInsetsGeometry.only(
                      top: MediaQuery.sizeOf(context).height / 4,
                    ),
                    child: Text('Choose a Course To Start'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TotalReportWidget extends StatelessWidget {
  final String text;
  final String totalNum;

  const TotalReportWidget({
    super.key,
    required this.text,
    required this.totalNum,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: AppColors.jonquilLight,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                totalNum,
                style: TextStyle(
                  color: AppColors.jonquil,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
