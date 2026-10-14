import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_installment_management/core/firebase/firebase_auth_services.dart';

import 'verify_email_state.dart';

class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  VerifyEmailCubit() : super(VerifyEmailInitial());

  Future<void> sendEmailVerification() async {
    try {
      emit(VerifyEmailLoading());

      await FirebaseAuthServices.sendEmailVerification();

      emit(VerifyEmailSent());
    } on FirebaseAuthException catch (e) {
      emit(VerifyEmailError(_getErrorMessage(e.code)));
    } catch (_) {
      emit(
        VerifyEmailError(
          'Unable to send verification email. Please try again.',
        ),
      );
    }
  }

  Future<void> checkEmailVerification() async {
    try {
      emit(VerifyEmailChecking());

      final verified = await FirebaseAuthServices.checkEmailVerified();

      if (verified) {
        emit(VerifyEmailVerified());
      } else {
        emit(VerifyEmailNotVerified());
      }
    } on FirebaseAuthException catch (e) {
      emit(VerifyEmailError(_getErrorMessage(e.code)));
    } catch (_) {
      emit(
        VerifyEmailError(
          'Unable to check email verification. Please try again.',
        ),
      );
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';

      case 'network-request-failed':
        return 'Check your internet connection.';

      case 'user-not-found':
        return 'No authenticated user was found. Please sign in again.';

      case 'already-verified':
        return 'Your email is already verified.';

      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
