import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/navigation/app_routes.dart';
import '../../../../../utils/colors.dart';
import '../../../data/model/category_model.dart';

class CategoryChipWidget extends StatelessWidget {
  final CategoryModel category;

  const CategoryChipWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final color = category.color != null
        ? Color(int.tryParse(category.color.toString()) ?? 0xFF000000)
        : AppColors.jonquil;
    bool isDark = Theme.brightnessOf(context) == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.courses,
          arguments: {'collegeId': category.id, 'yearId': 'All'},
        );
      },
      child: Container(
        padding: const EdgeInsets.all(7.0),
        margin: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 5),
        constraints: BoxConstraints(
          minWidth: MediaQuery.sizeOf(context).width / 3,
        ),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
          // color: color.withAlpha(10),
          // borderRadius: BorderRadius.circular(7),
          // border: Border.all(
          //   color: AppColors.lightGrey.withAlpha(90),
          //   width: 1.0,
          // ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(3.0),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedCollectionsBookmark,
                color: AppColors.whiteColor,
                size: 15.0,
                strokeWidth: 2.5, // Custom stroke width
              ),
            ),
            SizedBox(width: 3),
            Text(
              category.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: isDark ? AppColors.whiteColor : color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
