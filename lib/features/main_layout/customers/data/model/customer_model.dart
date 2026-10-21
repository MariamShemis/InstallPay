import 'package:smart_installment_management/features/main_layout/customers/data/model/installment_model.dart';

class CustomerModel {
  final String id;
  final String customerName;
  final String customerPhone;
  final String address;
  final String groupId;
  final String groupName;
  final String imageUrl;

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
    this.groupId = '',
    required this.groupName,
    this.imageUrl = '',
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

  double get totalPaid {
    final collectedDownPayment = isDownPaymentPaid ? downPayment : 0.0;
    final collectedInstallments = paidValue;

    return collectedDownPayment + collectedInstallments;
  }

  double get remainingValue {
    final remaining = sellingPrice - totalPaid;

    return remaining > 0 ? remaining : 0.0;
  }

  double get paymentProgress {
    if (sellingPrice <= 0) return 0.0;

    return (totalPaid / sellingPrice).clamp(0.0, 1.0);
  }

  bool get isCompleted => remainingValue <= 0;

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'customerPhone': customerPhone,
      'address': address,
      'groupId': groupId,
      'groupName': groupName,
      'imageUrl': imageUrl,
      'contractDate': contractDate,
      'contractName': contractName,
      'purchasePrice': purchasePrice,
      'sellingPrice': sellingPrice,
      'downPayment': downPayment,
      'debtAmount': debtAmount,
      'installmentAmount': installmentAmount,
      'installmentType': installmentType,
      'installmentsCount': installmentsCount,
      'firstInstallmentDate': firstInstallmentDate,
      'paidValue': paidValue,
      'isDownPaymentPaid': isDownPaymentPaid,
      'downPaymentPaidAtDate': downPaymentPaidAtDate,
      'status': status,
      'nextDueDate': nextDueDate,
      'description': description,
      'schedule': schedule.map((item) => item.toMap()).toList(),
    };
  }

  factory CustomerModel.fromMap(
    Map<String, dynamic> map, {
    String documentId = '',
  }) {
    final rawSchedule = map['schedule'];
    final List<InstallmentModel> parsedSchedule = [];

    if (rawSchedule is List) {
      for (final item in rawSchedule) {
        if (item is Map) {
          parsedSchedule.add(
            InstallmentModel.fromMap(Map<String, dynamic>.from(item)),
          );
        }
      }
    }

    return CustomerModel(
      id: documentId.isNotEmpty ? documentId : map['id']?.toString() ?? '',
      customerName: map['customerName']?.toString() ?? '',
      customerPhone: map['customerPhone']?.toString() ?? '',
      address: map['address']?.toString() ?? '',
      groupId: map['groupId']?.toString() ?? '',
      groupName: map['groupName']?.toString() ?? 'Other',
      imageUrl: map['imageUrl']?.toString() ?? '',
      contractDate: map['contractDate']?.toString() ?? '',
      contractName: map['contractName']?.toString() ?? '',
      purchasePrice: (map['purchasePrice'] as num?)?.toDouble() ?? 0,
      sellingPrice: (map['sellingPrice'] as num?)?.toDouble() ?? 0,
      downPayment: (map['downPayment'] as num?)?.toDouble() ?? 0,
      debtAmount: (map['debtAmount'] as num?)?.toDouble() ?? 0,
      installmentAmount: (map['installmentAmount'] as num?)?.toDouble() ?? 0,
      installmentType: map['installmentType']?.toString() ?? 'Monthly',
      installmentsCount: (map['installmentsCount'] as num?)?.toInt() ?? 0,
      firstInstallmentDate: map['firstInstallmentDate']?.toString() ?? '',
      paidValue: (map['paidValue'] as num?)?.toDouble() ?? 0,
      isDownPaymentPaid: map['isDownPaymentPaid'] == true,
      downPaymentPaidAtDate: map['downPaymentPaidAtDate']?.toString() ?? '',
      status: map['status']?.toString() ?? 'Up to Date',
      nextDueDate: map['nextDueDate']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      schedule: parsedSchedule,
    );
  }

  CustomerModel copyWith({
    String? id,
    String? customerName,
    String? customerPhone,
    String? address,
    String? groupId,
    String? groupName,
    String? imageUrl,
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
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      imageUrl: imageUrl ?? this.imageUrl,
      contractDate: contractDate ?? this.contractDate,
      contractName: contractName ?? this.contractName,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      downPayment: downPayment ?? this.downPayment,
      debtAmount: debtAmount ?? this.debtAmount,
      installmentAmount: installmentAmount ?? this.installmentAmount,
      installmentType: installmentType ?? this.installmentType,
      installmentsCount: installmentsCount ?? this.installmentsCount,
      firstInstallmentDate: firstInstallmentDate ?? this.firstInstallmentDate,
      paidValue: paidValue ?? this.paidValue,
      isDownPaymentPaid: isDownPaymentPaid ?? this.isDownPaymentPaid,
      downPaymentPaidAtDate:
          downPaymentPaidAtDate ?? this.downPaymentPaidAtDate,
      status: status ?? this.status,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      description: description ?? this.description,
      schedule: schedule ?? this.schedule,
    );
  }
}
