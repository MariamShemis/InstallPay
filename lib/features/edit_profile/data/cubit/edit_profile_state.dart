import 'package:smart_installment_management/features/auth/data/model/user_model.dart';

abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {}

class EditProfileLoading extends EditProfileState {}

class EditProfileLoaded extends EditProfileState {
  final UserModel user;

  EditProfileLoaded(this.user);
}

class EditProfileSaving extends EditProfileState {}

class EditProfileSuccess extends EditProfileState {
  final UserModel user;

  EditProfileSuccess(this.user);
}

class EditProfileError extends EditProfileState {
  final String message;

  EditProfileError(this.message);
}
