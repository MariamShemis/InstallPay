import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_installment_management/core/firebase/firebase_auth_services.dart';
import 'package:smart_installment_management/features/auth/data/model/user_model.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());

  UserModel? currentUser;

  Future<void> loadProfile(BuildContext context) async {
    emit(EditProfileLoading());

    try {
      final user = await FirebaseAuthServices.getCurrentUser();

      if (user == null) {
        emit(
          EditProfileError(
            AppLocalizations.of(context)!.no_account_found_with_this_email,
          ),
        );
        return;
      }

      currentUser = user;
      emit(EditProfileLoaded(user));
    } catch (e) {
      emit(
        EditProfileError(
          AppLocalizations.of(context)!
              .something_went_wrong_Please_try_again,
        ),
      );
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phoneNumber,
    required String jobTitle,
    required String birthday,
    required String? gender,
    required BuildContext context,
    File? imageFile,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    emit(EditProfileSaving());

    try {
      final user = currentUser ?? await FirebaseAuthServices.getCurrentUser();

      if (user == null) {
        emit(EditProfileError(l10n.no_account_found_with_this_email));
        return;
      }

      final updatedUser = user.copyWith(
        name: name.trim(),
        phoneNumber: phoneNumber.trim(),
        jobTitle: jobTitle.trim(),
        birthday: birthday.trim(),
        gender: gender,
      );

      await FirebaseAuthServices.updateUserProfile(
        updatedUser,
        imageFile: imageFile,
      );

      final refreshedUser = await FirebaseAuthServices.getCurrentUser();

      if (refreshedUser == null) {
        emit(EditProfileError(l10n.something_went_wrong_Please_try_again));
        return;
      }

      currentUser = refreshedUser;
      emit(EditProfileSuccess(refreshedUser));
    } on FirebaseAuthException catch (e) {
      emit(EditProfileError(_getErrorMessage(e, context)));
    } catch (_) {
      emit(EditProfileError(l10n.something_went_wrong_Please_try_again));
    }
  }

  String _getErrorMessage(
    FirebaseAuthException exception,
    BuildContext context,
  ) {
    final l10n = AppLocalizations.of(context)!;

    switch (exception.code) {
      case 'network-request-failed':
        return l10n.please_check_your_internet_connection;
      case 'user-not-found':
        return l10n.no_account_found_with_this_email;
      default:
        return l10n.something_went_wrong_Please_try_again;
    }
  }
}
