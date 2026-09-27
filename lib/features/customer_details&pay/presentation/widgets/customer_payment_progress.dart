import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/utils/extensions/extensions.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class CustomerPaymentProgress extends StatelessWidget {
  final CustomerModel customer;
  final Color primaryColor;
  final bool isDark;

  const CustomerPaymentProgress({
    super.key,
    required this.customer,
    required this.primaryColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final progress = customer.paymentProgress.clamp(0.0, 1.0);
    final percentage = progress * 100;
    final currency = context.currencySymbol;

    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              _iconBox(),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appLocalizations.paymentProgress,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      appLocalizations.paidAmount(
                        customer.totalPaid.toStringAsFixed(0),
                        currency,
                      ),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: _secondaryColor(),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8.h,
              backgroundColor: isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  appLocalizations.paidAmount(
                    customer.totalPaid.toStringAsFixed(0),
                    currency,
                  ),
                  style: TextStyle(fontSize: 10.sp, color: _secondaryColor()),
                ),
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  appLocalizations.remainingAmount(
                    customer.remainingValue.toStringAsFixed(0),
                    currency,
                  ),
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 10.sp, color: _secondaryColor()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconBox() {
    return Container(
      width: 32.r,
      height: 32.r,
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(Icons.trending_up_rounded, size: 16.r, color: primaryColor),
    );
  }

  Color _secondaryColor() {
    return isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
  }

  Color _borderColor() {
    return isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      borderRadius: BorderRadius.circular(14.r),
      border: Border.all(color: _borderColor()),
      boxShadow: isDark
          ? []
          : [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
    );
  }
}
