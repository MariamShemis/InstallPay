class IncomeExpenseModel {
  final String id;
  final String personName;
  final String phoneNumber;
  final String reason;
  final double incomeAmount;
  final DateTime? incomeDate;
  final double expenseAmount;
  final DateTime? expenseDate;

  IncomeExpenseModel({
    required this.id,
    required this.personName,
    required this.phoneNumber,
    required this.reason,
    this.incomeAmount = 0.0,
    this.incomeDate,
    this.expenseAmount = 0.0,
    this.expenseDate,
  });
}