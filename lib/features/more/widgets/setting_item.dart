import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class SettingItem extends StatelessWidget {
  final IconData? leadingIcon;
  final IconData? tailingIcon;
  final Color leadingIconColor;
  final Color bgIconColor;
  final Color txtIColor;
  final String title;
  final GestureTapCallback? onTap;
  const SettingItem({
    super.key,
    required this.title,
    this.onTap,
    this.leadingIcon,
    this.tailingIcon,
    this.leadingIconColor = Colors.white,
    this.txtIColor = Colors.black,
    required this.bgIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
          right: 10,
          left: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: leadingIcon != null
              ? [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: bgIconColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(leadingIcon, color: leadingIconColor),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 16, color: txtIColor),
                    ),
                  ),
                  Icon(
                    tailingIcon ?? Icons.arrow_forward_ios,
                    color: tailingIcon != null
                        ? AppColors.jonquil
                        : Colors.grey,
                    size: 17,
                  ),
                ]
              : [
                  Expanded(
                    child: Text(title, style: const TextStyle(fontSize: 16)),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.mainColor,
                    size: 17,
                  ),
                ],
        ),
      ),
    );
  }
}
