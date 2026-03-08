import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:headset_connection_event/headset_event.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:unimind/services/lang/app_localizations.dart';

import '../../utils/colors.dart';
import '../auth/bloc/login_cubit.dart';
import '../course_details/data/chapter_model.dart';
import 'widgets/chapter_details_widget.dart';
import 'widgets/warning_widget.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPermission() async {
  if (!Platform.isAndroid) return true;
  return Permission.bluetoothConnect.request().isGranted;
}

class SingleChapterScreen extends StatefulWidget {
  final Chapter singleChapter;
  const SingleChapterScreen({super.key, required this.singleChapter});

  @override
  State<SingleChapterScreen> createState() => _SingleChapterScreenState();
}

class _SingleChapterScreenState extends State<SingleChapterScreen> {
  final _headsetPlugin = HeadsetEvent();
  HeadsetState? _headsetState;
  String errorMsg = "";

  @override
  void initState() {
    super.initState();

    ///Request Permissions (Required for Android 12)
    requestPermission();

    /// if headset is plugged
    _headsetPlugin.getCurrentState.then((val) {
      setState(() {
        _headsetState = val;
      });
    });

    /// Detect the moment headset is plugged or unplugged
    _headsetPlugin.setListener((val) {
      setState(() {
        _headsetState = val;
      });
    });
  }

  bool isValid() {
    final currentStudent = GetIt.I<LoginCubit>().currentUser;

    if (currentStudent!.role == "admin") {
      return true;
    } else {
      if (currentStudent.status == "active") {
        if (currentStudent.statusEnableHeadset == false ||
            _headsetState == HeadsetState.CONNECT) {
          return true;
        } else {
          errorMsg = "headset";
          return false;
        }
      } else {
        errorMsg = "inactive";
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ScrollController scrollController = ScrollController();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(backgroundColor: AppColors.jonquil, elevation: 0),
      ),
      body: SingleChildScrollView(
        // controller: scrollController,
        child: Column(
          children: [
            isValid()
                ? VideoPlayerWidget(
                    chapterModel: widget.singleChapter,
                    startWatchingTime: DateTime.now(),
                  )
                : WarningWidget(
                    errorMsg: errorMsg == "inactive"
                        ? 'you are Not allowed to this play video.'.tr(context)
                        : "${"Sorry".tr(context)}, ${'Unable to play video until you Plug headset in'.tr(context)}",
                    errorDes: errorMsg == "inactive"
                        ? "Please, Contact admininstrator".tr(context)
                        : "Headset NOT Connected".tr(context),
                    iconWidget: errorMsg == "inactive"
                        ? const HugeIcon(
                            icon: HugeIcons.strokeRoundedUserWarning01,
                            size: 40,
                            color: AppColors.redWood,
                          )
                        : null,
                  ),
            ChapterDetailsWidget(
              chapterModel: widget.singleChapter,
              startWatchingTime: DateTime.now(),
            ),
          ],
        ),
      ),
    );
  }
}
