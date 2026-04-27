import 'package:flutter/material.dart';

import '../../../../utils/colors.dart';

class SimpleTitleWidget extends StatelessWidget {
  final String title;
  const SimpleTitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 5, bottom: 5),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: AppColors.jonquil,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
