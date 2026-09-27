class InstallmentModel {
  final int installmentNumber;
  final String dueDate;
  final double amount;
  final bool isPaid;
  final String paidAtDate;

  const InstallmentModel({
    required this.installmentNumber,
    required this.dueDate,
    required this.amount,
    required this.isPaid,
    this.paidAtDate = '',
  });

  InstallmentModel copyWith({
    int? installmentNumber,
    String? dueDate,
    double? amount,
    bool? isPaid,
    String? paidAtDate,
  }) {
    return InstallmentModel(
      installmentNumber:
      installmentNumber ?? this.installmentNumber,
      dueDate: dueDate ?? this.dueDate,
      amount: amount ?? this.amount,
      isPaid: isPaid ?? this.isPaid,
      paidAtDate: paidAtDate ?? this.paidAtDate,
    );
  }
}

class CustomerModel {
  final String id;

  final String customerName;
  final String customerPhone;
  final String address;
  final String groupName;

  final String contractDate;
  final String contractName;
  final double purchasePrice;
  final double sellingPrice;
  final double downPayment;
  final double debtAmount;

  final double installmentAmount;
  final String installmentType;
  final int installmentsCount;
  final String firstInstallmentDate;

  final double paidValue;
  final bool isDownPaymentPaid;
  final String downPaymentPaidAtDate;

  final String status;
  final String nextDueDate;

  final String description;

  final List<InstallmentModel> schedule;

  const CustomerModel({
    this.id = '',
    required this.customerName,
    required this.customerPhone,
    required this.address,
    required this.groupName,
    required this.contractDate,
    required this.contractName,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.downPayment,
    required this.debtAmount,
    required this.installmentAmount,
    required this.installmentType,
    required this.installmentsCount,
    required this.firstInstallmentDate,
    required this.paidValue,
    this.isDownPaymentPaid = false,
    this.downPaymentPaidAtDate = '',
    required this.status,
    required this.nextDueDate,
    required this.description,
    this.schedule = const [],
  });

  double get remainingValue {
    final remaining = debtAmount - paidValue;

    if (remaining < 0) {
      return 0;
    }

    return remaining;
  }

  double get totalPaid {
    final paidDownPayment =
    isDownPaymentPaid ? downPayment : 0;

    return paidDownPayment + paidValue;
  }

  double get paymentProgress {
    if (sellingPrice <= 0) {
      return 0;
    }

    return (totalPaid / sellingPrice).clamp(0.0, 1.0);
  }

  bool get isCompleted {
    return remainingValue <= 0;
  }

  CustomerModel copyWith({
    String? id,
    String? customerName,
    String? customerPhone,
    String? address,
    String? groupName,
    String? contractDate,
    String? contractName,
    double? purchasePrice,
    double? sellingPrice,
    double? downPayment,
    double? debtAmount,
    double? installmentAmount,
    String? installmentType,
    int? installmentsCount,
    String? firstInstallmentDate,
    double? paidValue,
    bool? isDownPaymentPaid,
    String? downPaymentPaidAtDate,
    String? status,
    String? nextDueDate,
    String? description,
    List<InstallmentModel>? schedule,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      address: address ?? this.address,
      groupName: groupName ?? this.groupName,
      contractDate: contractDate ?? this.contractDate,
      contractName: contractName ?? this.contractName,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      downPayment: downPayment ?? this.downPayment,
      debtAmount: debtAmount ?? this.debtAmount,
      installmentAmount:
      installmentAmount ?? this.installmentAmount,
      installmentType:
      installmentType ?? this.installmentType,
      installmentsCount:
      installmentsCount ?? this.installmentsCount,
      firstInstallmentDate:
      firstInstallmentDate ?? this.firstInstallmentDate,
      paidValue: paidValue ?? this.paidValue,
      isDownPaymentPaid:
      isDownPaymentPaid ?? this.isDownPaymentPaid,
      downPaymentPaidAtDate:
      downPaymentPaidAtDate ?? this.downPaymentPaidAtDate,
      status: status ?? this.status,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      description: description ?? this.description,
      schedule: schedule ?? this.schedule,
    );
  }
}