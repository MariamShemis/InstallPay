
class InstallmentModel {
  final int installmentNumber;
  final String dueDate;
  final double amount;
  final double paidAmount;
  final bool isPaid;
  final String paidAtDate;

  const InstallmentModel({
    required this.installmentNumber,
    required this.dueDate,
    required this.amount,
    this.paidAmount = 0,
    required this.isPaid,
    this.paidAtDate = '',
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
    };
  }

  factory InstallmentModel.fromMap(Map<String, dynamic> map) {
    final amount = (map['amount'] as num?)?.toDouble() ?? 0;
    final isPaid = map['isPaid'] == true;

    return InstallmentModel(
      installmentNumber:
      (map['installmentNumber'] as num?)?.toInt() ?? 0,
      dueDate: map['dueDate']?.toString() ?? '',
      amount: amount,
      // يدعم الأقساط القديمة التي لم يكن لها paidAmount.
      paidAmount: (map['paidAmount'] as num?)?.toDouble() ??
          (isPaid ? amount : 0),
      isPaid: isPaid,
      paidAtDate: map['paidAtDate']?.toString() ?? '',
    );
  }

  InstallmentModel copyWith({
    int? installmentNumber,
    String? dueDate,
    double? amount,
    double? paidAmount,
    bool? isPaid,
    String? paidAtDate,
  }) {
    return InstallmentModel(
      installmentNumber: installmentNumber ?? this.installmentNumber,
      dueDate: dueDate ?? this.dueDate,
      amount: amount ?? this.amount,
      paidAmount: paidAmount ?? this.paidAmount,
      isPaid: isPaid ?? this.isPaid,
      paidAtDate: paidAtDate ?? this.paidAtDate,
    );
  }
}
