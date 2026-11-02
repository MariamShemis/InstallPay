import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/features/main_layout/groups/data/model/group_model.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class GroupCard extends StatelessWidget {
  final GroupModel group;
  final String currency;
  final VoidCallback? onOpenSheetTap;

  const GroupCard({
    super.key,
    required this.group,
    required this.currency,
    this.onOpenSheetTap,
  });

  String get _initials {
    final names = group.collectorName.trim().split(' ');

    if (names.isEmpty || names.first.isEmpty) {
      return 'U';
    }

    if (names.length == 1) {
      return names.first[0].toUpperCase();
    }

    return '${names.first[0]}${names.last[0]}'.toUpperCase();
  }

  String _money(double value) {
    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDark ? const Color(0xFF151F28) : Colors.white;

    final borderColor = isDark
        ? const Color(0xFF243444)
        : const Color(0xFFE2E8F0);

    final innerCardBg = isDark
        ? const Color(0xFF1D2933)
        : const Color(0xFFF0F3FF);

    final primaryTextColor = isDark ? Colors.white : const Color(0xFF111C2D);

    final secondaryTextColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF43474D);

    final avatarBg = isDark ? const Color(0xFF17324D) : const Color(0xFFE2E8F0);

    final avatarTextColor = isDark
        ? const Color(0xFF34D399)
        : const Color(0xFF006C4D);

    final accentGreenBg = isDark
        ? const Color(0xFF15966D).withOpacity(0.15)
        : const Color(0xFF006C4D).withOpacity(0.10);

    final accentGreenText = isDark
        ? const Color(0xFF34D399)
        : const Color(0xFF006C4D);

    final progressColor = isDark
        ? const Color(0xFF15966D)
        : const Color(0xFF006C4D);

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

    final monthPercentage = group.monthTarget <= 0
        ? 0.0
        : (group.monthCollection / group.monthTarget * 100);

    return InkWell(
      onTap: onOpenSheetTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: REdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: borderColor, width: 1.w),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.35)
                  : const Color(0xFF111C2D).withOpacity(0.06),
              blurRadius: 16.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    group.groupTitle,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
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
              padding: REdgeInsets.all(12),
              decoration: BoxDecoration(
                color: innerCardBg,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: avatarBg,
                    backgroundImage:
                        group.imageUrl != null &&
                            group.imageUrl!.trim().isNotEmpty
                        ? NetworkImage(group.imageUrl!)
                        : null,
                    child:
                        group.imageUrl == null || group.imageUrl!.trim().isEmpty
                        ? Text(
                            _initials,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: avatarTextColor,
                            ),
                          )
                        : null,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.collectorName,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          group.collectorPhone,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${group.clientsCount} ${l10n.customers}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '${group.dueCount} ${l10n.due}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFEF4444),
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
                _buildStatBox(
                  label: l10n.totalValue,
                  value: '${_money(group.totalValue)} $currency',
                  bg: innerCardBg,
                  textColor: primaryTextColor,
                ),
                SizedBox(width: 8.w),
                _buildStatBox(
                  label: l10n.collected,
                  value: '${_money(group.collectedValue)} $currency',
                  bg: accentGreenBg,
                  textColor: accentGreenText,
                ),
                SizedBox(width: 8.w),
                _buildStatBox(
                  label: l10n.remaining,
                  value: '${_money(group.remainingValue)} $currency',
                  bg: innerCardBg,
                  textColor: primaryTextColor,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildStatBox(
                    label: l10n.monthTarget,
                    value: '${_money(group.monthTarget)} $currency',
                    bg: innerCardBg,
                    textColor: primaryTextColor,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Container(
                      padding: REdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: accentGreenBg,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.monthCollection,
                            style: TextStyle(
                              fontSize: 9.sp,
                              color: accentGreenText.withOpacity(0.85),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 7.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '${_money(group.monthCollection)} $currency  -',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: accentGreenText,
                                  ),
                                ),
                              ),
                              SizedBox(width: 7.h),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '${monthPercentage.toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w700,
                                    color: accentGreenText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.collectionProgress,
                  style: TextStyle(fontSize: 11.sp, color: secondaryTextColor),
                ),
                Text(
                  '${(group.progress * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: group.progress.clamp(0.0, 1.0),
                minHeight: 8.h,
                backgroundColor: isDark
                    ? const Color(0xFF243444)
                    : const Color(0xFFE2E8F0),
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox({
    required String label,
    required String value,
    required Color bg,
    required Color textColor,
    bool isMonthTarget = false,
  }) {
    return Expanded(
      child: Container(
        padding: REdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 9.sp,
                color: textColor.withOpacity(0.75),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: isMonthTarget ? 7.h : 4.h),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
