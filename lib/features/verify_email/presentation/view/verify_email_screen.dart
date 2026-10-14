import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/firebase/firebase_auth_services.dart';
import 'package:smart_installment_management/core/routes/app_routes.dart';
import 'package:smart_installment_management/core/utils/ui_utils.dart';
import 'package:smart_installment_management/features/verify_email/data/cubit/verify_email_cubit.dart';
import 'package:smart_installment_management/features/verify_email/data/cubit/verify_email_state.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final mutedColor = isDark
        ? ColorManager.darkMutedText
        : ColorManager.greyDark;

    final accentColor = isDark
        ? ColorManager.darkAccentGreen
        : ColorManager.primaryColor;

    return BlocConsumer<VerifyEmailCubit, VerifyEmailState>(
      listener: (context, state) {
        if (state is VerifyEmailSent) {
          UiUtils.showSuccess(
            context,
            'Verification email sent. Check your inbox.',
          );
        }

        if (state is VerifyEmailError) {
          UiUtils.showError(context, state.message);
        }

        if (state is VerifyEmailNotVerified) {
          UiUtils.showError(
            context,
            'Your email is not verified yet. Open the link in your email first.',
          );
        }

        if (state is VerifyEmailVerified) {
          UiUtils.showToast('Your email has been verified successfully.');

          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
        }
      },
      builder: (context, state) {
        final isBusy =
            state is VerifyEmailLoading || state is VerifyEmailChecking;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: isBusy
                  ? null
                  : () async {
                      await FirebaseAuthServices.logout();

                      if (context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.login,
                          (route) => false,
                        );
                      }
                    },
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            title: const Text('Verify Email'),
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: REdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 440.w),
                  child: Card(
                    child: Padding(
                      padding: REdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 100.r,
                            height: 100.r,
                            decoration: BoxDecoration(
                              color: accentColor.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.mark_email_unread_outlined,
                              size: 52.r,
                              color: accentColor,
                            ),
                          ),
                          SizedBox(height: 28.h),
                          Text(
                            'Verify your email address',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineMedium,
                          ),
                          SizedBox(height: 14.h),
                          Text(
                            'We have sent a verification link to your email address. Open the email and tap the link to activate your account.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              height: 1.6,
                              color: mutedColor,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Container(
                            width: double.infinity,
                            padding: REdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: colors.surface,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isDark
                                    ? ColorManager.whiteOpacity20
                                    : ColorManager.blueLightTint,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  color: accentColor,
                                  size: 22.r,
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    email ??
                                        FirebaseAuthServices
                                            .currentFirebaseUser
                                            ?.email ??
                                        '',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colors.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: isBusy
                                  ? null
                                  : () {
                                      context
                                          .read<VerifyEmailCubit>()
                                          .checkEmailVerification();
                                    },
                              icon: isBusy
                                  ? SizedBox(
                                      width: 18.r,
                                      height: 18.r,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.verified_outlined),
                              label: Text(
                                state is VerifyEmailChecking
                                    ? 'Checking...'
                                    : 'I have verified my email',
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: isBusy
                                  ? null
                                  : () {
                                      context
                                          .read<VerifyEmailCubit>()
                                          .sendEmailVerification();
                                    },
                              icon: const Icon(Icons.mark_email_read_outlined),
                              label: const Text('Resend verification email'),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            'Did not receive the email? Check your spam folder, then try sending it again.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
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
