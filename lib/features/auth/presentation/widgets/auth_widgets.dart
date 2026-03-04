import 'package:flutter/material.dart';

import '../../../../utils/colors.dart';

// === Custom Text Field with Label Outside ===
class LabeledInputFields extends StatelessWidget {
  final String label;
  final String hint;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextEditingController controller;
  final VoidCallback? onTogglePassword;
  final bool isPasswordVisible;
  final bool? isEnabled;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int? maxLines;

  const LabeledInputFields({
    super.key,
    required this.label,
    required this.hint,
    this.prefixIcon,
    required this.controller,
    this.isPassword = false,
    this.onTogglePassword,
    this.isPasswordVisible = false,
    this.isEnabled = true,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            enabled: isEnabled,
            controller: controller,
            obscureText: isPassword && !isPasswordVisible,
            textAlignVertical: TextAlignVertical.center,
            validator: validator,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.whiteColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              hintText: hint,
              hintStyle: TextStyle(color: AppColors.grey),
              prefixIcon: prefixIcon != null
                  ? IconButton(
                      icon: Icon(
                        isPasswordVisible ? Icons.visibility : prefixIcon,
                        color: AppColors.grey,
                      ),
                      onPressed: onTogglePassword,
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.lightGrey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.lightGrey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.jonquil),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// === Selection Chip for Academic Year ===
class YearSelectionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const YearSelectionChip({
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
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.jonquil : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.jonquil : AppColors.lightGrey,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: isSelected ? AppColors.whiteColor : AppColors.blackColor,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          // GoogleFonts.cairo(
          //   color: isSelected ? AppColors.white : AppColors.textGrey,
          //   fontWeight: FontWeight.bold,
          //   fontSize: 13,
          // ),
        ),
      ),
    );
  }
}
