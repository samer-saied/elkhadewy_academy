import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:unimind/features/course_details/presentations/cubit/request_show_course_cubit.dart';
import 'package:unimind/services/lang/app_localizations.dart';

import '../../../utils/colors.dart';

class ManageRequestsPage extends StatelessWidget {
  final bool materials;
  const ManageRequestsPage({super.key, required this.materials});

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
        bloc: GetIt.I<RequestShowCourseCubit>()..getPendingRequests(),

        builder: (context, state) {
          if (state is RequestShowCourseLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is RequestShowCourseError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          if (state is PendingRequestsLoaded) {
            final dataList = state.requests;
            if (dataList.isEmpty) {
              return Center(
                child: Text("No Pending Requests Found".tr(context)),
              );
            }
            return ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final request = dataList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(request['studentName'] ?? 'No Name'),
                        const SizedBox(height: 5),
                        Text(request['studentPhone'] ?? 'No Phone'),
                        const SizedBox(height: 5),
                        Text(request['courseTitle'] ?? 'No Course'),
                        const SizedBox(height: 5),
                        Text(
                          request['createdAt'] != null
                              ? request['createdAt'].toDate().toString()
                              : 'No Date',
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FilledButton(
                              onPressed: () {
                                GetIt.I<RequestShowCourseCubit>().acceptRequest(
                                  request: request,
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  AppColors.emerald,
                                ),
                              ),
                              child: const Text("Accept"),
                            ),
                            const SizedBox(width: 10),
                            FilledButton(
                              onPressed: () {
                                GetIt.I<RequestShowCourseCubit>().deleteRequest(
                                  requestId: request['docId'],
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  AppColors.redWood,
                                ),
                              ),
                              child: const Text("Reject"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
