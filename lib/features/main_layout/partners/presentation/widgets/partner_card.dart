import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/features/main_layout/partners/data/model/partner_model.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class PartnerCard extends StatelessWidget {
  final PartnerModel partner;
  final String currency;
  final double secondaryProfitTotal;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const PartnerCard({
    super.key,
    required this.partner,
    required this.currency,
    this.secondaryProfitTotal = 0,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDark ? ColorManager.darkSurface : ColorManager.white;
    final innerBg = isDark
        ? ColorManager.darkSurfaceVariant
        : ColorManager.blueSoftBackground;
    final textColor = isDark ? ColorManager.white : ColorManager.navyText;
    final mutedColor = isDark
        ? ColorManager.darkMutedText
        : ColorManager.greyDark;
    final accentColor = isDark
        ? ColorManager.darkAccentGreen
        : ColorManager.green;

    final typeLabel = partner.isAdmin
        ? l10n.admin
        : partner.isPrimary
        ? l10n.primaryPartner
        : l10n.secondaryPartner;

    final profitLabel = partner.isAdmin
        ? '+100%'
        : '+${partner.profitMargin.toStringAsFixed(0)}%';

    ImageProvider? imageProvider;

    if (partner.imagePath != null && partner.imagePath!.isNotEmpty) {
      imageProvider = NetworkImage(partner.imagePath!);
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: REdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark
                ? ColorManager.darkSurfaceVariant
                : ColorManager.blueLightTint,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24.r,
                  backgroundColor: innerBg,
                  backgroundImage: imageProvider,
                  child: imageProvider == null
                      ? Text(
                          partner.name.isEmpty
                              ? 'P'
                              : partner.name[0].toUpperCase(),
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        partner.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        padding: REdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: innerBg,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          typeLabel,
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 6.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      profitLabel,
                      style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                    if (partner.isAdmin) ...[
                      SizedBox(height: 3.h),
                      Text(
                        '${l10n.secondaryProfitTotal}: '
                        '${secondaryProfitTotal.toStringAsFixed(0)}%',
                        textAlign: TextAlign.end,
                        style: TextStyle(color: mutedColor, fontSize: 9.sp),
                      ),
                    ],
                  ],
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit?.call();
                    } else if (value == 'delete') {
                      onDelete?.call();
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit_outlined),
                          SizedBox(width: 8.w),
                          Text(l10n.edit),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete_outline, color: Colors.red),
                          SizedBox(width: 8.w),
                          Text(l10n.delete),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: partner.phone.isNotEmpty && partner.address.isNotEmpty
                  ? 10.h
                  : 0.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (partner.phone.isNotEmpty) ...[
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 15.r,
                          color: mutedColor,
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            partner.phone,
                            style: TextStyle(
                              color: mutedColor,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (partner.address.isNotEmpty) ...[
                  SizedBox(width: 6.h),
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 15.r,
                          color: mutedColor,
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            partner.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: mutedColor,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _capitalBox(
                    label: l10n.mainCapital,
                    value:
                        '${partner.mainCapital.toStringAsFixed(2)} $currency',
                    background: innerBg,
                    labelColor: mutedColor,
                    valueColor: textColor,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _capitalBox(
                    label: l10n.newCapital,
                    value: '${partner.newCapital.toStringAsFixed(2)} $currency',
                    background: innerBg,
                    labelColor: mutedColor,
                    valueColor: accentColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _capitalBox({
    required String label,
    required String value,
    required Color background,
    required Color labelColor,
    required Color valueColor,
  }) {
    return Container(
      padding: REdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10.sp, color: labelColor),
          ),
          SizedBox(height: 5.h),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
