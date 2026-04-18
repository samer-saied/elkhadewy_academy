import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unimind/services/lang/app_localizations.dart';

import '../../core/navigation/app_routes.dart';
import '../../general/widgets/headers_widgets.dart';
import '../../utils/colors.dart';
import '../more/widgets/setting_item.dart';
import 'info/screens/count_students/count_stud_materials_screen.dart';
import 'reports/charts/chart_report_screen.dart';
import 'reports/show_reports_bydate.dart';
import 'reports/show_reports_byuser.dart';
import 'users/manage_requests.dart';

class TeacherPage extends StatelessWidget {
  const TeacherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SectionHeaderSmallWidget(
          title: "Teacher Panel".tr(context),
          color: AppColors.whiteColor,
        ),
      ),
      body: GetBodyTeacherPage(),
    );
  }
}

///
///
///
//////////////////    Main Body Widget    //////////////////
///  Add News Post - Add New Chapter - Manage posts , Chapter and Users
class GetBodyTeacherPage extends StatelessWidget {
  const GetBodyTeacherPage({super.key});

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
              //             title: "Add New News post".tr(context),
              //             leadingIcon: Icons.campaign,
              //             bgIconColor: AppColors.jonquil,
              //             leadingIconColor: AppColors.whiteColor,
              //             onTap: () {
              //               HapticFeedback.mediumImpact();
              //               Navigator.pushNamed(context, '/AddNewsPage');
              //             },
              //           ),
              //           Padding(
              //             padding: const EdgeInsets.only(left: 45),
              //             child: Divider(height: 0, color: AppColors.grey),
              //           ),
              //           SettingItem(
              //             title: "Manage News Section".tr(context),
              //             leadingIcon: Icons.edit_rounded,
              //             bgIconColor: AppColors.jonquil,
              //             leadingIconColor: AppColors.whiteColor,
              //             onTap: () {
              //               HapticFeedback.mediumImpact();
              //               Navigator.pushNamed(context, AppRoutes.manageNews);
              //             },
              //           ),
              //         ],
              //       ),
              //     ),
              //     const SizedBox(height: 10),
              //   ],
              // ),

              ///
              ///
              ///      Add Materials
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
              //             title: "Add New Course".tr(context),
              //             leadingIcon: Icons.bookmark_add_rounded,
              //             bgIconColor: AppColors.jonquil,
              //             leadingIconColor: AppColors.whiteColor,
              //             onTap: () {
              //               HapticFeedback.mediumImpact();
              //               Navigator.pushNamed(context, AppRoutes.addCourse);
              //             },
              //           ),
              //           Padding(
              //             padding: const EdgeInsets.only(left: 45),
              //             child: Divider(height: 0, color: AppColors.lightGrey),
              //           ),
              //           SettingItem(
              //             title: "Manage Courses".tr(context),
              //             leadingIcon: Icons.edit,
              //             bgIconColor: AppColors.jonquil,
              //             leadingIconColor: AppColors.whiteColor,
              //             onTap: () {
              //               HapticFeedback.mediumImpact();
              //               Navigator.pushNamed(
              //                 context,
              //                 AppRoutes.manageCourse,
              //               );
              //             },
              //           ),
              //         ],
              //       ),
              //     ),
              //     const SizedBox(height: 10),
              //   ],
              // ),

              ///
              ///
              ///
              ///
              ////////////////////////////  Chapters ////////////////////
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
                        // SettingItem(
                        //   title: "Manage Users by Role".tr(context),
                        //   leadingIcon: Icons.people,
                        //   bgIconColor: AppColors.jonquil,
                        //   leadingIconColor: AppColors.whiteColor,
                        //   onTap: () {
                        //     HapticFeedback.mediumImpact();
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => ManageUsersPage(),
                        //       ),
                        //     );
                        //   },
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 45),
                        //   child: Divider(height: 0, color: AppColors.lightGrey),
                        // ),
                        SettingItem(
                          title: "Manage Users By Materials".tr(context),
                          leadingIcon: Icons.people_outline,
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

                        // Padding(
                        //   padding: const EdgeInsets.only(left: 45),
                        //   child: Divider(height: 0, color: AppColors.lightGrey),
                        // ),
                        // SettingItem(
                        //   title: "Search Users".tr(context),
                        //   leadingIcon: Icons.person_search,
                        //   bgIconColor: AppColors.jonquil,
                        //   leadingIconColor: AppColors.whiteColor,
                        //   onTap: () {
                        //     HapticFeedback.mediumImpact();
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => SearchUsersPage(),
                        //       ),
                        //     );
                        //   },
                        // ),
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
                          title: "Date-Based Reports".tr(context),
                          leadingIcon: Icons.date_range_rounded,
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
                        Padding(
                          padding: const EdgeInsets.only(left: 45),
                          child: Divider(height: 0, color: AppColors.lightGrey),
                        ),
                        SettingItem(
                          title: "Weekly Analytics Chart".tr(context),
                          leadingIcon: Icons.bar_chart_sharp,
                          bgIconColor: AppColors.jonquil,
                          leadingIconColor: AppColors.whiteColor,
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChartReportScreen(),
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 45),
                          child: Divider(height: 0, color: AppColors.lightGrey),
                        ),
                        SettingItem(
                          title: "User-Specific Reports".tr(context),
                          leadingIcon: Icons.bar_chart_sharp,
                          bgIconColor: AppColors.jonquil,
                          leadingIconColor: AppColors.whiteColor,
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowReportsByUserPage(),
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
            ],
          ),
        ],
      ),
    );
  }
}
