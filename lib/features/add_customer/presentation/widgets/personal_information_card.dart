import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/widgets/person_image_picker.dart';
import 'package:smart_installment_management/features/add_customer/presentation/widgets/custom_dropdown_field.dart';
import 'package:smart_installment_management/features/add_customer/presentation/widgets/customer_add_text_form_field.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class PersonalInformationCard extends StatelessWidget {
  final String? selectedGroupId;
  final List<MapEntry<String, String>> groupsList;
  final ValueChanged<String?> onGroupChanged;

  final File? selectedImage;
  final ValueChanged<File?> onImageChanged;

  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;

  const PersonalInformationCard({
    super.key,
    required this.selectedGroupId,
    required this.groupsList,
    required this.onGroupChanged,
    required this.selectedImage,
    required this.onImageChanged,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
  });

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final safeGroupId = groupsList.any((group) => group.key == selectedGroupId)
        ? selectedGroupId
        : '';

    return Card(
      child: Padding(
        padding: REdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person_outline_rounded,
                  color: isDark
                      ? ColorManager.darkAccentGreen
                      : ColorManager.primaryColor,
                  size: 22.r,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    appLocalizations.personalInformation,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Center(
              child: PersonImagePicker(
                onImageChanged: onImageChanged,
                radius: 48,
              ),
            ),
            SizedBox(height: 20.h),
            CustomDropdownField<String>(
              labelText: appLocalizations.group,
              hintText: appLocalizations.selectGroup,
              value: safeGroupId,
              prefixIcon: const Icon(Icons.group_outlined),
              items: groupsList.map((group) {
                return DropdownMenuItem<String>(
                  value: group.key,
                  child: Text(group.value, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: onGroupChanged,
            ),
            SizedBox(height: 14.h),
            CustomersAddTextFormField(
              labelText: appLocalizations.customerName,
              hintText: appLocalizations.enter_customer_name,
              controller: nameController,
              prefixIcon: const Icon(Icons.badge_outlined),
            ),
            SizedBox(height: 14.h),
            CustomersAddTextFormField(
              labelText: appLocalizations.phoneNumber,
              hintText: appLocalizations.enter_phone_number,
              controller: phoneController,
              keyboardType: TextInputType.phone,
              prefixIcon: const Icon(Icons.phone_outlined),
            ),
            SizedBox(height: 14.h),
            CustomersAddTextFormField(
              labelText: appLocalizations.address,
              hintText: appLocalizations.enter_customer_address,
              controller: addressController,
              prefixIcon: const Icon(Icons.location_on_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
