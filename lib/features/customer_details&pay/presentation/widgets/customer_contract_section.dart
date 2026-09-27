import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/utils/extensions/extensions.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class CustomerContractSection extends StatelessWidget {
  final CustomerModel customer;
  final Color primaryColor;
  final bool isDark;

  const CustomerContractSection({
    super.key,
    required this.customer,
    required this.primaryColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final currency = context.currencySymbol;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          appLocalizations.contractDetails,
          Icons.description_outlined,
        ),
        SizedBox(height: 8.h),
        _row(
          _detail(
            appLocalizations.contract,
            customer.contractName,
            Icons.insert_drive_file_outlined,
          ),
          _detail(
            appLocalizations.contractDate,
            customer.contractDate,
            Icons.calendar_today_outlined,
          ),
        ),
        SizedBox(height: 10.h),
        _row(
          _detail(
            appLocalizations.purchasePrice,
            customer.purchasePrice.toStringAsFixed(0),
            Icons.shopping_cart_outlined,
            unit: currency,
          ),
          _detail(
            appLocalizations.sellingPrice,
            customer.sellingPrice.toStringAsFixed(0),
            Icons.sell_outlined,
            unit: currency,
          ),
        ),
        SizedBox(height: 10.h),
        _row(
          _detail(
            appLocalizations.downPayment,
            customer.downPayment.toStringAsFixed(0),
            Icons.account_balance_wallet_outlined,
            unit: currency,
            valueColor: primaryColor,
            iconColor: primaryColor,
            iconBackground: isDark
                ? const Color(0xFF0F2E2B)
                : const Color(0xFFE0F7F3),
          ),
          _detail(
            appLocalizations.debtAmount,
            customer.debtAmount.toStringAsFixed(0),
            Icons.money_off_outlined,
            unit: currency,
          ),
        ),
        SizedBox(height: 10.h),
        _row(
          _detail(
            appLocalizations.installmentAmount,
            customer.installmentAmount.toStringAsFixed(0),
            Icons.payments_outlined,
            unit: currency,
          ),
          _detail(
            appLocalizations.frequency,
            '${_installmentType(context)} (${customer.installmentsCount})',
            Icons.repeat_rounded,
          ),
        ),
        SizedBox(height: 10.h),
        _row(
          _detail(
            appLocalizations.firstPayment,
            customer.firstInstallmentDate,
            Icons.event_outlined,
          ),
          _detail(
            appLocalizations.nextDueDate,
            customer.nextDueDate,
            Icons.notifications_active_outlined,
            valueColor: isDark
                ? ColorManager.darkAccentGreen1
                : ColorManager.green,
            iconColor: isDark
                ? ColorManager.darkAccentGreen1
                : ColorManager.green,
            iconBackground: isDark
                ? const Color(0xFF0F2E2B)
                : const Color(0xFFD1FAE5),
          ),
        ),
        SizedBox(height: 10.h),
        _moneySummary(context),
        if (customer.description.isNotEmpty) ...[
          SizedBox(height: 10.h),
          _description(),
        ],
      ],
    );
  }

  Widget _moneySummary(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final currency = context.currencySymbol;

    return Row(
      children: [
        Expanded(
          child: _moneyItem(
            appLocalizations.total,
            customer.sellingPrice,
            currency,
            Icons.payments_outlined,
            isDark ? Colors.white : const Color(0xFF1E293B),
            primaryColor,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _moneyItem(
            appLocalizations.paid,
            customer.totalPaid,
            currency,
            Icons.check_circle_outline_rounded,
            isDark ? ColorManager.darkAccentGreen1 : ColorManager.green,
            isDark ? ColorManager.darkAccentGreen1 : ColorManager.green,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _moneyItem(
            appLocalizations.remaining,
            customer.remainingValue,
            currency,
            Icons.account_balance_outlined,
            customer.remainingValue > 0
                ? (isDark ? const Color(0xFFF87171) : ColorManager.red)
                : primaryColor,
            customer.remainingValue > 0
                ? (isDark ? const Color(0xFFF87171) : ColorManager.red)
                : primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _moneyItem(
    String title,
    double value,
    String currency,
    IconData icon,
    Color valueColor,
    Color accentColor,
  ) {
    return Container(
      padding: REdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15.r, color: accentColor),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: _secondaryColor(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            '${value.toStringAsFixed(0)} $currency',
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

  Widget _detail(
    String title,
    String value,
    IconData icon, {
    String? unit,
    Color? valueColor,
    Color? iconColor,
    Color? iconBackground,
  }) {
    return Expanded(
      child: Container(
        padding: REdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                  ),
                ),
                Container(
                  width: 28.r,
                  height: 28.r,
                  decoration: BoxDecoration(
                    color:
                        iconBackground ??
                        (isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFE2E8F0)),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 14.r,
                    color:
                        iconColor ??
                        (isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF475569)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Flexible(
                  child: Text(
                    value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: title == 'Contract' ? 13.sp : 15.sp,
                      fontWeight: FontWeight.bold,
                      color:
                          valueColor ??
                          (isDark ? Colors.white : const Color(0xFF0F172A)),
                    ),
                  ),
                ),
                if (unit != null) ...[
                  SizedBox(width: 4.w),
                  Text(
                    unit,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color:
                          valueColor ??
                          (isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B)),
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

  Widget _row(Widget first, Widget second) {
    return Row(
      children: [
        first,
        SizedBox(width: 10.w),
        second,
      ],
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          width: 32.r,
          height: 32.r,
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, size: 16.r, color: primaryColor),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _description() {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Icon(Icons.notes_outlined, size: 16.r, color: _secondaryColor()),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              customer.description,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _installmentType(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    switch (customer.installmentType.toLowerCase()) {
      case 'monthly':
        return appLocalizations.monthly;
      case 'weekly':
        return appLocalizations.weekly;
      case 'yearly':
        return appLocalizations.yearly;
      default:
        return customer.installmentType;
    }
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
