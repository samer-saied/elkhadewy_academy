import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:unimind/features/auth/bloc/login_cubit.dart';
import 'package:unimind/services/lang/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/navigation/app_routes.dart';
import '../../general/presentations/cubits/navigation_cubit.dart';
import '../../utils/app_info.dart';
import '../../utils/colors.dart';
import 'widgets/setting_item.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: SectionHeaderWidget(title: "More", action: ''),
      body: GetBody(),
    );
  }
}

///
///
///
//////////////////    Main Body Widget    //////////////////
///  Add News Post - Add New Chapter - Manage posts , Chapter and Users

class GetBody extends StatelessWidget {
  const GetBody({super.key});

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
          ///    Admin Menu
          GetIt.I<LoginCubit>().currentUser!.role == "admin"
              ? Container(
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
                        title: "Admin Panel".tr(context),
                        leadingIcon: Icons.admin_panel_settings_rounded,
                        bgIconColor: AppColors.jonquil,
                        leadingIconColor: AppColors.whiteColor,
                        tailingIcon: Icons.circle,
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          Navigator.pushNamed(context, AppRoutes.adminPage);
                          // Get.to(() => const AdminScreen());
                        },
                      ),
                    ],
                  ),
                )
              : const SizedBox(height: 10),
          const SizedBox(height: 10),

          ///
          ///
          ///    User Menu ( Statistics )
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
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                SettingItem(
                  title: "Profile".tr(context),
                  leadingIcon: Icons.person,
                  bgIconColor: AppColors.jonquil,
                  leadingIconColor: AppColors.whiteColor,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    Navigator.pushNamed(context, AppRoutes.profilePage);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          ///
          ///
          ///    User Menu ( Statistics )
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
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                SettingItem(
                  title: "Watching Report".tr(context),
                  leadingIcon: Icons.bar_chart_rounded,
                  bgIconColor: AppColors.jonquil,
                  leadingIconColor: AppColors.whiteColor,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    Navigator.pushNamed(context, AppRoutes.watchingReport);
                  },
                ),
                // SettingItem(
                //   title: "Quiz Report",
                //   leadingIcon: Icons.quora_outlined,
                //   bgIconColor: AppColors.mainColor,
                //   leadingIconColor: AppColors.whiteColor,
                //   onTap: () {
                //     HapticFeedback.mediumImpact();
                //     //watchedReports
                //     // Get.to(() => const QuizzesStatisticUserScreen());
                //   },
                // ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          ///
          ///
          ///    Settings - Password - Logout
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
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                SettingItem(
                  title: "Settings".tr(context),
                  leadingIcon: Icons.settings,
                  bgIconColor: AppColors.jonquil,
                  leadingIconColor: AppColors.whiteColor,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    Navigator.pushNamed(context, AppRoutes.settingsPage);
                    // Get.to(() => const SettingsScreen());
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 45),
                  child: Divider(height: 0, color: AppColors.grey),
                ),
                // SettingItem(
                //   title: "Change Password",
                //   leadingIcon: Icons.password,
                //   bgIconColor: AppColors.jonquil,
                //   onTap: () {
                //     // Get.to(() => ChangePasswordScreen());
                //     // getCustomDialog(
                //     //   title: "message",
                //     //   content: "Contact admin to help you",
                //     // );
                //   },
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 45),
                  child: Divider(height: 0, color: AppColors.grey),
                ),
                SettingItem(
                  title: "Logout".tr(context),
                  leadingIcon: Icons.logout,
                  bgIconColor: AppColors.jonquil,
                  onTap: () {
                    //////////////////    removeAutoSignIn();
                    HapticFeedback.mediumImpact();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
                      (route) => false,
                    );
                    GetIt.I<NavigationCubit>().updateIndex(0);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          ///
          ///
          ///    Contact me - privacy
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
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                SettingItem(
                  title: "Contact us".tr(context),
                  leadingIcon: Icons.phone,
                  bgIconColor: AppColors.jonquil,
                  leadingIconColor: AppColors.whiteColor,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    Navigator.pushNamed(context, AppRoutes.contactMe);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 45),
                  child: Divider(height: 0, color: AppColors.grey),
                ),
                SettingItem(
                  title: "Privacy & Terms".tr(context),
                  leadingIcon: Icons.library_books_sharp,
                  bgIconColor: AppColors.jonquil,
                  onTap: () {
                    launchUrl(
                      Uri.parse(AppInfo.appTerms),
                      mode: LaunchMode.platformDefault,
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 45),
                  child: Divider(height: 0, color: AppColors.grey),
                ),
                SettingItem(
                  title: "Report an issue",
                  leadingIcon: Icons.report_problem_rounded,
                  bgIconColor: AppColors.jonquil,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    launchUrl(
                      Uri.parse("mailto:${AppInfo.technicalEMail}"),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () => launchUrl(
                  Uri.parse("mailto:samersaied02@gmail.com"),
                  mode: LaunchMode.platformDefault,
                ),
                child: Text(
                  "${"Developed by".tr(context)} Samer Saied",
                  style: TextStyle(color: AppColors.jonquil),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
