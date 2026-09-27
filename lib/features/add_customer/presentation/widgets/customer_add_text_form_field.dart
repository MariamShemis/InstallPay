import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/utils/extensions/extensions.dart';

class CustomersAddTextFormField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final String? initialValue;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool multiLine;
  final bool isCurrency;

  const CustomersAddTextFormField({
    super.key,
    required this.labelText,
    this.hintText,
    this.initialValue,
    this.controller,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.multiLine = false,
    this.isCurrency = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget? effectiveSuffixIcon = suffixIcon;
    if (isCurrency) {
      effectiveSuffixIcon = Padding(
        padding: REdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.currencySymbol,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          keyboardType: multiLine ? TextInputType.multiline : keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          onChanged: onChanged,
          maxLines: multiLine ? 5 : 1,
          minLines: multiLine ? 1 : 1,
          onTap: onTap,
          readOnly: readOnly,
          style: theme.textTheme.bodyLarge?.copyWith(fontSize: 14.sp),
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: effectiveSuffixIcon,
          ),
        ),
      ],
    );
  }
}