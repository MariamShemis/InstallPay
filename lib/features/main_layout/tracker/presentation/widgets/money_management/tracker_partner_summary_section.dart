import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/features/main_layout/tracker/data/cubit/tracker_money_management_state.dart';
import 'package:smart_installment_management/features/main_layout/tracker/presentation/widgets/money_management/tracker_shared_widgets.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class TrackerPartnerSummarySection extends StatelessWidget {
  final TrackerMoneyManagementState state;

  const TrackerPartnerSummarySection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TrackerSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TrackerCardHeader(
            icon: Icons.pie_chart_outline_rounded,
            title: l10n.trackerPartnerSummary,
            subtitle: l10n.trackerCombinedPartnerCapital,
          ),
          SizedBox(height: 14.h),
          TrackerEquationBanner(text: l10n.trackerPartnerTotalEquation),
          SizedBox(height: 16.h),
          TrackerNumberField(
            label: l10n.trackerTotalPartners,
            value: state.partnersCount.toString(),
          ),
          SizedBox(height: 12.h),
          TrackerSummaryTile(
            icon: Icons.account_balance_wallet_outlined,
            title: l10n.trackerCombinedMainCapital,
            value: trackerFormatCurrency(state.mainCapital),
            accent: isDark
                ? ColorManager.darkAccentGreen
                : ColorManager.primaryColor,
          ),
          SizedBox(height: 10.h),
          TrackerSummaryTile(
            icon: Icons.trending_up_rounded,
            title: l10n.trackerCombinedNewCapital,
            value: trackerFormatCurrency(state.newCapital),
            accent: isDark ? ColorManager.darkAccentGreen : ColorManager.green,
          ),
          SizedBox(height: 10.h),
          TrackerSummaryTile(
            icon: Icons.calculate_outlined,
            title: l10n.trackerExpectedProfit,
            value: trackerFormatCurrency(state.expectedProfit),
            accent: state.expectedProfit >= 0
                ? (isDark ? ColorManager.darkAccentGreen : ColorManager.green)
                : (isDark ? ColorManager.redErrorDark : ColorManager.red),
          ),
          SizedBox(height: 12.h),
          Text(
            l10n.trackerPartnerCapitalNote,
            style: TextStyle(
              fontSize: 11.sp,
              height: 1.5,
              color: isDark
                  ? ColorManager.darkMutedText
                  : ColorManager.greySecondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
