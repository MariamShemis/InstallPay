
import 'package:smart_installment_management/features/auth/data/model/user_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final UserModel user;

  HomeSuccess(this.user);
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
