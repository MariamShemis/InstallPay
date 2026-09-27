import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/utils/extensions/extensions.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class ConfirmContractDialog extends StatelessWidget {
  final String groupName;
  final String customerName;
  final String phone;
  final String address;

  final String contractDate;
  final String contractName;
  final String purchasePrice;
  final String installmentAmount;
  final String installmentType;
  final int installmentsCount;
  final String firstInstallmentDate;
  final String advancePayment;
  final String totalCost;
  final String debtAmount;
  final String description;

  final VoidCallback onConfirm;

  const ConfirmContractDialog({
    super.key,
    required this.groupName,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.contractDate,
    required this.contractName,
    required this.purchasePrice,
    required this.installmentAmount,
    required this.installmentType,
    required this.installmentsCount,
    required this.firstInstallmentDate,
    required this.advancePayment,
    required this.totalCost,
    required this.debtAmount,
    required this.description,
    required this.onConfirm,
  });

  String _getFormattedInstallmentText() {
    String unit = 'Months';
    if (installmentType == 'Weekly') unit = 'Weeks';
    if (installmentType == 'Yearly') unit = 'Years';

    if (installmentsCount > 0) {
      return '$installmentAmount ($installmentType - $installmentsCount $unit)';
    }
    return '$installmentAmount ($installmentType)';
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final currencySymbol = context.currencySymbol;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = isDark ? ColorManager.darkAccentGreen : ColorManager.primaryColor;
    final cardBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderDivider = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Dialog(
      backgroundColor: isDark ? ColorManager.darkSurface : ColorManager.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Padding(
        padding: REdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52.r,
              height: 52.r,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline_rounded,
                color: primaryColor,
                size: 30.r,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              appLocalizations.confirmCustomer_Contract,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 17.sp,
              ),
            ),
            SizedBox(height: 6.h),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 13.sp,
                  color: textSecondary,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: '${appLocalizations.are_you_sure_you_want_to_add_this_customer} ',
                  ),
                  TextSpan(
                    text: customerName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? ColorManager.white : ColorManager.black,
                    ),
                  ),
                  const TextSpan(text: '?'),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Flexible(
              child: SingleChildScrollView(
                child: Container(
                  padding: REdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: borderDivider, width: 0.8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(
                        appLocalizations.personalDetails,
                        primaryColor,
                      ),
                      SizedBox(height: 6.h),
                      _buildSummaryItem(
                        context,
                        appLocalizations.group,
                        groupName,
                        textSecondary,
                        badge: true,
                      ),
                      _buildDivider(borderDivider),
                      _buildSummaryItem(
                        context,
                        appLocalizations.customerName,
                        customerName,
                        textSecondary,
                      ),
                      _buildDivider(borderDivider),
                      _buildSummaryItem(
                        context,
                        appLocalizations.phoneNumber,
                        phone,
                        textSecondary,
                      ),
                      _buildDivider(borderDivider),
                      _buildSummaryItem(
                        context,
                        appLocalizations.address,
                        address,
                        textSecondary,
                      ),
                      SizedBox(height: 14.h),
                      _buildSectionTitle(
                        appLocalizations.contractDetails,
                        primaryColor,
                      ),
                      SizedBox(height: 6.h),
                      _buildSummaryItem(
                        context,
                        appLocalizations.contractDate,
                        contractDate,
                        textSecondary,
                      ),
                      _buildDivider(borderDivider),
                      _buildSummaryItem(
                        context,
                        appLocalizations.contractName,
                        contractName,
                        textSecondary,
                      ),
                      _buildDivider(borderDivider),
                      _buildSummaryItem(
                        context,
                        appLocalizations.purchasePrice,
                        '$purchasePrice $currencySymbol',
                        textSecondary,
                      ),
                      _buildDivider(borderDivider),
                      _buildSummaryItem(
                        context,
                        appLocalizations.installment,
                        '${_getFormattedInstallmentText()} $currencySymbol',
                        textSecondary,
                      ),
                      _buildDivider(borderDivider),
                      _buildSummaryItem(
                        context,
                        appLocalizations.firstInstallmentDate,
                        firstInstallmentDate,
                        textSecondary,
                      ),
                      _buildDivider(borderDivider),
                      _buildSummaryItem(
                        context,
                        appLocalizations.downPayment,
                        '$advancePayment $currencySymbol',
                        textSecondary,
                      ),
                      _buildDivider(borderDivider),
                      _buildSummaryItem(
                        context,
                        appLocalizations.totalCost,
                        '$totalCost $currencySymbol',
                        textSecondary,
                      ),
                      _buildDivider(borderDivider),
                      _buildSummaryItem(
                        context,
                        appLocalizations.netDebt,
                        '$debtAmount $currencySymbol',
                        textSecondary,
                        isHighlight: true,
                      ),
                      if (description.isNotEmpty && description != 'N/A') ...[
                        _buildDivider(borderDivider),
                        _buildSummaryItem(
                          context,
                          appLocalizations.notes,
                          description,
                          textSecondary,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    appLocalizations.no,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                  child: Text(
                    appLocalizations.yes,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
        color: color,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildSummaryItem(
      BuildContext context,
      String label,
      String value,
      Color labelColor, {
        bool isHighlight = false,
        bool badge = false,
      }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = isDark ? ColorManager.darkAccentGreen : ColorManager.primaryColor;

    return Padding(
      padding: REdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.5.sp,
              color: labelColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 8.w),
          badge
              ? Container(
            padding: REdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          )
              : Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 12.5.sp,
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
                color: isHighlight
                    ? primaryColor
                    : (isDark ? ColorManager.white : ColorManager.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(Color color) {
    return Divider(height: 1, thickness: 0.6, color: color);
  }
}