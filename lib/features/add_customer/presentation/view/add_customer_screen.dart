import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/firebase/taqseet_firestore_services.dart';
import 'package:smart_installment_management/core/utils/ui_utils.dart';
import 'package:smart_installment_management/features/add_customer/data/cubit/add_customer_cubit.dart';
import 'package:smart_installment_management/features/add_customer/data/cubit/add_customer_state.dart';
import 'package:smart_installment_management/features/add_customer/presentation/widgets/confirm_contract_dialog.dart';
import 'package:smart_installment_management/features/add_customer/presentation/widgets/contract_information_card.dart';
import 'package:smart_installment_management/features/add_customer/presentation/widgets/personal_information_card.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  String _selectedGroupId = '';
  String _selectedGroupName = 'Other';

  File? _selectedImage;

  final AddCustomerCubit _addCustomerCubit = AddCustomerCubit();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  final _contractDateController = TextEditingController();
  final _contractNameController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _installmentAmountController = TextEditingController();
  final _firstInstallmentDateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _advancePaymentController = TextEditingController();
  final _totalCostController = TextEditingController();
  final _debtAmountController = TextEditingController();
  String _installmentType = 'Monthly';

  @override
  void initState() {
    super.initState();

    _contractDateController.text =
    DateTime.now().toString().split(' ')[0];

    _totalCostController.addListener(_calculateDebt);
    _advancePaymentController.addListener(_calculateDebt);
    _installmentAmountController.addListener(_calculateDebt);

    _calculateDebt();
  }

  CustomerModel _buildCustomerModel() {
    final sellingPrice = double.tryParse(_totalCostController.text) ?? 0;

    final purchasePrice = double.tryParse(_purchasePriceController.text) ?? 0;

    final downPayment = double.tryParse(_advancePaymentController.text) ?? 0;
    final debtAmount = double.tryParse(_debtAmountController.text) ?? 0;

    final installmentsCount = _calculateInstallmentsCount();

    final installmentAmount =
        double.tryParse(_installmentAmountController.text.trim()) ?? 0;

    return CustomerModel(
      customerName: _nameController.text.trim(),
      customerPhone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      groupId: _selectedGroupId,
      groupName: _selectedGroupName,
      contractDate: _contractDateController.text,
      contractName: _contractNameController.text.trim(),
      purchasePrice: purchasePrice,
      sellingPrice: sellingPrice,
      downPayment: downPayment,
      debtAmount: debtAmount,

      installmentAmount: installmentAmount,
      installmentType: _installmentType,
      installmentsCount: installmentsCount,
      firstInstallmentDate: _firstInstallmentDateController.text,
      paidValue: 0,
      status: 'Up to Date',
      nextDueDate: _firstInstallmentDateController.text,
      description: _descriptionController.text.trim(),

      downPaymentPaidAtDate:_contractDateController.text
          ,
    );
  }

  Future<void> _saveCustomer() async {
    UiUtils.showLoading(context);

    await _addCustomerCubit.addCustomer(
      customer: _buildCustomerModel(),
      image: _selectedImage,
    );

    if (!mounted) return;

    UiUtils.hideLoading(context);

    final state = _addCustomerCubit.state;

    if (state is AddCustomerSuccess) {
      UiUtils.showToast('Customer added successfully');

      Navigator.of(context).pop(state.customer);
    } else if (state is AddCustomerFailure) {
      UiUtils.showError(context, state.message);
    }
  }

  int _calculateInstallmentsCount() {
    final sellingPrice =
        double.tryParse(_totalCostController.text.trim()) ?? 0;

    final downPayment =
        double.tryParse(_advancePaymentController.text.trim()) ?? 0;

    final installmentAmount =
        double.tryParse(_installmentAmountController.text.trim()) ?? 0;

    final debt = _addCustomerCubit.calculateDebt(
      sellingPrice,
      downPayment,
    );

    return _addCustomerCubit.calculateInstallmentsCount(
      debt: debt,
      installmentAmount: installmentAmount,
    );
  }

  @override
  void dispose() {
    _totalCostController.removeListener(_calculateDebt);
    _advancePaymentController.removeListener(_calculateDebt);
    _installmentAmountController.removeListener(_calculateDebt);

    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();

    _contractDateController.dispose();
    _contractNameController.dispose();
    _purchasePriceController.dispose();
    _installmentAmountController.dispose();
    _firstInstallmentDateController.dispose();
    _descriptionController.dispose();
    _advancePaymentController.dispose();
    _totalCostController.dispose();
    _debtAmountController.dispose();

    _addCustomerCubit.close();

    super.dispose();
  }

  void _showConfirmDialog() {
    final debt = double.tryParse(_debtAmountController.text.trim()) ?? 0;
    final installmentAmount =
        double.tryParse(_installmentAmountController.text.trim()) ?? 0;

    if (debt > 0 && installmentAmount <= 0) {
      UiUtils.showError(context, 'Please enter a valid installment amount.');
      return;
    }

    if (debt > 0 &&
        _firstInstallmentDateController.text.trim().isEmpty) {
      UiUtils.showError(
        context,
        'Please select the first installment date.',
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) => ConfirmContractDialog(
        groupName: _selectedGroupName,
        customerName: _nameController.text.isEmpty
            ? 'N/A'
            : _nameController.text,
        phone: _phoneController.text.isEmpty ? 'N/A' : _phoneController.text,
        address: _addressController.text.isEmpty
            ? 'N/A'
            : _addressController.text,
        contractDate: _contractDateController.text.isEmpty
            ? 'N/A'
            : _contractDateController.text,
        contractName: _contractNameController.text.isEmpty
            ? 'N/A'
            : _contractNameController.text,
        purchasePrice: _purchasePriceController.text.isEmpty
            ? '0'
            : _purchasePriceController.text,
        installmentAmount: _installmentAmountController.text.isEmpty
            ? '0'
            : _installmentAmountController.text,
        installmentType: _installmentType,
        installmentsCount: _calculateInstallmentsCount(),
        firstInstallmentDate: _firstInstallmentDateController.text.isEmpty
            ? 'N/A'
            : _firstInstallmentDateController.text,
        advancePayment: _advancePaymentController.text.isEmpty
            ? '0'
            : _advancePaymentController.text,
        totalCost: _totalCostController.text.isEmpty
            ? '0'
            : _totalCostController.text,
        debtAmount: _debtAmountController.text.isEmpty
            ? '0'
            : _debtAmountController.text,
        description: _descriptionController.text.isEmpty
            ? 'N/A'
            : _descriptionController.text,
        onConfirm: () {
          _saveCustomer();
        },
      ),
    );
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = pickedDate.toString().split(' ')[0];
      });
    }
  }

  void _calculateDebt() {
    final sellingPrice = double.tryParse(_totalCostController.text) ?? 0;

    final downPayment = double.tryParse(_advancePaymentController.text) ?? 0;

    final debt = _addCustomerCubit.calculateDebt(sellingPrice, downPayment);

    final formattedDebt = debt.toStringAsFixed(2);

    if (_debtAmountController.text != formattedDebt) {
      _debtAmountController.text = formattedDebt;
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(appLocalizations.addNewCustomer),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: REdgeInsets.all(16),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: TaqseetFirestoreServices.recordsStream(type: 'group'),
                builder: (context, snapshot) {
                  final List<MapEntry<String, String>> groupsList = [
                    const MapEntry('', 'Other'),
                  ];

                  if (snapshot.hasData) {
                    for (final document in snapshot.data!.docs) {
                      final data = document.data();
                      final groupName =
                          data['groupTitle']?.toString().trim() ?? '';

                      if (groupName.isNotEmpty) {
                        groupsList.add(MapEntry(document.id, groupName));
                      }
                    }
                  }

                  return PersonalInformationCard(
                    selectedGroupId: _selectedGroupId,
                    groupsList: groupsList,
                    selectedImage: _selectedImage,
                    onGroupChanged: (value) {
                      final selectedGroup = groupsList.firstWhere(
                        (group) => group.key == (value ?? ''),
                        orElse: () => const MapEntry('', 'Other'),
                      );

                      setState(() {
                        _selectedGroupId = selectedGroup.key;
                        _selectedGroupName = selectedGroup.value;
                      });
                    },
                    onImageChanged: (image) {
                      setState(() {
                        _selectedImage = image;
                      });
                    },
                    nameController: _nameController,
                    phoneController: _phoneController,
                    addressController: _addressController,
                  );
                },
              ),
              SizedBox(height: 16.h),
              ContractInformationCard(
                contractDateController: _contractDateController,
                contractNameController: _contractNameController,
                purchasePriceController: _purchasePriceController,
                installmentAmountController: _installmentAmountController,
                firstInstallmentDateController: _firstInstallmentDateController,
                descriptionController: _descriptionController,
                advancePaymentController: _advancePaymentController,
                totalCostController: _totalCostController,
                debtAmountController: _debtAmountController,
                installmentType: _installmentType,
                installmentsCount: _calculateInstallmentsCount(),
                onInstallmentTypeChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _installmentType = value;
                    });

                    _calculateDebt();
                  }
                },
                onSelectContractDate: () =>
                    _selectDate(_contractDateController),
                onSelectFirstInstallmentDate: () =>
                    _selectDate(_firstInstallmentDateController),
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: _showConfirmDialog,
                child: Text(appLocalizations.save),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
