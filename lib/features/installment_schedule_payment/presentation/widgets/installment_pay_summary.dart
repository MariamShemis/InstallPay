import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class InstallmentPaySummary extends StatelessWidget {
  final CustomerModel customer;
  final Color primaryColor;
  final bool isDark;
  final String currency;

  const InstallmentPaySummary({
    super.key,
    required this.customer,
    required this.primaryColor,
    required this.isDark,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    int remainingCount = 0;
    for (final item in customer.schedule) {
      if (!item.isPaid) {
        remainingCount++;
      }
    }
    return Row(
      children: [
        Expanded(
          child: _buildSummaryTile(
            title: l10n.agreedTotalDebt,
            value: customer.sellingPrice.toStringAsFixed(0),
            unit: currency,
            subtitle: l10n.contractValue,
            icon: Icons.south_rounded,
            iconBgColor: isDark
                ? const Color(0xFF3D1919)
                : const Color(0xFFFFDAD6),
            accentColor:
            isDark ? const Color(0xFFF87171) : ColorManager.red,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _buildSummaryTile(
            title: l10n.collected,
            value: customer.totalPaid.toStringAsFixed(0),
            unit: currency,
            subtitle: l10n.paidPercent(
              (customer.paymentProgress * 100)
                  .toStringAsFixed(0),
            ),
            icon: Icons.check_circle_outline_rounded,
            iconBgColor: isDark
                ? const Color(0xFF0F2E2B)
                : const Color(0xFFD1FAE5),
            accentColor: isDark
                ? ColorManager.darkAccentGreen1
                : ColorManager.green,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _buildSummaryTile(
            title: l10n.remaining,
            value: customer.remainingValue.toStringAsFixed(0),
            unit: currency,
            subtitle: l10n.installmentsLeft(remainingCount),
            icon: Icons.account_balance_wallet_outlined,
            iconBgColor: isDark
                ? const Color(0xFF1E293B)
                : const Color(0xFFE0F2FE),
            accentColor: primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryTile({
    required String title,
    required String value,
    required String unit,
    required String subtitle,
    required IconData icon,
    required Color iconBgColor,
    required Color accentColor,
  }) {
    return Container(
      padding: REdgeInsets.all(10),
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
          Container(
            width: 26.r,
            height: 26.r,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 14.r,
              color: accentColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.sp,
              color: _secondaryColor,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: _secondaryColor,
            ),
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