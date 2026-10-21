import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_installment_management/core/firebase/taqseet_firestore_services.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/cubit/customers_state.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';
import 'package:smart_installment_management/features/main_layout/groups/data/model/group_model.dart';

class CustomersCubit extends Cubit<CustomersState> {
  CustomersCubit() : super(const CustomersState()) {
    loadCustomers();
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  _customersSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _groupsSubscription;

  final List<String> _filters = const [
    'All',
    'Overdue',
    'Due Today',
    'Completed',
  ];

  Future<void> loadCustomers() async {
    await _customersSubscription?.cancel();
    await _groupsSubscription?.cancel();

    emit(state.copyWith(isLoading: true, errorMessage: ''));

    try {
      _customersSubscription =
          TaqseetFirestoreServices.recordsStream(type: 'customer').listen(
            (snapshot) {
              final List<CustomerModel> customers = [];

              for (final document in snapshot.docs) {
                final customer = CustomerModel.fromMap(
                  document.data(),
                  documentId: document.id,
                );

                customers.add(_updateCustomerStatus(customer));
              }

              _emitFilteredCustomers(customers);
            },
            onError: (error) {
              emit(
                state.copyWith(
                  isLoading: false,
                  errorMessage: 'Could not load customers. Please try again.',
                ),
              );
            },
          );
      _groupsSubscription =
          TaqseetFirestoreServices.recordsStream(type: 'group').listen(
            (snapshot) {
              final groups = <GroupModel>[];

              for (final document in snapshot.docs) {
                groups.add(
                  GroupModel.fromMap(document.data(), id: document.id),
                );
              }

              if (isClosed) return;

              emit(state.copyWith(groups: groups));
              _emitFilteredCustomers(state.allCustomers);
            },
            onError: (error) {
              if (isClosed) return;
              emit(state.copyWith(groups: []));
            },
          );
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Could not load customers. Please try again.',
        ),
      );
    }
  }

  void searchCustomers(String query) {
    emit(state.copyWith(searchQuery: query));
    _emitFilteredCustomers(state.allCustomers);
  }

  void changeFilter(int index) {
    if (index < 0 || index >= _filters.length) return;

    emit(state.copyWith(selectedFilterIndex: index));
    _emitFilteredCustomers(state.allCustomers);
  }

  void changeGroupFilter(String groupId) {
    emit(state.copyWith(selectedGroupId: groupId));
    _emitFilteredCustomers(state.allCustomers);
  }

  void _emitFilteredCustomers(List<CustomerModel> allCustomers) {
    final query = state.searchQuery.trim().toLowerCase();
    final selectedFilter = _filters[state.selectedFilterIndex];

    final List<CustomerModel> filteredCustomers = [];

    for (final customer in allCustomers) {
      final selectedGroupId = state.selectedGroupId;

      bool matchesGroup = true;

      if (selectedGroupId == '__other__') {
        matchesGroup =
            customer.groupId.isEmpty ||
            customer.groupName.trim().toLowerCase() == 'other';
      } else if (selectedGroupId != '__all__') {
        GroupModel? selectedGroup;

        for (final group in state.groups) {
          if (group.id == selectedGroupId) {
            selectedGroup = group;
            break;
          }
        }

        if (selectedGroup != null) {
          matchesGroup =
              customer.groupId == selectedGroup.id ||
              (customer.groupId.isEmpty &&
                  customer.groupName == selectedGroup.groupTitle);
        }
      }

      if (!matchesGroup) continue;
      final matchesSearch =
          customer.customerName.toLowerCase().contains(query) ||
          customer.customerPhone.toLowerCase().contains(query) ||
          customer.address.toLowerCase().contains(query) ||
          customer.groupName.toLowerCase().contains(query);

      if (!matchesSearch) continue;

      bool matchesFilter = false;

      switch (selectedFilter) {
        case 'Overdue':
          matchesFilter = customer.status == 'Overdue';
          break;

        case 'Due Today':
          matchesFilter = customer.status == 'Due Today';
          break;

        case 'Completed':
          matchesFilter = customer.status == 'Completed';
          break;

        default:
          matchesFilter = true;
      }

      if (matchesFilter) {
        filteredCustomers.add(customer);
      }
    }

    emit(
      state.copyWith(
        allCustomers: allCustomers,
        customers: filteredCustomers,
        isLoading: false,
        errorMessage: '',
      ),
    );
  }

  CustomerModel _updateCustomerStatus(CustomerModel customer) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    final unpaidInstallments = customer.schedule
        .where((installment) => !installment.isPaid)
        .toList();

    unpaidInstallments.sort(
      (first, second) =>
          first.installmentNumber.compareTo(second.installmentNumber),
    );

    if (customer.remainingValue <= 0) {
      return customer.copyWith(status: 'Completed', nextDueDate: '');
    }

    String nextDueDate = customer.nextDueDate;

    if (unpaidInstallments.isNotEmpty) {
      nextDueDate = unpaidInstallments.first.dueDate;
    }

    if (nextDueDate.isEmpty) {
      return customer.copyWith(status: 'Up to Date', nextDueDate: '');
    }

    final dueDate = _parseDate(nextDueDate);

    if (dueDate == null) {
      return customer.copyWith(status: 'Up to Date', nextDueDate: nextDueDate);
    }

    final normalizedDueDate = DateTime(
      dueDate.year,
      dueDate.month,
      dueDate.day,
    );

    String status;

    if (normalizedDueDate.isBefore(todayDate)) {
      status = 'Overdue';
    } else if (normalizedDueDate == todayDate) {
      status = 'Due Today';
    } else {
      status = 'Up to Date';
    }

    return customer.copyWith(status: status, nextDueDate: nextDueDate);
  }

  DateTime? _parseDate(String value) {
    final text = value.trim();

    final parsedDate = DateTime.tryParse(text);
    if (parsedDate != null) return parsedDate;

    // Supports dates such as 12 Oct 2026.
    final parts = text.split(' ');
    if (parts.length != 3) return null;

    final day = int.tryParse(parts[0]);
    final year = int.tryParse(parts[2]);

    if (day == null || year == null) return null;

    const months = {
      'jan': 1,
      'feb': 2,
      'mar': 3,
      'apr': 4,
      'may': 5,
      'jun': 6,
      'jul': 7,
      'aug': 8,
      'sep': 9,
      'oct': 10,
      'nov': 11,
      'dec': 12,
    };

    final month =
        months[parts[1].toLowerCase().substring(
          0,
          parts[1].length >= 3 ? 3 : parts[1].length,
        )];

    if (month == null) return null;

    final date = DateTime(year, month, day);

    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }

    return date;
  }

  @override
  Future<void> close() async {
    await _customersSubscription?.cancel();
    await _groupsSubscription?.cancel();
    return super.close();
  }
}
