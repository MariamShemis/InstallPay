import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/firebase/taqseet_firestore_services.dart';
import 'package:smart_installment_management/core/services/cloudinary_services.dart';
import 'package:smart_installment_management/core/utils/ui_utils.dart';
import 'package:smart_installment_management/features/add_customer/presentation/widgets/customer_add_text_form_field.dart';
import 'package:smart_installment_management/features/main_layout/groups/data/cubit/group_cubit.dart';
import 'package:smart_installment_management/features/main_layout/groups/data/model/group_model.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class AddGroupBottomSheet extends StatefulWidget {
  final GroupModel? group;

  const AddGroupBottomSheet({super.key, this.group});

  static Future<void> show(BuildContext context) {
    final groupsCubit = context.read<GroupsCubit>();

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BlocProvider<GroupsCubit>.value(
          value: groupsCubit,
          child: const AddGroupBottomSheet(),
        );
      },
    );
  }

  static Future<bool?> showEdit(BuildContext context, GroupModel group) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return AddGroupBottomSheet(group: group);
      },
    );
  }

  @override
  State<AddGroupBottomSheet> createState() => _AddGroupBottomSheetState();
}

class _AddGroupBottomSheetState extends State<AddGroupBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _groupNameController = TextEditingController();

  final TextEditingController _collectorNameController =
      TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  File? _selectedImage;
  String? _existingImageUrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final group = widget.group;

    if (group != null) {
      _groupNameController.text = group.groupTitle;
      _collectorNameController.text = group.collectorName;
      _phoneController.text = group.collectorPhone;
      _addressController.text = group.address;
    }
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _collectorNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();

      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1000,
      );

      if (pickedFile == null || !mounted) return;

      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not select image: $error')));
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));

    if (name.trim().isEmpty) return 'U';

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  Future<void> _saveGroup() async {
    if (_isSaving) return;

    final groupName = _groupNameController.text.trim();
    final collectorName = _collectorNameController.text.trim();

    // Group name and collector name are required.
    if (groupName.isEmpty || collectorName.isEmpty) {
      UiUtils.showError(context, AppLocalizations.of(context)!.requiredField);
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    bool success = false;

    try {
      final existingGroup = widget.group;

      if (existingGroup == null) {
        // Add a new group.
        success = await context.read<GroupsCubit>().addGroup(
          groupTitle: groupName,
          collectorName: collectorName,
          collectorPhone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
          image: _selectedImage,
        );
      } else {
        // Edit the existing group.
        String? imageUrl = _existingImageUrl;

        if (_selectedImage != null) {
          imageUrl = await CloudinaryServices.uploadImage(_selectedImage!);
        }

        final updatedGroup = existingGroup.copyWith(
          groupTitle: groupName,
          collectorName: collectorName,
          collectorPhone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
          imageUrl: imageUrl,
        );

        await TaqseetFirestoreServices.saveRecord(
          type: 'group',
          documentId: existingGroup.id,
          data: updatedGroup.toMap(),
        );

        success = true;
      }
    } catch (error) {
      success = false;
    }

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    if (success) {
      Navigator.of(context).pop(true);
    } else {
      UiUtils.showError(context, AppLocalizations.of(context)!.operationFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final sheetBg = isDark ? ColorManager.darkSurface : ColorManager.white;

    final primaryTextColor = isDark
        ? ColorManager.white
        : ColorManager.navyText;

    final secondaryTextColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    final avatarBg = isDark ? const Color(0xFF17324D) : const Color(0xFFE2E8F0);

    final avatarTextColor = isDark
        ? const Color(0xFF34D399)
        : const Color(0xFF006C4D);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        padding: REdgeInsets.all(20),
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Form(
          key: _formKey,
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
                      color: secondaryTextColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                Text(
                  widget.group == null
                      ? appLocalizations.addNewGroup
                      : appLocalizations.editGroup,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),
                SizedBox(height: 20.h),

                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _isSaving ? null : _pickImage,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 43.r,
                              backgroundColor: avatarBg,
                              backgroundImage: _selectedImage != null
                                  ? FileImage(_selectedImage!)
                                  : (_existingImageUrl != null &&
                                            _existingImageUrl!.trim().isNotEmpty
                                        ? NetworkImage(_existingImageUrl!)
                                        : null),
                              child:
                                  _selectedImage == null &&
                                      (_existingImageUrl == null ||
                                          _existingImageUrl!.trim().isEmpty)
                                  ? Icon(
                                      Icons.group_outlined,
                                      size: 36.r,
                                      color: avatarTextColor,
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: REdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF15966D)
                                      : const Color(0xFF006C4D),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: sheetBg, width: 2),
                                ),
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                  size: 17.r,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 8.h),

                      Text(
                        'Add optional profile photo',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: secondaryTextColor,
                        ),
                      ),

                      if (_selectedImage != null)
                        TextButton.icon(
                          onPressed: _isSaving
                              ? null
                              : () {
                                  setState(() {
                                    _selectedImage = null;
                                  });
                                },
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Remove photo'),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

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

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveGroup,
                    style: ElevatedButton.styleFrom(
                      padding: REdgeInsets.symmetric(vertical: 14),
                      backgroundColor: isDark
                          ? const Color(0xFF15966D)
                          : const Color(0xFF006C4D),
                      foregroundColor: Colors.white,
                    ),
                    child: _isSaving
                        ? SizedBox(
                            width: 22.r,
                            height: 22.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            widget.group == null
                                ? appLocalizations.save
                                : appLocalizations.saveChanges,
                          ),
                  ),
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
