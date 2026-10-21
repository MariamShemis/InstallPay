import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/utils/ui_utils.dart';
import 'package:smart_installment_management/features/edit_profile/data/cubit/edit_profile_cubit.dart';
import 'package:smart_installment_management/features/edit_profile/data/cubit/edit_profile_state.dart';
import 'package:smart_installment_management/features/edit_profile/presentation/widgets/custom_profile_field.dart';
import 'package:smart_installment_management/features/edit_profile/presentation/widgets/profile_birthday_field.dart';
import 'package:smart_installment_management/features/edit_profile/presentation/widgets/profile_gender_dropdown.dart';
import 'package:smart_installment_management/features/main_layout/profile/presentation/widgets/user_image_profile.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _jobController = TextEditingController();
  final _birthdayController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  String? _selectedGender;
  String? _imageUrl;
  File? _profileImage;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    context.read<EditProfileCubit>().loadProfile(context);
  }

  Widget _defaultProfileImage() {
    return Container(
      color: ColorManager.navyDark,
      alignment: Alignment.center,
      child: Icon(Icons.person, size: 45.sp, color: ColorManager.white),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _jobController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  void _fillProfileFields(EditProfileLoaded state) {
    final user = state.user;

    _nameController.text = user.name;
    _emailController.text = user.email;
    _phoneController.text = user.phoneNumber;
    _jobController.text = user.jobTitle ?? '';
    _birthdayController.text = user.birthday ?? '';

    _selectedGender = user.gender;
    _imageUrl = user.image;
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.of(context).pop();

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile == null || !mounted) return;

      setState(() {
        _profileImage = File(pickedFile.path);
      });
    } catch (_) {
      if (!mounted) return;
      UiUtils.showError(
        context,
        AppLocalizations.of(context)!.something_went_wrong_Please_try_again,
      );
    }
  }

  void _saveProfileToFirebase() {
    final appLocalizations = AppLocalizations.of(context)!;

    if (_nameController.text.trim().isEmpty) {
      UiUtils.showError(context, appLocalizations.nameRequired);
      return;
    }

    if (_phoneController.text.trim().isEmpty) {
      UiUtils.showError(context, appLocalizations.phoneNumberRequired);
      return;
    }

    context.read<EditProfileCubit>().updateProfile(
      context: context,
      name: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      jobTitle: _jobController.text.trim(),
      birthday: _birthdayController.text.trim(),
      gender: _selectedGender,
      imageFile: _profileImage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.editProfile),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<EditProfileCubit, EditProfileState>(
        listener: (context, state) {
          // if (state is EditProfileLoaded) {
          //   setState(() {
          //     _fillProfileFields(state);
          //   });
          // }
          if (state is EditProfileLoaded) {
            _nameController.text = state.user.name;
            _emailController.text = state.user.email;
            _phoneController.text = state.user.phoneNumber;
            _jobController.text = state.user.jobTitle ?? '';
            _birthdayController.text = state.user.birthday ?? '';

            _selectedGender = state.user.gender;
            _imageUrl = state.user.image;
          }

          if (state is EditProfileSaving) {
            _isSaving = true;
            UiUtils.showLoading(context, isDismissible: false);
          }

          if (state is EditProfileSuccess) {
            if (_isSaving) {
              UiUtils.hideLoading(context);
              _isSaving = false;
            }

            _imageUrl = state.user.image;

            UiUtils.showSuccess(
              context,
              appLocalizations.profileUpdatedSuccessfully,
            );

            Navigator.pop(context, true);
          }

          if (state is EditProfileError) {
            if (_isSaving) {
              UiUtils.hideLoading(context);
              _isSaving = false;
            }

            UiUtils.showError(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is EditProfileLoading &&
              context.read<EditProfileCubit>().currentUser == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EditProfileError &&
              context.read<EditProfileCubit>().currentUser == null) {
            return Center(
              child: Padding(
                padding: REdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 42),
                    SizedBox(height: 12.h),
                    Text(state.message, textAlign: TextAlign.center),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        context.read<EditProfileCubit>().loadProfile(context);
                      },
                      child: Text(appLocalizations.retry ?? 'Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: REdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: UserImageProfile(
                    radius: 18.r,
                    onTap: _showBottomSheetImage,
                    image: CircleAvatar(
                      radius: 50.r,
                      backgroundColor: ColorManager.navyDark,
                      child: ClipOval(
                        child: SizedBox(
                          width: 100.r,
                          height: 100.r,
                          child: _profileImage != null
                              ? Image.file(
                                  _profileImage!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _defaultProfileImage();
                                  },
                                )
                              : (_imageUrl != null &&
                                    _imageUrl!.trim().isNotEmpty)
                              ? Image.network(
                                  _imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _defaultProfileImage();
                                  },
                                )
                              : _defaultProfileImage(),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                CustomProfileField(
                  title: appLocalizations.name.toUpperCase(),
                  hintText: appLocalizations.enterYourName,
                  controller: _nameController,
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                ),
                SizedBox(height: 16.h),
                CustomProfileField(
                  title: appLocalizations.email.toUpperCase(),
                  hintText: appLocalizations.enterYourEmail,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  readOnly: true,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                SizedBox(height: 16.h),
                CustomProfileField(
                  title: appLocalizations.phoneNumber.toUpperCase(),
                  hintText: appLocalizations.enterYourPhoneNumber,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),
                SizedBox(height: 16.h),
                CustomProfileField(
                  title: appLocalizations.jobTitle.toUpperCase(),
                  hintText: appLocalizations.enter_your_job,
                  controller: _jobController,
                  prefixIcon: const Icon(Icons.work_outline_rounded),
                ),
                SizedBox(height: 16.h),
                ProfileBirthdayField(controller: _birthdayController),
                SizedBox(height: 16.h),
                ProfileGenderDropdown(
                  selectedValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                SizedBox(height: 32.h),
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveProfileToFirebase,
                    child: Text(
                      appLocalizations.saveChanges.toUpperCase(),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30.h),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showBottomSheetImage() {
    final appLocalizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? ColorManager.darkSurface : ColorManager.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: REdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: isDark
                      ? ColorManager.darkMutedText.withOpacity(0.3)
                      : ColorManager.greyText.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),

              SizedBox(height: 20.h),

              ListTile(
                leading: Icon(
                  Icons.photo_camera_outlined,
                  color: isDark
                      ? ColorManager.darkAccentGreen
                      : ColorManager.primaryColor,
                ),
                title: Text(appLocalizations.take_a_photo),
                onTap: () => _pickImage(ImageSource.camera),
              ),

              ListTile(
                leading: Icon(
                  Icons.photo_library_outlined,
                  color: isDark
                      ? ColorManager.darkAccentGreen
                      : ColorManager.primaryColor,
                ),
                title: Text(appLocalizations.choose_from_gallery),
                onTap: () => _pickImage(ImageSource.gallery),
              ),

              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
  }
}
