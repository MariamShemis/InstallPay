import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

import 'payment_options_bottom_sheet.dart'; // import

class InstallmentPayBottomBar extends StatelessWidget {
  final CustomerModel customer;
  final int selectedIndex;
  final Color primaryColor;
  final bool isDark;
  final String currency;
  final Function(DateTime date, double amount)? onPaymentConfirmed;

  const InstallmentPayBottomBar({
    super.key,
    required this.customer,
    required this.selectedIndex,
    required this.primaryColor,
    required this.isDark,
    required this.currency,
    this.onPaymentConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasDownPayment = customer.downPayment > 0;

    bool isSelectedItemPaid = false;
    String itemTitle = '';
    String originalDueDate = '';
    double itemAmount = 0;

    if (hasDownPayment && selectedIndex == 0) {
      isSelectedItemPaid = customer.isDownPaymentPaid;
      itemTitle = l10n.downPayment;
      originalDueDate = customer.contractDate.isNotEmpty
          ? customer.contractDate
          : l10n.notAvailable;
      itemAmount = customer.downPayment;
    } else {
      final scheduleIndex = hasDownPayment ? selectedIndex - 1 : selectedIndex;

      if (scheduleIndex >= 0 && scheduleIndex < customer.schedule.length) {
        final installment = customer.schedule[scheduleIndex];
        isSelectedItemPaid = installment.isPaid;
        itemTitle = l10n.installmentNumber(installment.installmentNumber);
        originalDueDate = installment.dueDate;
        itemAmount = installment.amount;
      }
    }

    return SafeArea(
      child: Container(
        padding: REdgeInsets.fromLTRB(14, 8, 14, 10),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: _borderColor)),
        ),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 46.h,
                child: ElevatedButton.icon(
                  onPressed: isSelectedItemPaid
                      ? null
                      : () {
                          PaymentOptionsBottomSheet.show(
                            context,
                            title: itemTitle,
                            originalDueDate: originalDueDate,
                            amount: itemAmount,
                            currency: currency,
                            isDark: isDark,
                            primaryColor: primaryColor,
                            onConfirmPayment: (paymentDate, paidAmount) {
                              if (onPaymentConfirmed != null) {
                                onPaymentConfirmed!(paymentDate, paidAmount);
                              }
                            },
                          );
                        },
                  icon: Icon(
                    isSelectedItemPaid
                        ? Icons.check_circle_outline_rounded
                        : Icons.credit_card,
                    size: 16.r,
                  ),
                  label: Text(
                    l10n.payInstallment,
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelectedItemPaid
                        ? (isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFCBD5E1))
                        : primaryColor,
                    foregroundColor: isSelectedItemPaid
                        ? (isDark
                              ? ColorManager.darkMutedText
                              : ColorManager.greyDark)
                        : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            _buildIconButton(icon: Icons.receipt_long_outlined),
            SizedBox(width: 6.w),
            _buildIconButton(icon: Icons.picture_as_pdf_outlined),
            SizedBox(width: 6.w),
            _buildIconButton(icon: Icons.archive_outlined),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({required IconData icon}) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 46.r,
        height: 46.r,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEEF2FF),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: _borderColor),
        ),
        child: Icon(
          icon,
          size: 18.r,
          color: isDark ? Colors.white : const Color(0xFF1E293B),
        ),
      ),
    );
  }

  Color get _borderColor {
    return isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
  }
}
