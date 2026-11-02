import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/features/main_layout/tracker/data/cubit/tracker_money_management_state.dart';
import 'package:smart_installment_management/features/main_layout/tracker/presentation/widgets/money_management/tracker_shared_widgets.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class TrackerCapitalSection extends StatelessWidget {
  final TrackerMoneyManagementState state;

  const TrackerCapitalSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final green = isDark ? ColorManager.darkAccentGreen : ColorManager.green;

    return TrackerSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TrackerCardHeader(
            icon: Icons.account_balance_outlined,
            title: l10n.trackerCapitalSection,
            subtitle: l10n.trackerCapitalSubtitle,
          ),
          SizedBox(height: 14.h),
          TrackerEquationBanner(text: l10n.trackerProfitEquation),
          SizedBox(height: 16.h),
          TrackerMoneyField(
            label: l10n.trackerMainCapital,
            value: state.mainCapital,
          ),
          SizedBox(height: 12.h),
          TrackerMoneyField(
            label: l10n.trackerNewCapital,
            value: state.newCapital,
          ),
          SizedBox(height: 16.h),
          TrackerResultPanel(
            title: l10n.trackerCalculationOutput,
            children: [
              TrackerOutputResultBox(
                label: l10n.trackerMainCapital,
                value: trackerFormatCurrency(state.mainCapital),
                valueColor: isDark
                    ? ColorManager.darkAccentGreen
                    : ColorManager.primaryColor,
              ),
              SizedBox(height: 10.h),
              TrackerOutputResultBox(
                label: l10n.trackerExpectedProfit,
                value: trackerFormatCurrency(state.expectedProfit),
                valueColor: state.expectedProfit >= 0
                    ? green
                    : (isDark ? ColorManager.redErrorDark : ColorManager.red),
                leading: Icon(
                  state.expectedProfit >= 0
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  size: 20.r,
                  color: state.expectedProfit >= 0
                      ? green
                      : (isDark ? ColorManager.redErrorDark : ColorManager.red),
                ),
              ),
              SizedBox(height: 10.h),
              TrackerOutputResultBox(
                label: l10n.trackerCapitalGrowthRate,
                value: '${state.growthRate.toStringAsFixed(2)}%',
                valueColor: green,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          TrackerNumberField(
            label: l10n.trackerPartnersCount,
            value: state.partnersCount.toString(),
          ),
        ],
      ),
    );
  }
}
