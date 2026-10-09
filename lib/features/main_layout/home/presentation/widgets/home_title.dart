import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class HomeTitle extends StatelessWidget {
  const HomeTitle({
    super.key,
    required this.name,
    required this.image,
    this.onCalculatorTap,
    required this.isPrivacyHidden,
    required this.onTogglePrivacy,
  });

  final String name;
  final Widget image;
  final VoidCallback? onCalculatorTap;
  final bool isPrivacyHidden;
  final VoidCallback onTogglePrivacy;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, dd MMM yyyy').format(now);

    final iconBgColor = isDark
        ? ColorManager.darkSurfaceVariant
        : ColorManager.blueSoftBackground;

    final iconColor = isDark
        ? ColorManager.darkAccentGreen1
        : ColorManager.primaryColor;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            Container(
              padding: REdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? ColorManager.white.withOpacity(0.5)
                      : colorScheme.primary,
                  width: 1.5.w,
                ),
              ),
              child: image,
            ),
          ],
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: textTheme.bodyLarge?.copyWith(
                    fontSize: 15.sp,
                    color: colorScheme.onSurface,
                  ),
                  children: [
                    TextSpan(
                      text: "${appLocalizations.welcome}, ",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 13.sp,
                      ),
                    ),
                    TextSpan(
                      text: name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: " ✨"),
                  ],
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                formattedDate,
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 11.5.sp,
                  color: isDark
                      ? colorScheme.onSurface.withOpacity(0.6)
                      : ColorManager.greySecondaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        Row(
          children: [
            InkWell(
              onTap: onTogglePrivacy,
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: REdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: iconColor, width: 0.7.w),
                ),
                child: Icon(
                  isPrivacyHidden
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: iconColor,
                  size: 22.r,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            InkWell(
              onTap: onCalculatorTap,
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: REdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: iconColor, width: 0.7.w),
                ),
                child: Icon(
                  Icons.calculate_outlined,
                  color: iconColor,
                  size: 22.r,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}