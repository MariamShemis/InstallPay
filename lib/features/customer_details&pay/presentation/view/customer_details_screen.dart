import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/routes/app_routes.dart';
import 'package:smart_installment_management/features/customer_details&pay/presentation/widgets/customer_contract_section.dart';
import 'package:smart_installment_management/features/customer_details&pay/presentation/widgets/customer_payment_progress.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

import '../widgets/customer_details_header.dart';
import '../widgets/customer_pay_button.dart';

class CustomerDetailsScreen extends StatelessWidget {
  final CustomerModel customer;

  const CustomerDetailsScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
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
          appLocalizations.customerDetails,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : ColorManager.black,
          ),
        ),
      ),
      bottomNavigationBar: CustomerPayButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRoutes.payInstallment,
            arguments: customer,
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
                customer: customer,
                primaryColor: primaryColor,
                isDark: isDark,
              ),
              SizedBox(height: 12.h),
              CustomerContractSection(
                customer: customer,
                primaryColor: primaryColor,
                isDark: isDark,
              ),
              SizedBox(height: 12.h),
              CustomerPaymentProgress(
                customer: customer,
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
