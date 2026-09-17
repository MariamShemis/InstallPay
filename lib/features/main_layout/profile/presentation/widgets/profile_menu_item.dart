import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';

class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final VoidCallback onTap;
  final bool showDivider;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailingText,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Column(
        children: [
          Padding(
            padding: REdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: REdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? ColorManager.darkSurfaceVariant
                        : ColorManager.blueSoftBackground,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    icon,
                    color: isDark
                        ? ColorManager.darkAccentGreen
                        : ColorManager.primaryColor,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? ColorManager.white : ColorManager.navyDark,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (trailingText != null) ...[
                  Text(
                    trailingText!,
                    style: TextStyle(
                      color: isDark
                          ? ColorManager.darkAccentGreen1
                          : ColorManager.primaryColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4.w),
                ],
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDark
                      ? ColorManager.darkSlateText
                      : ColorManager.greySecondaryText,
                  size: 15.sp,
                ),
              ],
            ),
          ),
          if (showDivider)
            Divider(
              height: 1,
              thickness: 1,
              color: isDark
                  ? ColorManager.darkSurfaceVariant
                  : ColorManager.blueLightTint.withOpacity(0.5),
              indent: 16.w,
              endIndent: 16.w,
            ),
        ],
      ),
    );
  }
}