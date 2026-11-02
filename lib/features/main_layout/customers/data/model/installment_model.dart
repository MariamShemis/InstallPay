
class InstallmentModel {
  final int installmentNumber;
  final String dueDate;
  final double amount;
  final double paidAmount;
  final bool isPaid;
  final String paidAtDate;
  final String status;

  const InstallmentModel({
    required this.installmentNumber,
    required this.dueDate,
    required this.amount,
    this.paidAmount = 0,
    this.isPaid = false,
    this.paidAtDate = '',
    this.status = 'unpaid',
  });

  double get remainingAmount {
    final remaining = amount - paidAmount;
    return remaining > 0 ? remaining : 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'installmentNumber': installmentNumber,
      'dueDate': dueDate,
      'amount': amount,
      'paidAmount': paidAmount,
      'isPaid': isPaid,
      'paidAtDate': paidAtDate,
      'status': status,
    };
  }

  factory InstallmentModel.fromMap(Map<String, dynamic> map) {
    final amount = (map['amount'] as num?)?.toDouble() ?? 0.0;
    final isPaid = map['isPaid'] as bool? ?? false;

    final savedPaidAmount = (map['paidAmount'] as num?)?.toDouble();

    return InstallmentModel(
      installmentNumber:
      (map['installmentNumber'] as num?)?.toInt() ?? 0,
      dueDate: map['dueDate']?.toString() ?? '',
      amount: amount,
      paidAmount: savedPaidAmount ?? (isPaid ? amount : 0.0),
      isPaid: isPaid,
      paidAtDate: map['paidAtDate']?.toString() ?? '',
      status: map['status']?.toString() ?? 'unpaid',
    );
  }

  InstallmentModel copyWith({
    int? installmentNumber,
    String? dueDate,
    double? amount,
    double? paidAmount,
    bool? isPaid,
    String? paidAtDate,
    String? status,
  }) {
    return InstallmentModel(
      installmentNumber: installmentNumber ?? this.installmentNumber,
      dueDate: dueDate ?? this.dueDate,
      amount: amount ?? this.amount,
      paidAmount: paidAmount ?? this.paidAmount,
      isPaid: isPaid ?? this.isPaid,
      paidAtDate: paidAtDate ?? this.paidAtDate,
      status: status ?? this.status,
    );
  }
}
