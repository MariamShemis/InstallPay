import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_installment_management/core/firebase/firebase_auth_services.dart';
import 'package:smart_installment_management/core/services/biometric_auth_service.dart';
import 'package:smart_installment_management/core/services/secure_storage_service.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

import 'account_security_state.dart';

class AccountSecurityCubit extends Cubit<AccountSecurityState> {
  AccountSecurityCubit() : super(AccountSecurityInitial());

  static const String changePasswordAction = 'change_password';
  static const String verifyEmailAction = 'verify_email';
  static const String deleteAccountAction = 'delete_account';
  static const String biometricAction = 'biometric';

  User? get currentUser => FirebaseAuthServices.currentFirebaseUser;

  String get email => currentUser?.email ?? '';

  bool get isEmailVerified => currentUser?.emailVerified ?? false;

  bool get isEmailPasswordAccount =>
      FirebaseAuthServices.isEmailPasswordAccount;

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required BuildContext context,
  }) async {
    emit(AccountSecurityLoading(changePasswordAction));

    try {
      await FirebaseAuthServices.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      emit(AccountSecuritySuccess(changePasswordAction));
    } on FirebaseAuthException catch (e) {
      emit(AccountSecurityError(_getErrorMessage(e, context)));
    } catch (_) {
      emit(
        AccountSecurityError(
          AppLocalizations.of(context)!.something_went_wrong_Please_try_again,
        ),
      );
    }
  }

  Future<void> sendVerificationEmail(BuildContext context) async {
    emit(AccountSecurityLoading(verifyEmailAction));

    try {
      await FirebaseAuthServices.sendEmailVerification();

      emit(AccountSecuritySuccess(verifyEmailAction));
    } on FirebaseAuthException catch (e) {
      emit(AccountSecurityError(_getErrorMessage(e, context)));
    } catch (_) {
      emit(
        AccountSecurityError(
          AppLocalizations.of(context)!.something_went_wrong_Please_try_again,
        ),
      );
    }
  }

  Future<bool> refreshEmailVerification() async {
    try {
      return await FirebaseAuthServices.checkEmailVerified();
    } catch (_) {
      return false;
    }
  }

  Future<void> deleteAccount({
    required String currentPassword,
    required BuildContext context,
  }) async {
    emit(AccountSecurityLoading(deleteAccountAction));

    try {
      await FirebaseAuthServices.deleteEmailPasswordAccount(
        currentPassword: currentPassword,
      );

      emit(AccountSecuritySuccess(deleteAccountAction));
    } on FirebaseAuthException catch (e) {
      emit(AccountSecurityError(_getErrorMessage(e, context)));
    } catch (_) {
      emit(
        AccountSecurityError(
          AppLocalizations.of(context)!.something_went_wrong_Please_try_again,
        ),
      );
    }
  }

  Future<bool> loadBiometricEnabled(BuildContext context) async {
    try {
      return await FirebaseAuthServices.getBiometricEnabled();
    } catch (_) {
      emit(
        AccountSecurityError(
          AppLocalizations.of(context)!.something_went_wrong_Please_try_again,
        ),
      );
      return false;
    }
  }

  Future<void> toggleBiometric(
    bool enable, {
    String? currentPassword,
    required BuildContext context,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      emit(AccountSecurityLoading(biometricAction));

      final user = currentUser;

      if (user == null) {
        emit(AccountSecurityError(l10n.no_account_found_with_this_email));
        return;
      }

      if (!enable) {
        await FirebaseAuthServices.setBiometricEnabled(false);
        await SecureStorageService.clearLoginCredentials();

        emit(BiometricStatusChanged(false));
        return;
      }

      if (!FirebaseAuthServices.isEmailPasswordAccount) {
        emit(AccountSecurityError(l10n.something_went_wrong_Please_try_again));
        return;
      }

      if (currentPassword == null || currentPassword.trim().isEmpty) {
        emit(AccountSecurityError(l10n.this_field_is_required));
        return;
      }

      final email = user.email;

      if (email == null || email.isEmpty) {
        emit(AccountSecurityError(l10n.no_account_found_with_this_email));
        return;
      }

      await FirebaseAuthServices.reauthenticateWithPassword(currentPassword);

      final available = await BiometricAuthService.isBiometricAvailable();

      if (!available) {
        emit(AccountSecurityError(l10n.something_went_wrong_Please_try_again));
        return;
      }

      final authenticated = await BiometricAuthService.authenticate();

      if (!authenticated) {
        emit(AccountSecurityError(l10n.something_went_wrong_Please_try_again));
        return;
      }

      await SecureStorageService.saveEmailLogin(
        email: email,
        password: currentPassword,
        userId: user.uid,
      );

      try {
        await FirebaseAuthServices.setBiometricEnabled(true);
      } catch (_) {
        await SecureStorageService.clearLoginCredentials();
        rethrow;
      }

      emit(BiometricStatusChanged(true));
    } on FirebaseAuthException catch (e) {
      emit(AccountSecurityError(_getBiometricErrorMessage(e, context)));
    } catch (error) {
      emit(AccountSecurityError(_getBiometricErrorMessage(error, context)));
    }
  }

  String _getBiometricErrorMessage(Object error, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'wrong-password':
        case 'invalid-credential':
        case 'invalid-login-credentials':
          return l10n.incorrect_email_or_password;

        case 'user-not-found':
          return l10n.no_account_found_with_this_email;

        case 'too-many-requests':
          return l10n.too_many_attempts_Please_try_again_later;

        case 'network-request-failed':
          return l10n.please_check_your_internet_connection;

        default:
          return l10n.something_went_wrong_Please_try_again;
      }
    }

    return l10n.something_went_wrong_Please_try_again;
  }

  String _getErrorMessage(FirebaseAuthException e, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    switch (e.code) {
      case 'wrong-password':
      case 'invalid-credential':
        return l10n.incorrect_email_or_password;
      case 'weak-password':
        return l10n.password_is_too_weak;
      case 'too-many-requests':
        return l10n.too_many_attempts_Please_try_again_later;
      case 'network-request-failed':
        return l10n.please_check_your_internet_connection;
      case 'already-verified':
        return l10n.something_went_wrong_Please_try_again;
      default:
        return e.message ?? l10n.something_went_wrong_Please_try_again;
    }
  }
}
