// ويدجت العناوين الفرعية

import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class SectionHeaderWidget extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback? onTapFunc;

  const SectionHeaderWidget({
    super.key,
    required this.title,
    required this.action,
    this.onTapFunc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 15, 20, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.blackColor,
            ),
          ),
          GestureDetector(
            onTap: onTapFunc,
            child: Text(
              action,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.mainColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionHeaderSmallWidget extends StatelessWidget {
  final String title;
  final Color color;

  const SectionHeaderSmallWidget({
    super.key,
    required this.title,
    this.color = AppColors.blackColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}
