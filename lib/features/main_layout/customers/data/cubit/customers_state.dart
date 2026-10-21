import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';
import 'package:smart_installment_management/features/main_layout/groups/data/model/group_model.dart';

class CustomersState {
  final List<CustomerModel> allCustomers;
  final List<CustomerModel> customers;
  final bool isLoading;
  final String errorMessage;
  final String searchQuery;
  final int selectedFilterIndex;
  final List<GroupModel> groups;
  final String selectedGroupId;

  const CustomersState({
    this.allCustomers = const [],
    this.customers = const [],
    this.isLoading = true,
    this.errorMessage = '',
    this.searchQuery = '',
    this.selectedFilterIndex = 0,
    this.groups = const [],
    this.selectedGroupId = '__all__',
  });

  CustomersState copyWith({
    List<CustomerModel>? allCustomers,
    List<CustomerModel>? customers,
    bool? isLoading,
    String? errorMessage,
    String? searchQuery,
    int? selectedFilterIndex,
    List<GroupModel>? groups,
    String? selectedGroupId,
  }) {
    return CustomersState(
      allCustomers: allCustomers ?? this.allCustomers,
      customers: customers ?? this.customers,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilterIndex: selectedFilterIndex ?? this.selectedFilterIndex,
      groups: groups ?? this.groups,
      selectedGroupId: selectedGroupId ?? this.selectedGroupId,
    );
  }
}
