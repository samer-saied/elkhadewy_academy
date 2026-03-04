import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unimind/services/lang/app_localizations.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../../utils/colors.dart';
import '../../data/models/course_model.dart';

///////////// 2ND COURSE CARD WITH BOTTOM TITLE WITH GRADIENT COLOR ONLY /////////////
class FeaturedCourseCardWidget extends StatelessWidget {
  final CourseModel currentCourse;
  final int? index;
  const FeaturedCourseCardWidget({
    super.key,
    required this.currentCourse,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.courseDetails,
          arguments: currentCourse,
        );
      },
      child: Container(
        height: MediaQuery.sizeOf(context).height / 3,
        margin: EdgeInsets.symmetric(horizontal: 5),
        width: MediaQuery.sizeOf(context).width / 2.3,
        clipBehavior: Clip.antiAlias,
        constraints: BoxConstraints(minHeight: 220),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(
            color: AppColors.lightGrey.withAlpha(50),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Flexible(
              flex: 4,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.80,
                      child: Hero(
                        tag: currentCourse.id ?? "None".tr(context),
                        child:
                            currentCourse.imgLink != null &&
                                currentCourse.imgLink!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: currentCourse.imgLink!,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/logo/logo_light.jpg",
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: index != null && index! % 2 == 0
                        ? AlignmentGeometry.topRight
                        : AlignmentGeometry.topLeft,
                    end: AlignmentGeometry.bottomCenter,
                    colors: [
                      currentCourse.color == null
                          ? AppColors.mainColor.withAlpha(95)
                          : Color(
                              int.parse(currentCourse.color!),
                            ).withAlpha(95),
                      currentCourse.color == null
                          ? AppColors.mainColor
                          : Color(int.parse(currentCourse.color!)),
                    ],
                  ),
                ),
                padding: const EdgeInsets.only(bottom: 3.0, left: 5, right: 5),
                child: Center(
                  child: Center(
                    child: Text(
                      currentCourse.title,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: AppColors.whiteColor,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
