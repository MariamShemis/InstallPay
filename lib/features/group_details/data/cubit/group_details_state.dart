import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';
import 'package:smart_installment_management/features/main_layout/groups/data/model/group_model.dart';

abstract class GroupDetailsState {}

class GroupDetailsInitial extends GroupDetailsState {}

class GroupDetailsLoading extends GroupDetailsState {}

class GroupDetailsLoaded extends GroupDetailsState {
  final GroupModel group;
  final List<CustomerModel> customers;

  GroupDetailsLoaded({required this.group, required this.customers});
}

class GroupDetailsError extends GroupDetailsState {
  final String message;

  GroupDetailsError(this.message);
}

class GroupDetailsSaving extends GroupDetailsState {}

class GroupDetailsDeleting extends GroupDetailsState {}
