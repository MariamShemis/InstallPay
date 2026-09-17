import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';

class FilterChipsList extends StatelessWidget {
  final List<String> filters;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const FilterChipsList({
    super.key,
    required this.filters,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 36.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return ChoiceChip(
            label: Text(filters[index]),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) onSelected(index);
            },
            selectedColor: isDark
                ? ColorManager.darkAccentGreen
                : ColorManager.primaryColor,
            backgroundColor: isDark
                ? ColorManager.darkSurfaceVariant
                : ColorManager.white,
            labelStyle: TextStyle(
              color: isSelected
                  ? ColorManager.white
                  : (isDark
                  ? ColorManager.darkMutedText
                  : ColorManager.greyDark),
              fontSize: 12.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
              side: BorderSide(
                color: isSelected
                    ? Colors.transparent
                    : (isDark
                    ? ColorManager.whiteOpacity20
                    : ColorManager.blueLightTint),
              ),
            ),
            showCheckmark: false,
          );
        },
      ),
    );
  }
}