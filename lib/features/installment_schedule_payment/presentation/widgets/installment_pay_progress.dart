import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class InstallmentPayProgress extends StatelessWidget {
  final CustomerModel customer;
  final Color primaryColor;
  final bool isDark;
  final String currency;

  const InstallmentPayProgress({
    super.key,
    required this.customer,
    required this.primaryColor,
    required this.isDark,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final progress = customer.paymentProgress.clamp(0.0, 1.0).toDouble();
    final totalPaid = customer.totalPaid;
    final remaining = customer.remainingValue;
    final isCompleted = remaining <= 0;

    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);

    final secondaryColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);
    final int paidInstallmentsCount = customer.schedule
        .where((item) => item.isPaid)
        .length;

    final int totalInstallmentsCount = customer.schedule.length;

    final int paidItemsCount =
        paidInstallmentsCount +
        (customer.downPayment > 0 && customer.isDownPaymentPaid ? 1 : 0);

    final int totalItemsCount =
        totalInstallmentsCount + (customer.downPayment > 0 ? 1 : 0);

    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 4.r, backgroundColor: primaryColor),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  l10n.paymentProgress,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9.h,
              backgroundColor: isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(
                isCompleted ? Colors.green : primaryColor,
              ),
            ),
          ),
          SizedBox(height: 14.h),

          Row(
            children: [
              Expanded(
                child: _amountInfo(
                  title: l10n.paid,
                  amount: totalPaid,
                  valueColor: isCompleted ? Colors.green : primaryColor,
                  secondaryColor: secondaryColor,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _amountInfo(
                  title: l10n.remaining,
                  amount: remaining,
                  valueColor: isCompleted
                      ? Colors.green
                      : ColorManager.warningOrange,
                  secondaryColor: secondaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          Divider(
            height: 1,
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
          SizedBox(height: 10.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.settledInstallmentsAndDownPayment,
                style: TextStyle(fontSize: 10.sp, color: secondaryColor),
              ),
              Text(
                '$paidItemsCount / $totalItemsCount',
                // '${customer.schedule.where((item) => item.isPaid).length}'
                // ' / ${customer.schedule.length}',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _amountInfo({
    required String title,
    required double amount,
    required Color valueColor,
    required Color secondaryColor,
  }) {
    return Container(
      padding: REdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 10.sp, color: secondaryColor),
          ),
          SizedBox(height: 5.h),
          Text(
            '${amount.toStringAsFixed(2)} $currency',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
