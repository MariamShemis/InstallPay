import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/utils/extensions/extensions.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class CustomerPayButton extends StatelessWidget {
  final Color primaryColor;
  final bool isDark;
  final VoidCallback onPressed;

  const CustomerPayButton({
    super.key,
    required this.primaryColor,
    required this.isDark, required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return SafeArea(
      child: Container(
        padding: REdgeInsets.fromLTRB(14, 8, 14, 10),
        child: SizedBox(
          height: 48.h,
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(
              Icons.payments_outlined,
              size: 18.r,
            ),
            label: Text(
              appLocalizations.payInstallment,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ),
      ),
    );
  }
}