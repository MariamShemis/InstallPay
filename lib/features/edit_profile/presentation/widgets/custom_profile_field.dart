import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';

class CustomProfileField extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final void Function(String)? onChanged;

  const CustomProfileField({
    super.key,
    required this.title,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: REdgeInsets.only(left: 4, bottom: 8, right: 4),
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: isDark
                  ? ColorManager.darkMutedText
                  : ColorManager.greyDark,
            ),
          ),
        ),
        TextFormField(
          onChanged: onChanged,
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 14.sp,
            // color: readOnly
            //     ? (isDark
            //           ? ColorManager.darkSlateText
            //           : ColorManager.greySecondaryText)
            //     : null,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            // fillColor: readOnly
            //     ? (isDark
            //           ? ColorManager.darkSurfaceVariant.withOpacity(0.5)
            //           : ColorManager.greyLight)
            //     : null,
          ),
        ),
      ],
    );
  }
}
