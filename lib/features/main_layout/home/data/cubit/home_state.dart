import 'package:smart_installment_management/features/auth/data/model/user_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final UserModel user;
  final double cashPartner;
  final double outMoney;

  HomeSuccess(this.user, {this.cashPartner = 0, this.outMoney = 0});
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
