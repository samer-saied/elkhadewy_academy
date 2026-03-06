import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../utils/colors.dart';
import '../../../course_details/data/chapter_model.dart';
import '../../../course_details/presentations/cubit/chapters_cubit.dart';
import '../../../courses/presentations/cubit/course_cubit.dart';

class ManageChapters extends StatefulWidget {
  const ManageChapters({super.key});

  @override
  State<ManageChapters> createState() => _ManageChaptersState();
}

class _ManageChaptersState extends State<ManageChapters> {
  String? _selectedCourseId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Chapters')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Text(
              "Select the course",
              style: TextStyle(color: AppColors.jonquil, fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildCourseDropdown(context),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: ElevatedButton(
          //     onPressed: () {},
          //     child: const Text('Get Chapters'),
          //   ),2
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(),
          ),
          Expanded(
            child: _selectedCourseId == null
                ? const Center(child: Text("Please select a course"))
                : BlocBuilder<ChaptersCubit, ChaptersState>(
                    bloc: GetIt.I<ChaptersCubit>()
                      ..fetchChapters(_selectedCourseId!),
                    builder: (context, state) {
                      if (state is ChaptersLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is ChaptersFailure) {
                        return Center(child: Text(state.error));
                      }
                      if (state is ChaptersLoaded) {
                        if (state.items.isEmpty) {
                          return const Center(child: Text("No Chapters Found"));
                        }
                        return ListView.builder(
                          itemCount: state.items.length,
                          itemBuilder: (context, index) {
                            return _chapterCard(context, state.items[index]);
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
          ),
        ],
      ),
    );
  }

  //////////////////  COURSES DROPDOWN //////////////////
  Widget _buildCourseDropdown(BuildContext context) {
    return BlocBuilder<CourseCubit, CourseState>(
      bloc: GetIt.I<CourseCubit>()..fetchCourseItems(),
      builder: (context, state) {
        final courses = GetIt.I<CourseCubit>().allCourses;
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
              value: _selectedCourseId,
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
              onChanged: (v) => setState(() => _selectedCourseId = v),
            ),
          ),
        );
      },
    );
  }

  Widget _chapterCard(BuildContext context, Chapter chapter) {
    return Dismissible(
      key: Key(chapter.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        color: AppColors.redWood,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [Icon(Icons.delete, color: Colors.white)],
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          GetIt.I<ChaptersCubit>().deleteChapter(
            _selectedCourseId!,
            chapter.id.toString(),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        constraints: BoxConstraints(
          minHeight: MediaQuery.sizeOf(context).height / 7,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: AppColors.lightGrey.withAlpha(90)),
        ),
        width: MediaQuery.sizeOf(context).width,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(7),
                  bottomLeft: Radius.circular(7),
                ),
                child: Container(width: 10, color: AppColors.jonquil),
              ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Center(
                        child: Opacity(
                          opacity: 0.15,
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedDashboardSquareAdd,
                            size: MediaQuery.sizeOf(context).height / 8,
                            color: AppColors.jonquil,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chapter.title,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),

                              SizedBox(height: 3),
                              Text(
                                chapter.content,
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              timeago.format(chapter.createdAt.toDate()),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
