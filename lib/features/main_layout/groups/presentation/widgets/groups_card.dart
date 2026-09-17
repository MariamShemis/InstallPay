import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GroupCard extends StatelessWidget {
  final String groupTitle;
  final String collectorName;
  final String collectorPhone;
  final String clientsCount;
  final String dueCount;
  final String totalValue;
  final String collectedValue;
  final String remainingValue;
  final double progress;
  final VoidCallback? onOpenSheetTap;

  const GroupCard({
    super.key,
    required this.groupTitle,
    required this.collectorName,
    required this.collectorPhone,
    required this.clientsCount,
    required this.dueCount,
    required this.totalValue,
    required this.collectedValue,
    required this.remainingValue,
    required this.progress,
    this.onOpenSheetTap,
  });

  String get _initials {
    final names = collectorName.trim().split(' ');
    if (names.isEmpty || names.first.isEmpty) return 'U';
    if (names.length == 1) return names.first[0].toUpperCase();
    return '${names.first[0]}${names.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // الألوان المستخرجة بدقة من تصميم Figma المرفق
    final cardBg = isDark ? const Color(0xFF151F28) : Colors.white;
    final borderColor = isDark ? const Color(0xFF243444) : const Color(0xFFE2E8F0);
    final innerCardBg = isDark ? const Color(0xFF1D2933) : const Color(0xFFF0F3FF);
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF111C2D);
    final secondaryTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF43474D);
    final avatarBg = isDark ? const Color(0xFF17324D) : const Color(0xFFE2E8F0);
    final avatarTextColor = isDark ? const Color(0xFF34D399) : const Color(0xFF006C4D);
    final dueTextColor = const Color(0xFFEF4444);

    // ألوان خانة Collected (تخفيف للأخضر)
    final accentGreenBg = isDark ? const Color(0xFF15966D).withOpacity(0.15) : const Color(0xFF006C4D).withOpacity(0.10);
    final accentGreenText = isDark ? const Color(0xFF34D399) : const Color(0xFF006C4D);
    final progressColor = isDark ? const Color(0xFF15966D) : const Color(0xFF006C4D);

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
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Title
            Text(
              groupTitle,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 10.h),

            // Collector Info Bar
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
                    child: Text(
                      _initials,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: avatarTextColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          collectorName,
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
                          collectorPhone,
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
                        '$clientsCount Customers',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '$dueCount Due',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: dueTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // Stats Row
            Row(
              children: [
                _buildStatBox(
                  label: 'Total Value',
                  value: totalValue,
                  bg: innerCardBg,
                  textColor: primaryTextColor,
                ),
                SizedBox(width: 8.w),
                _buildStatBox(
                  label: 'Collected',
                  value: collectedValue,
                  bg: accentGreenBg,
                  textColor: accentGreenText,
                ),
                SizedBox(width: 8.w),
                _buildStatBox(
                  label: 'Remaining',
                  value: remainingValue,
                  bg: innerCardBg,
                  textColor: primaryTextColor,
                ),
              ],
            ),
            SizedBox(height: 14.h),

            // Progress Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Collection Progress (نسبة الإنجاز)',
                  style: TextStyle(fontSize: 11.sp, color: secondaryTextColor),
                ),
                Text(
                  '${(progress * 100).toStringAsFixed(1)}%',
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
                value: progress,
                minHeight: 8.h,
                backgroundColor: isDark
                    ? const Color(0xFF243444)
                    : const Color(0xFFE2E8F0),
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
            SizedBox(height: 14.h),
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
  }) {
    return Expanded(
      child: Container(
        padding: REdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
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
            SizedBox(height: 4.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}