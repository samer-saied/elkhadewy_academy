import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:unimind/services/lang/app_localizations.dart';

import '../../../utils/colors.dart';
import '../../auth/models/user_model.dart';
import '../../watching_report/data/cubit/watching_report_cubit.dart';
import '../../watching_report/widgets/watched_report_card_widget.dart';

class UserToDoReportsPage extends StatelessWidget {
  final UserModel user;
  const UserToDoReportsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watching Reports'),
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              color: AppColors.whiteColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColors.lightprussianBlue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                    ),
                    width: 30,
                    height: 120,
                    child: Center(
                      child: Icon(
                        Icons.person,
                        color: AppColors.whiteColor,
                        size: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ////////////    USER INFO    //////////////////
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(user.phone),
                                      Wrap(
                                        children: [
                                          Text("College : ${user.faculty}"),
                                          const SizedBox(width: 10),
                                          Text(
                                            "Academic Year : ${int.parse(user.studyYear) + 1}",
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<WatchingReportCubit, WatchingReportState>(
              bloc: GetIt.I<WatchingReportCubit>()
                ..getWatchingReports(userId: user.id),
              builder: (context, state) {
                if (state is WatchingReportLoaded) {
                  if (state.reports.isEmpty) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.2,
                          ),
                          child: Text(
                            "${'No Watching Reports Found'.tr(context)} for ${user.name}",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      ////////////// TOTAL COUNT //////////////
                      Card(
                        elevation: 1,
                        color: AppColors.whiteColor,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Watching Reports",
                                style: TextStyle(
                                  color: AppColors.prussianBlue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.prussianBlue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  state.reports.length.toString(),
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.reports.length,
                        itemBuilder: (context, index) {
                          return WatchedReportCardWidget(
                            number: index.toString(),
                            report: state.reports[index],
                            color: AppColors.prussianBlue,
                          );
                        },
                      ),
                    ],
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}
