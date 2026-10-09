import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/features/main_layout/tracker/presentation/widgets/expenses_widget/tracker_income_expenses_widget.dart';
import 'package:smart_installment_management/features/main_layout/tracker/presentation/widgets/tracker_money_management_widget.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class TrackerTab extends StatefulWidget {
  const TrackerTab({super.key});

  @override
  State<TrackerTab> createState() => _TrackerTabState();
}

class _TrackerTabState extends State<TrackerTab>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryColor = isDark
        ? ColorManager.darkAccentGreen
        : ColorManager.primaryColor;

    final containerBackground = isDark
        ? ColorManager.darkSurfaceVariant
        : ColorManager.blueSoftBackground;

    final unselectedColor = isDark
        ? ColorManager.darkMutedText
        : ColorManager.greyDark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: REdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(height: 8.h),
              Container(
                height: 58.h,
                width: double.infinity,
                padding: REdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: containerBackground,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: TabBar(
                  controller: _tabController,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: ColorManager.white,
                  unselectedLabelColor: unselectedColor,
                  labelStyle: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: [
                    Tab(
                      iconMargin: const EdgeInsets.only(bottom: 2),
                      icon: const Icon(
                        Icons.swap_vert_circle_outlined,
                        size: 20,
                      ),
                      text: l10n.incomeExpenses,
                    ),
                    Tab(
                      iconMargin: const EdgeInsets.only(bottom: 2),
                      icon: const Icon(
                        Icons.account_balance_outlined,
                        size: 20,
                      ),
                      text: l10n.moneyManagement,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    TrackerIncomeExpensesWidget(),
                    TrackerMoneyManagementWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
