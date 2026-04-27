import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:unimind/services/lang/app_localizations.dart';

import '../../../../utils/colors.dart';
import '../../../course_details/presentations/screens/course_details_page.dart';
import '../../../homepage/presentations/cubit/category_cubit.dart';
import '../../data/models/course_model.dart';

///////////// COURSE CARD WITH ((TOP LABEL && BOTTOM TITLE)) WITH GRADIENT COLOR /////////////
class CourseGridCardWidget extends StatelessWidget {
  final CourseModel course;

  const CourseGridCardWidget({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    Size sizeWidget = MediaQuery.sizeOf(context);
    return InkWell(
      onTap: () {
        // Navigate to course details page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailsPage(course: course),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        clipBehavior: Clip.antiAlias,
        height: sizeWidget.height / 4,
        width: sizeWidget.width / 2.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: BoxBorder.all(color: AppColors.lightGrey.withAlpha(30)),
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // Get the maximum available width from the parent
            return Stack(
              children: [
                // BackGround Image
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.80,
                    child: Hero(
                      tag: course.id ?? "None".tr(context),
                      child:
                          course.imgLink != null && course.imgLink!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: course.imgLink!,
                              fit: BoxFit.cover,
                              memCacheWidth: 400,
                              errorWidget: (context, url, error) => Center(
                                child: HugeIcon(
                                  icon: HugeIcons.strokeRoundedImageCrop,
                                  color: AppColors.grey.withAlpha(80),
                                ),
                              ),
                            )
                          : Image.asset(
                              "assets/logo/logo_light.jpg",
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                // Top Label - Gategory
                Positioned(
                  top: 15,
                  left: 0,
                  // right: parentWidth * 0.3,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(70),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(1, 2),
                        ),
                      ],

                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(7),
                        bottomRight: Radius.circular(7),
                      ),
                      color: course.color == null
                          ? AppColors.raisinBlack
                          : Color(int.parse(course.color!)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        maxLines: 2,
                        (course.collegeId.isEmpty)
                            ? "General".tr(context)
                            : GetIt.I<CategoryCubit>().categories
                                  .firstWhere(
                                    (element) => element.id == course.collegeId,
                                  )
                                  .title,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: AppColors.whiteColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                // Bottom Title Text
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    constraints: BoxConstraints(minHeight: 60),
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.blackColor.withAlpha(70),
                          AppColors.blackColor,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            course.title,
                            style: Theme.of(context).textTheme.titleSmall!
                                .copyWith(
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
