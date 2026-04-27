import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:unimind/features/auth/bloc/login_cubit.dart';

import '../../../utils/colors.dart';
import '../info/cubit/statistic_cubit.dart';
import 'widgets/user_card_widget.dart';
// bloc: GetIt.I<StatisticCubit>()..getUsersData(role: role, value: value),

class ShowUsersPage extends StatefulWidget {
  final String title;
  final bool isDelete;
  final bool isAll;
  final String? field;
  final String? value;
  const ShowUsersPage({
    super.key,
    required this.title,
    required this.isDelete,
    required this.isAll,
    this.field,
    this.value,
  });

  @override
  State<ShowUsersPage> createState() => _ShowUsersPageState();
}

class _ShowUsersPageState extends State<ShowUsersPage> {
  @override
  void initState() {
    super.initState();
    if (widget.field == "materials" && widget.value != null) {
      GetIt.I<StatisticCubit>().getUsersDataByMaterial(
        materialId: widget.value!,
      );
    } else if (widget.field != null && widget.value != null) {
      if (widget.isAll) {
        GetIt.I<StatisticCubit>().getUsersData(
          role: widget.field!,
          value: widget.value!,
        );
      } else {
        GetIt.I<StatisticCubit>().getUsersData(
          role: widget.field!,
          value: widget.value!,
          role2: "role",
          value2: "student",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.jonquil,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.title.toUpperCase(),
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
        bloc: GetIt.I<StatisticCubit>(),
        builder: (context, state) {
          if (state is StatisticLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is StatisticLoaded) {
            if (GetIt.I<StatisticCubit>().users.isEmpty) {
              return Center(
                child: Text(
                  "No Data Available",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: AppColors.blackColor,
                  ),
                ),
              );
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    elevation: 1,
                    color: AppColors.whiteColor,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Reports",
                            style: TextStyle(
                              color: AppColors.jonquil,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: AppColors.jonquil,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              GetIt.I<StatisticCubit>().users.length.toString(),
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: GetIt.I<StatisticCubit>().users.length,
                    itemBuilder: (context, index) {
                      return UserCardWidget(
                        index: index,
                        student: GetIt.I<StatisticCubit>().users[index],
                        isDelete: widget.isDelete,
                        isAdmin:
                            GetIt.I<LoginCubit>().currentUser!.role == "admin",
                      );
                    },
                  ),
                ],
              ),
            );
          }
          return Center(child: Text("No Data"));
        },
      ),
    );
  }
}
