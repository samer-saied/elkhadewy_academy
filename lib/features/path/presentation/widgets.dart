import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../utils/colors.dart';
import '../../homepage/data/model/category_model.dart';

class CollegeCard extends StatelessWidget {
  final CategoryModel college;
  final bool isSelected;
  final VoidCallback onTap;

  const CollegeCard({
    super.key,
    required this.college,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(maxHeight: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lightGrey.withAlpha(30) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.jonquil : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white
                    : AppColors.lightGrey.withAlpha(50),
                borderRadius: BorderRadius.circular(8),
              ),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedCollectionsBookmark,
                color: AppColors.jonquil,
              ),
            ),
            const Spacer(),
            FittedBox(
              child: Text(
                college.title,
                style: AppTextStyles.heading.copyWith(fontSize: 16),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              college.subtitle ?? college.title,
              style: AppTextStyles.subHeading.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class YearChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const YearChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.jonquil : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppColors.jonquil : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.blackColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    color: AppColors.blackColor,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle subHeading = TextStyle(
    color: AppColors.grey,
    fontSize: 14,
  );
}
