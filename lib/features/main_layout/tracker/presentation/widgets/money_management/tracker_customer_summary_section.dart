
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/features/main_layout/tracker/data/cubit/tracker_money_management_state.dart';
import 'package:smart_installment_management/features/main_layout/tracker/presentation/widgets/money_management/tracker_shared_widgets.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class TrackerCustomerSummarySection extends StatelessWidget {
  final TrackerMoneyManagementState state;

  const TrackerCustomerSummarySection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasRemaining = state.totalRemaining > 0;
    final green = isDark
        ? ColorManager.darkAccentGreen
        : ColorManager.green;

    final remainingColor = hasRemaining
        ? (isDark
        ? ColorManager.warningYellow
        : ColorManager.warningOrange)
        : green;

    return TrackerSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TrackerCardHeader(
            icon: Icons.people_alt_outlined,
            title: l10n.trackerCustomersSection,
            subtitle: l10n.trackerCustomerSummarySubtitle,
          ),
          SizedBox(height: 14.h),
          TrackerEquationBanner(text: l10n.trackerRemainingEquation),
          SizedBox(height: 16.h),
          TrackerNumberField(
            label: l10n.trackerCustomersCount,
            value: state.customersCount.toString(),
          ),
          SizedBox(height: 12.h),
          TrackerMoneyField(
            label: l10n.trackerTotalSales,
            value: state.totalSales,
          ),
          SizedBox(height: 12.h),
          TrackerMoneyField(
            label: l10n.trackerTotalCollected,
            value: state.totalCollected,
          ),
          SizedBox(height: 12.h),
          TrackerMoneyField(
            label: l10n.trackerRemainingAmount,
            value: state.totalRemaining,
          ),
          SizedBox(height: 16.h),
          TrackerResultPanel(
            title: l10n.trackerCollectionStatus,
            children: [
              TrackerOutputResultBox(
                label: l10n.trackerCollectionRate,
                value: '${state.collectionRate.toStringAsFixed(2)}%',
                valueColor: green,
                leading: Icon(
                  Icons.donut_large_rounded,
                  size: 20.r,
                  color: green,
                ),
              ),
              SizedBox(height: 10.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: LinearProgressIndicator(
                  value: (state.collectionRate / 100).clamp(0.0, 1.0),
                  minHeight: 8.h,
                  backgroundColor: isDark
                      ? ColorManager.darkSurface
                      : ColorManager.greyLight,
                  color: green,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            padding: REdgeInsets.all(14),
            decoration: BoxDecoration(
              color: hasRemaining
                  ? (isDark
                  ? ColorManager.darkBrownContainer
                  : ColorManager.lightBeg.withOpacity(0.6))
                  : (isDark
                  ? ColorManager.darkGreenContainer
                  : ColorManager.greenAccent.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              children: [
                Icon(
                  hasRemaining
                      ? Icons.hourglass_top_rounded
                      : Icons.verified_user_outlined,
                  size: 23.r,
                  color: remainingColor,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.trackerOutstandingBalance,
                        style: GoogleFonts.inter(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? ColorManager.darkMutedText
                              : ColorManager.greySecondaryText,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        trackerFormatCurrency(state.totalRemaining),
                        style: GoogleFonts.inter(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                          color: remainingColor,
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
