import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/features/main_layout/partners/data/model/partner_model.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class PartnerCard extends StatelessWidget {
  final PartnerModel partner;
  final String currency;
  final VoidCallback? onTap;

  const PartnerCard({
    super.key,
    required this.partner,
    required this.currency,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDark ? ColorManager.darkSurface : ColorManager.white;
    final borderColor = isDark ? ColorManager.darkSurfaceVariant : ColorManager.blueLightTint;
    final innerBg = isDark ? ColorManager.darkSurfaceVariant : ColorManager.blueSoftBackground;
    final primaryTextColor = isDark ? ColorManager.white : ColorManager.navyText;
    final secondaryTextColor = isDark ? ColorManager.darkMutedText : ColorManager.greyDark;
    final accentGreenText = isDark ? ColorManager.darkAccentGreen1 : ColorManager.green;
    final accentGreenBg = isDark ? ColorManager.darkGreenOpacity30 : ColorManager.greenOpacity10;

    final typeBadgeBg = partner.isAdmin
        ? (isDark ? ColorManager.darkBlueSurface : ColorManager.blueAccent)
        : partner.isPrimary
        ? (isDark ? ColorManager.darkGreenOpacity30 : ColorManager.greenOpacity15)
        : (isDark ? ColorManager.darkYellowOpacity30 : ColorManager.lightBeg);

    final typeBadgeText = partner.isAdmin
        ? (isDark ? ColorManager.secondary : ColorManager.navyDark)
        : partner.isPrimary
        ? accentGreenText
        : (isDark ? ColorManager.warningYellow : ColorManager.lightBrown);

    final typeBadgeLabel = partner.isAdmin
        ? 'Admin'
        : partner.isPrimary
        ? l10n.primaryPartner
        : l10n.secondaryPartner;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: REdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: borderColor, width: 1.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: innerBg,
                  child: Text(
                    partner.name.isNotEmpty ? partner.name[0].toUpperCase() : 'P',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: accentGreenText,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              partner.name,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: primaryTextColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Container(
                            padding: REdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: typeBadgeBg,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              typeBadgeLabel,
                              style: TextStyle(
                                fontSize: 9.5.sp,
                                fontWeight: FontWeight.bold,
                                color: typeBadgeText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Icon(Icons.phone_outlined, size: 11.r, color: secondaryTextColor),
                          SizedBox(width: 4.w),
                          Text(
                            partner.phone,
                            style: TextStyle(fontSize: 11.sp, color: secondaryTextColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: REdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentGreenBg,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    '+${partner.profitMargin.toStringAsFixed(0)}% ${l10n.profit}',
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.bold,
                      color: accentGreenText,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 12.r, color: secondaryTextColor),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    partner.address,
                    style: TextStyle(fontSize: 11.5.sp, color: secondaryTextColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: REdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(
                      color: innerBg,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      children: [
                        Text(
                          l10n.mainCapital,
                          style: TextStyle(fontSize: 10.sp, color: secondaryTextColor),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          '${partner.mainCapital.toStringAsFixed(0)} $currency',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Container(
                    padding: REdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(
                      color: accentGreenBg,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      children: [
                        Text(
                          l10n.newCapital,
                          style: TextStyle(fontSize: 10.sp, color: accentGreenText),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          '${partner.newCapital.toStringAsFixed(0)} $currency',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: accentGreenText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}