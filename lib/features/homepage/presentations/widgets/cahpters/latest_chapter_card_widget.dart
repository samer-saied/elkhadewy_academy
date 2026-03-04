import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../utils/colors.dart';
import '../../../../course_details/data/chapter_model.dart';
import '../../../../courses/data/models/course_model.dart';
import '../../../../single_chapter_view/chapter_view.dart';

class LatestChapterCardWidget extends StatelessWidget {
  final Chapter chapter;
  final Color? cardColor;
  final CourseModel? course;

  const LatestChapterCardWidget({
    super.key,
    required this.chapter,
    this.cardColor,
    this.course,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleChapterScreen(singleChapter: chapter),
          ),
        );
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
                child: Container(
                  width: 10,
                  color: cardColor ?? colorScheme.primary,
                ),
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
                            color: cardColor ?? colorScheme.primary,
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
                              Text(chapter.title, style: textTheme.titleLarge),

                              SizedBox(height: 3),
                              Text(
                                chapter.content,
                                style: textTheme.bodyMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(course!.title, style: textTheme.bodyMedium),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                timeago.format(chapter.createdAt.toDate()),
                                style: textTheme.bodySmall,
                              ),
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
