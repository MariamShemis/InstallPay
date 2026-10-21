import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/routes/app_routes.dart';
import 'package:smart_installment_management/core/utils/ui_utils.dart';
import 'package:smart_installment_management/features/account_security/data/cubit/account_security_cubit.dart';
import 'package:smart_installment_management/features/account_security/data/cubit/account_security_state.dart';
import 'package:smart_installment_management/features/account_security/presentation/widgets/account_info_card.dart';
import 'package:smart_installment_management/features/account_security/presentation/widgets/biometric_password_dialog.dart';
import 'package:smart_installment_management/features/account_security/presentation/widgets/change_password_bottom_sheet.dart';
import 'package:smart_installment_management/features/account_security/presentation/widgets/delete_account_dialog.dart';
import 'package:smart_installment_management/features/account_security/presentation/widgets/security_switch_tile.dart';
import 'package:smart_installment_management/features/account_security/presentation/widgets/security_tile.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  User? get currentUser => FirebaseAuth.instance.currentUser;
  bool biometricEnabled = false;
  bool isLoadingBiometric = true;

  @override
  void initState() {
    super.initState();
    _loadBiometricSetting();
  }

  Future<void> _loadBiometricSetting() async {
    final cubit = context.read<AccountSecurityCubit>();
    final enabled = await cubit.loadBiometricEnabled(context);

    if (!mounted) return;

    setState(() {
      biometricEnabled = enabled;
      isLoadingBiometric = false;
    });
  }

  Future<void> _toggleBiometric(bool enable) async {
    if (isLoadingBiometric) return;
    String? password;
    if (enable) {
      password = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const BiometricPasswordDialog(),
      );
      if (!mounted || password == null || password.isEmpty) {
        return;
      }
    }
    setState(() {
      isLoadingBiometric = true;
    });
    try {
      await context.read<AccountSecurityCubit>().toggleBiometric(
        enable,
        currentPassword: password,
        context: context,
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoadingBiometric = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = currentUser;
    final isVerified = user?.emailVerified ?? false;
    final email = user?.email ?? '';
    final securityCubit = context.read<AccountSecurityCubit>();

    return BlocListener<AccountSecurityCubit, AccountSecurityState>(
      listener: (context, state) {
        if (state is AccountSecurityLoading) {
          UiUtils.showLoading(context);
        } else {
          UiUtils.hideLoading(context);
        }

        if (state is AccountSecurityError) {
          UiUtils.showError(context, state.message);
        }

        if (state is AccountSecuritySuccess &&
            state.action == AccountSecurityCubit.verifyEmailAction) {
          UiUtils.showSuccess(
            context,
            localization.smartFinancialSolutions_FieldCollection,
          );
        }

        if (state is BiometricStatusChanged) {
          if (!mounted) return;

          setState(() {
            biometricEnabled = state.enabled;
          });

          UiUtils.showSuccess(
            context,
            localization.secure_access_with_your_fingerprint,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(localization.account_Security),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AccountInfoCard(email: email, isVerified: isVerified),
                SizedBox(height: 28.h),

                _SectionTitle(title: localization.accountProtection),
                SizedBox(height: 12.h),
                SecuritySwitchTile(
                  icon: Icons.fingerprint_rounded,
                  title: localization.fingerprintLogin,
                  subtitle: localization.secure_access_with_your_fingerprint,
                  value: biometricEnabled,
                  onChanged: isLoadingBiometric ? (_) {} : _toggleBiometric,
                ),
                SizedBox(height: 12.h),

                if (securityCubit.isEmailPasswordAccount) ...[
                  SecurityTile(
                    icon: Icons.lock_outline_rounded,
                    title: localization.changePassword,
                    subtitle: localization.update_your_account_password,
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) {
                          return BlocProvider.value(
                            value: securityCubit,
                            child: const ChangePasswordBottomSheet(),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 12.h),
                ],
                if (securityCubit.isEmailPasswordAccount && !isVerified) ...[
                  SecurityTile(
                    icon: Icons.mark_email_unread_outlined,
                    title: localization.verifyEmail,
                    subtitle: localization
                        .send_a_verification_email_to_your_email_address,
                    onTap: () async {
                      final verified = await Navigator.of(context)
                          .pushNamed<bool>(
                            AppRoutes.verifyEmail,
                            arguments: {
                              'email': email,
                              'fromAccountSecurity': true,
                            },
                          );

                      if (!mounted) return;

                      if (verified == true) {
                        await FirebaseAuth.instance.currentUser?.reload();

                        if (!mounted) return;

                        setState(() {});
                      }
                    },
                  ),
                  SizedBox(height: 28.h),
                ] else
                  SizedBox(height: 16.h),
                _SectionTitle(title: localization.dangerZone),
                SizedBox(height: 12.h),
                SecurityTile(
                  isRed: true,
                  icon: Icons.delete_outline_rounded,
                  title: localization.deleteAccount,
                  subtitle: localization.permanently_delete_your_account,
                  color: isDark
                      ? ColorManager.darkRedContainer
                      : ColorManager.red.withOpacity(0.1),
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      builder: (_) {
                        return BlocProvider.value(
                          value: securityCubit,
                          child: const DeleteAccountDialog(),
                        );
                      },
                    );
                  },
                ),

                SizedBox(height: 20.h),

                _SecurityNote(text: localization.accountSecurityDescription),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _SecurityNote extends StatelessWidget {
  const _SecurityNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark
            ? ColorManager.darkGreenContainer
            : ColorManager.greenOpacity10,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.shield_outlined,
            color: isDark
                ? ColorManager.darkAccentGreen1
                : ColorManager.primaryColor,
            size: 23.r,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
