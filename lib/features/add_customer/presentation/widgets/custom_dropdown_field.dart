
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final Widget? prefixIcon;
  final String? Function(T?)? validator;

  const CustomDropdownField({
    super.key,
    required this.labelText,
    required this.items,
    required this.onChanged,
    this.hintText,
    this.value,
    this.prefixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
        DropdownButtonFormField<T>(
          value: value,
          hint: hintText != null ? Text(hintText!) : null,
          items: items,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
          ),
        ),
      ],
    );
  }
}