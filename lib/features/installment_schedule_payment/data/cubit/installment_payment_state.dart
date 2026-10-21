import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';

abstract class InstallmentPaymentState {}

class InstallmentPaymentInitial extends InstallmentPaymentState {}

class InstallmentPaymentLoading extends InstallmentPaymentState {}

class InstallmentPaymentSuccess extends InstallmentPaymentState {
  final CustomerModel customer;

  InstallmentPaymentSuccess(this.customer);
}

class InstallmentPaymentError extends InstallmentPaymentState {
  final String message;

  InstallmentPaymentError(this.message);
}
