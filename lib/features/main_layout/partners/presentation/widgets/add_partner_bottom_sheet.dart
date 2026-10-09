import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/utils/extensions/extensions.dart';
import 'package:smart_installment_management/features/add_customer/presentation/widgets/customer_add_text_form_field.dart';
import 'package:smart_installment_management/features/main_layout/partners/data/model/partner_model.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class AddPartnerBottomSheet extends StatefulWidget {
  final Function(PartnerModel partner)? onPartnerAdded;

  const AddPartnerBottomSheet({super.key, this.onPartnerAdded});

  static void show(
      BuildContext context, {
        Function(PartnerModel partner)? onPartnerAdded,
      }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          AddPartnerBottomSheet(onPartnerAdded: onPartnerAdded),
    );
  }

  @override
  State<AddPartnerBottomSheet> createState() => _AddPartnerBottomSheetState();
}

class _AddPartnerBottomSheetState extends State<AddPartnerBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  late final TextEditingController _mainCapitalController;
  late final TextEditingController _profitMarginController;

  PartnerType _selectedType = PartnerType.admin;
  double _calculatedNewCapital = 0.0;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _mainCapitalController = TextEditingController();
    _profitMarginController = TextEditingController(text: '100');

    _mainCapitalController.addListener(_calculateNewCapital);
    _profitMarginController.addListener(_calculateNewCapital);
  }

  void _calculateNewCapital() {
    final mainCapital =
        double.tryParse(_mainCapitalController.text.trim()) ?? 0.0;
    final profitMargin =
        double.tryParse(_profitMarginController.text.trim()) ?? 0.0;

    setState(() {
      _calculatedNewCapital =
          mainCapital + (mainCapital * (profitMargin / 100));
    });
  }

  void _onTypeChanged(PartnerType type) {
    setState(() {
      _selectedType = type;
      if (type == PartnerType.admin) {
        _profitMarginController.text = '100';
      } else {
        if (_profitMarginController.text == '100') {
          _profitMarginController.clear();
        }
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _mainCapitalController.dispose();
    _profitMarginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currency = context.currencySymbol;

    final cardBg = isDark ? ColorManager.darkSurface : ColorManager.white;
    final primaryTextColor =
    isDark ? ColorManager.white : ColorManager.navyText;
    final secondaryTextColor =
    isDark ? ColorManager.darkMutedText : ColorManager.greyDark;
    final primaryColor = isDark
        ? ColorManager.darkAccentGreen
        : ColorManager.primaryColor;
    final boxBg = isDark
        ? ColorManager.darkSurfaceVariant
        : ColorManager.blueSoftBackground;
    final borderColor = isDark
        ? ColorManager.whiteOpacity20
        : ColorManager.blueLightTint;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: REdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42.w,
                    height: 4.5.h,
                    decoration: BoxDecoration(
                      color: secondaryTextColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                Center(
                  child: Text(
                    l10n.addNewPartner,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 38.r,
                        backgroundColor: boxBg,
                        child: Icon(
                          Icons.person_outline_rounded,
                          size: 38.r,
                          color: primaryColor,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 13.r,
                          backgroundColor: primaryColor,
                          child: Icon(
                            Icons.add_a_photo_outlined,
                            size: 13.r,
                            color: ColorManager.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                Text(
                  l10n.partnerType,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 8.h),

                // ChoiceChips row (Admin -> Primary -> Secondary)
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: Center(
                          child: Text(
                            'Admin',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: _selectedType == PartnerType.admin
                                  ? ColorManager.white
                                  : primaryTextColor,
                            ),
                          ),
                        ),
                        selected: _selectedType == PartnerType.admin,
                        selectedColor: primaryColor,
                        backgroundColor: boxBg,
                        side: BorderSide(
                          color: _selectedType == PartnerType.admin
                              ? primaryColor
                              : borderColor,
                        ),
                        onSelected: (selected) {
                          if (selected) _onTypeChanged(PartnerType.admin);
                        },
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: ChoiceChip(
                        label: Center(
                          child: Text(
                            l10n.primaryPartner,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: _selectedType == PartnerType.primary
                                  ? ColorManager.white
                                  : primaryTextColor,
                            ),
                          ),
                        ),
                        selected: _selectedType == PartnerType.primary,
                        selectedColor: primaryColor,
                        backgroundColor: boxBg,
                        side: BorderSide(
                          color: _selectedType == PartnerType.primary
                              ? primaryColor
                              : borderColor,
                        ),
                        onSelected: (selected) {
                          if (selected) _onTypeChanged(PartnerType.primary);
                        },
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: ChoiceChip(
                        label: Center(
                          child: Text(
                            l10n.secondaryPartner,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: _selectedType == PartnerType.secondary
                                  ? ColorManager.white
                                  : primaryTextColor,
                            ),
                          ),
                        ),
                        selected: _selectedType == PartnerType.secondary,
                        selectedColor: primaryColor,
                        backgroundColor: boxBg,
                        side: BorderSide(
                          color: _selectedType == PartnerType.secondary
                              ? primaryColor
                              : borderColor,
                        ),
                        onSelected: (selected) {
                          if (selected) _onTypeChanged(PartnerType.secondary);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),

                CustomersAddTextFormField(
                  labelText: l10n.partnerName,
                  hintText: 'e.g. John Doe',
                  controller: _nameController,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? l10n.this_field_is_required
                      : null,
                  prefixIcon: const Icon(Icons.person_outlined),
                ),
                SizedBox(height: 12.h),

                CustomersAddTextFormField(
                  labelText: l10n.address,
                  hintText: 'e.g. 123 Main St, New York',
                  controller: _addressController,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? l10n.this_field_is_required
                      : null,
                  prefixIcon: const Icon(Icons.location_on_outlined),
                ),
                SizedBox(height: 12.h),

                CustomersAddTextFormField(
                  labelText: l10n.phoneNumber,
                  hintText: 'e.g. +1 234 567 8900',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? l10n.this_field_is_required
                      : null,
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),
                SizedBox(height: 12.h),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: CustomersAddTextFormField(
                        labelText: l10n.mainCapital,
                        hintText: 'e.g. 50000',
                        controller: _mainCapitalController,
                        keyboardType: TextInputType.number,
                        isCurrency: true,
                        validator: (value) =>
                        value == null || value.trim().isEmpty
                            ? l10n.this_field_is_required
                            : null,
                        prefixIcon: const Icon(
                          Icons.account_balance_wallet_outlined,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      flex: 2,
                      child: CustomersAddTextFormField(
                        labelText: l10n.profitMargin,
                        hintText: 'e.g. 15',
                        controller: _profitMarginController,
                        enabled: _selectedType != PartnerType.admin,
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                        value == null || value.trim().isEmpty
                            ? l10n.this_field_is_required
                            : null,
                        prefixIcon: const Icon(Icons.percent_rounded),
                        suffixIcon: Padding(
                          padding: REdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '%',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.sp,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),

                Container(
                  padding: REdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: boxBg,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.newCapitalCalculated,
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          color: secondaryTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${_calculatedNewCapital.toStringAsFixed(0)} $currency',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
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
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        final partner = PartnerModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: _nameController.text.trim(),
                          address: _addressController.text.trim(),
                          phone: _phoneController.text.trim(),
                          mainCapital: double.parse(
                            _mainCapitalController.text.trim(),
                          ),
                          profitMargin: double.parse(
                            _profitMarginController.text.trim(),
                          ),
                          type: _selectedType,
                        );
                        if (widget.onPartnerAdded != null) {
                          widget.onPartnerAdded!(partner);
                        }
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: ColorManager.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      l10n.addPartnerBtn,
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
}