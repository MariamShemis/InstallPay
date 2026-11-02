import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_installment_management/core/firebase/taqseet_firestore_services.dart';
import 'package:smart_installment_management/core/utils/helper/payment_status_helper.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';
import 'package:smart_installment_management/features/main_layout/groups/data/cubit/group_state.dart';
import 'package:smart_installment_management/features/main_layout/groups/data/model/group_model.dart';

import '../../../../../core/services/cloudinary_services.dart';

class GroupsCubit extends Cubit<GroupsState> {
  GroupsCubit() : super(GroupsInitial());

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _groupsSubscription;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  _customersSubscription;

  List<GroupModel> _savedGroups = [];
  List<CustomerModel> _customers = [];
  List<GroupModel> _groups = [];

  bool _hasGroupsSnapshot = false;
  bool _hasCustomersSnapshot = false;

  final Set<String> _pendingMonthlyWrites = {};

  List<GroupModel> get groups => List.unmodifiable(_groups);

  String _monthKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }

  DateTime? _parseDate(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final text = value.trim();

    final isoDate = DateTime.tryParse(text);
    if (isoDate != null) {
      return DateTime(isoDate.year, isoDate.month, isoDate.day);
    }

    final slashParts = text.split('/');

    if (slashParts.length == 3) {
      final day = int.tryParse(slashParts[0]);
      final month = int.tryParse(slashParts[1]);
      final year = int.tryParse(slashParts[2]);

      if (day != null && month != null && year != null) {
        final date = DateTime(year, month, day);

        if (date.year == year && date.month == month && date.day == day) {
          return date;
        }
      }
    }

    final parts = text.split(RegExp(r'\s+'));

    if (parts.length == 3) {
      final day = int.tryParse(parts[0]);
      final year = int.tryParse(parts[2]);

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

      final monthText = parts[1].toLowerCase();
      final shortMonth = monthText.length >= 3
          ? monthText.substring(0, 3)
          : monthText;

      final month = months[shortMonth];

      if (day != null && year != null && month != null) {
        final date = DateTime(year, month, day);

        if (date.year == year && date.month == month && date.day == day) {
          return date;
        }
      }
    }

    return null;
  }

  void loadGroups() {
    _groupsSubscription?.cancel();
    _customersSubscription?.cancel();

    _hasGroupsSnapshot = false;
    _hasCustomersSnapshot = false;

    emit(GroupsLoading());

    try {
      _groupsSubscription =
          TaqseetFirestoreServices.recordsStream(type: 'group').listen(
            (snapshot) {
              if (isClosed) return;

              _savedGroups = [];

              for (final document in snapshot.docs) {
                _savedGroups.add(
                  GroupModel.fromMap(document.data(), id: document.id),
                );
              }

              _hasGroupsSnapshot = true;
              _recalculateGroups();
            },
            onError: (error) {
              if (isClosed) return;

              emit(GroupsError('Unable to load groups. Please try again.'));
            },
          );

      _customersSubscription =
          TaqseetFirestoreServices.recordsStream(type: 'customer').listen(
            (snapshot) {
              if (isClosed) return;

              _customers = [];

              for (final document in snapshot.docs) {
                _customers.add(
                  CustomerModel.fromMap(
                    document.data(),
                    documentId: document.id,
                  ),
                );
              }

              _hasCustomersSnapshot = true;
              _recalculateGroups();
            },
            onError: (error) {
              if (isClosed) return;

              emit(GroupsError('Unable to load customers. Please try again.'));
            },
          );
    } catch (error) {
      if (isClosed) return;

      emit(GroupsError('Unable to load groups. Please try again.'));
    }
  }

  bool _belongsToGroup(CustomerModel customer, GroupModel group) {
    return customer.groupId == group.id ||
        (customer.groupId.isEmpty &&
            customer.groupName.trim().toLowerCase() ==
                group.groupTitle.trim().toLowerCase());
  }

  bool _belongsToAnySavedGroup(CustomerModel customer) {
    for (final group in _savedGroups) {
      if (_belongsToGroup(customer, group)) {
        return true;
      }
    }

    return false;
  }

  // Target:
  // - Down payment for contracts created in the selected month.
  // - Installments due in the selected month.
  //
  // Collection:
  // - Down payment actually received in the selected month.
  // - Installment payments actually received in the selected month,
  //   regardless of the installment's due date.
  Map<String, double> _calculateMonthlyStats(
    List<CustomerModel> customers,
    String monthKey,
  ) {
    double target = 0;
    double collection = 0;

    for (final customer in customers) {
      final contractDate = _parseDate(customer.contractDate);

      if (contractDate != null && _monthKey(contractDate) == monthKey) {
        target += customer.downPayment;
      }

      final downPaymentDate = _parseDate(customer.downPaymentPaidAtDate);

      if (customer.isDownPaymentPaid &&
          downPaymentDate != null &&
          _monthKey(downPaymentDate) == monthKey) {
        collection += customer.downPaymentPaidAmount;
      }

      for (final installment in customer.schedule) {
        final dueDate = _parseDate(installment.dueDate);

        if (dueDate != null && _monthKey(dueDate) == monthKey) {
          target += installment.amount;
        }

        final paymentDate = _parseDate(installment.paidAtDate);

        if (paymentDate != null && _monthKey(paymentDate) == monthKey) {
          collection += installment.paidAmount;
        }
      }
    }

    return {'target': target, 'collection': collection};
  }

  void _saveMonthlyStatsIfChanged({
    required GroupModel group,
    required String monthKey,
    required double target,
    required double collection,
  }) {
    if (group.id.isEmpty || group.id == '__other__') return;

    final oldMonth = group.monthlyStats[monthKey];

    final oldTarget = oldMonth is Map
        ? (oldMonth['target'] as num?)?.toDouble() ?? 0.0
        : 0.0;

    final oldCollection = oldMonth is Map
        ? (oldMonth['collection'] as num?)?.toDouble() ?? 0.0
        : 0.0;

    final alreadyCurrent =
        oldTarget == target &&
        oldCollection == collection &&
        group.currentMonthKey == monthKey &&
        group.monthTarget == target &&
        group.monthCollection == collection;

    if (alreadyCurrent) return;

    final writeKey = '${group.id}_$monthKey';

    if (_pendingMonthlyWrites.contains(writeKey)) return;

    final history = Map<String, dynamic>.from(group.monthlyStats);

    history[monthKey] = {
      'target': target,
      'collection': collection,
      'progress': target <= 0 ? 0.0 : (collection / target).clamp(0.0, 1.0),
      'updatedAt': DateTime.now().toIso8601String(),
    };

    _pendingMonthlyWrites.add(writeKey);

    unawaited(
      TaqseetFirestoreServices.saveRecord(
            type: 'group',
            documentId: group.id,
            data: {
              'currentMonthKey': monthKey,
              'monthTarget': target,
              'monthCollection': collection,
              'monthlyStats': history,
            },
          )
          .catchError((error) {
            // A later snapshot can retry the write.
          })
          .whenComplete(() {
            _pendingMonthlyWrites.remove(writeKey);
          }),
    );
  }

  void _recalculateGroups() {
    if (isClosed || !_hasGroupsSnapshot || !_hasCustomersSnapshot) {
      return;
    }

    final updatedGroups = <GroupModel>[];
    final monthKey = _monthKey(DateTime.now());

    for (final group in _savedGroups) {
      int clientsCount = 0;
      int dueCount = 0;
      int dueTodayCount = 0;
      int overdueCount = 0;
      int completedCount = 0;

      double totalValue = 0;
      double collectedValue = 0;
      double remainingValue = 0;

      final groupCustomers = <CustomerModel>[];

      for (final customer in _customers) {
        if (!_belongsToGroup(customer, group)) continue;

        groupCustomers.add(customer);

        clientsCount++;
        totalValue += customer.sellingPrice;
        collectedValue += customer.totalPaid;
        remainingValue += customer.remainingValue;

        final updatedCustomer = PaymentStatusHelper.updateCustomer(customer);

        final status = updatedCustomer.status.trim().toLowerCase();

        if (status == 'due') {
          dueCount++;
          dueTodayCount++;
        } else if (status == 'overdue') {
          dueCount++;
          overdueCount++;
        } else if (status == 'unpaid') {
          dueCount++;
        }

        if (status == 'paid' || updatedCustomer.remainingValue <= 0) {
          completedCount++;
        }
      }

      final monthly = _calculateMonthlyStats(groupCustomers, monthKey);

      final monthTarget = monthly['target'] ?? 0.0;
      final monthCollection = monthly['collection'] ?? 0.0;

      _saveMonthlyStatsIfChanged(
        group: group,
        monthKey: monthKey,
        target: monthTarget,
        collection: monthCollection,
      );

      final history = Map<String, dynamic>.from(group.monthlyStats);

      history[monthKey] = {
        'target': monthTarget,
        'collection': monthCollection,
        'progress': monthTarget <= 0
            ? 0.0
            : (monthCollection / monthTarget).clamp(0.0, 1.0),
      };

      updatedGroups.add(
        group.copyWith(
          clientsCount: clientsCount,
          dueCount: dueCount,
          totalValue: totalValue,
          collectedValue: collectedValue,
          remainingValue: remainingValue,
          dueTodayCount: dueTodayCount,
          overdueCount: overdueCount,
          completedCount: completedCount,
          currentMonthKey: monthKey,
          monthTarget: monthTarget,
          monthCollection: monthCollection,
          monthlyStats: history,
        ),
      );
    }

    final otherCustomers = <CustomerModel>[];

    int otherDueCount = 0;
    int otherDueTodayCount = 0;
    int otherOverdueCount = 0;
    int otherCompletedCount = 0;

    double otherTotalValue = 0;
    double otherCollectedValue = 0;
    double otherRemainingValue = 0;

    for (final customer in _customers) {
      if (_belongsToAnySavedGroup(customer)) continue;

      otherCustomers.add(customer);

      otherTotalValue += customer.sellingPrice;
      otherCollectedValue += customer.totalPaid;
      otherRemainingValue += customer.remainingValue;

      final updatedCustomer = PaymentStatusHelper.updateCustomer(customer);

      final status = updatedCustomer.status.trim().toLowerCase();

      if (status == 'due') {
        otherDueCount++;
        otherDueTodayCount++;
      } else if (status == 'overdue') {
        otherDueCount++;
        otherOverdueCount++;
      } else if (status == 'unpaid') {
        otherDueCount++;
      }

      if (status == 'paid' || updatedCustomer.remainingValue <= 0) {
        otherCompletedCount++;
      }
    }

    if (otherCustomers.isNotEmpty) {
      final monthly = _calculateMonthlyStats(otherCustomers, monthKey);

      updatedGroups.add(
        GroupModel(
          id: '__other__',
          groupTitle: 'Other',
          collectorName: '',
          collectorPhone: '',
          clientsCount: otherCustomers.length,
          dueCount: otherDueCount,
          totalValue: otherTotalValue,
          collectedValue: otherCollectedValue,
          remainingValue: otherRemainingValue,
          dueTodayCount: otherDueTodayCount,
          overdueCount: otherOverdueCount,
          completedCount: otherCompletedCount,
          currentMonthKey: monthKey,
          monthTarget: monthly['target'] ?? 0.0,
          monthCollection: monthly['collection'] ?? 0.0,
        ),
      );
    }

    _groups = updatedGroups;

    emit(GroupsLoaded(List.unmodifiable(_groups)));
  }

  Future<bool> addGroup({
    required String groupTitle,
    required String collectorName,
    required String collectorPhone,
    required String address,
    File? image,
  }) async {
    try {
      emit(GroupsSaving());

      String? imageUrl;

      if (image != null) {
        imageUrl = await CloudinaryServices.uploadImage(image);
      }

      final group = GroupModel(
        groupTitle: groupTitle.trim(),
        collectorName: collectorName.trim(),
        collectorPhone: collectorPhone.trim(),
        address: address.trim(),
        imageUrl: imageUrl,
      );

      await TaqseetFirestoreServices.saveRecord(
        type: 'group',
        data: group.toMap(),
      );

      emit(GroupsSaveSuccess());
      return true;
    } catch (error) {
      emit(GroupsSaveError('Unable to save group. Please try again.'));

      return false;
    }
  }

  Future<void> deleteGroup(String groupId) async {
    if (groupId == '__other__') return;

    try {
      await TaqseetFirestoreServices.deleteRecord(documentId: groupId);
    } catch (error) {
      if (isClosed) return;

      emit(GroupsError('Unable to delete group. Please try again.'));
    }
  }

  @override
  Future<void> close() async {
    await _groupsSubscription?.cancel();
    await _customersSubscription?.cancel();

    return super.close();
  }
}
