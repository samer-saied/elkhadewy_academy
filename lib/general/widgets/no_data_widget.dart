import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:unimind/services/lang/app_localizations.dart';

import '../../utils/colors.dart';

class NoDataWidget extends StatelessWidget {
  final String? noDataTxt;
  const NoDataWidget({super.key, this.noDataTxt});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedAlbumNotFound02,
            color: AppColors.jonquil,
            size: 60,
          ),
          SizedBox(height: 10),
          ListTile(
            title: Text(
              noDataTxt ??
                  "No Courses Available Now, Please Try Again Later".tr(
                    context,
                  ),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
