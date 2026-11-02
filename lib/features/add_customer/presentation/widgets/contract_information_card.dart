import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/features/add_customer/presentation/widgets/custom_dropdown_field.dart';
import 'package:smart_installment_management/features/add_customer/presentation/widgets/customer_add_text_form_field.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class ContractInformationCard extends StatelessWidget {
  final TextEditingController contractDateController;
  final TextEditingController contractNameController;
  final TextEditingController purchasePriceController;
  final TextEditingController installmentAmountController;
  final TextEditingController firstInstallmentDateController;
  final TextEditingController descriptionController;
  final TextEditingController advancePaymentController;
  final TextEditingController totalCostController;
  final TextEditingController debtAmountController;

  final String installmentType;
  final ValueChanged<String?> onInstallmentTypeChanged;
  final VoidCallback onSelectContractDate;
  final VoidCallback onSelectFirstInstallmentDate;
  final int installmentsCount;

  const ContractInformationCard({
    super.key,
    required this.contractDateController,
    required this.contractNameController,
    required this.purchasePriceController,
    required this.installmentAmountController,
    required this.firstInstallmentDateController,
    required this.descriptionController,
    required this.advancePaymentController,
    required this.totalCostController,
    required this.debtAmountController,
    required this.installmentType,
    required this.onInstallmentTypeChanged,
    required this.onSelectContractDate,
    required this.onSelectFirstInstallmentDate,
    required this.installmentsCount,
  });

  String _buildSummaryText(AppLocalizations l10n) {
    if (installmentsCount <= 0) return '';

    String unitText;
    String durationDetail = '';

    if (installmentType == 'Weekly') {
      unitText = l10n.weekly;
      final months = (installmentsCount / 4.33).toStringAsFixed(1);
      durationDetail = ' (~$months ${l10n.monthly})';
    } else if (installmentType == 'Yearly') {
      unitText = l10n.yearly;
    } else {
      unitText = l10n.monthly;
      if (installmentsCount >= 12) {
        final years = (installmentsCount / 12).toStringAsFixed(1);
        durationDetail = ' (~$years ${l10n.yearly})';
      }
    }

    return '$installmentsCount ${l10n.installment} • $installmentsCount $unitText';
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      child: Padding(
        padding: REdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.assignment_outlined,
                  color: isDark
                      ? ColorManager.darkAccentGreen
                      : ColorManager.primaryColor,
                  size: 22.r,
                ),
                SizedBox(width: 8.w),
                Text(
                  appLocalizations.contractDetails,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            CustomersAddTextFormField(
              labelText: appLocalizations.contractDate,
              hintText: 'YYYY-MM-DD',
              controller: contractDateController,
              readOnly: true,
              onTap: onSelectContractDate,
              prefixIcon: const Icon(Icons.calendar_today_outlined),
            ),
            SizedBox(height: 14.h),

            CustomersAddTextFormField(
              labelText: appLocalizations.contractName,
              hintText: 'e.g., Household Appliances',
              controller: contractNameController,
              multiLine: true,
              prefixIcon: const Icon(Icons.description_outlined),
            ),
            SizedBox(height: 14.h),

            Row(
              children: [
                Expanded(
                  child: CustomersAddTextFormField(
                    labelText: appLocalizations.purchasePrice,
                    hintText: '00.0',
                    controller: purchasePriceController,
                    keyboardType: TextInputType.number,
                    isCurrency: true,
                    prefixIcon: const Icon(Icons.sell_outlined),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: CustomersAddTextFormField(
                    labelText: appLocalizations.sellingPrice,
                    hintText: '00.0',
                    controller: totalCostController,
                    keyboardType: TextInputType.number,
                    isCurrency: true,
                    prefixIcon: const Icon(Icons.calculate_outlined),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),

            Row(
              children: [
                Expanded(
                  child: CustomersAddTextFormField(
                    labelText: appLocalizations.downPayment,
                    hintText: '00.0',
                    controller: advancePaymentController,
                    keyboardType: TextInputType.number,
                    isCurrency: true,
                    prefixIcon: const Icon(Icons.money_outlined),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: CustomersAddTextFormField(
                    labelText: appLocalizations.debt,
                    hintText: '00.0',
                    controller: debtAmountController,
                    keyboardType: TextInputType.number,
                    isCurrency: true,
                    readOnly: true,
                    prefixIcon: const Icon(Icons.money_off_outlined),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            // CheckboxListTile(
            //   contentPadding: EdgeInsets.zero,
            //   controlAffinity: ListTileControlAffinity.leading,
            //   value: isDownPaymentPaid,
            //   onChanged: (value) {
            //     onDownPaymentPaidChanged(value ?? false);
            //   },
            //   title: Text(
            //     'Down payment received',
            //     style: theme.textTheme.bodyMedium?.copyWith(
            //       fontWeight: FontWeight.w600,
            //     ),
            //   ),
            //   subtitle: Text(
            //     'Enable this only if you actually received the down payment.',
            //     style: theme.textTheme.bodySmall?.copyWith(
            //       color: isDark
            //           ? const Color(0xFF94A3B8)
            //           : const Color(0xFF64748B),
            //     ),
            //   ),
            //   activeColor: isDark
            //       ? ColorManager.darkAccentGreen
            //       : ColorManager.primaryColor,
            // ),
            // SizedBox(height: 14.h),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: CustomersAddTextFormField(
                    labelText: appLocalizations.installmentAmount,
                    hintText: '500',
                    controller: installmentAmountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    isCurrency: true,
                    prefixIcon: const Icon(Icons.payments_outlined),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  flex: 2,
                  child: CustomDropdownField<String>(
                    labelText: appLocalizations.period,
                    value: installmentType,
                    items: ['Monthly', 'Weekly', 'Yearly'].map((type) {
                      String periodLabel;

                      if (type == 'Monthly') {
                        periodLabel = appLocalizations.monthly;
                      } else if (type == 'Weekly') {
                        periodLabel = appLocalizations.weekly;
                      } else {
                        periodLabel = appLocalizations.yearly;
                      }
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(
                          periodLabel,
                          style: TextStyle(fontSize: 13.sp),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: onInstallmentTypeChanged,
                  ),
                ),
              ],
            ),

            if (installmentsCount > 0) ...[
              SizedBox(height: 8.h),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Text(
                  _buildSummaryText(appLocalizations),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? ColorManager.darkAccentGreen
                        : ColorManager.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            SizedBox(height: 14.h),

            CustomersAddTextFormField(
              labelText: appLocalizations.firstInstallmentDate,
              hintText: 'YYYY-MM-DD',
              controller: firstInstallmentDateController,
              readOnly: true,
              onTap: onSelectFirstInstallmentDate,
              prefixIcon: const Icon(Icons.event_outlined),
            ),
            SizedBox(height: 14.h),

            CustomersAddTextFormField(
              labelText: appLocalizations.notes,
              hintText: '${appLocalizations.additional_contract_notes}...',
              controller: descriptionController,
              multiLine: true,
              prefixIcon: const Icon(Icons.note_alt_outlined),
            ),
          ],
        ),
      ),
    );
  }
}