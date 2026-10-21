import 'package:smart_installment_management/features/auth/data/model/user_model.dart';

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final UserModel user;

  ProfileLoadedState(this.user);
}

class ProfileErrorState extends ProfileState {
  final String message;

  ProfileErrorState(this.message);
}

class ProfileLogoutLoadingState extends ProfileState {}

class ProfileLogoutSuccessState extends ProfileState {}

class ProfileLogoutErrorState extends ProfileState {
  final String message;

  ProfileLogoutErrorState(this.message);
}
