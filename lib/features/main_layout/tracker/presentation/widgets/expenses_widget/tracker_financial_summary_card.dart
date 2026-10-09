import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class TrackerFinancialSummaryCard extends StatelessWidget {
  final double totalIncome;
  final double totalExpenses;
  final double netBalance;

  const TrackerFinancialSummaryCard({
    super.key,
    required this.totalIncome,
    required this.totalExpenses,
    required this.netBalance,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryColor = isDark
        ? ColorManager.darkAccentGreen
        : ColorManager.green;

    final expenseColor = isDark
        ? ColorManager.redErrorDark
        : ColorManager.red;

    final incomeBackground = isDark
        ? ColorManager.darkGreenContainer
        : ColorManager.greenOpacity10;

    final expenseBackground = isDark
        ? ColorManager.darkRedContainer
        : ColorManager.redLight;

    final netColor = netBalance >= 0 ? primaryColor : expenseColor;

    final netBackground = netBalance >= 0
        ? incomeBackground
        : expenseBackground;

    final cardColor = isDark
        ? ColorManager.darkSurface
        : ColorManager.white;

    final borderColor = isDark
        ? ColorManager.darkSurfaceVariant
        : ColorManager.blueLightTint;

    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: borderColor,
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.18)
                : ColorManager.greenOpacity10,
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: isDark
                      ? ColorManager.darkGreenOpacity30
                      : ColorManager.greenOpacity10,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  color: primaryColor,
                  size: 21.r,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  l10n.incomeExpensesOverview,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? ColorManager.white
                        : ColorManager.navyText,
                  ),
                ),
              ),
              Icon(
                Icons.info_outline_rounded,
                size: 19.r,
                color: isDark
                    ? ColorManager.darkSlateText
                    : ColorManager.greyText,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  title: l10n.incomes,
                  value: '\$${totalIncome.toStringAsFixed(2)}',
                  color: primaryColor,
                  backgroundColor: incomeBackground,
                  icon: Icons.north_east_rounded,
                  isDark: isDark,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _SummaryItem(
                  title: l10n.expenses,
                  value: '\$${totalExpenses.toStringAsFixed(2)}',
                  color: expenseColor,
                  backgroundColor: expenseBackground,
                  icon: Icons.south_west_rounded,
                  isDark: isDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: REdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: netBackground,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: netColor.withOpacity(0.25),
                width: 1.w,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 38.w,
                  height: 38.w,
                  decoration: BoxDecoration(
                    color: netColor,
                    borderRadius: BorderRadius.circular(11.r),
                  ),
                  child: Icon(
                    Icons.account_balance_outlined,
                    color: ColorManager.white,
                    size: 19.r,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.netBalance,
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? ColorManager.darkMutedText
                              : ColorManager.greyDark,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '${netBalance >= 0 ? '+' : ''}\$${netBalance.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: netColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final Color backgroundColor;
  final IconData icon;
  final bool isDark;

  const _SummaryItem({
    required this.title,
    required this.value,
    required this.color,
    required this.backgroundColor,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: REdgeInsets.all(13),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: color.withOpacity(0.22),
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? ColorManager.darkMutedText
                        : ColorManager.greyDark,
                  ),
                ),
              ),
              Container(
                width: 25.w,
                height: 25.w,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 14.r,
                ),
              ),
            ],
          ),
          SizedBox(height: 7.h),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}