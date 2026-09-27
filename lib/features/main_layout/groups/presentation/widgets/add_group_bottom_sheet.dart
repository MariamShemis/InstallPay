import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/features/add_customer/presentation/widgets/customer_add_text_form_field.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class AddGroupBottomSheet extends StatefulWidget {
  const AddGroupBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddGroupBottomSheet(),
    );
  }

  @override
  State<AddGroupBottomSheet> createState() => _AddGroupBottomSheetState();
}

class _AddGroupBottomSheetState extends State<AddGroupBottomSheet> {
  late final TextEditingController _groupNameController;
  late final TextEditingController _collectorNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _groupNameController = TextEditingController();
    _collectorNameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _collectorNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final sheetBg = isDark ? ColorManager.darkSurface : ColorManager.white;
    final primaryTextColor = isDark
        ? ColorManager.white
        : ColorManager.navyText;
    final dragHandleColor = isDark
        ? ColorManager.darkSlateText
        : ColorManager.greySecondaryText;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: REdgeInsets.all(20),
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: REdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: dragHandleColor.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              Text(
                appLocalizations.addNewGroup,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
              SizedBox(height: 20.h),
              CustomersAddTextFormField(
                labelText: appLocalizations.groupName,
                hintText: appLocalizations.enter_group_name,
                controller: _groupNameController,
                prefixIcon: Icon(Icons.folder_outlined, size: 22.r),
              ),
              SizedBox(height: 14.h),
              CustomersAddTextFormField(
                labelText: appLocalizations.collectorName,
                hintText: appLocalizations.enter_responsible_person_name,
                controller: _collectorNameController,
                prefixIcon: Icon(Icons.person_outline, size: 22.r),
              ),
              SizedBox(height: 14.h),
              CustomersAddTextFormField(
                labelText: appLocalizations.phoneNumber,
                hintText: appLocalizations.enter_phone_number,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                prefixIcon: Icon(Icons.phone_outlined, size: 22.r),
              ),
              SizedBox(height: 14.h),
              CustomersAddTextFormField(
                labelText: appLocalizations.address,
                hintText: appLocalizations.enter_address,
                controller: _addressController,
                prefixIcon: Icon(Icons.location_on_outlined, size: 22.r),
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(appLocalizations.save),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
