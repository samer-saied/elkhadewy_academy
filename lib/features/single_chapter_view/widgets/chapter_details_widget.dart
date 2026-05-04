import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../courses/data/models/course_model.dart';
import '../../courses/presentations/cubit/course_cubit.dart';
import '../../pdfviewer/web_view_screen.dart';
import '../../watching_report/data/cubit/watching_report_cubit.dart';
import '../../watching_report/data/model/watching_model.dart';
import 'copy_right_widget.dart';
import 'warning_widget.dart';

class ChapterDetailsWidget extends StatefulWidget {
  final Chapter chapterModel;
  final DateTime startWatchingTime;
  const ChapterDetailsWidget({
    super.key,
    required this.chapterModel,
    required this.startWatchingTime,
  });

  @override
  State<ChapterDetailsWidget> createState() => _ChapterDetailsWidgetState();
}

class _ChapterDetailsWidgetState extends State<ChapterDetailsWidget> {
  CourseModel? currentCourse;

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // Show status bar and navigation bar
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    GetIt.I<CourseCubit>().findLocalCourse(widget.chapterModel.courseId).then((
      val,
    ) {
      if (mounted) {
        setState(() {
          currentCourse =
              val ??
              CourseModel(
                title: "Unknown",
                description: "",
                collegeId: "",
                collegeTitle: "Unknown",
                yearId: "",
                color: "0xFFD69E33",
              );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentCourse == null) {
      return const Padding(
        padding: EdgeInsets.all(40.0),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.jonquil),
        ),
      );
    }

    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            ///////////  2 MAIN BUTTONS //////////////////////////////
            Row(
              children: [
                InkWell(
                  onTap: () {
                    DateTime endWatchingTime = DateTime.now();
                    UserModel? currentUser = GetIt.I<LoginCubit>().currentUser;
                    if (endWatchingTime
                            .difference(widget.startWatchingTime)
                            .inSeconds >
                        60) {
                      WatchingReport currentWatchingReport = WatchingReport(
                        chapterId: widget.chapterModel.id.toString(),
                        chapterName: widget.chapterModel.title,
                        courseId: widget.chapterModel.courseId,
                        courseName: currentCourse!.title,
                        courseColor:
                            currentCourse!.color ??
                            AppColors.jonquil.toString(),
                        userId: currentUser!.id,
                        userPhone: currentUser.phone,
                        userName: currentUser.name,
                        endDate: endWatchingTime,
                        startDate: widget.startWatchingTime,
                        videoWatchedDuration: endWatchingTime
                            .difference(widget.startWatchingTime)
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
                    margin: const EdgeInsets.only(right: 5, left: 5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          currentCourse!.color == null ||
                              currentCourse!.color!.isEmpty
                          ? AppColors.jonquil
                          : Color(int.parse(currentCourse!.color!)),
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
                        currentCourse!.color == null ||
                            currentCourse!.color!.isEmpty
                        ? AppColors.jonquil
                        : Color(int.parse(currentCourse!.color!)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    "${"CHAPTER".tr(context)} ${widget.chapterModel.orderIndex}",
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ///////////  Chapter Details //////////////////////////////
            Card(
              color: AppColors.whiteColor,
              elevation: 0,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    // 3. Lesson Title
                    Text(
                      widget.chapterModel.title,
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
                            widget.chapterModel.createdAt.toDate(),
                          ),
                          color: AppColors.blackColor,
                        ),
                        _buildMetadataItem(
                          icon: Icons.schedule,
                          text: timeago.format(
                            widget.chapterModel.createdAt.toDate(),
                          ),
                          color: AppColors.blackColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // 5. Lesson Description
                    Text(
                      widget.chapterModel.content,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: AppColors.blackColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (widget.chapterModel.attachments.isNotEmpty)
                      SectionHeaderSmallWidget(title: "Attachments"),
                    if (widget.chapterModel.attachments.isNotEmpty)
                      Column(
                        children: List.generate(
                          widget.chapterModel.attachments.length,
                          (index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WebViewScreen(
                                      url: widget
                                          .chapterModel
                                          .attachments[index],
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
                                    const Icon(
                                      Icons.picture_as_pdf,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            ///////////  Create details //////////////////////////////
            // 6. Lesson Created
            Card(
              color: AppColors.whiteColor,
              elevation: 0,

              child: Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Course".tr(context),
                      style: TextStyle(
                        color: AppColors.darkGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                        vertical: 3,
                      ),
                      child: Text(
                        currentCourse!.title,
                        style: TextStyle(
                          color: AppColors.darkGrey,
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "College".tr(context),
                      style: TextStyle(
                        color: AppColors.darkGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                        vertical: 3,
                      ),
                      child: Text(
                        currentCourse!.collegeTitle,
                        style: TextStyle(
                          color: AppColors.darkGrey,
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Created By".tr(context),
                      style: TextStyle(
                        color: AppColors.darkGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                        vertical: 3,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            child: const Icon(
                              Icons.person,
                              color: AppColors.whiteColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              widget.chapterModel.createdBy,
                              style: TextStyle(
                                color: AppColors.raisinBlack,
                                fontSize: 12,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
  String totalDuration = "";
  @override
  void initState() {
    super.initState();
    _controller =
        YoutubePlayerController(
          initialVideoId: Helper.extractYoutubeId(
            widget.chapterModel.videoUrl,
          ).toString(),
          flags: YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            disableDragSeek: true,
            enableCaption: false,
            forceHD: true,
            hideThumbnail: true,
            controlsVisibleAtStart: true,
            hideControls: false,
            showLiveFullscreenButton: false,
          ),
        )..addListener(() {
          if (_controller.value.isReady) {
            getTotalDuration();
          }
        });

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

  void getTotalDuration() {
    int totalSeconds = _controller.metadata.duration.inSeconds;
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    if (hours > 0) {
      totalDuration =
          "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    } else {
      totalDuration =
          "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InteractiveViewer(
          scaleEnabled: true,
          maxScale: 4,
          minScale: 1,
          child: YoutubePlayer(
            liveUIColor: AppColors.jonquil,
            aspectRatio:
                MediaQuery.sizeOf(context).height /
                MediaQuery.sizeOf(context).width,
            controller: _controller,

            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.black,
            progressColors: ProgressBarColors(
              playedColor: const Color.fromARGB(255, 189, 162, 162),
              handleColor: Colors.black,
              bufferedColor: Colors.black,
              backgroundColor: Colors.black,
            ),
            topActions: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                width: MediaQuery.sizeOf(context).width - 20,
                decoration: BoxDecoration(
                  color: AppColors.blackColor.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(
                    5.0,
                  ), // Adjust corner radius as needed
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Remaining: ",
                          style: TextStyle(color: Colors.white),
                        ),
                        const RemainingDuration(),
                      ],
                    ),
                    Spacer(),
                    Icon(Icons.hd, color: AppColors.whiteColor),
                  ],
                ),
              ),
            ],

            bottomActions: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                width: MediaQuery.sizeOf(context).width - 20,
                decoration: BoxDecoration(
                  color: AppColors.blackColor,
                  borderRadius: BorderRadius.circular(
                    5.0,
                  ), // Adjust corner radius as needed
                ),
                child: Row(
                  children: [
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: FittedBox(child: PlayPauseButton()),
                    ),
                    CurrentPosition(),
                    const SizedBox(width: 5),

                    GestureDetector(
                      onTap: () {
                        _controller.seekTo(
                          _controller.value.position -
                              const Duration(seconds: 10),
                        );
                      },
                      child: const Icon(
                        Icons.replay_10_rounded,
                        color: AppColors.whiteColor,
                        size: 30,
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        _controller.seekTo(
                          _controller.value.position +
                              const Duration(seconds: 10),
                        );
                      },
                      child: const Icon(
                        Icons.forward_10_rounded,
                        color: AppColors.whiteColor,
                        size: 30,
                      ),
                    ),

                    ProgressBar(
                      isExpanded: true,
                      colors: const ProgressBarColors(
                        playedColor: AppColors.jonquil,
                        handleColor: AppColors.jonquilLight,
                      ),
                    ),

                    const SizedBox(width: 3),

                    Text(
                      totalDuration,
                      style: TextStyle(color: AppColors.whiteColor),
                    ),

                    const PlaybackSpeedButton(
                      icon: Icon(Icons.speed, color: AppColors.whiteColor),
                    ),
                    FullScreenButton(),
                  ],
                ),
              ),
            ],
            onReady: () {
              // _controller.addListener(listener);
            },
            onEnded: (metaData) {
              CourseModel? currentCourse;
              try {
                currentCourse = GetIt.I<CourseCubit>().userCourses.firstWhere(
                  (element) => element.id == widget.chapterModel.courseId,
                );
              } catch (_) {}
              DateTime endWatchingTime = DateTime.now();
              UserModel? currentUser = GetIt.I<LoginCubit>().currentUser;
              if (endWatchingTime
                      .difference(widget.startWatchingTime)
                      .inSeconds >
                  60) {
                WatchingReport currentWatchingReport = WatchingReport(
                  chapterId: widget.chapterModel.id.toString(),
                  chapterName: widget.chapterModel.title,
                  courseId: widget.chapterModel.courseId,
                  courseName: widget.chapterModel.title,
                  courseColor: currentCourse?.color ?? "0xFFD69E33",
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
  }
}
