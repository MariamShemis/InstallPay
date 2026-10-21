import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class AccountInfoCard extends StatelessWidget {
  const AccountInfoCard({
    super.key,
    required this.email,
    required this.isVerified,
  });

  final String email;
  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final statusColor = isVerified
        ? (isDark ? ColorManager.darkAccentGreen1 : ColorManager.green)
        : ColorManager.warningOrange;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isDark
              ? ColorManager.darkSurfaceVariant
              : ColorManager.blueLightTint,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 70.r,
            height: 70.r,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(22.r),
            ),
            child: Icon(
              Icons.shield_moon_outlined,
              color: statusColor,
              size: 38.r,
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            localization.secureYourAccount,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            email.isEmpty ? localization.noEmailProvided : email,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 18.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isVerified
                      ? Icons.verified_rounded
                      : Icons.info_outline_rounded,
                  color: statusColor,
                  size: 18.r,
                ),
                SizedBox(width: 8.w),
                Text(
                  isVerified
                      ? localization.emailVerified
                      : localization.emailNotVerified,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
