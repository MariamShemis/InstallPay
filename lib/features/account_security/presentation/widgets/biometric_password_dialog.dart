import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class BiometricPasswordDialog extends StatefulWidget {
  const BiometricPasswordDialog({super.key});

  @override
  State<BiometricPasswordDialog> createState() =>
      _BiometricPasswordDialogState();
}

class _BiometricPasswordDialogState extends State<BiometricPasswordDialog> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final password = _passwordController.text;
    if (password.trim().isEmpty) return;
    Navigator.of(context).pop(password);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryColor = isDark
        ? ColorManager.darkAccentGreen
        : ColorManager.primaryColor;

    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 22.w),
      icon: Container(
        width: 62.w,
        height: 62.h,
        decoration: BoxDecoration(
          color: isDark
              ? ColorManager.darkGreenContainer
              : ColorManager.greenOpacity15,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.fingerprint_rounded, color: primaryColor, size: 32.r),
      ),
      title: Text(localization.fingerprintLogin, textAlign: TextAlign.center),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              localization.secure_access_with_your_fingerprint,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            SizedBox(height: 18.h),
            TextField(
              controller: _passwordController,
              obscureText: true,
              autofocus: true,
              decoration: InputDecoration(
                labelText: localization.currentPassword,
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              onSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.end,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(localization.cancel),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(localization.ok),
        ),
      ],
      backgroundColor:
          Theme.of(context).dialogTheme.backgroundColor ??
          (isDark ? ColorManager.darkSurface : ColorManager.white),
    );
  }
}
