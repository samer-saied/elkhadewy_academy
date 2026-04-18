import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:unimind/features/admin/info/cubit/statistic_cubit.dart';
import 'package:unimind/services/lang/app_localizations.dart';

import '../../../utils/colors.dart';
import '../info/screens/count_students/filter_list_widget.dart';
import 'show_users.dart';

class ManageUsersPage extends StatelessWidget {
  const ManageUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.jonquil,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Manage Users by Role".tr(context),
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
        // actions: [
        //   MaterialButton(
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => const SearchUsersPage(),
        //         ),
        //       );
        //     },
        //     child: HugeIcon(
        //       icon: HugeIcons.strokeRoundedSearch02,
        //       size: 24,
        //       color: AppColors.whiteColor,
        //     ),
        //   ),
        // ],
      ),
      body: Center(
        child: BlocProvider.value(
          value: GetIt.I<StatisticCubit>()..getUsersStatusCount(),
          child: BlocBuilder<StatisticCubit, StatisticState>(
            bloc: GetIt.I<StatisticCubit>(),
            builder: (context, state) {
              if (state is StatisticLoaded) {
                Map<String, int> results = GetIt.I<StatisticCubit>().results;
                return Column(
                  children: [
                    buildSectionTitle('Total Users'),

                    Container(
                      margin: const EdgeInsets.all(15),
                      padding: const EdgeInsets.all(25),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.jonquilLight.withAlpha(70),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(
                            results["users"]?.toString() ?? "0",
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 36,
                                ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            "Users",
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(color: AppColors.blackColor),
                          ),
                        ],
                      ),
                    ),
                    buildSectionTitle('Roles'),

                    Row(
                      children: [
                        NumberLabelWidget(
                          number: results["admins"] ?? 0,
                          text: "Admins",
                          labelColor: AppColors.raisinBlack,
                          icon: Icons.admin_panel_settings,
                          onTapFunc: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowUsersPage(
                                  field: "role",
                                  value: "admin",
                                  title: "admin",
                                  isDelete: true,
                                  isAll: true,
                                ),
                              ),
                            );
                          },
                        ),
                        NumberLabelWidget(
                          number: results["students"] ?? 0,
                          text: "Students",
                          labelColor: AppColors.lightprussianBlue,
                          onTapFunc: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowUsersPage(
                                  field: "role",
                                  value: "student",
                                  title: "student",
                                  isDelete: true,
                                  isAll: true,
                                ),
                              ),
                            );
                          },
                        ),
                        NumberLabelWidget(
                          number: results["teachers"] ?? 0,
                          text: "Teachers",
                          icon: Icons.book,
                          labelColor: AppColors.jonquil,
                          onTapFunc: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowUsersPage(
                                  field: "role",
                                  value: "teacher",
                                  title: "teacher",
                                  isDelete: true,
                                  isAll: true,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    buildSectionTitle('Status'),

                    Row(
                      children: [
                        NumberLabelWidget(
                          number: results["activeStudents"] ?? 0,
                          text: "Active",
                          labelColor: AppColors.emerald,
                          onTapFunc: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowUsersPage(
                                  field: "status",
                                  value: "active",
                                  title: "active",
                                  isDelete: true,
                                  isAll: true,
                                ),
                              ),
                            );
                          },
                        ),
                        NumberLabelWidget(
                          number: results["blockedStudents"] ?? 0,
                          text: "Blocked",
                          labelColor: AppColors.redWood,
                          onTapFunc: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowUsersPage(
                                  field: "status",
                                  value: "blocked",
                                  title: "blocked",
                                  isDelete: true,
                                  isAll: true,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}

class NumberLabelWidget extends StatelessWidget {
  final int number;
  final Color labelColor;
  final String text;
  final IconData icon;
  final void Function()? onTapFunc;
  const NumberLabelWidget({
    super.key,
    required this.number,
    required this.labelColor,
    required this.text,
    this.onTapFunc,
    this.icon = Icons.person,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTapFunc ?? () {},
        child: Container(
          margin: const EdgeInsets.all(7),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          // height: 50,
          decoration: BoxDecoration(
            color: labelColor.withAlpha(50),
            borderRadius: BorderRadius.circular(10),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        children: [
                          Icon(icon, color: labelColor, size: 28),
                          Text(
                            number.toString(),
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                  color: labelColor,
                                ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      text,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium!.copyWith(color: labelColor),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 18, color: labelColor),
            ],
          ),
        ),
      ),
    );
  }
}
