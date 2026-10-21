import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';

abstract class AddCustomerState {}

class AddCustomerInitial extends AddCustomerState {}

class AddCustomerLoading extends AddCustomerState {}

class AddCustomerSuccess extends AddCustomerState {
  final CustomerModel customer;

  AddCustomerSuccess(this.customer);
}

class AddCustomerFailure extends AddCustomerState {
  final String message;

  AddCustomerFailure(this.message);
}
