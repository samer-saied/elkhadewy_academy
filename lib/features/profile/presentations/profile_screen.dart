import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:unimind/services/lang/app_localizations.dart';
import '../../../utils/colors.dart';
import '../../auth/bloc/login_cubit.dart';
import '../../auth/bloc/login_state.dart';
import '../../courses/presentations/cubit/course_cubit.dart';
import '../../homepage/presentations/widgets/divider_widget.dart';
import 'widgets/boxs_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile".tr(context))),
      body: getBody(context),
    );
  }
}

Widget getBody(BuildContext context) {
  final currentUser = context.read<LoginCubit>().currentUser;
  return BlocBuilder<LoginCubit, LoginState>(
    builder: (context, state) {
      return SingleChildScrollView(
        padding: const EdgeInsets.only(left: 15, right: 15),
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: Column(
            children: [
              ///
              ///
              ///      pic + name
              Column(
                children: [
                  const SizedBox(height: 10),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        child: HugeIcon(
                          icon: currentUser!.role == "teacher"
                              ? HugeIcons.strokeRoundedTeaching
                              : currentUser.role == "admin"
                              ? HugeIcons.strokeRoundedMicrosoftAdmin
                              : HugeIcons.strokeRoundedUser,
                          size: 30,
                          color: AppColors.blackColor,
                        ),
                        // statusColor: Colors.green,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: currentUser.status == "active"
                                ? AppColors.emerald
                                : AppColors.redWood,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    currentUser.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blackColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${currentUser.role.tr(context)} ${"Profile".tr(context)}",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.jonquil,
                    ),
                  ),
                ],
              ),

              const DividerWidget(),

              const SizedBox(height: 10),
              NameLabelWidget(txt: "Personal Data".tr(context)),
              DataBox(
                title: "${"Name".tr(context)} :",
                txt: currentUser.name,
                iconData: Icons.title,
              ),
              DataBox(
                title: "${"Academic".tr(context)} :",
                txt:
                    "${currentUser.faculty} - Level ${int.parse(currentUser.studyYear) + 1}",
                iconData: Icons.school,
              ),
              DataBox(
                title: "${"Phone".tr(context)} :",
                txt: currentUser.phone,
                iconData: Icons.phone_iphone_rounded,
              ),

              DataBox(
                title: "${"Email".tr(context)} :",
                txt: currentUser.email,
                iconData: Icons.email,
              ),

              DataBox(
                title: "${"Status".tr(context)} :",
                txt: currentUser.status,
                iconData: Icons.power_settings_new_rounded,
              ),

              ///
              ///
              ///       details User
              const DividerWidget(),

              NameLabelWidget(txt: "Materials".tr(context)),
              currentUser.materials.isEmpty
                  ? Center(
                      child: DataBox(
                        title: "Materials".tr(context),
                        txt: "You don't have any materials yet".tr(context),
                        iconData: Icons.title,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 3),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: currentUser.materials.length,
                      itemBuilder: (context, index) {
                        return DataBox(
                          title: "",
                          iconData: Icons.circle,
                          color: AppColors.jonquil,
                          txt: GetIt.I<CourseCubit>().userCourses[index].title,
                        );
                      },
                    ),
              const DividerWidget(),
              const SizedBox(height: 10),
              Text(
                "If you get an error with your data or materials,\nPlease contact the administrator to have it edited."
                    .tr(context),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.jonquilLight,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
