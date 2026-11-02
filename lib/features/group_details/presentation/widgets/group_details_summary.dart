import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/features/main_layout/groups/data/model/group_model.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class GroupDetailsSummary extends StatelessWidget {
  final GroupModel group;
  final double totalValue;
  final double collectedValue;
  final double remainingValue;
  final int customerCount;
  final int completedCount;
  final int overdueCount;
  final String currency;

  const GroupDetailsSummary({
    super.key,
    required this.group,
    required this.totalValue,
    required this.collectedValue,
    required this.remainingValue,
    required this.customerCount,
    required this.completedCount,
    required this.overdueCount,
    required this.currency,
  });

  String _money(double value) {
    return value.toStringAsFixed(2).replaceFirst(RegExp(r'\.00$'), '');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    final monthTarget = group.monthTarget;
    final monthCollection = group.monthCollection;

    final monthPercentage = monthTarget > 0
        ? (monthCollection / monthTarget * 100)
        : 0.0;

    final borderColor = isDark
        ? ColorManager.darkSurfaceVariant
        : ColorManager.blueLightTint;

    final cardBg = isDark ? ColorManager.darkSurface : ColorManager.white;

    final greenColor = isDark
        ? ColorManager.darkAccentGreen1
        : ColorManager.green;
    final orangeColor = isDark
        ? ColorManager.warningYellow
        : ColorManager.warningOrange;

    final initialChar = group.collectorName.isNotEmpty
        ? group.collectorName.trim()[0].toUpperCase()
        : 'G';
    final groupStatus = group.status(context).trim().toLowerCase();
    String statusLabel;

    switch (groupStatus) {
      case 'paid':
        statusLabel = l10n.paid;
        break;
      case 'overdue':
        statusLabel = l10n.overdue;
        break;
      case 'due':
        statusLabel = l10n.due;
        break;
      default:
        statusLabel = l10n.unpaid;
    }

    final statusColor = groupStatus == 'paid'
        ? (isDark ? ColorManager.darkAccentGreen1 : ColorManager.green)
        : groupStatus == 'overdue'
        ? ColorManager.red
        : groupStatus == 'due'
        ? ColorManager.warningOrange
        : ColorManager.red;

    final statusBackground = statusColor.withOpacity(0.12);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: REdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      group.groupTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: REdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: statusBackground,
                      border: Border.all(color: statusColor.withOpacity(0.7)),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.h),
              Container(
                padding: REdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark
                      ? ColorManager.darkSurfaceVariant.withOpacity(0.5)
                      : ColorManager.blueSoftBackground.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundColor: theme.colorScheme.primary.withOpacity(
                        0.15,
                      ),
                      child: Text(
                        initialChar,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            group.collectorName.isEmpty
                                ? ""
                                : group.collectorName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            group.collectorPhone.isNotEmpty
                                ? group.collectorPhone
                                : "",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? ColorManager.darkSlateText
                                  : ColorManager.greyText,
                              fontSize: 11.sp,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          if (group.address.isNotEmpty) ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 14.r,
                                  color: isDark
                                      ? ColorManager.darkSlateText
                                      : ColorManager.greyText,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  group.address,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$customerCount ${l10n.customers}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '$overdueCount ${l10n.due}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: ColorManager.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 12.h),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 8.h,
          childAspectRatio: 2.1,
          children: [
            _StatCard(
              title: l10n.totalContractValue,
              value: _money(totalValue),
              currency: currency,
              icon: Icons.receipt_long_outlined,
              color: theme.colorScheme.primary,
              borderColor: borderColor,
            ),
            _StatCard(
              title: l10n.totalCollected,
              value: _money(collectedValue),
              currency: currency,
              icon: Icons.account_balance_wallet_outlined,
              color: greenColor,
              borderColor: borderColor,
            ),
            _StatCard(
              title: l10n.totalRemaining,
              value: _money(remainingValue),
              currency: currency,
              icon: Icons.pending_actions_rounded,
              color: orangeColor,
              borderColor: borderColor,
            ),
            _StatCard(
              title: l10n.customers,
              value: '$customerCount',
              currency: '',
              icon: Icons.people_outline_rounded,
              color: theme.colorScheme.primary,
              borderColor: borderColor,
            ),
          ],
        ),

        SizedBox(height: 8.h),

        // 3. Month Target & Collection
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: l10n.monthTarget,
                value: _money(monthTarget),
                currency: currency,
                icon: Icons.flag_outlined,
                color: theme.colorScheme.primary,
                borderColor: borderColor,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _StatCard(
                title: l10n.monthCollection,
                value: _money(monthCollection),
                currency: currency,
                icon: Icons.trending_up_rounded,
                color: greenColor,
                borderColor: borderColor,
                percentage: monthPercentage,
              ),
            ),
          ],
        ),

        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: _SmallStat(
                title: l10n.completedCustomers,
                count: completedCount,
                color: greenColor,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _SmallStat(
                title: l10n.overdueCustomers,
                count: overdueCount,
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String currency;
  final IconData icon;
  final Color color;
  final Color borderColor;
  final double? percentage;

  const _StatCard({
    required this.title,
    required this.value,
    required this.currency,
    required this.icon,
    required this.color,
    required this.borderColor,
    this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: REdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 15.r, color: color),
              SizedBox(width: 5.w),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    currency.isEmpty ? value : '$value $currency',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              if (percentage != null) ...[
                SizedBox(width: 4.w),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${percentage!.toStringAsFixed(1)}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallStat extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const _SmallStat({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: REdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8.r, color: color),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 10.sp,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            '$count',
            style: theme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}
