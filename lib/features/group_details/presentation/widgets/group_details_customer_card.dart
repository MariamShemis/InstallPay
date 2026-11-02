
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class GroupDetailsCustomerCard extends StatelessWidget {
  final CustomerModel customer;
  final String currency;
  final VoidCallback? onTap;

  const GroupDetailsCustomerCard({
    super.key,
    required this.customer,
    required this.currency,
    this.onTap,
  });

  String getLocalizedPaymentStatus(BuildContext context, String status) {
    final l10n = AppLocalizations.of(context)!;

    switch (status.trim().toLowerCase()) {
      case 'paid':
        return l10n.paid;
      case 'overdue':
        return l10n.overdue;
      case 'due':
        return l10n.due;
      default:
        return l10n.unpaid;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final progress = customer.paymentProgress.clamp(0.0, 1.0);
    final isCompleted = customer.isCompleted;

    final primaryColor = isDark
        ? ColorManager.darkAccentGreen
        : ColorManager.primaryColor;

    final greenColor = isDark
        ? ColorManager.darkAccentGreen1
        : ColorManager.green;

    final borderColor = isDark
        ? ColorManager.darkSurfaceVariant
        : ColorManager.blueLightTint;

    final cardColor = isDark
        ? ColorManager.darkSurface
        : ColorManager.white;

    final secondaryBg = isDark
        ? ColorManager.darkSurfaceVariant
        : ColorManager.blueSoftBackground;

    final collectedBg = isDark
        ? ColorManager.darkGreenContainer
        : ColorManager.greenOpacity10;

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: REdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: primaryColor.withOpacity(0.12),
                    backgroundImage: customer.imageUrl.isNotEmpty
                        ? NetworkImage(customer.imageUrl)
                        : null,
                    child: customer.imageUrl.isEmpty
                        ? Icon(
                      Icons.person_outline_rounded,
                      color: primaryColor,
                      size: 22.r,
                    )
                        : null,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer.customerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          customer.contractName.isEmpty
                              ? AppLocalizations.of(context)!.contract
                              : customer.contractName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: REdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? greenColor.withOpacity(0.12)
                          : primaryColor.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      getLocalizedPaymentStatus(context, customer.status),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isCompleted ? greenColor : primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: _AmountBox(
                      title: AppLocalizations.of(context)!.totalValue,
                      value: customer.sellingPrice,
                      currency: currency,
                      bgColor: secondaryBg,
                      textColor: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: _AmountBox(
                      title: AppLocalizations.of(context)!.collected,
                      value: customer.totalPaid,
                      currency: currency,
                      bgColor: collectedBg,
                      textColor: greenColor,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: _AmountBox(
                      title: AppLocalizations.of(context)!.debt,
                      value: customer.remainingValue,
                      currency: currency,
                      bgColor: secondaryBg,
                      textColor: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 5.h,
                  backgroundColor: isDark
                      ? ColorManager.whiteOpacity20
                      : ColorManager.greyLight,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isCompleted ? greenColor : primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AmountBox extends StatelessWidget {
  final String title;
  final double value;
  final String currency;
  final Color bgColor;
  final Color textColor;

  const _AmountBox({
    required this.title,
    required this.value,
    required this.currency,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final valStr = value
        .toStringAsFixed(2)
        .replaceFirst(RegExp(r'\.00$'), '');

    return Container(
      padding: REdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 10.sp,
            ),
          ),
          SizedBox(height: 4.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '$valStr $currency',
              style: theme.textTheme.titleMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
