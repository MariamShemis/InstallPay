import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/features/edit_profile/presentation/widgets/custom_profile_field.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class ProfileBirthdayField extends StatelessWidget {
  final TextEditingController controller;

  const ProfileBirthdayField({super.key, required this.controller});

  Future<void> _selectDate(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? ColorScheme.dark(
                    primary: ColorManager.darkAccentGreen,
                    onPrimary: ColorManager.white,
                    surface: ColorManager.darkSurface,
                    onSurface: ColorManager.white,
                  )
                : ColorScheme.light(
                    primary: ColorManager.primaryColor,
                    onPrimary: ColorManager.white,
                    onSurface: ColorManager.black,
                  ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        return CustomProfileField(
          title: (appLocalizations.birthday ?? 'Birthday').toUpperCase(),
          hintText:
              appLocalizations.select_your_birthday ?? 'Select your birthday',
          controller: controller,
          readOnly: true,
          prefixIcon: const Icon(Icons.cake_outlined),
          suffixIcon: value.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close_rounded, size: 20.r),
                  onPressed: () {
                    controller.clear();
                  },
                )
              : null,
          onTap: () => _selectDate(context),
        );
      },
    );
  }
}
