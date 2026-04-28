import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:unimind/services/lang/app_localizations.dart';

import '../../../../../general/widgets/headers_widgets.dart';
import '../../../../../general/widgets/loading_widget.dart';
import '../../../../../utils/colors.dart';
import '../../../../course_details/presentations/cubit/chapters_cubit.dart';
import '../../../../single_chapter_view/chapter_view.dart';
import '../../../../watching_report/data/cubit/watching_report_cubit.dart';

// 2. كارت "Continue Learning"
Widget buildContinueLearningCard(BuildContext context) {
  return FutureBuilder(
    future: GetIt.I<WatchingReportCubit>().getLastWatchingReport(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return LoadingWidget(isFullWidth: true, numRows: 3);
      }
      if (snapshot.hasError) {
        return SizedBox();
      }
      if (snapshot.hasData && snapshot.data != null) {
        return Column(
          children: [
            SectionHeaderWidget(
              title: "Continue Learning".tr(context),
              action: "ACTIVE NOW".tr(context),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey.withAlpha(50),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedPlay,
                            color: AppColors.mainColor,
                            size: 30,
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data!.courseName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              snapshot.data!.chapterName,
                              style: TextStyle(fontSize: 14),
                            ),
                            // Text(
                            //   "Progress: 72%",
                            //   style: TextStyle(color: Colors.grey, fontSize: 13),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 30),
                  //   child: Divider(color: AppColors.mainColor, thickness: 2),
                  // ),
                  // // LinearProgressIndicator(
                  //   value: 0.72,
                  //   backgroundColor: Colors.grey[200],
                  //   valueColor: AlwaysStoppedAnimation(AppColors.mainColor),
                  // ),
                  // SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        GetIt.I
                            .get<ChaptersCubit>()
                            .fetchlastWatchingChapter(
                              chapterId: snapshot.data!.chapterId,
                            )
                            .then((chapter) {
                              if (chapter == null) {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Chapter not found"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              Navigator.push(
                                // ignore: use_build_context_synchronously
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SingleChapterScreen(
                                    singleChapter: chapter,
                                  ),
                                ),
                              );
                            });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.jonquil,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(
                        "RESUME CHAPTER".tr(context),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }
      return SizedBox();
    },
  );
}
