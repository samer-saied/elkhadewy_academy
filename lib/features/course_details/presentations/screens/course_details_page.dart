import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unimind/services/lang/app_localizations.dart';

import '../../../../../utils/colors.dart';
import '../../../../../utils/helper.dart';
import '../../../courses/data/models/course_model.dart';
import '../widgets/course_details_widget.dart';
import '../widgets/timeline_widget.dart';

class CourseDetailsPage extends StatelessWidget {
  final CourseModel course;
  const CourseDetailsPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    print(course.title);
    Color courseColor = Helper.getCourseColor(course.color);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(backgroundColor: courseColor, elevation: 0),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.whiteColor,
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.blackColor,
                ),
              ),
            ),
            expandedHeight: 150.0,
            backgroundColor: courseColor,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                course.title,
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 16.0,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(1.0, 3.0),
                      blurRadius: 10.0,
                      color: AppColors.whiteColor,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              background: Hero(
                tag: course.id ?? "None".tr(context),
                child: course.imgLink != null && course.imgLink!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: course.imgLink!,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        "assets/logo/logo_light.jpg",
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: CourseDetailsWidget(
              course: course,
              courseColor: courseColor,
            ),
          ),

          SliverToBoxAdapter(child: ChaptersCourseWidget(course: course)),
        ],
      ),
    );
  }
}
