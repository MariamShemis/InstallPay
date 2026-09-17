import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/cubits/language/language_cubit.dart';

class LanguageToggle extends StatelessWidget {
  final bool isDark;

  const LanguageToggle({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.watch<LanguageCubit>().state.locale.languageCode;
    final isEnglish = currentLocale == 'en';

    return Container(
      padding: REdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isDark
            ? ColorManager.darkSurfaceVariant
            : ColorManager.blueSoftBackground,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLanguageButton(
            text: "EN",
            isSelected: isEnglish,
            onTap: () {
              context.read<LanguageCubit>().changeLanguage('en');
            },
          ),
          _buildLanguageButton(
            text: "عربي",
            isSelected: !isEnglish,
            onTap: () {
              context.read<LanguageCubit>().changeLanguage('ar');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: REdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
              ? ColorManager.darkAccentGreen
              : ColorManager.primaryColor)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
            color: isSelected
                ? ColorManager.white
                : (isDark ? ColorManager.darkMutedText : ColorManager.greyDark),
          ),
        ),
      ),
    );
  }
}