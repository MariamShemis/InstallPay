import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/utils/extensions/extensions.dart';
import 'package:smart_installment_management/core/utils/ui_utils.dart';
import 'package:smart_installment_management/features/main_layout/partners/data/model/partner_model.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class AddPartnerBottomSheet extends StatefulWidget {
  final Future<bool> Function(PartnerModel partner, {File? imageFile})?
  onPartnerAdded;
  final PartnerModel? partnerToEdit;
  final double adminProfitMargin;
  final double secondaryProfitTotal;

  const AddPartnerBottomSheet({
    super.key,
    this.onPartnerAdded,
    this.partnerToEdit,
    this.adminProfitMargin = 100,
    this.secondaryProfitTotal = 0,
  });

  static void show(
    BuildContext context, {
    final Future<bool> Function(PartnerModel partner, {File? imageFile})?
    onPartnerAdded,
    PartnerModel? partnerToEdit,
    double adminProfitMargin = 100,
    double secondaryProfitTotal = 0,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddPartnerBottomSheet(
        onPartnerAdded: onPartnerAdded,
        partnerToEdit: partnerToEdit,
        adminProfitMargin: adminProfitMargin,
        secondaryProfitTotal: secondaryProfitTotal,
      ),
    );
  }

  @override
  State<AddPartnerBottomSheet> createState() => _AddPartnerBottomSheetState();
}

class _AddPartnerBottomSheetState extends State<AddPartnerBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  late final TextEditingController _capitalController;
  late final TextEditingController _profitController;

  PartnerType _selectedType = PartnerType.secondary;
  File? _selectedImage;
  String? _existingImageUrl;
  bool _isSaving = false;
  double _newCapital = 0;

  bool get _isEditing => widget.partnerToEdit != null;
  bool _removeExistingImage = false;

  @override
  void initState() {
    super.initState();

    final partner = widget.partnerToEdit;

    _selectedType = partner?.type ?? PartnerType.secondary;
    _existingImageUrl = partner?.imagePath;

    _nameController = TextEditingController(text: partner?.name ?? '');
    _addressController = TextEditingController(text: partner?.address ?? '');
    _phoneController = TextEditingController(text: partner?.phone ?? '');
    _capitalController = TextEditingController(
      text: partner == null ? '' : partner.mainCapital.toString(),
    );
    _profitController = TextEditingController(
      text: partner == null
          ? ''
          : partner.isAdmin
          ? '100'
          : partner.profitMargin.toString(),
    );

    _capitalController.addListener(_calculateNewCapital);
    _profitController.addListener(_calculateNewCapital);

    _calculateNewCapital();
  }

  void _calculateNewCapital() {
    final capital = double.tryParse(_capitalController.text.trim()) ?? 0;

    final profit = _selectedType == PartnerType.admin
        ? 100.0
        : double.tryParse(_profitController.text.trim()) ?? 0;

    if (!mounted) return;

    setState(() {
      _newCapital = capital + capital * profit / 100;
    });
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1200,
      );

      if (pickedFile == null || !mounted) return;

      setState(() {
        _selectedImage = File(pickedFile.path);
        _removeExistingImage = false;
      });
    } catch (error) {
      if (!mounted) return;

      UiUtils.showError(context, AppLocalizations.of(context)!.operationFailed);
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _existingImageUrl = null;
      _removeExistingImage = true;
    });
  }

  void _changeType(PartnerType type) {
    setState(() {
      _selectedType = type;

      if (type == PartnerType.admin) {
        _profitController.text = widget.adminProfitMargin.toString();
      } else if (type == PartnerType.primary) {
        _profitController.text = '100';
      } else if (!_isEditing || widget.partnerToEdit!.type != type) {
        _profitController.clear();
      }
    });

    _calculateNewCapital();
  }

  Future<void> _savePartner() async {
    if (_isSaving) return;

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final l10n = AppLocalizations.of(context)!;
    final capital = double.tryParse(_capitalController.text.trim());

    final profit = _selectedType == PartnerType.admin
        ? widget.adminProfitMargin
        : double.tryParse(_profitController.text.trim());

    if (capital == null || capital < 0) {
      UiUtils.showToast(l10n.invalidMainCapital);
      return;
    }

    if (profit == null || profit < 0 || profit > 100) {
      UiUtils.showToast(l10n.invalidProfitMargin);
      return;
    }

    final save = widget.onPartnerAdded;

    if (save == null) {
      UiUtils.showError(context, l10n.operationFailed);
      return;
    }

    setState(() {
      _isSaving = true;
    });

    UiUtils.showLoading(context);

    var success = false;

    try {
      final oldPartner = widget.partnerToEdit;

      final partner = PartnerModel(
        id: oldPartner?.id ?? '',
        name: _nameController.text.trim(),
        imagePath: _removeExistingImage ? '' : _existingImageUrl,
        address: _addressController.text.trim(),
        phone: _phoneController.text.trim(),
        mainCapital: capital,
        profitMargin: profit,
        type: _selectedType,
      );
      success = await save(partner, imageFile: _selectedImage);
    } catch (error, stackTrace) {
      debugPrint('Save partner error: $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      UiUtils.hideLoading(context);
    }

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    if (!success) {
      UiUtils.showError(context, l10n.operationFailed);
      return;
    }

    Navigator.of(context).pop();

    UiUtils.showToast(
      _isEditing
          ? l10n.partnerUpdatedSuccessfully
          : l10n.partnerAddedSuccessfully,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _capitalController.dispose();
    _profitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currency = context.currencySymbol;

    final background = isDark ? ColorManager.darkSurface : ColorManager.white;
    final fieldBackground = isDark
        ? ColorManager.darkSurfaceVariant
        : ColorManager.blueSoftBackground;
    final textColor = isDark ? ColorManager.white : ColorManager.navyText;
    final mutedColor = isDark
        ? ColorManager.darkMutedText
        : ColorManager.greyDark;
    final accentColor = isDark
        ? ColorManager.darkAccentGreen
        : ColorManager.primaryColor;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SingleChildScrollView(
          padding: REdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: mutedColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Center(
                  child: Text(
                    _isEditing ? l10n.editPartner : l10n.addNewPartner,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GestureDetector(
                        onTap: _isSaving ? null : _pickImage,
                        child: CircleAvatar(
                          radius: 43.r,
                          backgroundColor: fieldBackground,
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : (_existingImageUrl != null &&
                                        _existingImageUrl!.isNotEmpty
                                    ? NetworkImage(_existingImageUrl!)
                                    : null),
                          child:
                              _selectedImage == null &&
                                  (_existingImageUrl == null ||
                                      _existingImageUrl!.isEmpty)
                              ? Icon(
                                  Icons.person_outline_rounded,
                                  size: 42.r,
                                  color: accentColor,
                                )
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _isSaving ? null : _pickImage,
                          child: CircleAvatar(
                            radius: 15.r,
                            backgroundColor: accentColor,
                            child: Icon(
                              Icons.add_a_photo_outlined,
                              size: 15.r,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      if (_selectedImage != null ||
                          (_existingImageUrl != null &&
                              _existingImageUrl!.isNotEmpty))
                        Positioned(
                          top: -4,
                          left: -4,
                          child: GestureDetector(
                            onTap: _isSaving ? null : _removeImage,
                            child: CircleAvatar(
                              radius: 15.r,
                              backgroundColor: Colors.red,
                              child: Icon(
                                Icons.close,
                                size: 17.r,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Center(
                  child: Text(
                    l10n.choosePartnerPhoto,
                    style: TextStyle(color: mutedColor, fontSize: 12.sp),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  l10n.partnerType,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    _typeChip(
                      label: l10n.admin,
                      type: PartnerType.admin,
                      accentColor: accentColor,
                      fieldBackground: fieldBackground,
                      textColor: textColor,
                    ),
                    SizedBox(width: 6.w),
                    _typeChip(
                      label: l10n.primaryPartner,
                      type: PartnerType.primary,
                      accentColor: accentColor,
                      fieldBackground: fieldBackground,
                      textColor: textColor,
                    ),
                    SizedBox(width: 6.w),
                    _typeChip(
                      label: l10n.secondaryPartner,
                      type: PartnerType.secondary,
                      accentColor: accentColor,
                      fieldBackground: fieldBackground,
                      textColor: textColor,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                _inputField(
                  label: l10n.partnerName,
                  controller: _nameController,
                  hint: l10n.enterName,
                  icon: Icons.person_outline,
                  textColor: textColor,
                  fieldBackground: fieldBackground,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.this_field_is_required;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.h),
                _inputField(
                  label: l10n.address,
                  controller: _addressController,
                  hint: l10n.enter_address,
                  icon: Icons.location_on_outlined,
                  textColor: textColor,
                  fieldBackground: fieldBackground,
                ),
                SizedBox(height: 12.h),
                _inputField(
                  label: l10n.phoneNumber,
                  controller: _phoneController,
                  hint: l10n.enter_phone_number,
                  icon: Icons.phone_outlined,
                  textColor: textColor,
                  fieldBackground: fieldBackground,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 12.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _inputField(
                        label: l10n.mainCapital,
                        controller: _capitalController,
                        hint: '0.00',
                        icon: Icons.account_balance_wallet_outlined,
                        textColor: textColor,
                        fieldBackground: fieldBackground,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.this_field_is_required;
                          }

                          final amount = double.tryParse(value.trim());

                          if (amount == null || amount < 0) {
                            return l10n.invalidMainCapital;
                          }

                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _inputField(
                        label: l10n.profitMargin,
                        controller: _profitController,
                        hint: _selectedType == PartnerType.admin ? '100' : '0',
                        icon: Icons.percent_rounded,
                        textColor: textColor,
                        fieldBackground: fieldBackground,
                        enabled: _selectedType != PartnerType.admin,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) {
                          if (_selectedType == PartnerType.admin) return null;

                          if (value == null || value.trim().isEmpty) {
                            return l10n.this_field_is_required;
                          }

                          final percentage = double.tryParse(value.trim());

                          if (percentage == null ||
                              percentage < 0 ||
                              percentage > 100) {
                            return l10n.invalidProfitMargin;
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                if (_selectedType == PartnerType.admin) ...[
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: REdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: fieldBackground,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${l10n.admin}: 100%',
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          '${l10n.secondaryProfitTotal}: '
                          '${widget.secondaryProfitTotal.toStringAsFixed(0)}%',
                          style: TextStyle(color: mutedColor, fontSize: 13.sp),
                        ),
                      ],
                    ),
                  ),
                ],

                SizedBox(height: 14.h),
                Container(
                  width: double.infinity,
                  padding: REdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: fieldBackground,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: accentColor.withOpacity(0.25)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.newCapitalCalculated,
                          style: TextStyle(color: mutedColor, fontSize: 12.sp),
                        ),
                      ),
                      Text(
                        '${_newCapital.toStringAsFixed(2)} $currency',
                        style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _savePartner,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      _isEditing ? l10n.updatePartner : l10n.addPartnerBtn,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _typeChip({
    required String label,
    required PartnerType type,
    required Color accentColor,
    required Color fieldBackground,
    required Color textColor,
  }) {
    final selected = _selectedType == type;

    return Expanded(
      child: ChoiceChip(
        label: SizedBox(
          width: double.infinity,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.sp,
              color: selected ? Colors.white : textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        selected: selected,
        selectedColor: accentColor,
        backgroundColor: fieldBackground,
        showCheckmark: false,
        onSelected: (value) {
          if (value) _changeType(type);
        },
      ),
    );
  }

  Widget _inputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Color textColor,
    required Color fieldBackground,
    TextInputType? keyboardType,
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(color: textColor, fontSize: 13.sp),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 19.r),
            filled: true,
            fillColor: fieldBackground,
            contentPadding: REdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
