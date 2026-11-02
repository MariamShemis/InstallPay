import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class CustomFilterSearch extends StatelessWidget {
  const CustomFilterSearch({
    super.key,
    this.valueDropDownGroups,
    this.itemsGroups,
    this.onChangedGroups,
    this.valueDropDownStatus,
    this.itemsStatus,
    this.onChangedStatus,
    this.onPressedReset,
    this.onPressedApply,
    required this.theme,
    this.isCustomer = false,
  });

  final String? valueDropDownGroups;
  final List<DropdownMenuItem<String>>? itemsGroups;
  final void Function(String?)? onChangedGroups;
  final int? valueDropDownStatus;
  final List<DropdownMenuItem<int>>? itemsStatus;
  final void Function(int?)? onChangedStatus;
  final void Function()? onPressedReset;
  final void Function()? onPressedApply;
  final ThemeData theme;
  final bool isCustomer;

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isCustomer ? l10n.filterCustomers : l10n.filterGroups,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              isCustomer ? l10n.groups : l10n.groupStatus,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            DropdownButtonFormField<String>(
              value: valueDropDownGroups,
              isExpanded: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  isCustomer
                      ? Icons.groups_outlined
                      : Icons.filter_alt_outlined,
                ),
              ),
              items: itemsGroups,
              onChanged: onChangedGroups,
            ),
            SizedBox(height: 20.h),
            if (isCustomer) ...[
              Text(
                l10n.paymentStatus,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),

              DropdownButtonFormField<int>(
                value: valueDropDownStatus,
                isExpanded: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.payments_outlined),
                ),
                items: itemsStatus,
                onChanged: onChangedStatus,
              ),

              SizedBox(height: 24.h),
            ],

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onPressedReset,
                    child: Text(l10n.reset),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onPressedApply,
                    child: Text(l10n.applyFilters),
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
