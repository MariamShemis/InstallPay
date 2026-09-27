import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class InstallmentScheduleList extends StatelessWidget {
  final CustomerModel customer;
  final int selectedIndex;
  final Color primaryColor;
  final bool isDark;
  final String currency;
  final ValueChanged<int> onItemSelected;

  const InstallmentScheduleList({
    super.key,
    required this.customer,
    required this.selectedIndex,
    required this.primaryColor,
    required this.isDark,
    required this.currency,
    required this.onItemSelected,
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
          amount: customer.downPayment.toStringAsFixed(0),
          isPaid: customer.isDownPaymentPaid,
          isSelected: selectedIndex == currentIndex,
          onTap: () => onItemSelected(currentIndex),
        ),
      );

      itemIndex++;
    }

    for (int i = 0; i < customer.schedule.length; i++) {
      final installment = customer.schedule[i];
      final currentIndex = itemIndex;
      final isPaid = installment.isPaid;
      final isFuture = _isFutureDate(installment.dueDate);

      items.add(
        _buildInstallmentTile(
          l10n: l10n,
          installmentTitle: l10n.installmentNumber(
            installment.installmentNumber,
          ),
          dueDate: installment.dueDate,
          paidAtDate: isPaid && installment.paidAtDate.isNotEmpty
              ? installment.paidAtDate
              : installment.dueDate,
          amount: installment.amount.toStringAsFixed(0),
          isPaid: isPaid,
          isFuture: isFuture,
          isSelected: selectedIndex == currentIndex,
          onTap: () => onItemSelected(currentIndex),
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
  }) {
    final isOverdue = !isPaid && _isOverdue(date);

    final statusColor = isPaid
        ? (isDark ? ColorManager.darkAccentGreen1 : ColorManager.green)
        : isOverdue
        ? ColorManager.red
        : ColorManager.warningOrange;

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
                  padding: REdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    isPaid ? l10n.paid : l10n.unpaid,
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
    required bool isFuture,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isFutureUnpaid = !isPaid && isFuture;
    final isOverdue = !isPaid && _isOverdue(dueDate);

    final statusColor = isPaid
        ? (isDark ? ColorManager.darkAccentGreen1 : ColorManager.green)
        : isOverdue
        ? ColorManager.red
        : isFutureUnpaid
        ? _futureColor
        : ColorManager.warningOrange;

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
                installmentTitle.replaceAll(
                  RegExp(r'[^0-9]'),
                  '',
                ),
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
                    style: TextStyle(
                      fontSize: 9.5.sp,
                      color: _secondaryColor,
                    ),
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
                  padding: REdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    isPaid
                        ? l10n.paid
                        : isFutureUnpaid
                        ? l10n.unpaid
                        : l10n.dueNow,
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
  }) {
    Color cardBg;

    if (isFuture && !isPaid) {
      cardBg = isDark ? const Color(0xFF151C24) : const Color(0xFFE5E7EB);
    } else {
      cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    }
    Color borderColor = _borderColor;
    double borderWidth = 1.w;
    if (isSelected && !isPaid) {
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