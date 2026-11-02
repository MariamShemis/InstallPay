import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class UiUtils {
  static bool _isLoadingShowing = false;
  static DialogRoute<void>? _loadingRoute;
  static NavigatorState? _loadingNavigator;

  static void showLoading(BuildContext context, {bool isDismissible = false}) {
    if (!context.mounted || _isLoadingShowing) return;

    final appLocalizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navigator = Navigator.of(context, rootNavigator: true);

    final route = DialogRoute<void>(
      context: context,
      barrierDismissible: isDismissible,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (dialogContext) {
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
    );

    _isLoadingShowing = true;
    _loadingRoute = route;
    _loadingNavigator = navigator;

    route.completed.then((_) {
      if (identical(_loadingRoute, route)) {
        _loadingRoute = null;
        _loadingNavigator = null;
        _isLoadingShowing = false;
      }
    });

    navigator.push<void>(route);
  }

  static void hideLoading(BuildContext context) {
    final route = _loadingRoute;
    final navigator = _loadingNavigator;

    if (!_isLoadingShowing || route == null || navigator == null) {
      return;
    }

    // Close the loading dialog itself, not whichever route happens
    // to be on top of the Navigator.
    if (route.isActive) {
      navigator.removeRoute(route);
    } else {
      _loadingRoute = null;
      _loadingNavigator = null;
      _isLoadingShowing = false;
    }
  }

  static void showMessage(BuildContext context, String message) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(content: Text(message)),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
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
