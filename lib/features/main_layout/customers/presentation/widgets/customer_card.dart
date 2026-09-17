import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomerCard extends StatelessWidget {
  final String customerName;
  final String customerPhone;
  final String groupName;
  final String status;
  final String totalValue;
  final String paidValue;
  final String remainingValue;
  final String nextDueDate;
  final double progress;
  final VoidCallback? onTap;

  const CustomerCard({
    super.key,
    required this.customerName,
    required this.customerPhone,
    required this.groupName,
    required this.status,
    required this.totalValue,
    required this.paidValue,
    required this.remainingValue,
    required this.nextDueDate,
    required this.progress,
    this.onTap,
  });

  String get _initials {
    final names = customerName.trim().split(' ');
    if (names.isEmpty || names.first.isEmpty) return 'C';
    if (names.length == 1) return names.first[0].toUpperCase();
    return '${names.first[0]}${names.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDark ? const Color(0xFF151F28) : Colors.white;
    final borderColor = isDark ? const Color(0xFF243444) : const Color(0xFFE2E8F0);
    final innerCardBg = isDark ? const Color(0xFF1D2933) : const Color(0xFFF0F3FF);
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF111C2D);
    final secondaryTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF43474D);
    final avatarBg = isDark ? const Color(0xFF17324D) : const Color(0xFFE2E8F0);
    final avatarTextColor = isDark ? const Color(0xFF34D399) : const Color(0xFF006C4D);

    final accentGreenBg = isDark ? const Color(0xFF15966D).withOpacity(0.15) : const Color(0xFF006C4D).withOpacity(0.10);
    final accentGreenText = isDark ? const Color(0xFF34D399) : const Color(0xFF006C4D);
    final progressColor = isDark ? const Color(0xFF15966D) : const Color(0xFF006C4D);

    return InkWell(
      onTap: onTap,
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
            // Customer Header Bar
            Row(
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
                        customerName,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        customerPhone,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: REdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: innerCardBg,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    groupName,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: primaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Due Date Bar
            Container(
              padding: REdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: innerCardBg,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Next Due Date:',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: secondaryTextColor,
                    ),
                  ),
                  Text(
                    nextDueDate,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFEF4444),
                    ),
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
                  label: 'Paid',
                  value: paidValue,
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

            // Progress Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Progress (نسبة السداد)',
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