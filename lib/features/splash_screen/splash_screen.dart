import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/assets_manager.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/routes/app_routes.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _fadeAnimation;

  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    FlutterNativeSplash.remove();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    _startSplash();
  }

  Future<void> _startSplash() async {
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundImage = isDark
        ? ImageAssets.splashBgDark
        : ImageAssets.splashBgLight;
    return Scaffold(
      backgroundColor: isDark ? ColorManager.bgDark : ColorManager.bgLight,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,

              child: ScaleTransition(
                scale: _scaleAnimation,

                child: Padding(
                  padding: REdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        ImageAssets.logoApp,
                        width: 180.w,
                        height: 180.w,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'Smart Installment Management',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'إدارة الأقساط الذكية',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontFamily: 'Arial',
                        ),
                      ),

                      SizedBox(height: 12.h),
                      Text(
                        appLocalizations.smartFinancialSolutions_FieldCollection,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 80.h),
                      SizedBox(
                        width: 220.w,
                        child: LinearProgressIndicator(
                          minHeight: 4.h,
                          borderRadius: BorderRadius.circular(10.r),
                          backgroundColor: isDark
                              ? ColorManager.darkSurfaceVariant
                              : ColorManager.blueLightTint,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isDark
                                ? ColorManager.darkAccentGreen
                                : ColorManager.green,
                          ),
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Text(
                        '${appLocalizations.initializingSecureWorkspace}...',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall,
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
  }
}
