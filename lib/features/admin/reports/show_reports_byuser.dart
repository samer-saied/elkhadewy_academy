import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:unimind/features/admin/info/cubit/statistic_cubit.dart';

import '../../../utils/colors.dart';
import '../../auth/models/user_model.dart';
import '../info/screens/count_students/filter_list_widget.dart';
import 'widgets/report_card_widget.dart';

String searchValue = "";

class ShowReportsByUserPage extends StatelessWidget {
  const ShowReportsByUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.prussianBlue,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "User Reports",
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Text(
              "Enter User Phone Number",
              style: TextStyle(color: AppColors.prussianBlue, fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              decoration: InputDecoration(
                hint: Text(
                  "User phone Number",
                  style: TextStyle(color: AppColors.grey),
                ),
                filled: true,
                fillColor: AppColors.whiteColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                hintStyle: TextStyle(color: AppColors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.lightGrey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.lightGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.prussianBlue),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
              onChanged: (value) {
                searchValue = value;
                GetIt.I<StatisticCubit>().getUsersDataBySearch(
                  searchValue: value,
                  searchField: "phone",
                );
              },
              // onSubmitted: (value) {
              //   searchValue = value;
              //   GetIt.I<StatisticCubit>().getUsersData(
              //     role: "phone",
              //     value: value,
              //   );
              // },
            ),
          ),
          buildSectionTitle('Results'),
          BlocBuilder<StatisticCubit, StatisticState>(
            bloc: GetIt.I<StatisticCubit>()
              ..getUsersData(role: "phone", value: searchValue),
            builder: (context, state) {
              if (state is StatisticLoaded) {
                List<UserModel> users = GetIt.I<StatisticCubit>().users;
                if (users.isEmpty) {
                  return const Center(child: Text("No Users Found"));
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return ReportCardWidget(
                        index: index,
                        student: users[index],
                      );
                    },
                  ),
                );
              }
              if (state is StatisticLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (state is StatisticInitial) {
                return const Center(
                  child: Text("Please enter at least 3 characters"),
                );
              }

              return const Center(child: Text("Something went wrong"));
            },
          ),
        ],
      ),
    );
  }
}
