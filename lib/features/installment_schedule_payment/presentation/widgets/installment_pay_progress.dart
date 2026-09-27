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
    final progress =
    customer.paymentProgress.clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark
              ? const Color(0xFF334155)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 4.r,
                    backgroundColor: primaryColor,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    l10n.paymentProgress,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? Colors.white
                          : const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              Text(
                '${customer.totalPaid.toStringAsFixed(0)} / '
                    '${customer.sellingPrice.toStringAsFixed(0)} '
                    '$currency',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8.h,
              backgroundColor: isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFE2E8F0),
              valueColor:
              AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.settledInstallmentsAndDownPayment,
                style: TextStyle(
                  fontSize: 9.5.sp,
                  color: _secondaryColor,
                ),
              ),
              Text(
                l10n.dueNow,
                style: TextStyle(
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.warningOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color get _secondaryColor {
    return isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);
  }
}