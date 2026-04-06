import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unimind/features/admin/info/screens/count_students/count_stud_materials_screen.dart';
import 'package:unimind/services/lang/app_localizations.dart';

import '../../core/navigation/app_routes.dart';
import '../../general/widgets/headers_widgets.dart';
import '../../utils/colors.dart';
import '../more/widgets/setting_item.dart';
import 'reports/show_reports.dart';
import 'reports/show_reports_bydate.dart';
import 'users/manage_requests.dart';
import 'users/manage_users.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SectionHeaderSmallWidget(
          title: "Admin Panel".tr(context),
          color: AppColors.whiteColor,
        ),
      ),
      body: GetBodyAdminPage(),
    );
  }
}

///
///
///
//////////////////    Main Body Widget    //////////////////
///  Add News Post - Add New Chapter - Manage posts , Chapter and Users
class GetBodyAdminPage extends StatelessWidget {
  const GetBodyAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 15, right: 15),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          ///
          ///
          ///////////////////////  Header ///////////////////////
          const SizedBox(height: 10),

          ///
          ///
          ///    User Menu ( Statistics )
          Column(
            children: [
              ///
              ///
              ///      Add News Post
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.lightGrey,
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(
                            0,
                            1,
                          ), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SettingItem(
                          title: "Add New News post".tr(context),
                          leadingIcon: Icons.campaign,
                          bgIconColor: AppColors.jonquil,
                          leadingIconColor: AppColors.whiteColor,
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            Navigator.pushNamed(context, '/AddNewsPage');
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 45),
                          child: Divider(height: 0, color: AppColors.grey),
                        ),
                        SettingItem(
                          title: "Manage News Section".tr(context),
                          leadingIcon: Icons.edit_rounded,
                          bgIconColor: AppColors.jonquil,
                          leadingIconColor: AppColors.whiteColor,
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            Navigator.pushNamed(context, AppRoutes.manageNews);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),

              ///
              ///
              ///      Add Materials
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.lightGrey,
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(
                            0,
                            1,
                          ), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SettingItem(
                          title: "Add New Course".tr(context),
                          leadingIcon: Icons.bookmark_add_rounded,
                          bgIconColor: AppColors.jonquil,
                          leadingIconColor: AppColors.whiteColor,
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            Navigator.pushNamed(context, AppRoutes.addCourse);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 45),
                          child: Divider(height: 0, color: AppColors.lightGrey),
                        ),
                        SettingItem(
                          title: "Manage Courses".tr(context),
                          leadingIcon: Icons.edit,
                          bgIconColor: AppColors.jonquil,
                          leadingIconColor: AppColors.whiteColor,
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            Navigator.pushNamed(
                              context,
                              AppRoutes.manageCourse,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),

              ///
              ///
              ///
              ///
              ////////////////////////////  COURSES ////////////////////
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.lightGrey,
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(
                            0,
                            1,
                          ), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SettingItem(
                          title: "Add New Chapter".tr(context),
                          leadingIcon: Icons.video_call_rounded,
                          bgIconColor: AppColors.jonquil,
                          leadingIconColor: AppColors.whiteColor,
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            Navigator.pushNamed(context, AppRoutes.addChapter);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 45),
                          child: Divider(height: 0, color: AppColors.lightGrey),
                        ),
                        SettingItem(
                          title: "Manage Chapters".tr(context),
                          leadingIcon: Icons.video_library_rounded,
                          bgIconColor: AppColors.jonquil,
                          leadingIconColor: AppColors.whiteColor,
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            Navigator.pushNamed(
                              context,
                              AppRoutes.manageChapters,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),

              ////////////////////////////  USERS  ////////////////////
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.lightGrey,
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(
                            0,
                            1,
                          ), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SettingItem(
                          title: "Manage Users".tr(context),
                          leadingIcon: Icons.people,
                          bgIconColor: AppColors.jonquil,
                          leadingIconColor: AppColors.whiteColor,
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ManageUsersPage(),
                              ),
                            );
                            // Navigator.pushNamed(
                            //   context,
                            //   AppRoutes.manageUsers,
                            // );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),

              ////////////////////////////  Request Courses  ////////////////////
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.lightGrey,
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(
                            0,
                            1,
                          ), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SettingItem(
                          title: "Pending Requests".tr(context),
                          leadingIcon: Icons.pending,
                          bgIconColor: AppColors.jonquil,
                          leadingIconColor: AppColors.whiteColor,
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ManageRequestsPage(materials: false),
                              ),
                            );
                            // Navigator.pushNamed(
                            //   context,
                            //   AppRoutes.manageUsers,
                            // );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),

              ///
              ///
              ///
              ///
              ////////////////////////////  Statistics  ////////////////////
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.lightGrey,
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(
                            0,
                            1,
                          ), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SettingItem(
                          title: "Reports By Date".tr(context),
                          leadingIcon: Icons.bar_chart_sharp,
                          bgIconColor: AppColors.jonquil,
                          leadingIconColor: AppColors.whiteColor,
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowReportsByDatePage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),

              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.lightGrey,
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(
                            0,
                            1,
                          ), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SettingItem(
                          title: "Reports By User".tr(context),
                          leadingIcon: Icons.bar_chart_sharp,
                          bgIconColor: AppColors.jonquil,
                          leadingIconColor: AppColors.whiteColor,
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowReportsPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),

              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.lightGrey,
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(
                            0,
                            1,
                          ), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SettingItem(
                          title: "Sort Students By Materials".tr(context),
                          leadingIcon: Icons.bar_chart_sharp,
                          bgIconColor: AppColors.jonquil,
                          leadingIconColor: AppColors.whiteColor,
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CountStudMaterialsScreen(),
                              ),
                            );
                          },
                        ),
                        SettingItem(
                          title: "Sort Students By Role".tr(context),
                          leadingIcon: Icons.bar_chart_sharp,
                          bgIconColor: AppColors.jonquil,
                          leadingIconColor: AppColors.whiteColor,
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowReportsPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),

              ///
              ///
              ///
              ///
              ////////////////////////////  USERS  ////////////////////
              // Column(
              //   children: [
              //     Container(
              //       padding: const EdgeInsets.only(left: 15, right: 15),
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(5),
              //         color: AppColors.whiteColor,
              //         boxShadow: [
              //           BoxShadow(
              //             color: AppColors.lightGrey,
              //             spreadRadius: 1,
              //             blurRadius: 1,
              //             offset: const Offset(
              //               0,
              //               1,
              //             ), // changes position of shadow
              //           ),
              //         ],
              //       ),
              //       child: Column(
              //         children: [
              //           SettingItem(
              //             title: "Reset Factory".tr(context),
              //             leadingIcon: Icons.delete_forever,
              //             bgIconColor: AppColors.redWood,
              //             leadingIconColor: AppColors.whiteColor,
              //             onTap: () {
              //               HapticFeedback.mediumImpact();
              //               // Get.to(() => const ResetFactoryScreen());
              //             },
              //           ),
              //         ],
              //       ),
              //     ),
              //     const SizedBox(height: 10),
              //   ],
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
