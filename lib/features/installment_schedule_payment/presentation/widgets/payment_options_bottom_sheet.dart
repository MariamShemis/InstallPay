import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class PaymentOptionsBottomSheet extends StatefulWidget {
  final String title;
  final String originalDueDate;
  final double amount;
  final String currency;
  final bool isDark;
  final Color primaryColor;
  final Function(DateTime paymentDate, double paidAmount) onConfirmPayment;

  const PaymentOptionsBottomSheet({
    super.key,
    required this.title,
    required this.originalDueDate,
    required this.amount,
    required this.currency,
    required this.isDark,
    required this.primaryColor,
    required this.onConfirmPayment,
  });

  static void show(
    BuildContext context, {
    required String title,
    required String originalDueDate,
    required double amount,
    required String currency,
    required bool isDark,
    required Color primaryColor,
    required Function(DateTime paymentDate, double paidAmount) onConfirmPayment,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaymentOptionsBottomSheet(
        title: title,
        originalDueDate: originalDueDate,
        amount: amount,
        currency: currency,
        isDark: isDark,
        primaryColor: primaryColor,
        onConfirmPayment: onConfirmPayment,
      ),
    );
  }

  @override
  State<PaymentOptionsBottomSheet> createState() =>
      _PaymentOptionsBottomSheetState();
}

class _PaymentOptionsBottomSheetState extends State<PaymentOptionsBottomSheet> {
  late DateTime _selectedPaymentDate;
  bool _showCustomAmountInput = false;
  late TextEditingController _customAmountController;

  @override
  void initState() {
    super.initState();
    _selectedPaymentDate = DateTime.now();
    _customAmountController = TextEditingController(
      text: widget.amount.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }

  Future<void> _selectPaymentDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedPaymentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: widget.isDark
              ? ThemeData.dark().copyWith(
                  colorScheme: ColorScheme.dark(
                    primary: ColorManager.darkAccentGreen,
                    onPrimary: ColorManager.white,
                    surface: ColorManager.darkSurface,
                    onSurface: ColorManager.white,
                  ),
                )
              : ThemeData.light().copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: ColorManager.primaryColor,
                    onPrimary: ColorManager.white,
                    surface: ColorManager.white,
                    onSurface: ColorManager.black,
                  ),
                ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedPaymentDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cardBg = widget.isDark
        ? ColorManager.darkSurface
        : ColorManager.white;
    final primaryTextColor = widget.isDark
        ? ColorManager.white
        : ColorManager.navyText;
    final secondaryTextColor = widget.isDark
        ? ColorManager.darkMutedText
        : ColorManager.greyDark;
    final boxBg = widget.isDark
        ? ColorManager.darkSurfaceVariant
        : ColorManager.blueSoftBackground;
    final borderColor = widget.isDark
        ? ColorManager.whiteOpacity20
        : ColorManager.blueLightTint;

    final formattedPaymentDate = DateFormat(
      'dd MMM yyyy',
    ).format(_selectedPaymentDate);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: REdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 42.w,
                height: 4.5.h,
                decoration: BoxDecoration(
                  color: secondaryTextColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                padding: REdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.primaryColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.payments_outlined,
                  size: 26.r,
                  color: widget.primaryColor,
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                l10n.paymentOptionsTitle(widget.title),
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 6.h),
              Text(
                l10n.paymentOptionsSubtitle,
                style: TextStyle(
                  fontSize: 11.5.sp,
                  color: secondaryTextColor,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Container(
                padding: REdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: boxBg,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${l10n.dueDateLabel}: ',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: secondaryTextColor,
                          ),
                        ),
                        Text(
                          widget.originalDueDate,
                          style: TextStyle(
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${widget.amount.toStringAsFixed(0)} ${widget.currency}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              InkWell(
                onTap: _selectPaymentDate,
                borderRadius: BorderRadius.circular(14.r),
                child: Container(
                  padding: REdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: boxBg,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: widget.primaryColor,
                      width: 1.2.w,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 16.r,
                            color: widget.primaryColor,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '${l10n.paymentDateLabel}: ',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: secondaryTextColor,
                            ),
                          ),
                          Text(
                            formattedPaymentDate,
                            style: TextStyle(
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.bold,
                              color: widget.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.edit_calendar_outlined,
                        size: 18.r,
                        color: widget.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton.icon(
                  onPressed: () {
                    widget.onConfirmPayment(
                      _selectedPaymentDate,
                      widget.amount,
                    );
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.check_rounded, size: 18.r),
                  label: Text(
                    l10n.payFullInstallmentBtn(
                      '${widget.amount.toStringAsFixed(0)} ${widget.currency}',
                    ),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.primaryColor,
                    foregroundColor: ColorManager.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _showCustomAmountInput = !_showCustomAmountInput;
                    });
                  },
                  icon: Icon(
                    _showCustomAmountInput ? Icons.remove : Icons.add,
                    size: 18.r,
                    color: primaryTextColor,
                  ),
                  label: Text(
                    l10n.customPartialAmountBtn,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: borderColor, width: 1.2.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
              if (_showCustomAmountInput) ...[
                SizedBox(height: 14.h),
                TextField(
                  controller: _customAmountController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.enterCustomAmountLabel,
                    suffixText: widget.currency,
                    suffixStyle: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: widget.primaryColor,
                    ),
                    prefixIcon: Icon(
                      Icons.attach_money_rounded,
                      color: widget.primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  height: 46.h,
                  child: ElevatedButton(
                    onPressed: () {
                      final customVal =
                          double.tryParse(
                            _customAmountController.text.trim(),
                          ) ??
                          widget.amount;
                      widget.onConfirmPayment(_selectedPaymentDate, customVal);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.primaryColor,
                      foregroundColor: ColorManager.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      l10n.confirmCustomPaymentBtn,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
              SizedBox(height: 25.h,),
            ],
          ),
        ),
      ),
    );
  }
}
