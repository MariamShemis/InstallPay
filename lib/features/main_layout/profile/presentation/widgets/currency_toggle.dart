import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/cubits/currency/currency_cubit.dart';
import 'package:smart_installment_management/core/cubits/currency/currency_state.dart';

class CurrencyToggle extends StatelessWidget {
  final bool isDark;

  const CurrencyToggle({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final currencyType = context.watch<CurrencyCubit>().state.currencyType;

    return Container(
      padding: REdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isDark
            ? ColorManager.darkSurfaceVariant
            : ColorManager.blueSoftBackground,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCurrencyButton(
            context,
            text: "L.E",
            isSelected: currencyType == CurrencyType.egp,
            onTap: () =>
                context.read<CurrencyCubit>().changeCurrency(CurrencyType.egp),
          ),
          _buildCurrencyButton(
            context,
            text: "USD (\$)",
            isSelected: currencyType == CurrencyType.usd,
            onTap: () =>
                context.read<CurrencyCubit>().changeCurrency(CurrencyType.usd),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyButton(
      BuildContext context, {
        required String text,
        required bool isSelected,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: REdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
              ? ColorManager.darkAccentGreen
              : ColorManager.primaryColor)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(9.r),
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