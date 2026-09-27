import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class CustomerCard extends StatelessWidget {
  final CustomerModel customer;
  final String currency;
  final VoidCallback? onViewDetails;
  final VoidCallback? onPayInstallment;

  const CustomerCard({
    super.key,
    required this.customer,
    required this.currency,
    this.onViewDetails,
    this.onPayInstallment,
  });

  String get _initials {
    final names = customer.customerName.trim().split(' ');

    if (names.isEmpty || names.first.isEmpty) {
      return 'C';
    }

    if (names.length == 1) {
      return names.first[0].toUpperCase();
    }

    return '${names.first[0]}${names.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? ColorManager.darkSurface : ColorManager.white;
    final borderColor = isDark
        ? ColorManager.darkSurfaceVariant
        : ColorManager.blueLightTint;
    final innerCardBg = isDark
        ? ColorManager.darkSurfaceVariant
        : ColorManager.blueSoftBackground;
    final primaryTextColor =
    isDark ? ColorManager.white : ColorManager.navyText;
    final secondaryTextColor =
    isDark ? ColorManager.darkMutedText : ColorManager.greyDark;
    final avatarBg =
    isDark ? ColorManager.navyDark : ColorManager.greyLight;
    final avatarTextColor =
    isDark ? ColorManager.darkAccentGreen1 : ColorManager.green;
    final accentGreenBg = isDark
        ? ColorManager.darkGreenOpacity30
        : ColorManager.greenOpacity10;
    final accentGreenText =
    isDark ? ColorManager.darkAccentGreen1 : ColorManager.green;
    final progressColor =
    isDark ? ColorManager.darkAccentGreen : ColorManager.green;
    final primaryBtnColor =
    isDark ? ColorManager.darkAccentGreen : ColorManager.primaryColor;

    final secondaryBtnBg = isDark
        ? ColorManager.darkCardBg
        : ColorManager.greyLight;

    final progress = customer.paymentProgress;

    return Container(
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: borderColor, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? ColorManager.black.withOpacity(0.35)
                : ColorManager.navyText.withOpacity(0.06),
            blurRadius: 16.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                      customer.customerName,
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
                      customer.customerPhone,
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
                  customer.groupName,
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
                  customer.nextDueDate,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? ColorManager.redErrorDark : ColorManager.red,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildStatBox(
                label: appLocalizations.totalValue,
                value:
                '${customer.sellingPrice.toStringAsFixed(0)} $currency',
                bg: innerCardBg,
                textColor: primaryTextColor,
              ),
              SizedBox(width: 8.w),
              _buildStatBox(
                label: 'Paid',
                value: '${customer.totalPaid.toStringAsFixed(0)} $currency',
                bg: accentGreenBg,
                textColor: accentGreenText,
              ),
              SizedBox(width: 8.w),
              _buildStatBox(
                label: appLocalizations.remaining,
                value:
                '${customer.remainingValue.toStringAsFixed(0)} $currency',
                bg: innerCardBg,
                textColor: primaryTextColor,
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                appLocalizations.paymentProgress,
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
              value: progress.clamp(0.0, 1.0),
              minHeight: 8.h,
              backgroundColor: isDark
                  ? ColorManager.darkSurfaceVariant
                  : ColorManager.blueLightTint,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 42.h,
                  child: OutlinedButton.icon(
                    onPressed: onViewDetails,
                    icon: Icon(
                      Icons.receipt_long_outlined,
                      size: 16.r,
                      color: primaryTextColor,
                    ),
                    label: Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: secondaryBtnBg,
                      side: BorderSide(color: borderColor, width: 1.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              // Button 2: Pay Installment
              Expanded(
                child: SizedBox(
                  height: 42.h,
                  child: ElevatedButton.icon(
                    onPressed: onPayInstallment,
                    icon: Icon(
                      Icons.payments_outlined,
                      size: 16.r,
                      color: ColorManager.white,
                    ),
                    label: Text(
                      appLocalizations.payInstallment,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorManager.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBtnColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
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
                fontSize: 10.sp,
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