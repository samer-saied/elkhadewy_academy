import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class WarningWidget extends StatelessWidget {
  final String errorMsg;
  final String errorDes;
  final Widget? iconWidget;
  const WarningWidget({
    super.key,
    required this.errorMsg,
    required this.errorDes,
    this.iconWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          color: AppColors.jonquil,
          strokeWidth: 1.5,
          dashPattern: const [6, 3],
          radius: const Radius.circular(15),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: const Color(0xFFD49E3C),
                child: const Icon(
                  Icons.headphones,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                errorMsg,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFD49E3C),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 5),
              Text(
                errorDes,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
