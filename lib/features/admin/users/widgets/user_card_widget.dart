import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/colors.dart';
import '../../../auth/bloc/register_cubit.dart';
import '../../../auth/models/user_model.dart';
import '../edit_user.dart';

class UserCardWidget extends StatelessWidget {
  const UserCardWidget({
    super.key,
    required this.student,
    required this.index,
    required this.isDelete,
  });

  final UserModel student;
  final bool isDelete;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(student.id.toString()),
      direction: isDelete ? DismissDirection.endToStart : DismissDirection.none,
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
            return;
          }
          GetIt.I<RegisterCubit>().deleteUser(userId: student.id);
        }
      },
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditUserPage(userModel: student),
            ),
          );
        },
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.jonquilLight,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                ),
                width: 30,
                height: 120,
                child: Center(
                  child: Text(
                    (index + 1).toString(),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ////////////    USER INFO    //////////////////
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    student.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(student.phone),
                                  Wrap(
                                    children: [
                                      Text("College : ${student.faculty}"),
                                      const SizedBox(width: 10),
                                      Text(
                                        "Academic Year : ${int.parse(student.studyYear) + 1}",
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ),

                          Column(
                            children: [
                              Wrap(
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
                            ],
                          ),
                        ],
                      ),

                      ////////////    CALL & WHATSAPP BUTTONS    //////////////////
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SmallButtonWidget(
                            iconName: Icons.phone,
                            iconTxt: "Call",
                            bkColor: AppColors.redWood,
                            onTap: () {
                              launchUrl(
                                Uri.parse("tel:${student.phone}"),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                          ),
                          SmallButtonWidget(
                            iconName: Icons.chat_sharp,
                            iconTxt: "Whatsapp",
                            bkColor: AppColors.emerald,
                            onTap: () {
                              launchUrl(
                                Uri.parse("https://wa.me/2${student.phone}"),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SmallButtonWidget extends StatelessWidget {
  final Color bkColor;
  final Color? iconColor;
  final IconData iconName;
  final String? iconTxt;
  final void Function()? onTap;
  const SmallButtonWidget({
    super.key,
    required this.bkColor,
    required this.iconName,
    required this.onTap,
    this.iconTxt,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 3),
        decoration: iconTxt == null
            ? BoxDecoration(color: bkColor, shape: BoxShape.circle)
            : BoxDecoration(
                color: bkColor,
                borderRadius: BorderRadius.circular(25),
              ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          child: Row(
            children: [
              Icon(
                iconName,
                size: 18,
                color: iconColor ?? AppColors.whiteColor,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                child: Text(
                  iconTxt ?? "",
                  style: TextStyle(color: iconColor ?? AppColors.whiteColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
