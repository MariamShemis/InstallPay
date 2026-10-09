import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/features/main_layout/tracker/data/model/income_expense_model.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class AddTransactionBottomSheet extends StatefulWidget {
  final ValueChanged<IncomeExpenseModel> onAdd;

  const AddTransactionBottomSheet({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddTransactionBottomSheet> createState() =>
      _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState
    extends State<AddTransactionBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _reasonController = TextEditingController();
  final _incomeController = TextEditingController();
  final _expenseController = TextEditingController();

  DateTime? _incomeDate = DateTime.now();
  DateTime? _expenseDate = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _reasonController.dispose();
    _incomeController.dispose();
    _expenseController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isIncome) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryColor = isDark
        ? ColorManager.darkAccentGreen
        : ColorManager.primaryColor;

    final selectedDate = isIncome ? _incomeDate : _expenseDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      initialEntryMode: DatePickerEntryMode.calendar,
      locale: Localizations.localeOf(context),
      builder: (context, child) {
        final theme = Theme.of(context);

        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: primaryColor,
              onPrimary: ColorManager.white,
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: isDark
                  ? ColorManager.darkSurface
                  : ColorManager.white,
              headerBackgroundColor: primaryColor,
              headerForegroundColor: ColorManager.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
              elevation: 8,
              todayForegroundColor: WidgetStatePropertyAll(
                primaryColor,
              ),
              todayBorder: BorderSide(
                color: primaryColor,
                width: 1.w,
              ),
              cancelButtonStyle: TextButton.styleFrom(
                foregroundColor: primaryColor,
              ),
              confirmButtonStyle: TextButton.styleFrom(
                foregroundColor: primaryColor,
              ),
            ),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) {
      return;
    }

    setState(() {
      if (isIncome) {
        _incomeDate = picked;
      } else {
        _expenseDate = picked;
      }
    });
  }

  void _submitData() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final income =
        double.tryParse(_incomeController.text.trim()) ?? 0.0;

    final expense =
        double.tryParse(_expenseController.text.trim()) ?? 0.0;

    final newRecord = IncomeExpenseModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      personName: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      reason: _reasonController.text.trim(),
      incomeAmount: income,
      incomeDate: income > 0 ? _incomeDate : null,
      expenseAmount: expense,
      expenseDate: expense > 0 ? _expenseDate : null,
    );

    widget.onAdd(newRecord);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryColor = isDark
        ? ColorManager.darkAccentGreen
        : ColorManager.primaryColor;

    final incomeColor = isDark
        ? ColorManager.darkAccentGreen1
        : ColorManager.green;

    final expenseColor = isDark
        ? ColorManager.redErrorDark
        : ColorManager.red;

    final sheetColor = isDark
        ? ColorManager.darkSurface
        : ColorManager.white;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Container(
        padding: REdgeInsets.fromLTRB(20, 12, 20, 16),
        decoration: BoxDecoration(
          color: sheetColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28.r),
          ),
          border: Border.all(
            color: isDark
                ? ColorManager.darkSurfaceVariant
                : ColorManager.blueLightTint,
            width: 1.w,
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: isDark
                          ? ColorManager.darkSurfaceVariant
                          : ColorManager.greyLight,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                ),
                SizedBox(height: 18.h),
                Row(
                  children: [
                    Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        color: isDark
                            ? ColorManager.darkGreenOpacity30
                            : ColorManager.greenOpacity10,
                        borderRadius: BorderRadius.circular(13.r),
                      ),
                      child: Icon(
                        Icons.swap_vert_circle_outlined,
                        color: primaryColor,
                        size: 23.r,
                      ),
                    ),
                    SizedBox(width: 11.w),
                    Expanded(
                      child: Text(
                        l10n.addIncomeExpenseEntry,
                        style:
                        Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: l10n.personName,
                    prefixIcon: const Icon(
                      Icons.person_outline_rounded,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.enterName;
                    }

                    return null;
                  },
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: l10n.phoneNumber,
                    prefixIcon: const Icon(
                      Icons.phone_outlined,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.enterPhoneNumber;
                    }

                    return null;
                  },
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: _reasonController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: l10n.transactionReason,
                    prefixIcon: const Icon(
                      Icons.notes_outlined,
                    ),
                    alignLabelWithHint: true,
                  ),
                ),
                SizedBox(height: 16.h),
                _AmountDateSection(
                  controller: _incomeController,
                  label: l10n.incomeAmount,
                  icon: Icons.north_east_rounded,
                  color: incomeColor,
                  date: _incomeDate,
                  dateLabel: l10n.incomeDate,
                  onDateTap: () => _pickDate(true),
                  onClearDate: () {
                    setState(() {
                      _incomeDate = null;
                    });
                  },
                ),
                SizedBox(height: 13.h),
                _AmountDateSection(
                  controller: _expenseController,
                  label: l10n.expenseAmount,
                  icon: Icons.south_west_rounded,
                  color: expenseColor,
                  date: _expenseDate,
                  dateLabel: l10n.expenseDate,
                  onDateTap: () => _pickDate(false),
                  onClearDate: () {
                    setState(() {
                      _expenseDate = null;
                    });
                  },
                ),
                SizedBox(height: 22.h),
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton.icon(
                    onPressed: _submitData,
                    icon: const Icon(Icons.check_rounded),
                    label: Text(l10n.saveTransaction),
                  ),
                ),
                SizedBox(height: 5.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AmountDateSection extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String dateLabel;
  final IconData icon;
  final Color color;
  final DateTime? date;
  final VoidCallback onDateTap;
  final VoidCallback onClearDate;

  const _AmountDateSection({
    required this.controller,
    required this.label,
    required this.dateLabel,
    required this.icon,
    required this.color,
    required this.date,
    required this.onDateTap,
    required this.onClearDate,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final dateBackground = isDark
        ? ColorManager.darkSurfaceVariant
        : ColorManager.blueSoftBackground;

    final dateBorder = isDark
        ? ColorManager.whiteOpacity20
        : ColorManager.blueLightTint;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(
              icon,
              color: color,
            ),
          ),
        ),
        SizedBox(height: 9.h),
        InkWell(
          onTap: onDateTap,
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            width: double.infinity,
            padding: REdgeInsets.all(12),
            decoration: BoxDecoration(
              color: dateBackground,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: dateBorder,
                width: 1.w,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(11.r),
                  ),
                  child: Icon(
                    Icons.calendar_month_rounded,
                    color: color,
                    size: 20.r,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateLabel,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        date == null
                            ? AppLocalizations.of(context)!
                            .selectDate
                            : DateFormat('dd/MM/yyyy').format(date!),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (date != null)
                  InkWell(
                    onTap: onClearDate,
                    borderRadius: BorderRadius.circular(20.r),
                    child: Padding(
                      padding: REdgeInsets.all(5),
                      child: Icon(
                        Icons.close_rounded,
                        size: 18.r,
                        color: isDark
                            ? ColorManager.darkMutedText
                            : ColorManager.greyDark,
                      ),
                    ),
                  )
                else
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 21.r,
                    color: isDark
                        ? ColorManager.darkMutedText
                        : ColorManager.greyDark,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}