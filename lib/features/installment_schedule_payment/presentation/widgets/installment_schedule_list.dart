import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/utils/helper/payment_status_helper.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class InstallmentScheduleList extends StatelessWidget {
  final CustomerModel customer;
  final int selectedIndex;
  final Color primaryColor;
  final bool isDark;
  final String currency;
  final ValueChanged<int> onItemSelected;
  final Future<void> Function(int index, double currentAmount) onEditPayment;

  const InstallmentScheduleList({
    super.key,
    required this.customer,
    required this.selectedIndex,
    required this.primaryColor,
    required this.isDark,
    required this.currency,
    required this.onItemSelected,
    required this.onEditPayment,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final List<Widget> items = [];

    int itemIndex = 0;

    if (customer.downPayment > 0) {
      final currentIndex = itemIndex;

      items.add(
        _buildDownPaymentTile(
          l10n: l10n,
          date: customer.contractDate.isNotEmpty
              ? customer.contractDate
              : l10n.notAvailable,
          paidAtDate: customer.downPaymentPaidAtDate,
          //amount: customer.downPayment.toStringAsFixed(0),
          amount:
              (customer.downPaymentPaidAmount > 0
                      ? customer.downPaymentPaidAmount
                      : customer.downPayment)
                  .toStringAsFixed(0),
          onEdit: customer.isDownPaymentPaid
              ? () => onEditPayment(
                  currentIndex,
                  customer.downPaymentPaidAmount > 0
                      ? customer.downPaymentPaidAmount
                      : customer.downPayment,
                )
              : null,
          isPaid: customer.isDownPaymentPaid,
          isSelected: selectedIndex == currentIndex,
          onTap: () => onItemSelected(currentIndex),
          originalAmount: customer.downPayment,
        ),
      );

      itemIndex++;
    }

    for (int i = 0; i < customer.schedule.length; i++) {
      final installment = customer.schedule[i];
      final currentIndex = itemIndex;

      final bool isPaid =
          installment.isPaid ||
          installment.paidAmount > 0 ||
          installment.remainingAmount <= 0;

      // final String displayedAmount =
      // installment.amount.toStringAsFixed(0);
      final String displayedAmount = installment.amount.toStringAsFixed(0);

      final String status = isPaid
          ? PaymentStatusHelper.paid
          : PaymentStatusHelper.installmentStatus(installment);

      final parsedDueDate = PaymentStatusHelper.parseDate(installment.dueDate);

      final today = DateTime.now();
      final todayOnly = DateTime(today.year, today.month, today.day);

      final bool isFuture =
          !isPaid &&
          status == PaymentStatusHelper.unpaid &&
          parsedDueDate != null &&
          parsedDueDate.isAfter(todayOnly);

      final bool isOverdue = !isPaid && status == PaymentStatusHelper.overdue;

      final bool isDueToday = !isPaid && status == PaymentStatusHelper.due;

      items.add(
        _buildInstallmentTile(
          originalAmount: installment.amount,
          l10n: l10n,
          installmentTitle: l10n.installmentNumber(
            installment.installmentNumber,
          ),
          onEdit: isPaid
              ? () => onEditPayment(currentIndex, installment.paidAmount)
              : null,
          dueDate: installment.dueDate,
          paidAmount: installment.paidAmount,
          paidAtDate: installment.paidAtDate.isNotEmpty
              ? installment.paidAtDate
              : null,
          amount: displayedAmount,
          isPaid: isPaid,
          isFuture: isFuture,
          isSelected: selectedIndex == currentIndex,
          onTap: () => onItemSelected(currentIndex),
          isOverdue: isOverdue,
          isDueToday: isDueToday,
        ),
      );

      itemIndex++;
    }

    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: item,
            ),
          )
          .toList(),
    );
  }

  Widget _buildDownPaymentTile({
    required AppLocalizations l10n,
    required String date,
    required String paidAtDate,
    required String amount,
    required bool isPaid,
    required bool isSelected,
    required VoidCallback onTap,
    required VoidCallback? onEdit,
    required double originalAmount,
  }) {
    final String paymentStatus = isPaid
        ? PaymentStatusHelper.paid
        : PaymentStatusHelper.statusForDate(date);
    final double actualPaidAmount = customer.downPaymentPaidAmount > 0
        ? customer.downPaymentPaidAmount
        : customer.downPayment;

    final bool hasDifferentPaidAmount =
        isPaid && (actualPaidAmount - originalAmount).abs() > 0.001;

    final String statusText;

    if (paymentStatus == PaymentStatusHelper.paid) {
      statusText = l10n.paid;
    } else if (paymentStatus == PaymentStatusHelper.overdue) {
      statusText = l10n.overdue;
    } else if (paymentStatus == PaymentStatusHelper.due) {
      statusText = l10n.dueNow;
    } else {
      statusText = l10n.unpaid;
    }

    final Color statusColor;

    if (paymentStatus == PaymentStatusHelper.paid) {
      statusColor = isDark ? ColorManager.darkAccentGreen1 : ColorManager.green;
    } else if (paymentStatus == PaymentStatusHelper.overdue) {
      statusColor = ColorManager.red;
    } else if (paymentStatus == PaymentStatusHelper.due) {
      statusColor = ColorManager.warningOrange;
    } else {
      statusColor = _futureColor;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: REdgeInsets.all(12),
        decoration: _cardDecoration(
          isSelected: isSelected,
          isPaid: isPaid,
          isFuture: false,
          hasDifferentPaidAmount: hasDifferentPaidAmount,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.dueDate(date),
                    style: TextStyle(fontSize: 9.5.sp, color: _secondaryColor),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    l10n.downPayment,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  if (isPaid && paidAtDate.isNotEmpty) ...[
                    SizedBox(height: 3.h),
                    Text(
                      l10n.paidOn(paidAtDate),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: REdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 8.5.sp,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      amount,
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      currency,
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
                if (onEdit != null) ...[
                  SizedBox(height: 2.h),
                  TextButton.icon(
                    onPressed: onEdit,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: isDark
                          ? ColorManager.darkAccentGreen
                          : ColorManager.primaryColor,
                    ),
                    icon: Icon(Icons.edit_rounded, size: 12.sp),
                    label: Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstallmentTile({
    required AppLocalizations l10n,
    required String installmentTitle,
    required String dueDate,
    required String? paidAtDate,
    required String amount,
    required bool isPaid,
    required bool isOverdue,
    required bool isDueToday,
    required bool isFuture,
    required double paidAmount,
    required bool isSelected,
    required VoidCallback onTap,
    required VoidCallback? onEdit,
    required double originalAmount,
  }) {
    final isFutureUnpaid = !isPaid && isFuture;

    final statusColor = isPaid
        ? (isDark ? ColorManager.darkAccentGreen1 : ColorManager.green)
        : isOverdue
        ? ColorManager.red
        : isDueToday
        ? ColorManager.warningOrange
        : _futureColor;

    final bool hasDifferentPaidAmount =
        paidAmount > 0 && (paidAmount - originalAmount).abs() > 0.001;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: REdgeInsets.all(12),
        decoration: _cardDecoration(
          isSelected: isSelected,
          isPaid: isPaid,
          isFuture: isFutureUnpaid,
          hasDifferentPaidAmount: hasDifferentPaidAmount,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 34.r,
              height: 34.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(9.r),
              ),
              child: Text(
                installmentTitle.replaceAll(RegExp(r'[^0-9]'), ''),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.dueDate(dueDate),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 9.5.sp, color: _secondaryColor),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    installmentTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  // if (paidAmount > 0) ...[
                  //   SizedBox(height: 3.h),
                  //   Text(
                  //     '${l10n.paid}: ${paidAmount.toStringAsFixed(0)} $currency',
                  //     maxLines: 1,
                  //     overflow: TextOverflow.ellipsis,
                  //     style: TextStyle(
                  //       fontSize: 9.sp,
                  //       fontWeight: FontWeight.w600,
                  //       color: isDark
                  //           ? ColorManager.darkAccentGreen1
                  //           : ColorManager.green,
                  //     ),
                  //   ),
                  // ],
                  if (isPaid &&
                      paidAtDate != null &&
                      paidAtDate.isNotEmpty) ...[
                    SizedBox(height: 3.h),
                    Text(
                      l10n.paidOn(paidAtDate),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: REdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    isPaid
                        ? l10n.paid
                        : isOverdue
                        ? l10n.overdue
                        : isDueToday
                        ? l10n.dueNow
                        : l10n.unpaid,
                    style: TextStyle(
                      fontSize: 8.5.sp,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      paidAmount != 0 ? "${paidAmount} " : amount,
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      currency,
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
                if (onEdit != null) ...[
                  SizedBox(height: 2.h),
                  TextButton.icon(
                    onPressed: onEdit,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: isDark
                          ? ColorManager.darkAccentGreen
                          : ColorManager.primaryColor,
                    ),
                    icon: Icon(Icons.edit_rounded, size: 12.sp),
                    label: Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
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

  bool _isOverdue(String date) {
    final parsedDate = _parseDate(date);
    if (parsedDate == null) {
      return false;
    }
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    return parsedDate.isBefore(todayOnly);
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
    final parts = date.split('/');
    if (parts.length == 3) {
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);

      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }
    return null;
  }

  BoxDecoration _cardDecoration({
    required bool isSelected,
    required bool isPaid,
    required bool isFuture,
    required bool hasDifferentPaidAmount,
  }) {
    Color cardBg;

    if (isFuture && !isPaid) {
      cardBg = isDark ? const Color(0xFF151C24) : const Color(0xFFE5E7EB);
    } else {
      cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    }

    Color borderColor = _borderColor;
    double borderWidth = 1.w;

    final bool needsRedBorder = !isPaid && !isFuture && !isSelected;

    if (hasDifferentPaidAmount) {
      borderColor = ColorManager.warningOrange;
      borderWidth = 2.5.w;
    } else if (needsRedBorder) {
      borderColor = ColorManager.red;
      borderWidth = 2.5.w;
    } else if (isSelected && !isPaid) {
      borderColor = primaryColor;
      borderWidth = 2.w;
    }

    return BoxDecoration(
      color: cardBg,
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: borderColor, width: borderWidth),
      boxShadow: isSelected && !isDark && !isFuture
          ? [
              BoxShadow(
                color: primaryColor.withOpacity(0.12),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ]
          : [],
    );
  }

  Color get _futureColor {
    return isDark ? const Color(0xFF64748B) : const Color(0xFF6B7280);
  }

  Color get _secondaryColor {
    return isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
  }

  Color get _borderColor {
    return isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
  }
}
