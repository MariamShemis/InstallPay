import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';

class UiUtils {
  static bool _isLoadingShowing = false;

  static void showLoading(BuildContext context, {bool isDismissible = false}) {
    if (_isLoadingShowing) return;

    _isLoadingShowing = true;
    showDialog(
      context: context,
      barrierDismissible: isDismissible,
      useRootNavigator: true,
      builder: (_) {
        return PopScope(
          canPop: isDismissible,
          child: const AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Center(
              child: CircularProgressIndicator(
                color: ColorManager.primaryColor,
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
