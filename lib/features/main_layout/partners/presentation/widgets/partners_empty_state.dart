import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_installment_management/core/costants/assets_manager.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class PartnersEmptyState extends StatelessWidget {
  const PartnersEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              isDark
                  ? LottieAssets.addToPartnerDark
                  : LottieAssets.addToPartnerLight,
              width: 280.w,
              height: 280.h,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 16.h),
            Text(
              appLocalizations.noPartnersFound,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              appLocalizations.start_managing_your_business_by_adding_a_new_partner,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 13.sp,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}