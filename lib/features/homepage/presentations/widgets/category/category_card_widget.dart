import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../utils/colors.dart';
import '../../../data/model/category_model.dart';

class CategoryCardWidget extends StatelessWidget {
  final CategoryModel category;

  const CategoryCardWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final color = category.color != null
        ? Color(int.tryParse(category.color.toString()) ?? 0xFFd49b33)
        : AppColors.jonquil;

    bool isDark = Theme.brightnessOf(context) == Brightness.dark;

    return Container(
      height: 120,
      width: MediaQuery.sizeOf(context).width * 0.27,
      padding: const EdgeInsets.all(7.0),
      margin: const EdgeInsets.symmetric(horizontal: 3.0),
      decoration: BoxDecoration(
        color: isDark ? color.withAlpha(60) : color.withAlpha(20),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: isDark
              ? AppColors.lightGrey.withAlpha(30)
              : color.withAlpha(50),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            flex: 2,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: SizedBox.expand(
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedImageCrop,
                  color: AppColors.grey.withAlpha(80),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Text(
              category.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.whiteColor : color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
