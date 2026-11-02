class TrackerMoneyManagementState {
  final bool isLoading;
  final String? errorMessage;

  final int partnersCount;
  final int customersCount;

  final double mainCapital;
  final double newCapital;
  final double expectedProfit;
  final double growthRate;

  final double totalSales;
  final double totalCollected;
  final double totalRemaining;
  final double collectionRate;

  const TrackerMoneyManagementState({
    this.isLoading = true,
    this.errorMessage,
    this.partnersCount = 0,
    this.customersCount = 0,
    this.mainCapital = 0,
    this.newCapital = 0,
    this.expectedProfit = 0,
    this.growthRate = 0,
    this.totalSales = 0,
    this.totalCollected = 0,
    this.totalRemaining = 0,
    this.collectionRate = 0,
  });

  TrackerMoneyManagementState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    int? partnersCount,
    int? customersCount,
    double? mainCapital,
    double? newCapital,
    double? expectedProfit,
    double? growthRate,
    double? totalSales,
    double? totalCollected,
    double? totalRemaining,
    double? collectionRate,
  }) {
    return TrackerMoneyManagementState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      partnersCount: partnersCount ?? this.partnersCount,
      customersCount: customersCount ?? this.customersCount,
      mainCapital: mainCapital ?? this.mainCapital,
      newCapital: newCapital ?? this.newCapital,
      expectedProfit: expectedProfit ?? this.expectedProfit,
      growthRate: growthRate ?? this.growthRate,
      totalSales: totalSales ?? this.totalSales,
      totalCollected: totalCollected ?? this.totalCollected,
      totalRemaining: totalRemaining ?? this.totalRemaining,
      collectionRate: collectionRate ?? this.collectionRate,
    );
  }
}
