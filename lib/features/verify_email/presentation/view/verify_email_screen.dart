import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/assets_manager.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/firebase/firebase_auth_services.dart';
import 'package:smart_installment_management/core/routes/app_routes.dart';
import 'package:smart_installment_management/core/utils/ui_utils.dart';
import 'package:smart_installment_management/features/verify_email/data/cubit/verify_email_cubit.dart';
import 'package:smart_installment_management/features/verify_email/data/cubit/verify_email_state.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({
    super.key,
    this.email,
    this.fromAccountSecurity = false,
  });

  final String? email;
  final bool fromAccountSecurity;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final imagePath = isDark
        ? ImageAssets.verifyEmailDark
        : ImageAssets.verifyEmail;

    final accentColor = isDark
        ? ColorManager.darkAccentGreen
        : ColorManager.primaryColor;

    return BlocConsumer<VerifyEmailCubit, VerifyEmailState>(
      listener: (context, state) async {
        if (state is VerifyEmailLoading || state is VerifyEmailChecking) {
          UiUtils.showLoading(context, isDismissible: false);
          return;
        }

        UiUtils.hideLoading(context);

        if (state is VerifyEmailSent) {
          UiUtils.showSuccess(context, localizations.verificationEmailSent);
        }

        if (state is VerifyEmailError) {
          UiUtils.showError(context, state.message);
        }

        if (state is VerifyEmailNotVerified) {
          UiUtils.showError(context, localizations.emailNotVerifiedYet);
        }

        if (state is VerifyEmailVerified) {
          if (fromAccountSecurity) {
            // Return to Account Security without signing out.
            Navigator.of(context).pop(true);
            return;
          }
          await FirebaseAuthServices.logout();
          if (!context.mounted) return;
          UiUtils.showToast(localizations.emailVerifiedSuccessfully);
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
        }
      },
      builder: (context, state) {
        final isBusy =
            state is VerifyEmailLoading || state is VerifyEmailChecking;

        final displayedEmail =
            email ?? FirebaseAuthServices.currentFirebaseUser?.email ?? '';

        return Scaffold(
          backgroundColor: colors.surface,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                tooltip: localizations.close,
                onPressed: isBusy
                    ? null
                    : () async {
                        if (fromAccountSecurity) {
                          Navigator.of(context).pop(false);
                          return;
                        }

                        await FirebaseAuthServices.logout();

                        if (!context.mounted) return;

                        Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.login,
                          (route) => false,
                        );
                      },
                icon: const Icon(CupertinoIcons.clear),
              ),
              SizedBox(width: 8.w),
            ],
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: REdgeInsets.fromLTRB(24, 8, 24, 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 440.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        imagePath,
                        width: 300.w,
                        height: 300.h,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.mark_email_unread_outlined,
                            size: 150.r,
                            color: accentColor,
                          );
                        },
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        localizations.verifyYourEmailAddress,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium,
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        width: double.infinity,
                        padding: REdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              color: accentColor,
                              size: 22.r,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                displayedEmail,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: accentColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Text(
                        localizations.verifyEmailDescription,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.7,
                        ),
                      ),
                      SizedBox(height: 32.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isBusy
                              ? null
                              : () {
                                  context
                                      .read<VerifyEmailCubit>()
                                      .checkEmailVerification();
                                },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isBusy) ...[
                                SizedBox(
                                  width: 18.r,
                                  height: 18.r,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colors.onPrimary,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                              ] else ...[
                                const Icon(Icons.verified_outlined),
                                SizedBox(width: 8.w),
                              ],
                              Text(
                                state is VerifyEmailChecking
                                    ? localizations.checking
                                    : localizations.iHaveVerifiedMyEmail,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          onPressed: isBusy
                              ? null
                              : () {
                                  context
                                      .read<VerifyEmailCubit>()
                                      .sendEmailVerification();
                                },
                          icon: const Icon(Icons.mark_email_read_outlined),
                          label: Text(localizations.resendVerificationEmail),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        localizations.checkSpamFolder,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(height: 1.6),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
