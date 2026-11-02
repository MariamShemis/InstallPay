import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_installment_management/core/firebase/taqseet_firestore_services.dart';
import 'package:smart_installment_management/core/services/cloudinary_services.dart';
import 'package:smart_installment_management/features/main_layout/partners/data/cubit/partner_state.dart';
import 'package:smart_installment_management/features/main_layout/partners/data/model/partner_model.dart';

class PartnerCubit extends Cubit<PartnerState> {
  PartnerCubit() : super(const PartnerState());

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  static PartnerCubit get(context) => BlocProvider.of(context);

  double get adminProfitMargin {
    final remaining = 100 - secondaryProfitTotal;
    return remaining < 0 ? 0 : remaining;
  }

  double get secondaryProfitTotal {
    return _getSecondaryTotal(state.partners);
  }

  double _getSecondaryTotal(List<PartnerModel> partners, {String? excludeId}) {
    double total = 0;

    for (final partner in partners) {
      if (partner.isSecondary && partner.id != excludeId) {
        total += partner.profitMargin;
      }
    }

    return total;
  }

  List<PartnerModel> _normalizePartners(List<PartnerModel> partners) {
    final secondaryTotal = _getSecondaryTotal(partners);
    final remainingAdminProfit = 100 - secondaryTotal;
    final safeAdminProfit = remainingAdminProfit < 0
        ? 0.0
        : remainingAdminProfit;

    return partners.map((partner) {
      if (partner.isAdmin) {
        return partner.copyWith(profitMargin: safeAdminProfit);
      }

      // Primary and Secondary percentages are preserved.
      return partner;
    }).toList();
  }

  Future<void> loadPartners() async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      await _subscription?.cancel();

      _subscription = TaqseetFirestoreServices.recordsStream(type: 'partner')
          .listen(
            (snapshot) {
              if (isClosed) return;
              final partners = <PartnerModel>[];
              for (final document in snapshot.docs) {
                partners.add(
                  PartnerModel.fromMap(document.data(), id: document.id),
                );
              }
              final normalizedPartners = _normalizePartners(partners);
              double totalCapital = 0;
              for (final partner in normalizedPartners) {
                totalCapital += partner.mainCapital;
              }
              emit(
                state.copyWith(
                  partners: normalizedPartners,
                  applicationCapital: totalCapital,
                  isLoading: false,
                  clearError: true,
                ),
              );
            },
            onError: (error) {
              if (isClosed) return;

              emit(
                state.copyWith(
                  isLoading: false,
                  errorMessage: error.toString(),
                ),
              );
            },
          );
    } catch (error) {
      if (isClosed) return;

      emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
    }
  }

  Future<bool> addPartner(PartnerModel partner, {File? imageFile}) async {
    try {
      final currentPartners = List<PartnerModel>.from(state.partners);

      if (partner.isAdmin && currentPartners.any((item) => item.isAdmin)) {
        throw Exception('onlyOneAdminAllowed');
      }

      _validateProfit(partner.profitMargin);

      if (partner.isSecondary) {
        _validateSecondaryTotal(
          _getSecondaryTotal(currentPartners) + partner.profitMargin,
        );
      }

      String? imageUrl = partner.imagePath;

      if (imageFile != null) {
        imageUrl = await CloudinaryServices.uploadImage(imageFile);
      }

      final partnerToSave = partner.copyWith(
        imagePath: imageUrl,
        profitMargin: partner.isAdmin
            ? adminProfitMargin
            : partner.profitMargin,
      );

      final savedId = await TaqseetFirestoreServices.saveRecord(
        type: 'partner',
        data: partnerToSave.toMap(),
        documentId: partner.id.isEmpty ? null : partner.id,
      );

      final updatedPartners = List<PartnerModel>.from(currentPartners)
        ..add(partnerToSave.copyWith(id: savedId));

      await _saveCalculatedValues(updatedPartners);
      await loadPartners();

      return true;
    } catch (error) {
      _emitError(error);
      return false;
    }
  }

  Future<bool> updatePartner(PartnerModel partner, {File? imageFile}) async {
    try {
      final currentPartners = List<PartnerModel>.from(state.partners);

      final exists = currentPartners.any((item) => item.id == partner.id);

      if (!exists) {
        throw Exception('partnerNotFound');
      }

      if (partner.isAdmin &&
          currentPartners.any(
            (item) => item.isAdmin && item.id != partner.id,
          )) {
        throw Exception('onlyOneAdminAllowed');
      }

      _validateProfit(partner.profitMargin);

      if (partner.isSecondary) {
        final totalWithoutCurrent = _getSecondaryTotal(
          currentPartners,
          excludeId: partner.id,
        );

        _validateSecondaryTotal(totalWithoutCurrent + partner.profitMargin);
      }

      String? imageUrl = partner.imagePath;

      if (imageFile != null) {
        imageUrl = await CloudinaryServices.uploadImage(imageFile);
      }

      final partnerToSave = partner.copyWith(imagePath: imageUrl);

      await TaqseetFirestoreServices.saveRecord(
        type: 'partner',
        data: partnerToSave.toMap(),
        documentId: partner.id,
      );

      final updatedPartners = currentPartners.map((item) {
        return item.id == partner.id ? partnerToSave : item;
      }).toList();

      await _saveCalculatedValues(updatedPartners);
      await loadPartners();

      return true;
    } catch (error) {
      _emitError(error);
      return false;
    }
  }

  Future<bool> deletePartner(String partnerId) async {
    try {
      final currentPartners = List<PartnerModel>.from(state.partners);

      final index = currentPartners.indexWhere((item) => item.id == partnerId);

      if (index == -1) {
        throw Exception('partnerNotFound');
      }

      await TaqseetFirestoreServices.deleteRecord(documentId: partnerId);

      currentPartners.removeAt(index);

      await _saveCalculatedValues(currentPartners);
      await loadPartners();

      return true;
    } catch (error) {
      _emitError(error);
      return false;
    }
  }

  void _validateProfit(double profit) {
    if (!profit.isFinite || profit < 0 || profit > 100) {
      throw Exception('invalidProfitMargin');
    }
  }

  void _validateSecondaryTotal(double total) {
    if (total > 100) {
      throw Exception('secondaryProfitLimitExceeded');
    }
  }

  Future<void> _saveCalculatedValues(List<PartnerModel> partners) async {
    final normalizedPartners = _normalizePartners(partners);

    // Save the recalculated Admin percentage.
    for (final partner in normalizedPartners) {
      if (partner.isAdmin) {
        await TaqseetFirestoreServices.saveRecord(
          type: 'partner',
          documentId: partner.id,
          data: partner.toMap(),
        );
      }
    }

    double totalCapital = 0;

    for (final partner in normalizedPartners) {
      totalCapital += partner.mainCapital;
    }

    await TaqseetFirestoreServices.saveRecord(
      type: 'partner_summary',
      documentId: 'application_capital_summary',
      data: {
        'applicationCapital': totalCapital,
        'secondaryProfitTotal': _getSecondaryTotal(normalizedPartners),
        'adminProfitMargin': _getAdminProfit(normalizedPartners),
      },
    );
  }

  double _getAdminProfit(List<PartnerModel> partners) {
    final remaining = 100 - _getSecondaryTotal(partners);
    return remaining < 0 ? 0 : remaining;
  }

  void _emitError(Object error) {
    if (isClosed) return;
    emit(
      state.copyWith(
        errorMessage: error.toString().replaceFirst('Exception: ', ''),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
