import 'package:flutter/material.dart';

import '../../../../utils/colors.dart';
import '../../../auth/models/user_model.dart';
import '../user_todo_reports_screen.dart';

class ReportCardWidget extends StatelessWidget {
  const ReportCardWidget({
    super.key,
    required this.student,
    required this.index,
  });

  final UserModel student;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserToDoReportsPage(user: student),
          ),
        );
      },
      child: Card(
        color: AppColors.whiteColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppColors.jonquil,
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
                            padding: const EdgeInsets.symmetric(horizontal: 8),
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
                      ],
                    ),

                    ////////////    CALL & WHATSAPP BUTTONS    //////////////////
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SmallButtonWidget(
                          iconName: Icons.receipt_rounded,
                          iconTxt: "View User Activity",
                          bkColor: AppColors.jonquilLight,
                          onTap: () {},
                        ),

                        // SmallButtonWidget(
                        //   iconName: Icons.chat_sharp,
                        //   iconTxt: "Whatsapp",
                        //   bkColor: AppColors.emerald,
                        //   onTap: () {
                        //     launchUrl(
                        //       Uri.parse("https://wa.me/2${student.phone}"),
                        //       mode: LaunchMode.externalApplication,
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.lightprussianBlue,
              ),
            ),
          ],
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
