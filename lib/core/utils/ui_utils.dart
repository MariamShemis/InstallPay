import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class UiUtils {
  static bool _isLoadingShowing = false;

  static void showLoading(BuildContext context, {bool isDismissible = false}) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    if (_isLoadingShowing) return;

    _isLoadingShowing = true;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: isDismissible,
      barrierColor: Colors.black.withOpacity(0.35),
      useRootNavigator: true,
      builder: (_) {
        return PopScope(
          canPop: isDismissible,
          child: Center(
            child: Container(
              padding: REdgeInsets.all(20),
              width: 350.w,
              decoration: BoxDecoration(
                color: isDark ? ColorManager.darkSurface : ColorManager.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isDark
                      ? ColorManager.darkSurfaceVariant
                      : ColorManager.blueLightTint,
                  width: 1.w,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 36.r,
                    height: 36.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 4.w,
                      color: isDark
                          ? ColorManager.darkAccentGreen
                          : ColorManager.primaryColor,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  DefaultTextStyle(
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? ColorManager.darkMutedText
                          : ColorManager.greyDark,
                    ),
                    child: Text('${appLocalizations.loading} ...'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((_) {
      _isLoadingShowing = false;
    });
  }

  static void hideLoading(BuildContext context) {
    if (_isLoadingShowing) {
      _isLoadingShowing = false;
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  static void showMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(content: Text(message)),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showToast(
      String message, {
        Color backgroundColor = Colors.green,
      }) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
    );
  }
}