import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class LogoutButton extends StatelessWidget {
  final bool isDark;
  final String label;
  final VoidCallback onPressed;

  const LogoutButton({
    super.key,
    required this.isDark,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: TextButton(
        onPressed: () => _showDialogLogOut(context),
        style: TextButton.styleFrom(
          backgroundColor: isDark
              ? ColorManager.darkRedContainer
              : ColorManager.red.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: isDark
                  ? ColorManager.redErrorDark
                  : ColorManager.red.withOpacity(0.1),
              width: 0.5.w,
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout_rounded,
              color: isDark ? ColorManager.redErrorDark : ColorManager.red,
              size: 18.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                color: isDark ? ColorManager.redErrorDark : ColorManager.red,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialogLogOut(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? ColorManager.darkSurface : ColorManager.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: isDark
              ? BorderSide(color: ColorManager.darkSurfaceVariant, width: 1.w)
              : BorderSide.none,
        ),
        title: Text(
          appLocalizations.log_out,
          style: TextStyle(
            color: isDark ? ColorManager.darkAccentGreen : ColorManager.primaryColor,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          appLocalizations.are_you_sure_you_want_to_log_out,
          style: TextStyle(
            color: isDark ? ColorManager.darkSlateText : ColorManager.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              appLocalizations.cancel,
              style: TextStyle(
                color: ColorManager.redErrorDark,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(
              appLocalizations.ok,
              style: TextStyle(
                color: isDark
                    ? ColorManager.darkAccentGreen
                    : ColorManager.primaryColor,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}