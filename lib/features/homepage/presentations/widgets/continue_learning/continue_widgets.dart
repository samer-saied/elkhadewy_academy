import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:unimind/services/lang/app_localizations.dart';

import '../../../../../general/widgets/headers_widgets.dart';
import '../../../../../general/widgets/loading_widget.dart';
import '../../../../../utils/colors.dart';
import '../../../../course_details/presentations/cubit/chapters_cubit.dart';
import '../../../../single_chapter_view/chapter_view.dart';
import '../../../../watching_report/data/cubit/watching_report_cubit.dart';

// Widget buildHeader() {
//   return Container(
//     padding: EdgeInsets.fromLTRB(25, 20, 25, 20),
//     decoration: BoxDecoration(
//       gradient: LinearGradient(
//         colors: [Color(0xFFE8B65B), Color(0xFFD69E33)],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       ),
//       borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "STUDENT DASHBOARD",
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   "Hello, Samer!",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             CircleAvatar(
//               radius: 30,
//               backgroundColor: Colors.white24,
//               child: Icon(
//                 Icons.person,
//                 color: Colors.white,
//                 size: 40,
//               ), // استبدلها بصورة المستخدم
//             ),
//           ],
//         ),
//         // TextField(
//         //   decoration: InputDecoration(
//         //     filled: true,
//         //     fillColor: Colors.white,
//         //     hintText: "Search for courses...",
//         //     prefixIcon: Icon(Icons.search, color: Colors.grey),
//         //     border: OutlineInputBorder(
//         //       borderRadius: BorderRadius.circular(15),
//         //       borderSide: BorderSide.none,
//         //     ),
//         //   ),
//         // ),
//       ],
//     ),
//   );
// }

// 2. كارت "Continue Learning"
Widget buildContinueLearningCard() {
  return BlocBuilder<WatchingReportCubit, WatchingReportState>(
    bloc: GetIt.I.get<WatchingReportCubit>()..getLastWatchingReport(),
    builder: (context, state) {
      if (state is WatchingReportLoading) {
        return Container(
          width: double.infinity,
          height: 200,
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
          child: LoadingWidget(isFullWidth: true, numRows: 3),
        );
      }
      if (state is WatchingReportError) {
        return SizedBox();
      }
      if (state is LastWatchingReportLoaded) {
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
                              state.report.courseName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              state.report.chapterName,
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
                      onPressed: () async {
                        GetIt.I
                            .get<ChaptersCubit>()
                            .fetchlastWatchingChapter(
                              chapterId: state.report.chapterId,
                            )
                            .then((chapter) {
                              Navigator.push(
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
      return Container();
    },
  );
}
