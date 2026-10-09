import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/features/main_layout/tracker/data/model/income_expense_model.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class TrackerTransactionCard extends StatelessWidget {
  final IncomeExpenseModel record;
  final VoidCallback onDelete;

  const TrackerTransactionCard({
    super.key,
    required this.record,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final incomeColor = isDark
        ? ColorManager.darkAccentGreen1
        : ColorManager.green;

    final expenseColor = isDark
        ? ColorManager.redErrorDark
        : ColorManager.red;

    final cardColor = isDark
        ? ColorManager.darkSurface
        : ColorManager.white;

    final borderColor = isDark
        ? ColorManager.darkSurfaceVariant
        : ColorManager.blueLightTint;

    final iconBackground = isDark
        ? ColorManager.darkSurfaceVariant
        : ColorManager.blueSoftBackground;

    return Container(
      margin: REdgeInsets.only(bottom: 12),
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(
          color: borderColor,
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(13.r),
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: isDark
                      ? ColorManager.darkAccentGreen
                      : ColorManager.primaryColor,
                  size: 21.r,
                ),
              ),
              SizedBox(width: 11.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.personName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 13.r,
                          color: isDark
                              ? ColorManager.darkSlateText
                              : ColorManager.greySecondaryText,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            record.phoneNumber,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDelete,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: isDark
                      ? ColorManager.redErrorDark
                      : ColorManager.red,
                  size: 21.r,
                ),
              ),
            ],
          ),
          SizedBox(height: 13.h),
          Divider(
            height: 1,
            color: isDark
                ? ColorManager.whiteOpacity20
                : ColorManager.greyLight,
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              if (record.incomeAmount > 0)
                Expanded(
                  child: _AmountInfo(
                    amount: '+\$${record.incomeAmount.toStringAsFixed(2)}',
                    date: record.incomeDate,
                    color: incomeColor,
                    icon: Icons.north_east_rounded,
                  ),
                ),
              if (record.incomeAmount > 0 && record.expenseAmount > 0)
                SizedBox(width: 12.w),
              if (record.expenseAmount > 0)
                Expanded(
                  child: _AmountInfo(
                    amount: '-\$${record.expenseAmount.toStringAsFixed(2)}',
                    date: record.expenseDate,
                    color: expenseColor,
                    icon: Icons.south_west_rounded,
                    crossAxisAlignment: CrossAxisAlignment.end,
                  ),
                ),
            ],
          ),
          if (record.reason.isNotEmpty) ...[
            SizedBox(height: 11.h),
            Container(
              width: double.infinity,
              padding: REdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? ColorManager.darkSurfaceVariant
                    : ColorManager.greyLight,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.notes_outlined,
                    size: 15.r,
                    color: isDark
                        ? ColorManager.darkMutedText
                        : ColorManager.greyDark,
                  ),
                  SizedBox(width: 7.w),
                  Expanded(
                    child: Text(
                      record.reason,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 2.h),
          Text(
            l10n.transactionDetails,
            style: const TextStyle(
              fontSize: 0,
              height: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountInfo extends StatelessWidget {
  final String amount;
  final DateTime? date;
  final Color color;
  final IconData icon;
  final CrossAxisAlignment crossAxisAlignment;

  const _AmountInfo({
    required this.amount,
    required this.date,
    required this.color,
    required this.icon,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Row(
          mainAxisAlignment: crossAxisAlignment == CrossAxisAlignment.end
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: color,
              size: 14.r,
            ),
            SizedBox(width: 4.w),
            Text(
              amount,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        if (date != null) ...[
          SizedBox(height: 4.h),
          Text(
            DateFormat('dd/MM/yyyy').format(date!),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 10.sp,
            ),
          ),
        ],
      ],
    );
  }
}