import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:smart_installment_management/core/costants/assets_manager.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/utils/validators/app_validators.dart';
import 'package:smart_installment_management/features/auth/presentation/widgets/custom_auth_text_form_field.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          appLocalizations.forgetPassword,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: REdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          child: _emailSent
              ? _buildSuccessView(context, appLocalizations, theme, colorScheme)
              : Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  ImageAssets.forgetPassword,
                  height: 350.h,
                  fit: BoxFit.fill,
                ),
                SizedBox(height: 2.h),
                Card(
                  child: Padding(
                    padding: REdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          appLocalizations.forget_password_,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          appLocalizations
                              .pleaseEnterYourEmailToReceiveAConfirmationCodeToSetANewPassword,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),
                        CustomAuthTextFormField(
                          controller: _emailController,
                          labelText: appLocalizations.email,
                          hintText: appLocalizations.enterYourEmail,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: const Icon(Icons.email_outlined),
                          validator: (value) =>
                              AppValidators.validateEmail(value, context),
                        ),
                        SizedBox(height: 24.h),
                        ElevatedButton(
                          onPressed: _resetPassword,
                          child: Text(appLocalizations.sendResetLink),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _resetPassword() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _emailSent = true;
    });
  }

  Widget _buildSuccessView(
      BuildContext context,
      AppLocalizations appLocalizations,
      ThemeData theme,
      ColorScheme colorScheme,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: REdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  ImageAssets.emailSend,
                  height: 320.h,
                  fit: BoxFit.fill,
                ),
                SizedBox(height: 2.h),
                Icon(
                  Icons.mark_email_read_rounded,
                  color: ColorManager.darkAccentGreen,
                  size: 48.sp,
                ),
                SizedBox(height: 12.h),
                Text(
                  "${appLocalizations.emailSent}!",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  appLocalizations.we_ve_sent_a_password_reset_link_to,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                SizedBox(height: 6.h),
                Text(
                  _emailController.text.trim(),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                    color: colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Text(
                  appLocalizations
                      .please_check_your_inbox_and_follow_the_instructions_to_reset_your_password,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall,
                ),
                SizedBox(height: 24.h),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(appLocalizations.back_to_Login),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}