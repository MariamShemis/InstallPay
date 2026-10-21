import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/routes/app_routes.dart';
import 'package:smart_installment_management/features/account_security/data/cubit/account_security_cubit.dart';
import 'package:smart_installment_management/features/account_security/data/cubit/account_security_state.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final passwordController = TextEditingController();
  bool isSubmitting = false;

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.read<AccountSecurityCubit>();

    return BlocListener<AccountSecurityCubit, AccountSecurityState>(
      listener: (context, state) {
        if (state is AccountSecurityLoading &&
            state.action == AccountSecurityCubit.deleteAccountAction) {
          setState(() => isSubmitting = true);
        }

        if (state is AccountSecurityError) {
          setState(() => isSubmitting = false);
        }

        if (state is AccountSecuritySuccess &&
            state.action == AccountSecurityCubit.deleteAccountAction) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
        }
      },
      child: AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 22.w),
        icon: Container(
          width: 62.w,
          height: 62.h,
          decoration: BoxDecoration(
            color: isDark
                ? ColorManager.darkRedContainer.withOpacity(0.7)
                : ColorManager.red.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.delete_forever_rounded,
            color: isDark ? ColorManager.redErrorDark : ColorManager.red,
            size: 32.r,
          ),
        ),
        title: Text(localization.deleteAccount, textAlign: TextAlign.center),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                localization.deleteAccountWarning,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
              SizedBox(height: 18.h),
              if (cubit.isEmailPasswordAccount)
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: localization.currentPassword,
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                ),
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: isSubmitting ? null : () => Navigator.of(context).pop(),
            child: Text(localization.cancel),
          ),
          TextButton(
            onPressed: isSubmitting
                ? null
                : () {
                    if (passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(localization.this_field_is_required),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }
                    cubit.deleteAccount(
                      currentPassword: passwordController.text,
                      context: context,
                    );
                  },
            child: Text(
              localization.delete,
              style: TextStyle(
                color: isDark ? ColorManager.redErrorDark : ColorManager.red,
              ),
            ),
          ),
        ],
        backgroundColor:
            Theme.of(context).dialogTheme.backgroundColor ??
            (isDark ? ColorManager.darkSurface : ColorManager.white),
      ),
    );
  }
}
