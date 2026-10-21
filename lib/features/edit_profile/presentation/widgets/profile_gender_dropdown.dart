import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class ProfileGenderDropdown extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const ProfileGenderDropdown({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    String? normalizedValue;
    if (selectedValue != null) {
      final val = selectedValue!.trim().toLowerCase();
      if (val == 'male') normalizedValue = 'Male';
      if (val == 'female') normalizedValue = 'Female';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: REdgeInsets.only(left: 4, bottom: 8, right: 4),
          child: Text(
            (appLocalizations.gender ?? 'Gender').toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: isDark
                  ? ColorManager.darkMutedText
                  : ColorManager.greyDark,
            ),
          ),
        ),
        DropdownButtonFormField<String>(
          dropdownColor: isDark ? ColorManager.darkSurface : ColorManager.white,
          value: normalizedValue,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          decoration: InputDecoration(
            hintText: appLocalizations.selectGender ?? 'Select gender',
            prefixIcon: const Icon(Icons.wc_outlined),
          ),
          items: [
            DropdownMenuItem(
              value: 'Male',
              child: Text(isArabic ? 'ذكر' : 'Male'),
            ),
            DropdownMenuItem(
              value: 'Female',
              child: Text(isArabic ? 'أنثى' : 'Female'),
            ),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}
