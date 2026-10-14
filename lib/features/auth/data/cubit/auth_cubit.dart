import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_installment_management/core/firebase/firebase_auth_services.dart';
import 'package:smart_installment_management/features/auth/data/cubit/auth_state.dart';
import 'package:smart_installment_management/features/auth/data/model/login_request.dart';
import 'package:smart_installment_management/features/auth/data/model/register_request.dart';
import 'package:smart_installment_management/features/auth/data/model/user_model.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState());

  static AuthCubit get(BuildContext context) =>
      BlocProvider.of<AuthCubit>(context);

  UserModel? currentUser;

  Future<void> register(RegisterRequest request, BuildContext context) async {
    emit(RegisterLoadingState());

    try {
      currentUser = await FirebaseAuthServices.register(request);
      emit(RegisterSuccessState(currentUser!));
    } on FirebaseAuthException catch (e) {
      emit(RegisterErrorState(_firebaseErrorMessage(e, context)));
    } on FirebaseException catch (e) {
      debugPrint('Firestore Error Code: ${e.code}, Message: ${e.message}');
      emit(
        RegisterErrorState(
          e.message ??
              AppLocalizations.of(
                context,
              )!.something_went_wrong_Please_try_again,
        ),
      );
    } catch (e) {
      debugPrint('General Register Error: $e');
      emit(
        RegisterErrorState(
          AppLocalizations.of(context)!.something_went_wrong_Please_try_again,
        ),
      );
    }
  }

  Future<void> login(LoginRequest request, BuildContext context) async {
    emit(LoginLoadingState());

    try {
      currentUser = await FirebaseAuthServices.login(request);
      emit(LoginSuccessState(currentUser!));
    } on FirebaseAuthException catch (e) {
      emit(LoginErrorState(_firebaseErrorMessage(e, context)));
    } catch (_) {
      emit(
        LoginErrorState(
          AppLocalizations.of(context)!.something_went_wrong_Please_try_again,
        ),
      );
    }
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    emit(ResetPasswordLoadingState());

    try {
      await FirebaseAuthServices.resetPassword(email);
      emit(ResetPasswordSuccessState());
    } on FirebaseAuthException catch (e) {
      emit(ResetPasswordErrorState(_firebaseErrorMessage(e, context)));
    } catch (_) {
      emit(
        ResetPasswordErrorState(
          AppLocalizations.of(context)!.something_went_wrong_Please_try_again,
        ),
      );
    }
  }

  Future<void> getCurrentUser() async {
    try {
      currentUser = await FirebaseAuthServices.getCurrentUser();
    } catch (_) {
      currentUser = null;
    }
  }

  Future<void> logout(BuildContext context) async {
    emit(LogoutLoadingState());

    try {
      await FirebaseAuthServices.logout();
      currentUser = null;
      emit(LogoutSuccessState());
    } on FirebaseAuthException catch (e) {
      emit(LogoutErrorState(_firebaseErrorMessage(e, context)));
    } catch (_) {
      emit(
        LogoutErrorState(
          AppLocalizations.of(context)!.something_went_wrong_Please_try_again,
        ),
      );
    }
  }

  String _firebaseErrorMessage(
    FirebaseAuthException exception,
    BuildContext context,
  ) {
    final localizations = AppLocalizations.of(context)!;

    switch (exception.code) {
      case 'email-already-in-use':
        return localizations.this_email_is_already_in_use;
      case 'invalid-email':
        return localizations.please_enter_a_valid_email_address;
      case 'weak-password':
        return localizations.password_is_too_weak;
      case 'user-not-found':
        return localizations.no_account_found_with_this_email;
      case 'wrong-password':
      case 'invalid-credential':
        return localizations.incorrect_email_or_password;
      case 'network-request-failed':
        return localizations.please_check_your_internet_connection;
      case 'too-many-requests':
        return localizations.too_many_attempts_Please_try_again_later;
      case 'user-data-not-found':
        return localizations.no_account_found_with_this_email;
      case 'operation-not-allowed':
        return localizations.something_went_wrong_Please_try_again;
      default:
        return localizations.something_went_wrong_Please_try_again;
    }
  }
}
