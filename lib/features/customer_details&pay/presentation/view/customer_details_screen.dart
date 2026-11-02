
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/firebase/taqseet_firestore_services.dart';
import 'package:smart_installment_management/core/routes/app_routes.dart';
import 'package:smart_installment_management/core/utils/ui_utils.dart';
import 'package:smart_installment_management/features/customer_details&pay/presentation/widgets/customer_contract_section.dart';
import 'package:smart_installment_management/features/customer_details&pay/presentation/widgets/customer_payment_progress.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

import '../widgets/customer_details_header.dart';
import '../widgets/customer_pay_button.dart';

class CustomerDetailsScreen extends StatefulWidget {
  final CustomerModel customer;

  const CustomerDetailsScreen({
    super.key,
    required this.customer,
  });

  @override
  State<CustomerDetailsScreen> createState() =>
      _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  bool _isDeleting = false;

  Future<void> _editCustomer() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.addNewCustomer,
      arguments: widget.customer,
    );

    if (!mounted || result == null) return;

    Navigator.pop(context, true);
  }

  Future<void> _confirmDeleteCustomer() async {
    if (_isDeleting) return;

    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
          isDark ? ColorManager.darkSurface : ColorManager.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          icon: Icon(
            Icons.delete_forever_rounded,
            color: isDark ? ColorManager.redErrorDark : ColorManager.red,
            size: 42.sp,
          ),
          title: Text(
            l10n.deleteCustomerTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? ColorManager.white : ColorManager.black,
            ),
          ),
          content: Text(
            l10n.deleteCustomerConfirmation(
              widget.customer.customerName,
            ),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              height: 1.6,
              color: isDark
                  ? ColorManager.darkMutedText
                  : ColorManager.greyDark,
            ),
          ),
          actionsAlignment: MainAxisAlignment.end,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: TextButton.styleFrom(
                foregroundColor:
                isDark ? ColorManager.redErrorDark : ColorManager.red,
              ),
              child: Text(
                l10n.delete,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    if (widget.customer.id.isEmpty) {
      UiUtils.showError(context, l10n.deleteCustomerFailed);
      return;
    }

    setState(() => _isDeleting = true);
    UiUtils.showLoading(context);

    try {
      await TaqseetFirestoreServices.deleteRecord(
        documentId: widget.customer.id,
      );

      if (!mounted) return;

      UiUtils.hideLoading(context);
      UiUtils.showSuccess(context, l10n.deleteCustomerSuccess);
      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;

      UiUtils.hideLoading(context);
      UiUtils.showError(context, l10n.deleteCustomerFailed);
    } finally {
      if (mounted) {
        setState(() => _isDeleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryColor = isDark
        ? ColorManager.darkAccentGreen
        : ColorManager.primaryColor;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : ColorManager.black,
          ),
        ),
        title: Text(
          l10n.customerDetails,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : ColorManager.black,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Edit customer',
            onPressed: _editCustomer,
            icon: Icon(
              Icons.edit_rounded,
              color: isDark
                  ? ColorManager.darkAccentGreen
                  : ColorManager.primaryColor,
            ),
          ),
          IconButton(
            tooltip: l10n.deleteCustomerTitle,
            onPressed: _isDeleting ? null : _confirmDeleteCustomer,
            icon: _isDeleting
                ? SizedBox(
              width: 20.w,
              height: 20.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
                : Icon(
              Icons.delete_outline_rounded,
              color: isDark
                  ? ColorManager.redErrorDark
                  : ColorManager.red,
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      bottomNavigationBar: CustomerPayButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRoutes.payInstallment,
            arguments: widget.customer,
          );
        },
        primaryColor: primaryColor,
        isDark: isDark,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: REdgeInsets.fromLTRB(14, 8, 14, 20),
          child: Column(
            children: [
              CustomerDetailsHeader(
                customer: widget.customer,
                primaryColor: primaryColor,
                isDark: isDark,
              ),
              SizedBox(height: 12.h),
              CustomerContractSection(
                customer: widget.customer,
                primaryColor: primaryColor,
                isDark: isDark,
              ),
              SizedBox(height: 12.h),
              CustomerPaymentProgress(
                customer: widget.customer,
                primaryColor: primaryColor,
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
