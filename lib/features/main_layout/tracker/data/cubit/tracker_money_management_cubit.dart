import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_installment_management/core/firebase/taqseet_firestore_services.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';
import 'package:smart_installment_management/features/main_layout/partners/data/model/partner_model.dart';

import 'tracker_money_management_state.dart';

class TrackerMoneyManagementCubit extends Cubit<TrackerMoneyManagementState> {
  TrackerMoneyManagementCubit() : super(const TrackerMoneyManagementState());

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  _partnersSubscription;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  _customersSubscription;

  List<PartnerModel> _partners = [];
  List<CustomerModel> _customers = [];

  bool _partnersLoaded = false;
  bool _customersLoaded = false;
  int _loadRequestId = 0;

  static TrackerMoneyManagementCubit get(context) =>
      BlocProvider.of<TrackerMoneyManagementCubit>(context);

  Future<void> loadData() async {
    final requestId = ++_loadRequestId;

    await _cancelSubscriptions();

    if (isClosed || requestId != _loadRequestId) return;

    _partnersLoaded = false;
    _customersLoaded = false;
    _partners = [];
    _customers = [];

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      _partnersSubscription =
          TaqseetFirestoreServices.recordsStream(type: 'partner').listen(
            (snapshot) {
              if (isClosed || requestId != _loadRequestId) return;

              try {
                _partners = snapshot.docs.map((document) {
                  return PartnerModel.fromMap(document.data(), id: document.id);
                }).toList();

                _partnersLoaded = true;
                _calculateTotals();
              } catch (error) {
                _emitError(error);
              }
            },
            onError: (Object error) {
              if (requestId == _loadRequestId) _emitError(error);
            },
          );

      _customersSubscription =
          TaqseetFirestoreServices.recordsStream(type: 'customer').listen(
            (snapshot) {
              if (isClosed || requestId != _loadRequestId) return;

              try {
                _customers = snapshot.docs.map((document) {
                  return CustomerModel.fromMap(
                    document.data(),
                    documentId: document.id,
                  );
                }).toList();

                _customersLoaded = true;
                _calculateTotals();
              } catch (error) {
                _emitError(error);
              }
            },
            onError: (Object error) {
              if (requestId == _loadRequestId) _emitError(error);
            },
          );
    } catch (error) {
      _emitError(error);
    }
  }

  void _calculateTotals() {
    if (isClosed) return;

    double mainCapital = 0;
    double newCapital = 0;

    for (final partner in _partners) {
      mainCapital += partner.mainCapital;
      newCapital += partner.newCapital;
    }

    double totalSales = 0;
    double totalCollected = 0;
    double totalRemaining = 0;

    for (final customer in _customers) {
      totalSales += customer.sellingPrice;
      totalCollected += customer.totalPaid;
      totalRemaining += customer.remainingValue;
    }

    final expectedProfit = newCapital - mainCapital;

    final growthRate = mainCapital == 0
        ? 0.0
        : (expectedProfit / mainCapital) * 100;

    final collectionRate = totalSales == 0
        ? 0.0
        : (totalCollected / totalSales) * 100;

    emit(
      state.copyWith(
        isLoading: !(_partnersLoaded && _customersLoaded),
        partnersCount: _partners.length,
        customersCount: _customers.length,
        mainCapital: mainCapital,
        newCapital: newCapital,
        expectedProfit: expectedProfit,
        growthRate: growthRate,
        totalSales: totalSales,
        totalCollected: totalCollected,
        totalRemaining: totalRemaining,
        collectionRate: collectionRate,
        clearError: true,
      ),
    );
  }

  void _emitError(Object error) {
    if (isClosed) return;

    emit(
      state.copyWith(
        isLoading: false,
        errorMessage: error.toString().replaceFirst('Exception: ', ''),
      ),
    );
  }

  Future<void> _cancelSubscriptions() async {
    await _partnersSubscription?.cancel();
    await _customersSubscription?.cancel();

    _partnersSubscription = null;
    _customersSubscription = null;
  }

  @override
  Future<void> close() async {
    _loadRequestId++;
    await _cancelSubscriptions();
    return super.close();
  }
}
