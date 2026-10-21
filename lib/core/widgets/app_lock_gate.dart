
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/services/biometric_auth_service.dart';
import 'package:smart_installment_management/core/services/secure_storage_service.dart';

class AppLockGate extends StatefulWidget {
  final Widget child;

  const AppLockGate({
    super.key,
    required this.child,
  });

  @override
  State<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends State<AppLockGate>
    with WidgetsBindingObserver {
  bool _isLocked = false;
  bool _isAuthenticating = false;
  bool _wasBackgrounded = false;
  bool _isCheckingLock = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Do not lock the app while a biometric prompt is active.
    if (_isAuthenticating ||
        BiometricAuthService.isAuthenticating) {
      return;
    }

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      if (FirebaseAuth.instance.currentUser != null) {
        _wasBackgrounded = true;
      }
      return;
    }

    if (state == AppLifecycleState.resumed &&
        _wasBackgrounded) {
      _wasBackgrounded = false;
      _lockIfEnabled();
    }
  }

  Future<void> _lockIfEnabled() async {
    if (_isCheckingLock ||
        FirebaseAuth.instance.currentUser == null) {
      return;
    }

    _isCheckingLock = true;

    try {
      final enabled =
      await SecureStorageService.isBiometricLoginEnabled();

      if (!mounted) return;

      if (enabled &&
          FirebaseAuth.instance.currentUser != null) {
        setState(() {
          _isLocked = true;
        });
      }
    } catch (_) {
      // Do not lock the app if the local setting cannot be read.
    } finally {
      _isCheckingLock = false;
    }
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
    });

    try {
      final authenticated =
      await BiometricAuthService.authenticate(
        reason: 'Verify your identity to unlock the application',
      );

      if (!mounted) return;

      if (authenticated &&
          FirebaseAuth.instance.currentUser != null) {
        setState(() {
          _isLocked = false;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  Widget _buildLockScreen(
      BuildContext context,
      bool isDark,
      ) {
    final theme = Theme.of(context);

    return Material(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 110.r,
                  height: 110.r,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF243444)
                        : const Color(0xFFE2E8F0),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.fingerprint_rounded,
                    size: 72.r,
                    color: isDark
                        ? const Color(0xFF34D399)
                        : const Color(0xFF15966D),
                  ),
                ),
                SizedBox(height: 28.h),
                Text(
                  'Application Locked',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Verify your identity to access your account.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                SizedBox(height: 32.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed:
                    _isAuthenticating ? null : _authenticate,
                    icon: const Icon(Icons.fingerprint),
                    label: Text(
                      _isAuthenticating
                          ? 'Verifying...'
                          : 'Unlock with biometrics',
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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,

        // Keep the lock layer mounted to avoid repeatedly
        // inserting/removing it while routes and dialogs change.
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !_isLocked,
            child: AnimatedOpacity(
              opacity: _isLocked ? 1 : 0,
              duration: Duration.zero,
              child: _buildLockScreen(context, isDark),
              // PopScope(
              //   canPop: !_isLocked,
              //   child: _buildLockScreen(context, isDark),
              //),
            ),
          ),
        ),
      ],
    );
  }
}
