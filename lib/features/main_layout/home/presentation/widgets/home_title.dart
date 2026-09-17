import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class HomeTitle extends StatelessWidget {
  const HomeTitle({super.key, required this.name, required this.image});

  final String name;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final now = DateTime.now();
    final dayName = DateFormat('EEEE').format(now);
    final fullDate = DateFormat('dd MMM yyyy').format(now);

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
              Text(
                "${appLocalizations.welcome_back} ✨",
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 13.sp,
                  color: isDark ? colorScheme.onSurface.withOpacity(0.7) : textTheme.bodyMedium?.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                name,
                style: textTheme.titleMedium?.copyWith(
                  fontSize: 18.sp,
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              dayName,
              style: textTheme.bodyMedium?.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              fullDate,
              style: textTheme.titleMedium?.copyWith(
                fontSize: 15.sp,
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}