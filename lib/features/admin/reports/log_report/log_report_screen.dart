import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unimind/features/admin/reports/charts/chart_report_screen.dart';
import 'package:unimind/features/auth/bloc/log_report_cubit.dart';
import 'package:unimind/features/auth/bloc/log_report_state.dart';

import '../../../../utils/colors.dart';

class LogReportScreen extends StatefulWidget {
  const LogReportScreen({super.key});

  @override
  State<LogReportScreen> createState() => _LogReportScreenState();
}

class _LogReportScreenState extends State<LogReportScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<LogReportCubit>().fetchLogReports(refresh: true);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<LogReportCubit>().fetchLogReports();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 200);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogReportCubit, LogReportState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Log Reports'),
            backgroundColor: AppColors.blackColor,
          ),
          body: state.status == LogReportStatus.loading && state.reports.isEmpty
              ? Center(child: CircularProgressIndicator())
              : state.status == LogReportStatus.failure && state.reports.isEmpty
              ? Center(child: Text(state.errorMessage))
              : SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      TotalInfoWidget(
                        infoTxt: "3 Days' Log Reports",
                        infoTotaltxt:
                            "${state.reports.length}/ ${state.totalCount}",
                        color: AppColors.blackColor,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:
                            state.reports.length +
                            (state.hasReachedMax ? 0 : 1),
                        itemBuilder: (context, index) {
                          if (index >= state.reports.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          final report = state.reports[index];
                          return Card(
                            color: report.type == "admin"
                                ? const Color.fromARGB(255, 250, 242, 242)
                                : report.type == "teacher"
                                ? const Color.fromARGB(255, 237, 246, 255)
                                : AppColors.whiteColor,
                            child: ListTile(
                              title: Text.rich(
                                TextSpan(
                                  text: report.name,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: " try to login at ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    TextSpan(
                                      text: DateFormat(
                                        "EEE dd-MM-yyyy HH:mm:ss",
                                      ).format(DateTime.parse(report.dateTime)),
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(report.email),
                                  Text(report.phone),
                                  report.isSuccess
                                      ? Text(
                                          "🟢 Login Success",
                                          style: TextStyle(
                                            color: AppColors.emerald,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : Text(
                                          "🔴 Login Failed",
                                          style: TextStyle(
                                            color: AppColors.redWood,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ],
                              ),

                              trailing: Icon(
                                report.isSuccess ? Icons.check : Icons.close,
                              ),
                              leading: report.type == "student"
                                  ? Icon(Icons.person)
                                  : report.type == "teacher"
                                  ? Icon(Icons.school)
                                  : Icon(Icons.admin_panel_settings),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
