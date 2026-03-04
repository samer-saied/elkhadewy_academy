import 'package:flutter/material.dart';

import '../../../../utils/colors.dart';

class DataBox extends StatelessWidget {
  final String title;
  final String txt;
  final IconData iconData;
  final Color? color;

  const DataBox({
    super.key,
    required this.title,
    this.color,
    required this.iconData,
    required this.txt,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.lightGrey.withAlpha(50),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(iconData, color: AppColors.blackColor),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                title,
                style: TextStyle(
                  color: color ?? AppColors.blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              txt,
              style: TextStyle(
                color: color ?? AppColors.jonquil,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///
///
///////////// Name Label  Widget
class NameLabelWidget extends StatelessWidget {
  final String txt;
  const NameLabelWidget({super.key, required this.txt});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          txt,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: AppColors.blackColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
