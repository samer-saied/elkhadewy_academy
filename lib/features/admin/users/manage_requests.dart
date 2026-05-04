import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:unimind/features/admin/info/screens/count_students/teacher_count_stud_materials_screen.dart';
import 'package:unimind/features/course_details/presentations/cubit/request_show_course_cubit.dart';
import 'package:unimind/services/lang/app_localizations.dart';

import '../../../utils/colors.dart';
import '../chapters/manage_chapters/simple_title_widget.dart';

class ManageRequestsPage extends StatefulWidget {
  final bool materials;
  const ManageRequestsPage({super.key, required this.materials});

  @override
  State<ManageRequestsPage> createState() => _ManageRequestsPageState();
}

class _ManageRequestsPageState extends State<ManageRequestsPage> {
  String? selectedCourseId;

  @override
  void initState() {
    super.initState();
    GetIt.I<RequestShowCourseCubit>().getPendingRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.jonquil,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Manage Pending Requests".tr(context),
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.whiteColor,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.whiteColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<RequestShowCourseCubit, RequestShowCourseState>(
        bloc: GetIt.I<RequestShowCourseCubit>(),
        builder: (context, state) {
          if (state is RequestShowCourseLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is RequestShowCourseError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          if (state is PendingRequestsLoaded) {
            final allRequests = state.requests;

            // Extract unique courses for the filter
            final Map<String, String> courseMap = {};
            for (var req in allRequests) {
              if (req['courseId'] != null && req['courseTitle'] != null) {
                courseMap[req['courseId']] = req['courseTitle'];
              }
            }

            final dataList = selectedCourseId == null
                ? allRequests
                : allRequests
                      .where((req) => req['courseId'] == selectedCourseId)
                      .toList();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SimpleTitleWidget(title: "Select the course"),

                  if (courseMap.isNotEmpty)
                    SizedBox(
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(
                                "All".tr(context),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: selectedCourseId == null
                                      ? AppColors.whiteColor
                                      : AppColors.blackColor,
                                ),
                              ),
                              selected: selectedCourseId == null,
                              selectedColor: AppColors.jonquil,
                              onSelected: (selected) {
                                setState(() {
                                  selectedCourseId = null;
                                });
                              },
                            ),
                          ),
                          ...courseMap.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text(
                                  entry.value,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: selectedCourseId == entry.key
                                        ? AppColors.whiteColor
                                        : AppColors.blackColor,
                                  ),
                                ),
                                selected: selectedCourseId == entry.key,
                                selectedColor: AppColors.jonquil,
                                onSelected: (selected) {
                                  setState(() {
                                    selectedCourseId = selected
                                        ? entry.key
                                        : null;
                                  });
                                },
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  dataList.isEmpty
                      ? Center(
                          child: Text("No Pending Requests Found".tr(context)),
                        )
                      : Column(
                          children: [
                            TotalReportWidget(
                              text: "Total Reports",
                              totalNum: dataList.length.toString(),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: dataList.length,
                              itemBuilder: (context, index) {
                                final request = dataList[index];
                                return Card(
                                  color: AppColors.jonquilLightSoft,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          request['studentName'] ?? 'No Name',
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          request['studentPhone'] ?? 'No Phone',
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          request['courseTitle'] ?? 'No Course',
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          request['createdAt'] != null
                                              ? request['createdAt']
                                                    .toDate()
                                                    .toString()
                                              : 'No Date',
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            FilledButton(
                                              onPressed: () {
                                                GetIt.I<
                                                      RequestShowCourseCubit
                                                    >()
                                                    .acceptRequest(
                                                      request: request,
                                                    );
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStatePropertyAll(
                                                      AppColors.emerald,
                                                    ),
                                              ),
                                              child: Text("Accept".tr(context)),
                                            ),
                                            const SizedBox(width: 10),
                                            FilledButton(
                                              onPressed: () {
                                                GetIt.I<
                                                      RequestShowCourseCubit
                                                    >()
                                                    .deleteRequest(
                                                      requestId:
                                                          request['docId'],
                                                    );
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStatePropertyAll(
                                                      AppColors.redWood,
                                                    ),
                                              ),
                                              child: Text("Reject".tr(context)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
