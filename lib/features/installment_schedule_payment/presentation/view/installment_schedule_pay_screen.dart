import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/utils/extensions/extensions.dart';
import 'package:smart_installment_management/core/utils/ui_utils.dart';
import 'package:smart_installment_management/features/installment_schedule_payment/data/cubit/installment_payment_cubit.dart';
import 'package:smart_installment_management/features/installment_schedule_payment/presentation/widgets/installment_pay_bottom_bar.dart';
import 'package:smart_installment_management/features/installment_schedule_payment/presentation/widgets/installment_pay_header.dart';
import 'package:smart_installment_management/features/installment_schedule_payment/presentation/widgets/installment_pay_progress.dart';
import 'package:smart_installment_management/features/installment_schedule_payment/presentation/widgets/installment_pay_summary.dart';
import 'package:smart_installment_management/features/installment_schedule_payment/presentation/widgets/installment_schedule_list.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

import '../../data/cubit/installment_payment_state.dart';

class InstallmentSchedulePayScreen extends StatefulWidget {
  final CustomerModel customer;

  const InstallmentSchedulePayScreen({super.key, required this.customer});

  @override
  State<InstallmentSchedulePayScreen> createState() =>
      _InstallmentSchedulePayScreenState();
}

class _InstallmentSchedulePayScreenState
    extends State<InstallmentSchedulePayScreen> {
  int _selectedIndex = 0;
  late final InstallmentPaymentCubit _paymentCubit;

  @override
  void initState() {
    super.initState();

    _paymentCubit = InstallmentPaymentCubit(widget.customer);
    _autoSelectFirstUnpaid();
  }

  @override
  void dispose() {
    _paymentCubit.close();
    super.dispose();
  }

  bool _isSelectedItemPaid(CustomerModel customer) {
    final bool hasDownPayment = customer.downPayment > 0;

    // Down payment
    if (hasDownPayment && _selectedIndex == 0) {
      return customer.isDownPaymentPaid ||
          customer.downPaymentPaidAmount > 0;
    }

    // Regular installment
    final int scheduleIndex =
    hasDownPayment ? _selectedIndex - 1 : _selectedIndex;

    if (scheduleIndex < 0 ||
        scheduleIndex >= customer.schedule.length) {
      return true;
    }

    final installment = customer.schedule[scheduleIndex];

    return installment.isPaid ||
        installment.paidAmount > 0 ||
        installment.remainingAmount <= 0;
  }

  Future<void> _showEditPaymentDialog(int index, double currentAmount) async {
    final controller = TextEditingController(
      text: currentAmount.toStringAsFixed(2),
    );

    try {
      final newAmount = await showDialog<double>(
        context: context,
        useRootNavigator: true,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Edit paid amount'),
            content: TextField(
              controller: controller,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Paid amount',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext, rootNavigator: true).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final amount = double.tryParse(controller.text.trim());

                  if (amount == null || !amount.isFinite || amount <= 0) {
                    return;
                  }

                  Navigator.of(dialogContext, rootNavigator: true).pop(amount);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );

      if (!mounted || newAmount == null) return;

      await _paymentCubit.editPaymentAmount(
        selectedIndex: index,
        newAmount: newAmount,
      );
    } finally {
      controller.dispose();
    }
  }

  void _autoSelectFirstUnpaid() {
    final customer = _paymentCubit.customer;

    if (customer.downPayment > 0 && !customer.isDownPaymentPaid) {
      _selectedIndex = 0;
      return;
    }

    final hasDownPayment = customer.downPayment > 0;

    for (int i = 0; i < customer.schedule.length; i++) {
      final installment = customer.schedule[i];

      if (!installment.isPaid && !_isFutureDate(installment.dueDate)) {
        _selectedIndex = hasDownPayment ? i + 1 : i;
        return;
      }
    }

    for (int i = 0; i < customer.schedule.length; i++) {
      if (!customer.schedule[i].isPaid) {
        _selectedIndex = hasDownPayment ? i + 1 : i;
        return;
      }
    }

    _selectedIndex = 0;
  }

  bool _isFutureDate(String date) {
    final parsedDate = _parseDate(date);

    if (parsedDate == null) {
      return false;
    }

    final today = DateTime.now();

    final todayOnly = DateTime(today.year, today.month, today.day);

    return parsedDate.isAfter(todayOnly);
  }

  DateTime? _parseDate(String value) {
    final date = value.trim();

    if (date.isEmpty) {
      return null;
    }

    final parsed = DateTime.tryParse(date);

    if (parsed != null) {
      return DateTime(parsed.year, parsed.month, parsed.day);
    }

    final slashParts = date.split('/');

    if (slashParts.length == 3) {
      final day = int.tryParse(slashParts[0]);
      final month = int.tryParse(slashParts[1]);
      final year = int.tryParse(slashParts[2]);

      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryColor = isDark
        ? ColorManager.darkAccentGreen
        : ColorManager.primaryColor;

    final currency = context.currencySymbol;

    return BlocProvider.value(
      value: _paymentCubit,
      child: BlocConsumer<InstallmentPaymentCubit, InstallmentPaymentState>(
        listener: (context, state) {
          if (state is InstallmentPaymentLoading) {
            UiUtils.showLoading(context);
            return;
          }
          if (state is InstallmentPaymentSuccess) {
            UiUtils.hideLoading(context);

            if (!mounted) return;

            // Keep the same selected installment.
            // The payment bar will disappear if any amount was paid.
            setState(() {});

            UiUtils.showToast('Payment recorded successfully!');
            return;
          }
          if (state is InstallmentPaymentError) {
            UiUtils.hideLoading(context);
            if (!mounted) return;
            UiUtils.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final currentCustomer = state is InstallmentPaymentSuccess
              ? state.customer
              : _paymentCubit.customer;
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: isDark ? Colors.white : ColorManager.black,
                ),
              ),
              title: Text(
                l10n.payInstallment,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : ColorManager.black,
                ),
              ),
            ),

            bottomNavigationBar:
            // _isSelectedItemPaid(currentCustomer)
            //     ? null
                InstallmentPayBottomBar(
                    customer: currentCustomer,
                    selectedIndex: _selectedIndex,
                    primaryColor: primaryColor,
                    isDark: isDark,
                    currency: currency,
                    onPaymentConfirmed: (paymentDate, paidAmount) {
                      _paymentCubit.confirmPayment(
                        selectedIndex: _selectedIndex,
                        paymentDate: paymentDate,
                        paidAmount: paidAmount,
                      );
                    },
                  ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: REdgeInsets.fromLTRB(14, 8, 14, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InstallmentPayHeader(
                      customer: currentCustomer,
                      primaryColor: primaryColor,
                      isDark: isDark,
                    ),
                    SizedBox(height: 12.h),
                    InstallmentPaySummary(
                      customer: currentCustomer,
                      primaryColor: primaryColor,
                      isDark: isDark,
                      currency: currency,
                    ),
                    SizedBox(height: 12.h),
                    InstallmentPayProgress(
                      customer: currentCustomer,
                      primaryColor: primaryColor,
                      isDark: isDark,
                      currency: currency,
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.transactionHistory,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          l10n.installmentsCount(
                            currentCustomer.schedule.length,
                          ),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: isDark
                                ? ColorManager.darkSlateText
                                : ColorManager.greySecondaryText,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    InstallmentScheduleList(
                      onEditPayment: _showEditPaymentDialog,
                      customer: currentCustomer,
                      selectedIndex: _selectedIndex,
                      primaryColor: primaryColor,
                      isDark: isDark,
                      currency: currency,
                      onItemSelected: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
