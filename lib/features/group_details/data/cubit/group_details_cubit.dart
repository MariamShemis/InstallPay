import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_installment_management/core/firebase/taqseet_firestore_services.dart';
import 'package:smart_installment_management/core/utils/helper/payment_status_helper.dart';
import 'package:smart_installment_management/features/group_details/data/cubit/group_details_state.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';
import 'package:smart_installment_management/features/main_layout/groups/data/model/group_model.dart';

class GroupDetailsCubit extends Cubit<GroupDetailsState> {
  GroupDetailsCubit() : super(GroupDetailsInitial());

  GroupModel? _group;
  List<CustomerModel> _customers = [];

  GroupModel? get group => _group;

  List<CustomerModel> get customers => List.unmodifiable(_customers);

  double get totalValue {
    double total = 0;
    for (final customer in _customers) {
      total += customer.sellingPrice;
    }
    return total;
  }

  double get collectedValue {
    double total = 0;
    for (final customer in _customers) {
      total += customer.totalPaid;
    }
    return total;
  }

  double get remainingValue {
    double total = 0;
    for (final customer in _customers) {
      total += customer.remainingValue;
    }
    return total;
  }

  int get completedCount {
    int count = 0;
    for (final customer in _customers) {
      if (customer.isCompleted) count++;
    }
    return count;
  }

  int get overdueCount {
    int count = 0;
    for (final customer in _customers) {
      if (!customer.isCompleted &&
          customer.status.toLowerCase().contains('overdue')) {
        count++;
      }
    }
    return count;
  }

  String _getMonthKey(DateTime date) {
    return DateFormat('yyyy-MM').format(date);
  }

  DateTime? _parseDate(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final input = value.trim();

    final isoDate = DateTime.tryParse(input);
    if (isoDate != null) return isoDate;

    try {
      return DateFormat('dd/MM/yyyy').parseStrict(input);
    } catch (_) {}

    try {
      return DateFormat('d MMM yyyy', 'en').parseStrict(input);
    } catch (_) {}

    return null;
  }

  Map<String, double> _calculateMonthlyStats(String monthKey) {
    double target = 0;
    double collection = 0;

    for (final customer in _customers) {
      // Target: down payment is counted in the contract month,
      // whether it has been paid or not.
      final contractDate = _parseDate(customer.contractDate);

      if (contractDate != null && _getMonthKey(contractDate) == monthKey) {
        target += customer.downPayment;
      }

      // Collection: count the actual down payment received this month.
      final downPaymentDate = _parseDate(customer.downPaymentPaidAtDate);

      if (customer.isDownPaymentPaid &&
          downPaymentDate != null &&
          _getMonthKey(downPaymentDate) == monthKey) {
        collection += customer.downPaymentPaidAmount;
      }

      for (final installment in customer.schedule) {
        // Target: installments due this month, regardless of payment status.
        final dueDate = _parseDate(installment.dueDate);

        if (dueDate != null && _getMonthKey(dueDate) == monthKey) {
          target += installment.amount;
        }

        // Collection: count money received this month, regardless of
        // the installment's original due month.
        final paymentDate = _parseDate(installment.paidAtDate);

        if (paymentDate != null &&
            _getMonthKey(paymentDate) == monthKey) {
          collection += installment.paidAmount;
        }
      }
    }

    return {
      'target': target,
      'collection': collection,
    };
  }


  Future<void> loadDetails(String groupId) async {
    emit(GroupDetailsLoading());

    try {
      final groupsSnapshot = await TaqseetFirestoreServices.recordsStream(
        type: 'group',
      ).first;

      final savedGroups = <GroupModel>[];

      for (final document in groupsSnapshot.docs) {
        savedGroups.add(GroupModel.fromMap(document.data(), id: document.id));
      }

      final customersSnapshot = await TaqseetFirestoreServices.recordsStream(
        type: 'customer',
      ).first;

      final allCustomers = <CustomerModel>[];

      for (final document in customersSnapshot.docs) {
        final customer = CustomerModel.fromMap(
          document.data(),
          documentId: document.id,
        );

        allCustomers.add(PaymentStatusHelper.updateCustomer(customer));
      }

      bool belongsToSavedGroup(CustomerModel customer) {
        for (final savedGroup in savedGroups) {
          if (customer.groupId == savedGroup.id) {
            return true;
          }

          if (customer.groupId.isEmpty &&
              customer.groupName.trim().toLowerCase() ==
                  savedGroup.groupTitle.trim().toLowerCase()) {
            return true;
          }
        }

        return false;
      }

      _customers = [];

      if (groupId == '__other__') {
        // Other is virtual: it has no group document in Firestore.
        for (final customer in allCustomers) {
          if (!belongsToSavedGroup(customer)) {
            _customers.add(customer);
          }
        }

        int paidCount = 0;
        int dueCount = 0;
        int dueTodayCount = 0;
        int overdueCount = 0;

        for (final customer in _customers) {
          final status = customer.status.trim().toLowerCase();

          if (customer.isCompleted ||
              customer.remainingValue <= 0 ||
              status == PaymentStatusHelper.paid) {
            paidCount++;
          } else if (status == PaymentStatusHelper.overdue) {
            overdueCount++;
            dueCount++;
          } else if (status == PaymentStatusHelper.due) {
            dueTodayCount++;
            dueCount++;
          } else {
            dueCount++;
          }
        }

        _group = GroupModel(
          id: '__other__',
          groupTitle: 'Other',
          collectorName: '',
          collectorPhone: '',
          clientsCount: _customers.length,
          completedCount: paidCount,
          dueCount: dueCount,
          dueTodayCount: dueTodayCount,
          overdueCount: overdueCount,
          totalValue: totalValue,
          collectedValue: collectedValue,
          remainingValue: remainingValue,
        );
      } else {
        final groupDocument = await TaqseetFirestoreServices.getRecord(
          documentId: groupId,
        );

        if (!groupDocument.exists || groupDocument.data() == null) {
          throw Exception('Group not found.');
        }

        final groupData = groupDocument.data()!;

        if (groupData['type'] != 'group') {
          throw Exception('The selected record is not a group.');
        }

        _group = GroupModel.fromMap(groupData, id: groupDocument.id);

        for (final customer in allCustomers) {
          final belongsToThisGroup =
              customer.groupId == groupId ||
              (customer.groupId.isEmpty &&
                  customer.groupName.trim().toLowerCase() ==
                      _group!.groupTitle.trim().toLowerCase());

          if (belongsToThisGroup) {
            _customers.add(customer);
          }
        }

        await _saveGroupStatistics();
      }

      emit(
        GroupDetailsLoaded(
          group: _group!,
          customers: List.unmodifiable(_customers),
        ),
      );
    } catch (error) {
      emit(GroupDetailsError(error.toString()));
    }
  }

  Future<bool> updateGroup({
    required String groupTitle,
    required String collectorName,
    required String collectorPhone,
    required String address,
  }) async {
    final currentGroup = _group;
    if (currentGroup == null) return false;
    if (_group?.id == '__other__') return false;

    emit(GroupDetailsSaving());

    try {
      final updatedGroup = currentGroup.copyWith(
        groupTitle: groupTitle.trim(),
        collectorName: collectorName.trim(),
        collectorPhone: collectorPhone.trim(),
        address: address.trim(),
        clientsCount: _customers.length,
        completedCount: completedCount,
        dueCount: _customers.length - completedCount,
        overdueCount: overdueCount,
        totalValue: totalValue,
        collectedValue: collectedValue,
        remainingValue: remainingValue,
      );

      await TaqseetFirestoreServices.saveRecord(
        type: 'group',
        documentId: currentGroup.id,
        data: updatedGroup.toMap(),
      );

      _group = updatedGroup;

      emit(
        GroupDetailsLoaded(
          group: updatedGroup,
          customers: List.unmodifiable(_customers),
        ),
      );

      return true;
    } catch (error) {
      emit(GroupDetailsError(error.toString()));
      return false;
    }
  }

  Future<bool> deleteGroup() async {
    final currentGroup = _group;
    if (currentGroup == null) return false;
    if (_group?.id == '__other__') return false;

    emit(GroupDetailsDeleting());

    try {
      // Keep the customers' records, but unlink them from this group.
      for (final customer in _customers) {
        final updatedCustomer = customer.copyWith(
          groupId: '',
          groupName: 'Other',
        );

        await TaqseetFirestoreServices.saveRecord(
          type: 'customer',
          documentId: customer.id,
          data: updatedCustomer.toMap(),
        );
      }

      await TaqseetFirestoreServices.deleteRecord(documentId: currentGroup.id);

      _group = null;
      _customers = [];

      return true;
    } catch (error) {
      emit(GroupDetailsError(error.toString()));
      return false;
    }
  }

  Future<void> _saveGroupStatistics() async {
    final currentGroup = _group;

    if (currentGroup == null || currentGroup.id == '__other__') {
      return;
    }

    final now = DateTime.now();
    final monthKey = _getMonthKey(now);
    final monthlyValues = _calculateMonthlyStats(monthKey);

    final target = monthlyValues['target'] ?? 0;
    final collection = monthlyValues['collection'] ?? 0;

    final updatedMonthlyStats = <String, dynamic>{
      ...currentGroup.monthlyStats,
      monthKey: <String, dynamic>{
        'target': target,
        'collection': collection,
        'progress': target > 0 ? (collection / target).clamp(0.0, 1.0) : 0.0,
        'updatedAt': DateTime.now().toIso8601String(),
      },
    };

    final updatedGroup = currentGroup.copyWith(
      clientsCount: _customers.length,
      completedCount: completedCount,
      dueCount: _customers.length - completedCount,
      overdueCount: overdueCount,
      totalValue: totalValue,
      collectedValue: collectedValue,
      remainingValue: remainingValue,
      currentMonthKey: monthKey,
      monthTarget: target,
      monthCollection: collection,
      monthlyStats: updatedMonthlyStats,
    );
    await TaqseetFirestoreServices.saveRecord(
      type: 'group',
      documentId: currentGroup.id,
      data: updatedGroup.toMap(),
    );

    _group = updatedGroup;
  }
}
