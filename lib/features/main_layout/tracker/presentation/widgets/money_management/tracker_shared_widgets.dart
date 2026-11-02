import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/features/add_customer/presentation/widgets/customer_add_text_form_field.dart';

String trackerFormatCurrency(double amount) {
  return NumberFormat('#,##0.00', 'en_US').format(amount);
}

class TrackerSectionCard extends StatelessWidget {
  final Widget child;

  const TrackerSectionCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(18),
      decoration: BoxDecoration(
        color:
            Theme.of(context).cardTheme.color ??
            Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark
              ? ColorManager.darkSurfaceVariant
              : ColorManager.blueLightTint,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : ColorManager.blueSoftBackground,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class TrackerCardHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const TrackerCardHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: REdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDark
                ? ColorManager.darkSurfaceVariant
                : ColorManager.blueSoftBackground,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            size: 22.r,
            color: isDark
                ? ColorManager.darkAccentGreen
                : ColorManager.primaryColor,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? ColorManager.white : ColorManager.navyText,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  height: 1.4,
                  color: isDark
                      ? ColorManager.darkMutedText
                      : ColorManager.greySecondaryText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TrackerEquationBanner extends StatelessWidget {
  final String text;

  const TrackerEquationBanner({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark
        ? ColorManager.darkAccentGreen
        : ColorManager.primaryColor;

    return Container(
      width: double.infinity,
      padding: REdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? ColorManager.darkSurfaceVariant
            : ColorManager.blueSoftBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border(
          left: BorderSide(color: accent, width: 4.w),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Σ',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: accent,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? ColorManager.white : ColorManager.navyText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TrackerMoneyField extends StatelessWidget {
  final String label;
  final double value;

  const TrackerMoneyField({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return CustomersAddTextFormField(
      key: ValueKey('$label-$value'),
      labelText: label,
      initialValue: value.toStringAsFixed(2),
      readOnly: true,
      isCurrency: true,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }
}

class TrackerNumberField extends StatelessWidget {
  final String label;
  final String value;

  const TrackerNumberField({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return CustomersAddTextFormField(
      key: ValueKey('$label-$value'),
      labelText: label,
      initialValue: value,
      readOnly: true,
      keyboardType: TextInputType.number,
    );
  }
}

class TrackerResultPanel extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const TrackerResultPanel({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? ColorManager.darkSurfaceVariant
            : ColorManager.blueSoftBackground,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.7,
              color: isDark
                  ? ColorManager.darkSlateText
                  : ColorManager.greySecondaryText,
            ),
          ),
          SizedBox(height: 10.h),
          ...children,
        ],
      ),
    );
  }
}

class TrackerOutputResultBox extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final Widget? leading;

  const TrackerOutputResultBox({
    super.key,
    required this.label,
    required this.value,
    required this.valueColor,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            Theme.of(context).cardTheme.color ??
            Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              color: isDark
                  ? ColorManager.darkMutedText
                  : ColorManager.greySecondaryText,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              if (leading != null) ...[leading!, SizedBox(width: 6.w)],
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: valueColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TrackerSummaryTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color accent;

  const TrackerSummaryTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: REdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? ColorManager.darkCardBg
            : ColorManager.blueSoftBackground.withOpacity(0.6),
        borderRadius: BorderRadius.circular(14.r),
        border: Border(
          left: BorderSide(color: accent, width: 4.w),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 21.r, color: accent),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? ColorManager.darkMutedText
                    : ColorManager.greySecondaryText,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? ColorManager.white : ColorManager.navyText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class TrackerAutoUpdateNote extends StatelessWidget {
//   final String text;
//
//   const TrackerAutoUpdateNote({super.key, required this.text});
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return Container(
//       width: double.infinity,
//       padding: REdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: isDark
//             ? ColorManager.darkGreenContainer
//             : ColorManager.greenAccent.withOpacity(0.25),
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             Icons.sync_rounded,
//             size: 19.r,
//             color: isDark ? ColorManager.darkAccentGreen : ColorManager.green,
//           ),
//           SizedBox(width: 9.w),
//           Expanded(
//             child: Text(
//               text,
//               style: GoogleFonts.inter(
//                 fontSize: 11.sp,
//                 height: 1.5,
//                 color: isDark
//                     ? ColorManager.darkMutedText
//                     : ColorManager.greySecondaryText,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
