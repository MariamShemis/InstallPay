import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/utils/currency/currency_cubit.dart';
import 'package:smart_installment_management/core/utils/currency/currency_state.dart';
import 'package:smart_installment_management/core/utils/extensions/extensions.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class FinancialSummarySection extends StatelessWidget {
  const FinancialSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    final currencySymbol = context.currencySymbol;

    return Column(
      children: [
        _buildCapitalHeroCard(
          context,
          title: appLocalizations.capital,
          subtitle: appLocalizations.totalNetCapital,
          value: "150,000",
          currency: currencySymbol,
          badgeText: appLocalizations.activeVault,
          growthText: "+14.8% ${appLocalizations.this_week}",
          progressValue: 0.814,
          stat1Label: "${appLocalizations.collection}: 81.4%",
          stat2Label:
          "${appLocalizations.liquidityRate}: ${appLocalizations.safe}",
          isDark: isDark,
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                context,
                title: appLocalizations.cash,
                value: "45,000 $currencySymbol",
                subtitle: "+8.4% ${appLocalizations.moM}",
                subtitleColor: isDark
                    ? ColorManager.darkAccentGreen1
                    : ColorManager.greenMedium,
                icon: Icons.account_balance_wallet_rounded,
                iconBgColor: isDark
                    ? ColorManager.darkAccentGreen.withOpacity(0.2)
                    : ColorManager.greenAccent.withOpacity(0.4),
                iconColor: isDark
                    ? ColorManager.darkAccentGreen1
                    : ColorManager.primaryColor,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildMetricCard(
                context,
                title: appLocalizations.outMoney,
                value: "105,000 $currencySymbol",
                subtitle: "26 ${appLocalizations.accounts_due}",
                subtitleColor: isDark
                    ? ColorManager.darkMutedText
                    : ColorManager.greySecondaryText,
                icon: Icons.hourglass_top_rounded,
                iconBgColor: isDark
                    ? ColorManager.darkBrownContainer
                    : ColorManager.warningYellow.withOpacity(0.25),
                iconColor: isDark
                    ? ColorManager.warningYellow
                    : ColorManager.lightBrown,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                context,
                title: appLocalizations.monthCollection,
                value: "18,000 $currencySymbol",
                subtitle: "+5.2% ${appLocalizations.vs_last_month}",
                subtitleColor: isDark
                    ? ColorManager.darkAccentGreen1
                    : ColorManager.greenMedium,
                icon: Icons.monetization_on_rounded,
                iconBgColor: isDark
                    ? ColorManager.darkAccentGreen.withOpacity(0.2)
                    : ColorManager.greenAccent.withOpacity(0.4),
                iconColor: isDark
                    ? ColorManager.darkAccentGreen1
                    : ColorManager.primaryColor,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildMetricCard(
                context,
                title: appLocalizations.monthTarget,
                value: "74.6%",
                subtitle: appLocalizations.onTrack,
                subtitleColor: isDark
                    ? ColorManager.darkAccentGreen1
                    : ColorManager.greenMedium,
                icon: Icons.analytics_rounded,
                iconBgColor: isDark
                    ? ColorManager.darkSurfaceVariant
                    : ColorManager.blueLightTint,
                iconColor: isDark
                    ? ColorManager.darkSlateText
                    : ColorManager.navyDark,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: REdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? ColorManager.darkSurface : ColorManager.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDark
                  ? ColorManager.darkSurfaceVariant
                  : ColorManager.blueLightTint,
              width: 1.w,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    appLocalizations.todayCollection,
                    style: textTheme.titleMedium?.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? ColorManager.white : null,
                    ),
                  ),
                  Container(
                    padding: REdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isDark
                          ? ColorManager.darkAccentGreen.withOpacity(0.2)
                          : ColorManager.greenOpacity15,
                      shape: BoxShape.circle,
                      border: isDark
                          ? Border.all(
                        color: ColorManager.darkAccentGreen1.withOpacity(
                          0.35,
                        ),
                        width: 1.2.w,
                      )
                          : null,
                    ),
                    child: Icon(
                      Icons.today_rounded,
                      color: isDark
                          ? ColorManager.darkAccentGreen1
                          : ColorManager.primaryColor,
                      size: 18.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: REdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark
                          ? ColorManager.darkAccentGreen.withOpacity(0.2)
                          : ColorManager.greenOpacity15,
                      borderRadius: BorderRadius.circular(20.r),
                      border: isDark
                          ? Border.all(
                        color: ColorManager.darkAccentGreen1.withOpacity(
                          0.35,
                        ),
                        width: 1.2.w,
                      )
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.people_outline_rounded,
                          size: 16.sp,
                          color: isDark
                              ? ColorManager.darkAccentGreen1
                              : ColorManager.primaryColor,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          "10 ${appLocalizations.customers}",
                          style: textTheme.bodyMedium?.copyWith(
                            fontSize: 13.sp,
                            color: isDark
                                ? ColorManager.white
                                : ColorManager.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "2,000 $currencySymbol",
                    style: textTheme.headlineMedium?.copyWith(
                      fontSize: 20.sp,
                      color: isDark
                          ? ColorManager.darkAccentGreen1
                          : ColorManager.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                context,
                title: appLocalizations.groups,
                value: "12 ${appLocalizations.active}",
                subtitle: "4 ${appLocalizations.hubs_assigned}",
                subtitleColor: isDark
                    ? ColorManager.darkMutedText
                    : ColorManager.greySecondaryText,
                icon: Icons.bubble_chart_outlined,
                iconBgColor: isDark
                    ? ColorManager.darkSurfaceVariant
                    : ColorManager.blueAccent.withOpacity(0.5),
                iconColor: isDark
                    ? ColorManager.darkSlateText
                    : ColorManager.navyDark,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildMetricCard(
                context,
                title: appLocalizations.customers,
                value: "142",
                subtitle: "98.1% ${appLocalizations.goodStanding}",
                subtitleColor: isDark
                    ? ColorManager.darkAccentGreen1
                    : ColorManager.greenMedium,
                icon: Icons.people_alt_rounded,
                iconBgColor: isDark
                    ? ColorManager.darkSurfaceVariant
                    : ColorManager.blueAccent.withOpacity(0.5),
                iconColor: isDark
                    ? ColorManager.darkSlateText
                    : ColorManager.navyDark,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                context,
                title: appLocalizations.delinquent,
                value: "5 ${appLocalizations.accounts}",
                subtitle: appLocalizations.overdue_action_required,
                subtitleColor: colorScheme.error,
                icon: Icons.warning_amber_rounded,
                iconBgColor: isDark
                    ? ColorManager.darkRedContainer
                    : ColorManager.redLight,
                iconColor: colorScheme.error,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildMetricCard(
                context,
                title: appLocalizations.payOut,
                value: "1,000 $currencySymbol",
                subtitle: appLocalizations.scheduled_this_week,
                subtitleColor: isDark
                    ? ColorManager.darkMutedText
                    : ColorManager.greySecondaryText,
                icon: Icons.payments_rounded,
                iconBgColor: isDark
                    ? const Color(0xFFB45309).withOpacity(0.15)
                    : const Color(0xFF9C573A).withOpacity(0.2),
                iconColor: isDark
                    ? const Color(0xFFF5BD58)
                    : const Color(0xFF7F4025),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCapitalHeroCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required String value,
        required String currency,
        required String badgeText,
        required String growthText,
        required double progressValue,
        required String stat1Label,
        required String stat2Label,
        required bool isDark,
      }) {
    final textTheme = Theme.of(context).textTheme;
    final gradientDecoration = const LinearGradient(
      colors: [Color(0xFF15805D), Color(0xFF0F4C3A), Color(0xFF0A2B23)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: gradientDecoration,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? const Color(0xFF15805D).withOpacity(0.25)
                : const Color(0xFF00382B).withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: REdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.account_balance_wallet_outlined,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              fontSize: 11.sp,
                              color: const Color(0xFFA3E6CD),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium?.copyWith(
                              fontSize: 13.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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
          SizedBox(height: 16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        value,
                        style: textTheme.headlineLarge?.copyWith(
                          fontSize: 28.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        ".00 $currency",
                        style: textTheme.bodyMedium?.copyWith(
                          fontSize: 13.sp,
                          color: const Color(0xFF6EE7B7),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 7.h,
              backgroundColor: const Color(0xFFFBBF24),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF34D399),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: const BoxDecoration(
                        color: Color(0xFF34D399),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        stat1Label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color(0xFFE6F4EA),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFBBF24),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Flexible(
                      child: Text(
                        stat2Label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color(0xFFE6F4EA),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      BuildContext context, {
        required String title,
        required String value,
        required String subtitle,
        required Color subtitleColor,
        required IconData icon,
        required Color iconBgColor,
        required Color iconColor,
      }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: REdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? ColorManager.darkSurface : ColorManager.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isDark
              ? ColorManager.darkSurfaceVariant
              : ColorManager.blueLightTint,
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 13.sp,
                    color: isDark
                        ? ColorManager.darkMutedText
                        : ColorManager.navyText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                  border: isDark
                      ? Border.all(
                    color: iconColor.withOpacity(0.35),
                    width: 1.2.w,
                  )
                      : null,
                ),
                child: Icon(icon, size: 17.sp, color: iconColor),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleMedium?.copyWith(
              fontSize: 18.sp,
              color: isDark ? ColorManager.white : ColorManager.navyDark,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              fontSize: 11.sp,
              color: subtitleColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}