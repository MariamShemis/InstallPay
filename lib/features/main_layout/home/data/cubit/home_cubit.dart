import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_installment_management/core/firebase/firebase_auth_services.dart';
import 'package:smart_installment_management/core/firebase/taqseet_firestore_services.dart';
import 'package:smart_installment_management/features/auth/data/model/user_model.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  UserModel? user;

  double _mainCapital = 0;
  double _cash = 0;
  double _outMoney = 0;
  double _totalCollected = 0;
  double _totalPurchasePrices = 0;

  bool _partnersLoaded = false;
  bool _customersLoaded = false;

  StreamSubscription? _partnerSubscription;
  StreamSubscription? _customerSubscription;

  Future<void> loadUser() async {
    if (isClosed) return;

    emit(HomeLoading());

    try {
      // Cancel previous listeners before creating new ones.
      await _partnerSubscription?.cancel();
      await _customerSubscription?.cancel();

      _resetFinancialData();

      final currentUser = await FirebaseAuthServices.getCurrentUser();

      if (isClosed) return;

      if (currentUser == null) {
        user = null;
        emit(HomeError('User data not found.'));
        return;
      }

      user = currentUser;

      // Wait until both Firestore streams return their first snapshot.
      _listenToPartners();
      _listenToCustomers();
    } catch (e) {
      if (!isClosed) {
        emit(HomeError('Unable to load user data.'));
      }
    }
  }

  void _resetFinancialData() {
    _mainCapital = 0;
    _cash = 0;
    _outMoney = 0;
    _totalCollected = 0;
    _totalPurchasePrices = 0;

    _partnersLoaded = false;
    _customersLoaded = false;
  }

  void _listenToPartners() {
    _partnerSubscription =
        TaqseetFirestoreServices.recordsStream(type: 'partner').listen(
          (snapshot) {
            double totalMainCapital = 0;

            for (final document in snapshot.docs) {
              final data = document.data();
              final capital = data['mainCapital'];

              if (capital is num) {
                totalMainCapital += capital.toDouble();
              } else if (capital is String) {
                totalMainCapital += double.tryParse(capital) ?? 0;
              }
            }

            _mainCapital = totalMainCapital;
            _partnersLoaded = true;

            _recalculateFinancials();
          },
          onError: (error) {
            _handleStreamError();
          },
        );
  }

  void _listenToCustomers() {
    _customerSubscription =
        TaqseetFirestoreServices.recordsStream(type: 'customer').listen(
          (snapshot) {
            double totalCollected = 0;
            double totalPurchasePrices = 0;
            double totalRemaining = 0;

            for (final document in snapshot.docs) {
              final customer = CustomerModel.fromMap(
                document.data(),
                documentId: document.id,
              );

              // Calculate totals using the actual customer records.
              totalCollected += customer.totalPaid;
              totalPurchasePrices += customer.purchasePrice;
              totalRemaining += customer.remainingValue;
            }

            _totalCollected = totalCollected;
            _totalPurchasePrices = totalPurchasePrices;
            _outMoney = totalRemaining;

            _customersLoaded = true;

            _recalculateFinancials();
          },
          onError: (error) {
            _handleStreamError();
          },
        );
  }

  void _recalculateFinancials() {
    _cash = _mainCapital + _totalCollected - _totalPurchasePrices;

    _emitHomeSuccess();
  }

  void _emitHomeSuccess() {
    final currentUser = user;

    if (isClosed || currentUser == null) return;

    // Do not show zero values while one of the data sources is loading.
    if (!_partnersLoaded || !_customersLoaded) return;

    emit(HomeSuccess(currentUser, cashPartner: _cash, outMoney: _outMoney));
  }

  void _handleStreamError() {
    if (isClosed) return;

    // Show an error only if the initial data has not loaded yet.
    if (!_partnersLoaded || !_customersLoaded) {
      emit(HomeError('Unable to load financial data. Please try again.'));
    }
  }

  Future<void> refreshUser() async {
    await loadUser();
  }

  @override
  Future<void> close() async {
    await _partnerSubscription?.cancel();
    await _customerSubscription?.cancel();

    return super.close();
  }
}
