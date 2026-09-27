import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/features/add_customer/presentation/widgets/custom_dropdown_field.dart';
import 'package:smart_installment_management/features/add_customer/presentation/widgets/customer_add_text_form_field.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class PersonalInformationCard extends StatelessWidget {
  final String? selectedGroup;
  final List<String> groupsList;
  final ValueChanged<String?> onGroupChanged;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;

  const PersonalInformationCard({
    super.key,
    required this.selectedGroup,
    required this.groupsList,
    required this.onGroupChanged,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                Text(
                  appLocalizations.personalInformation,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            CustomDropdownField<String>(
              labelText: appLocalizations.group,
              hintText: appLocalizations.selectGroup,
              value: selectedGroup,
              prefixIcon: const Icon(Icons.group_outlined),
              items: groupsList.map((group) {
                return DropdownMenuItem(value: group, child: Text(group));
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
