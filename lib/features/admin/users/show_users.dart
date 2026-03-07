import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:unimind/features/admin/users/cubit/statistic_cubit.dart';
import 'package:unimind/features/auth/bloc/register_cubit.dart';
import 'package:unimind/features/auth/models/user_model.dart';

import '../../../utils/colors.dart';
import 'edit_user.dart';

class ShowUsersPage extends StatelessWidget {
  final String role;
  final String value;
  const ShowUsersPage({super.key, required this.role, required this.value});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.jonquil,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "$value Users",
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
      body: BlocBuilder<StatisticCubit, StatisticState>(
        bloc: GetIt.I<StatisticCubit>()..getUsersData(role: role, value: value),
        builder: (context, state) {
          if (state is StatisticLoaded) {
            List<UserModel> users = GetIt.I<StatisticCubit>().users;
            if (users.isEmpty) {
              return const Center(child: Text("No Users Found"));
            }
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return UserCardWidget(index: index, student: users[index]);
              },
            );
          }
          if (state is StatisticLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text("Something went wrong"));
        },
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
    return Dismissible(
      key: Key(student.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        color: AppColors.redWood,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [Icon(Icons.delete, color: Colors.white)],
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          if (student.role == "admin") {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Admin User can't be deleted"),
                backgroundColor: AppColors.redWood,
              ),
            );
          }
          GetIt.I<RegisterCubit>().deleteUser(userId: student.id);
        }
      },
      child: Card(
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
      ),
    );
  }
}
