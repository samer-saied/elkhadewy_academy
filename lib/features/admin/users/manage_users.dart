import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:unimind/features/admin/users/cubit/statistic_cubit.dart';
import 'package:unimind/services/lang/app_localizations.dart';

import '../../../utils/colors.dart';
import 'search_users.dart';
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
          "Manage Users".tr(context),
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
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchUsersPage(),
                ),
              );
            },
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedSearch02,
              size: 24,
              color: AppColors.whiteColor,
            ),
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder<StatisticCubit, StatisticState>(
          bloc: GetIt.I<StatisticCubit>()..getUsersCount(),
          builder: (context, state) {
            if (state is StatisticLoaded) {
              Map<String, int> results = GetIt.I<StatisticCubit>().results;
              return Column(
                children: [
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
                                fontSize: 26,
                              ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          "Total Users",
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(color: AppColors.blackColor),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      NumberLabelWidget(
                        number: results["admins"] ?? 0,
                        text: "Admins",
                        labelColor: AppColors.raisinBlack,
                        onTapFunc: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ShowUsersPage(
                                role: "role",
                                value: "admin",
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
                              builder: (context) => const ShowUsersPage(
                                role: "role",
                                value: "student",
                              ),
                            ),
                          );
                        },
                      ),
                      NumberLabelWidget(
                        number: results["teachers"] ?? 0,
                        text: "Teachers",
                        labelColor: AppColors.emerald,
                        onTapFunc: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ShowUsersPage(
                                role: "role",
                                value: "teacher",
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      NumberLabelWidget(
                        number: results["activeStudents"] ?? 0,
                        text: "Active",
                        labelColor: AppColors.jonquil,
                        onTapFunc: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ShowUsersPage(
                                role: "status",
                                value: "active",
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
                              builder: (context) => const ShowUsersPage(
                                role: "status",
                                value: "blocked",
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
    );
  }
}

class NumberLabelWidget extends StatelessWidget {
  final int number;
  final Color labelColor;
  final String text;
  final void Function()? onTapFunc;
  const NumberLabelWidget({
    super.key,
    required this.number,
    required this.labelColor,
    required this.text,
    this.onTapFunc,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTapFunc ?? () {},
        child: Container(
          margin: const EdgeInsets.all(7),
          padding: const EdgeInsets.all(15),
          // height: 50,
          decoration: BoxDecoration(
            color: labelColor.withAlpha(70),
            borderRadius: BorderRadius.circular(10),
          ),

          child: Column(
            children: [
              Text(
                number.toString(),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
              SizedBox(height: 3),
              Text(
                text,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(color: AppColors.blackColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
