import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:screen_capture_event/screen_capture_event.dart';
import 'package:timeago/timeago.dart' as timeago;
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:unimind/general/widgets/headers_widgets.dart';
import 'package:unimind/services/lang/app_localizations.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../utils/colors.dart';
import '../../../utils/helper.dart';
import '../../auth/bloc/login_cubit.dart';
import '../../auth/models/user_model.dart';
import '../../course_details/data/chapter_model.dart';
import '../../courses/presentations/cubit/course_cubit.dart';
import '../../pdfviewer/web_view_screen.dart';
import '../../watching_report/data/cubit/watching_report_cubit.dart';
import '../../watching_report/data/model/watching_model.dart';
import 'copy_right_widget.dart';
import 'warning_widget.dart';

class ChapterDetailsWidget extends StatelessWidget {
  final Chapter chapterModel;
  final DateTime startWatchingTime;
  const ChapterDetailsWidget({
    super.key,
    required this.chapterModel,
    required this.startWatchingTime,
  });

  @override
  Widget build(BuildContext context) {
    final currentCourse = GetIt.I<CourseCubit>().userCourses.firstWhere(
      (element) => element.id == chapterModel.courseId,
    );
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            Row(
              children: [
                InkWell(
                  onTap: () {
                    DateTime endWatchingTime = DateTime.now();
                    UserModel? currentUser = GetIt.I<LoginCubit>().currentUser;
                    if (endWatchingTime
                            .difference(startWatchingTime)
                            .inSeconds >
                        60) {
                      WatchingReport currentWatchingReport = WatchingReport(
                        chapterId: chapterModel.id.toString(),
                        chapterName: chapterModel.title,
                        courseId: chapterModel.courseId,
                        courseName: currentCourse.title,
                        courseColor:
                            currentCourse.color ?? AppColors.jonquil.toString(),
                        userId: currentUser!.id,
                        userPhone: currentUser.phone,
                        userName: currentUser.name,
                        endDate: endWatchingTime,
                        startDate: startWatchingTime,
                        videoWatchedDuration: endWatchingTime
                            .difference(startWatchingTime)
                            .inSeconds
                            .toString(),
                        videoWatchedFinished: true,
                      );
                      GetIt.I<WatchingReportCubit>().addWatchingReport(
                        watchingReport: currentWatchingReport,
                      );
                    }
                    Navigator.pop(context);

                    /////////
                    ///
                    ///
                    ///
                    ///
                    ///
                    ///
                    ///
                    ///
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12, left: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          currentCourse.color == null ||
                              currentCourse.color!.isEmpty
                          ? AppColors.jonquil
                          : Color(int.parse(currentCourse.color!)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.arrow_back, color: AppColors.whiteColor),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        currentCourse.color == null ||
                            currentCourse.color!.isEmpty
                        ? AppColors.jonquil
                        : Color(int.parse(currentCourse.color!)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    "${"CHAPTER".tr(context)} ${chapterModel.orderIndex}",
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            // 3. Lesson Title
            Text(
              chapterModel.title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 20),

            // 4. Author & Time Metadata
            Wrap(
              spacing: 24,
              children: [
                _buildMetadataItem(
                  icon: Icons.calendar_today_outlined,
                  text: DateFormat.yMMMd().format(
                    chapterModel.createdAt.toDate(),
                  ),
                  color: AppColors.blackColor,
                ),
                _buildMetadataItem(
                  icon: Icons.schedule,
                  text: timeago.format(chapterModel.createdAt.toDate()),
                  color: AppColors.blackColor,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 5. Lesson Description
            Text(
              chapterModel.content,
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 20),
            if (chapterModel.attachments.isNotEmpty)
              SectionHeaderSmallWidget(title: "Attachments"),
            if (chapterModel.attachments.isNotEmpty)
              Column(
                children: List.generate(chapterModel.attachments.length, (
                  index,
                ) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebViewScreen(
                            url: chapterModel.attachments[index],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.picture_as_pdf, color: Colors.red),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "File No. ${index + 1}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Text(
                                  "pdf file",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),

            // 6. Lesson Created
            const SizedBox(height: 20),
            Text(
              "${"Course".tr(context)}: ${currentCourse.title}",
              style: TextStyle(
                color: AppColors.darkGrey,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 5),

            Text(
              "${"College".tr(context)}: ${currentCourse.collegeTitle}",
              style: TextStyle(
                color: AppColors.darkGrey,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "${"Created By".tr(context)}: ${chapterModel.createdBy}",
              style: TextStyle(
                color: AppColors.darkGrey,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 40), // Bottom padding
          ],
        ),
      ),
    );
  }
}

// --- Helper Widgets ---

Widget _buildMetadataItem({
  required IconData icon,
  required String text,
  required Color color,
}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: color, size: 18),
      const SizedBox(width: 8),
      Text(text, style: TextStyle(color: color, fontSize: 14)),
    ],
  );
}

class VideoPlayerWidget extends StatefulWidget {
  final Chapter chapterModel;
  final DateTime startWatchingTime;
  const VideoPlayerWidget({
    super.key,
    required this.chapterModel,
    required this.startWatchingTime,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late YoutubePlayerController _controller;
  final ScreenCaptureEvent screenListener = ScreenCaptureEvent();
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: Helper.extractYoutubeId(
        widget.chapterModel.videoUrl,
      ).toString(),
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        disableDragSeek: true,
      ),
    );

    ////////////// LISTEN SCREEN RECORDING  ////////////////
    screenListener.addScreenRecordListener((recorded) {
      ///Recorded was your record status (bool)
      setState(() {
        _isRecording = recorded;
        _controller.pause();
      });
    });

    screenListener.addScreenShotListener((filePath) {
      ///filePath only available for Android
      setState(() {
        _isRecording = true;
        _controller.pause();
        // _controller.dispose();
      });
    });

    ///Start watch
    screenListener.watch();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.amber,

        progressColors: const ProgressBarColors(
          playedColor: Colors.amber,
          handleColor: Colors.amberAccent,
        ),
        onReady: () {
          // _controller.addListener(listener);
        },
        onEnded: (metaData) {
          final currentCourse = GetIt.I<CourseCubit>().userCourses.firstWhere(
            (element) => element.id == widget.chapterModel.courseId,
          );
          DateTime endWatchingTime = DateTime.now();
          UserModel? currentUser = GetIt.I<LoginCubit>().currentUser;
          if (endWatchingTime.difference(widget.startWatchingTime).inSeconds >
              60) {
            WatchingReport currentWatchingReport = WatchingReport(
              chapterId: widget.chapterModel.id.toString(),
              chapterName: widget.chapterModel.title,
              courseId: widget.chapterModel.courseId,
              courseName: widget.chapterModel.title,
              courseColor: currentCourse.color ?? AppColors.jonquil.toString(),
              userId: currentUser!.id,
              userPhone: currentUser.phone,
              userName: currentUser.name,
              endDate: endWatchingTime,
              startDate: widget.startWatchingTime,
              videoWatchedDuration: endWatchingTime
                  .difference(widget.startWatchingTime)
                  .inSeconds
                  .toString(),
              videoWatchedFinished: false,
            );
            GetIt.I<WatchingReportCubit>().addWatchingReport(
              watchingReport: currentWatchingReport,
            );
          }
          /////////
          ///
          ///
          ///
          ///
          ///
          ///
          ///
          ///
        },
      ),
      builder: (BuildContext context, Widget player) {
        return Stack(
          children: [
            InteractiveViewer(
              scaleEnabled: true,
              maxScale: 4,
              minScale: 1,
              child: player,
            ),
            CopyRigthsWidget(isSafeArea: true),
            CopyRigthsWidget(),
            if (_isRecording)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withAlpha(70),
                  child: Center(
                    child: WarningWidget(
                      errorMsg: "Illegal Action",
                      errorDes: "Recording is not allowed",
                      iconWidget: Image.asset(
                        "assets/images/logo.png",
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
