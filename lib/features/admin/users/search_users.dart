import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:unimind/features/admin/users/cubit/statistic_cubit.dart';
import 'package:unimind/features/auth/models/user_model.dart';

import '../../../utils/colors.dart';
import 'edit_user.dart';

String searchValue = "";

class SearchUsersPage extends StatelessWidget {
  const SearchUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.jonquil,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Search Users",
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
              style: TextStyle(color: AppColors.jonquil, fontSize: 18),
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
                  borderSide: const BorderSide(color: AppColors.jonquil),
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
              onSubmitted: (value) {
                searchValue = value;
                GetIt.I<StatisticCubit>().getUsersData(
                  role: "phone",
                  value: value,
                );
              },
            ),
          ),

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
                      return UserCardWidget(
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
              return const Center(child: Text("Something went wrong"));
            },
          ),
        ],
      ),
    );
  }
}

class UserCardWidget extends StatelessWidget {
  const UserCardWidget({super.key, required this.student, required this.index});

  final UserModel student;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditUserPage(userModel: student),
            ),
          );
        },
        leading: Container(
          padding: const EdgeInsets.all(5),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            // color: AppColors.getStatusColor(status: student.status),
          ),
          child: Center(
            child: FittedBox(
              child: Text(
                (index + 1).toString(),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        title: Text(student.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(student.phone),
            Wrap(
              children: [
                Text("College : ${student.faculty}"),
                const SizedBox(width: 10),
                Text("Academic Year : ${int.parse(student.studyYear) + 1}"),
              ],
            ),
          ],
        ),
        trailing: Wrap(
          children: [
            Icon(
              Icons.headphones,
              color: student.statusEnableHeadset == false
                  ? AppColors.redWood
                  : AppColors.emerald,
            ),
            Icon(
              Icons.token,
              color: student.refreshToken == true
                  ? AppColors.emerald
                  : AppColors.redWood,
            ),
          ],
        ),
      ),
    );
  }
}
