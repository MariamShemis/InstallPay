import 'package:smart_installment_management/features/main_layout/partners/data/model/partner_model.dart';

class PartnerState {
  final List<PartnerModel> partners;
  final double applicationCapital;
  final bool isLoading;
  final String? errorMessage;

  const PartnerState({
    this.partners = const [],
    this.applicationCapital = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  PartnerState copyWith({
    List<PartnerModel>? partners,
    double? applicationCapital,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PartnerState(
      partners: partners ?? this.partners,
      applicationCapital:
      applicationCapital ?? this.applicationCapital,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}