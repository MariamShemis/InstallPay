import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/utils/validators/app_validators.dart';
import 'package:smart_installment_management/core/widgets/logo_app.dart';
import 'package:smart_installment_management/features/auth/presentation/widgets/custom_auth_text_form_field.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
        title: Text(appLocalizations.sign_up),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: REdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LogoApp(),
                SizedBox(height: 24.h),

                // Main Form Card
                Card(
                  child: Padding(
                    padding: REdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appLocalizations.createAccount,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'Join your branch network & start managing installment portfolios',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium,
                        ),
                        SizedBox(height: 8.h),

                        CustomAuthTextFormField(
                          controller: _nameController,
                          labelText: appLocalizations.name,
                          hintText: appLocalizations.enterYourName,
                          prefixIcon: const Icon(Icons.person_outline_outlined),
                          keyboardType: TextInputType.name,
                          validator: (value) =>
                              AppValidators.validateName(value, context),
                        ),
                        SizedBox(height: 16.h),
                        CustomAuthTextFormField(
                          controller: _phoneController,
                          labelText: appLocalizations.phoneNumber,
                          hintText: appLocalizations.enterYourPhoneNumber,
                          prefixIcon: const Icon(Icons.phone_outlined),
                          keyboardType: TextInputType.phone,
                          validator: (value) =>
                              AppValidators.validatePhone(value, context),
                        ),
                        SizedBox(height: 16.h),
                        CustomAuthTextFormField(
                          controller: _emailController,
                          labelText: appLocalizations.email,
                          hintText: appLocalizations.enterYourEmail,
                          prefixIcon: const Icon(Icons.email_outlined),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) =>
                              AppValidators.validateEmail(value, context),
                        ),
                        SizedBox(height: 16.h),
                        CustomAuthTextFormField(
                          controller: _passwordController,
                          labelText: appLocalizations.password,
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          isPassword: true,
                          validator: (value) =>
                              AppValidators.validatePassword(value, context),
                        ),
                        SizedBox(height: 16.h),
                        CustomAuthTextFormField(
                          controller: _confirmPasswordController,
                          labelText: appLocalizations.confirmPassword,
                          hintText: '••••••••',
                          keyboardType: TextInputType.visiblePassword,
                          isPassword: true,
                          validator: (value) =>
                              AppValidators.validateConfirmPassword(
                                value,
                                _passwordController.text,
                                context,
                              ),
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 24.h,
                              width: 24.w,
                              child: Checkbox(
                                value: _agreedToTerms,
                                activeColor: colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _agreedToTerms = value ?? false;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  style: theme.textTheme.bodySmall,
                                  children: [
                                    const TextSpan(text: 'I agree to the '),
                                    TextSpan(
                                      text: 'Terms of Service',
                                      style: TextStyle(
                                        color: colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    const TextSpan(text: ' & '),
                                    TextSpan(
                                      text: 'Financial Compliance Policies',
                                      style: TextStyle(
                                        color: colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        ElevatedButton(
                          onPressed: _agreedToTerms
                              ? () {
                                  if (_formKey.currentState!.validate()) {
                                    // Complete Registration Action
                                  }
                                }
                              : null,
                          child: Text(appLocalizations.sign_up),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 18.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${appLocalizations.alreadyHaveAccount} ",
                      style: theme.textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        appLocalizations.login,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
