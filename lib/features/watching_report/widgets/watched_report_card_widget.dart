import 'package:flutter/material.dart';

import '../../../utils/colors.dart';
import '../data/model/watching_model.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class WatchedReportCardWidget extends StatelessWidget {
  final String number;
  final WatchingReport report;
  final double? widgetSize;

  const WatchedReportCardWidget({
    super.key,
    required this.number,
    required this.report,
    this.widgetSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width:
          MediaQuery.sizeOf(context).width *
          (widgetSize != null ? widgetSize! : 0.8),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Icon(
              Icons.circle,
              color:
                  // report.courseColor.isEmpty || report.courseColor == ""
                  //     ?
                  AppColors.jonquil,
              // : Color(int.parse(report.courseColor.toString())),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: VerticalDivider(thickness: 1, color: AppColors.darkGrey),
          ),
          Expanded(
            flex: 9,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // color: CupertinoColors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ////////////// TITLE ////////////////////
                  Text(
                    report.chapterName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  ////////////// Material ////////////////////
                  Text(
                    report.courseName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 16,
                      color:
                          // report.courseColor.isEmpty
                          //     ?
                          AppColors.jonquil,
                      // : Color(int.parse(report.courseColor.toString())),
                    ),
                  ),

                  ////////////// User Name ////////////////////
                  Text(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    "User: ${report.userName}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    "User Phone: ${report.userPhone}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    "Start : ${DateFormat.yMMMd().add_jm().format(report.startDate)}",
                    maxLines: 2,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    "End : ${DateFormat.yMMMd().add_jm().format(report.endDate)}",
                    maxLines: 2,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  ////////////// Date ////////////////////
                  Wrap(
                    children: [
                      Text(
                        "Period : ",
                        maxLines: 2,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        "${(int.tryParse(report.videoWatchedDuration) ?? 0) ~/ 3600} Hours",
                        maxLines: 2,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          "${(int.tryParse(report.videoWatchedDuration) ?? 0) % 3600 ~/ 60} Minutes",
                          maxLines: 2,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Text(
                        "${(int.tryParse(report.videoWatchedDuration) ?? 0) % 60} Seconds",
                        maxLines: 2,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Text(
                    "Watched To End : ${report.videoWatchedFinished}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 12,
                      color: AppColors.blackColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
