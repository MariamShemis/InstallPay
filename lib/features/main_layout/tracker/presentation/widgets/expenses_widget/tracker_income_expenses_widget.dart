import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/features/main_layout/tracker/data/model/income_expense_model.dart';
import 'package:smart_installment_management/features/main_layout/tracker/presentation/widgets/expenses_widget/tracker_financial_summary_card.dart';
import 'package:smart_installment_management/features/main_layout/tracker/presentation/widgets/expenses_widget/tracker_transaction_card.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';
import 'add_transaction_bottom_sheet.dart';

class TrackerIncomeExpensesWidget extends StatefulWidget {
  const TrackerIncomeExpensesWidget({super.key});

  @override
  State<TrackerIncomeExpensesWidget> createState() =>
      _TrackerIncomeExpensesWidgetState();
}

class _TrackerIncomeExpensesWidgetState
    extends State<TrackerIncomeExpensesWidget> {
  final List<IncomeExpenseModel> _records = [
    IncomeExpenseModel(
      id: '1',
      personName: 'Khaled El-Sayed',
      phoneNumber: '01012345678',
      reason: 'Batch Payment & Delivery Fee',
      incomeAmount: 3500.00,
      incomeDate: DateTime.now(),
      expenseAmount: 450.00,
      expenseDate: DateTime.now(),
    ),
    IncomeExpenseModel(
      id: '2',
      personName: 'Ahmed Mahmoud',
      phoneNumber: '01122334455',
      reason: 'Store Materials Cash In/Out',
      incomeAmount: 2000.00,
      incomeDate: DateTime.now(),
      expenseAmount: 1250.00,
      expenseDate: DateTime.now(),
    ),
  ];

  double get _totalIncome {
    return _records.fold(
      0.0,
          (sum, item) => sum + item.incomeAmount,
    );
  }

  double get _totalExpenses {
    return _records.fold(
      0.0,
          (sum, item) => sum + item.expenseAmount,
    );
  }

  double get _netBalance {
    return _totalIncome - _totalExpenses;
  }

  void _addRecord(IncomeExpenseModel record) {
    setState(() {
      _records.insert(0, record);
    });
  }

  void _deleteRecord(String id) {
    setState(() {
      _records.removeWhere((item) => item.id == id);
    });
  }

  void _openAddBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      showDragHandle: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28.r),
        ),
      ),
      builder: (_) {
        return AddTransactionBottomSheet(
          onAdd: _addRecord,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryColor = isDark
        ? ColorManager.darkAccentGreen
        : ColorManager.primaryColor;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddBottomSheet(context),
        backgroundColor: primaryColor,
        elevation: 2,
        icon: Icon(
          Icons.add_rounded,
          color: ColorManager.white,
          size: 21.r,
        ),
        label: Text(
          l10n.addTransaction,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: ColorManager.white,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: TrackerFinancialSummaryCard(
              totalIncome: _totalIncome,
              totalExpenses: _totalExpenses,
              netBalance: _netBalance,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 20.h),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: REdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.transactionHistory,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    l10n.trackerRecords(_records.length.toString()),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 10.h),
          ),
          if (_records.isEmpty)
            SliverToBoxAdapter(
              child: Container(
                padding: REdgeInsets.all(32),
                alignment: Alignment.center,
                child: Text(
                  l10n.noTransactions,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final record = _records[index];

                  return TrackerTransactionCard(
                    record: record,
                    onDelete: () => _deleteRecord(record.id),
                  );
                },
                childCount: _records.length,
              ),
            ),
          SliverToBoxAdapter(
            child: SizedBox(height: 90.h),
          ),
        ],
      ),
    );
  }
}