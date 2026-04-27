import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:unimind/services/lang/app_localizations.dart';

import '../../../../utils/colors.dart';
import '../../../course_details/presentations/screens/course_details_page.dart';
import '../../data/models/course_model.dart';

class CourseListCardWidget extends StatelessWidget {
  final CourseModel course;

  const CourseListCardWidget({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final sizeTheme = MediaQuery.sizeOf(context);
    final color = course.color == null
        ? AppColors.mainColor
        : Color(int.parse(course.color!));

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailsPage(course: course),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        constraints: BoxConstraints(minHeight: sizeTheme.height / 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: BoxBorder.all(color: color.withAlpha(50)),
          // AppColors.lightGrey.withAlpha(70)),
        ),
        width: sizeTheme.width,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(7),
                  bottomLeft: Radius.circular(7),
                ),
                child: SizedBox(
                  width: sizeTheme.width / 4,
                  child: Hero(
                    tag: course.id ?? "None".tr(context),
                    child: course.imgLink != null && course.imgLink!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: course.imgLink!,
                            fit: BoxFit.cover,
                            memCacheWidth: 200,
                          )
                        : Image.asset(
                            "assets/logo/logo_light.jpg",
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: <Widget>[
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
                                course.title,
                                style: textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                course.description,
                                style: textTheme.bodySmall!.copyWith(
                                  color: AppColors.grey,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          // cardSubtitle != null
                          //     ? Text(
                          //         cardSubtitle.toString(),
                          //         maxLines: 1,
                          //         style: textTheme.bodySmall?.copyWith(
                          //           color: cardColor ?? colorScheme.onPrimary,
                          //         ),
                          //         overflow: TextOverflow.ellipsis,
                          //       )
                          //     : SizedBox(),
                          // Expanded(
                          //   child: Align(
                          //     alignment: Alignment.bottomRight,
                          //     child: Text(
                          //       timeago.format(DateTime.parse(cardDateTime)),
                          //       style: textTheme.bodySmall,
                          //     ),
                          //   ),
                          // ),
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
