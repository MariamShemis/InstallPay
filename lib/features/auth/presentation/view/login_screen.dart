import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_installment_management/core/costants/assets_manager.dart';
import 'package:smart_installment_management/core/routes/app_routes.dart';
import 'package:smart_installment_management/core/utils/validators/app_validators.dart';
import 'package:smart_installment_management/core/widgets/logo_app.dart';
import 'package:smart_installment_management/features/auth/presentation/widgets/custom_auth_text_form_field.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _rememberMe = false;

  @override
  void dispose() {
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: REdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LogoApp(),
                  SizedBox(height: 24.h),
                  Card(
                    child: Padding(
                      padding: REdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appLocalizations.welcome_back,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            appLocalizations
                                .sign_in_to_access_your_installment_management_workspace,
                            style: theme.textTheme.bodyMedium,
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 24.h),
                          CustomAuthTextFormField(
                            controller: _emailController,
                            labelText: appLocalizations.email,
                            hintText: appLocalizations.enterYourEmail,
                            prefixIcon: const Icon(Icons.email_outlined),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) =>
                                AppValidators.validateEmail(value, context),
                          ),
                          SizedBox(height: 20.h),
                          CustomAuthTextFormField(
                            controller: _passwordController,
                            labelText: appLocalizations.password,
                            hintText: '••••••••',
                            prefixIcon: const Icon(Icons.lock_outline),
                            isPassword: true,
                            validator: (value) =>
                                AppValidators.validatePassword(value, context),
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              SizedBox(
                                height: 24.h,
                                width: 24.w,
                                child: Checkbox(
                                  value: _rememberMe,
                                  activeColor: colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value ?? false;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                appLocalizations.rememberMe,
                                style: theme.textTheme.bodyMedium,
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.forgetPassword,
                                  );
                                },
                                child: Text(
                                  appLocalizations.forget_password_,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Perform Sign In Action
                              }
                            },
                            child: Text(appLocalizations.login),
                          ),
                          SizedBox(height: 24.h),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(color: theme.dividerColor),
                              ),
                              Padding(
                                padding: REdgeInsets.symmetric(
                                  horizontal: 12.w,
                                ),
                                child: Text(
                                  appLocalizations.orContinueWith.toUpperCase(),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(color: theme.dividerColor),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          OutlinedButton(
                            onPressed: () {
                              // Perform Google Sign In Action
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  SvgAssets.googleIcon,
                                  height: 20.h,
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  appLocalizations.login_with_Google,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "${appLocalizations.dontHaveAnAccount}  ",
                            style: theme.textTheme.bodyMedium,
                          ),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.register,
                                );
                              },
                              child: Text(
                                appLocalizations.register,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
