import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_auth/local_auth.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/routes/app_routes.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen>
    with WidgetsBindingObserver {
  final LocalAuthentication _auth = LocalAuthentication();

  bool _isChecking = true;
  bool _isAuthenticating = false;
  bool _hasBiometric = false;
  bool _isUnavailable = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndAuthenticate();
    });
  }

  Future<void> _checkAndAuthenticate() async {
    if (_isAuthenticating) return;

    setState(() {
      _isChecking = true;
      _isUnavailable = false;
    });

    try {
      final isSupported = await _auth.isDeviceSupported();
      final canCheckBiometrics = await _auth.canCheckBiometrics;
      final availableBiometrics = await _auth.getAvailableBiometrics();

      if (!isSupported || !canCheckBiometrics || availableBiometrics.isEmpty) {
        if (!mounted) return;

        setState(() {
          _hasBiometric = false;
          _isChecking = false;
        });

        _goToSplash();
        return;
      }

      if (!mounted) return;

      setState(() {
        _hasBiometric = true;
        _isChecking = false;
      });

      await _authenticate();
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _hasBiometric = false;
        _isChecking = false;
      });

      _goToSplash();
    }
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
      _isUnavailable = false;
    });

    final l10n = AppLocalizations.of(context)!;

    try {
      final authenticated = await _auth.authenticate(
        localizedReason: l10n.secure_access_with_your_fingerprint,
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );

      if (!mounted) return;

      if (authenticated) {
        _goToSplash();
      } else {
        setState(() {
          _isUnavailable = true;
        });
      }
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isUnavailable = true;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  void _goToSplash() {
    if (!mounted) return;

    Navigator.of(context).pushReplacementNamed(AppRoutes.splashScreen);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_isAuthenticating) {
      // Launch handler
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final primaryColor = isDark
        ? ColorManager.darkAccentGreen
        : const Color(0xFF15966D);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: _isChecking
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 112.r,
                        height: 112.r,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF243444)
                              : const Color(0xFFE2E8F0),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.fingerprint_rounded,
                          size: 76.r,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(height: 28.h),
                      Text(
                        l10n.fingerprintLogin,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        l10n.secure_access_with_your_fingerprint,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                      if (_isUnavailable) ...[
                        SizedBox(height: 16.h),
                        Text(
                          l10n.something_went_wrong_Please_try_again,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ],
                      SizedBox(height: 28.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isAuthenticating ? null : _authenticate,
                          icon: const Icon(Icons.fingerprint_rounded),
                          label: Text(
                            _isAuthenticating
                                ? '${l10n.loading}...'
                                : l10n.fingerprintLogin,
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
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
}
