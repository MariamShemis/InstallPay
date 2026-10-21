import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/utils/ui_utils.dart';
import 'package:smart_installment_management/features/account_security/data/cubit/account_security_cubit.dart';
import 'package:smart_installment_management/features/account_security/data/cubit/account_security_state.dart';
import 'package:smart_installment_management/features/account_security/presentation/widgets/password_text_field.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class ChangePasswordBottomSheet extends StatefulWidget {
  const ChangePasswordBottomSheet({super.key});

  @override
  State<ChangePasswordBottomSheet> createState() =>
      _ChangePasswordBottomSheetState();
}

class _ChangePasswordBottomSheetState extends State<ChangePasswordBottomSheet> {
  final currentController = TextEditingController();
  final newController = TextEditingController();
  final confirmController = TextEditingController();

  bool isSubmitting = false;

  @override
  void dispose() {
    currentController.dispose();
    newController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AccountSecurityCubit, AccountSecurityState>(
      listener: (context, state) {
        if (state is AccountSecurityLoading &&
            state.action == AccountSecurityCubit.changePasswordAction) {
          setState(() => isSubmitting = true);
        }

        if (state is AccountSecuritySuccess &&
            state.action == AccountSecurityCubit.changePasswordAction) {
          setState(() => isSubmitting = false);

          Navigator.of(context).pop();

          UiUtils.showSuccess(context, localization.updatePassword);
        }

        if (state is AccountSecurityError) {
          setState(() => isSubmitting = false);
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(
          20.w,
          14.h,
          20.w,
          MediaQuery.of(context).viewInsets.bottom + 24.h,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 46.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: isDark
                      ? ColorManager.darkSlateText
                      : ColorManager.blueLightTint,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              SizedBox(height: 24.h),
              Icon(
                Icons.lock_reset_rounded,
                size: 42.r,
                color: isDark
                    ? ColorManager.darkAccentGreen1
                    : ColorManager.primaryColor,
              ),
              SizedBox(height: 12.h),
              Text(
                localization.changePassword,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 24.h),

              PasswordTextField(
                controller: currentController,
                label: localization.currentPassword,
              ),
              SizedBox(height: 16.h),

              PasswordTextField(
                controller: newController,
                label: localization.newPassword,
              ),
              SizedBox(height: 16.h),

              PasswordTextField(
                controller: confirmController,
                label: localization.confirmPassword,
              ),
              SizedBox(height: 24.h),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () => _changePassword(context),
                  child: isSubmitting
                      ? SizedBox(
                          width: 22.r,
                          height: 22.r,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(localization.updatePassword),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changePassword(BuildContext context) async {
    final localization = AppLocalizations.of(context)!;

    final currentPassword = currentController.text.trim();
    final newPassword = newController.text;
    final confirmPassword = confirmController.text;

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      UiUtils.showError(context, localization.this_field_is_required);
      return;
    }

    if (newPassword.length < 6) {
      UiUtils.showError(context, localization.password_is_too_weak);
      return;
    }

    if (newPassword != confirmPassword) {
      UiUtils.showError(
        context,
        localization.something_went_wrong_Please_try_again,
      );
      return;
    }

    await context.read<AccountSecurityCubit>().changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      context: context,
    );
  }
}
