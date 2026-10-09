import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/services/session_services.dart'; // عدل المسار بحسب مشروعك
import 'package:smart_installment_management/features/main_layout/customers/presentation/widgets/calculator_dialog.dart';
import 'package:smart_installment_management/features/main_layout/home/presentation/widgets/financial_summary_section.dart';
import 'package:smart_installment_management/features/main_layout/home/presentation/widgets/hidden_privacy_placeholder.dart';
import 'package:smart_installment_management/features/main_layout/home/presentation/widgets/home_title.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late bool _isPrivacyHidden;

  @override
  void initState() {
    super.initState();
    _isPrivacyHidden = SessionServices.getPrivacyHidden();
  }

  Future<void> _togglePrivacy() async {
    setState(() {
      _isPrivacyHidden = !_isPrivacyHidden;
    });
    await SessionServices.setPrivacyHidden(_isPrivacyHidden);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: REdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeTitle(
                name: "Ahmed",
                isPrivacyHidden: _isPrivacyHidden,
                onTogglePrivacy: _togglePrivacy,
                onCalculatorTap: () {
                  CalculatorDialog.show(context);
                },
                image: CircleAvatar(
                  radius: 22.r,
                  backgroundColor: ColorManager.navyDark,
                  child: Icon(
                    Icons.person,
                    color: ColorManager.white,
                    size: 22.sp,
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              Divider(
                color: isDark
                    ? colorScheme.onSurface.withOpacity(0.2)
                    : theme.dividerColor.withOpacity(0.15),
                thickness: 1,
                indent: 2,
                endIndent: 2,
              ),
              SizedBox(height: 12.h),
              _isPrivacyHidden
                  ? HiddenPrivacyPlaceholder(
                userName: "Ahmed",
                onUnhideTap: _togglePrivacy,
              )
                  : const FinancialSummarySection(),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}