import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/routes/app_routes.dart';
import 'package:smart_installment_management/core/utils/extensions/extensions.dart';
import 'package:smart_installment_management/core/widgets/custom_search_text_field.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';
import 'package:smart_installment_management/features/main_layout/customers/presentation/widgets/calculator_dialog.dart';
import 'package:smart_installment_management/features/main_layout/customers/presentation/widgets/customer_card.dart';
import 'package:smart_installment_management/features/main_layout/customers/presentation/widgets/customers_empty_state.dart';
import 'package:smart_installment_management/features/main_layout/groups/presentation/widgets/filter_chips_list.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class CustomersTab extends StatefulWidget {
  const CustomersTab({super.key});

  @override
  State<CustomersTab> createState() => _CustomersTabState();
}

class _CustomersTabState extends State<CustomersTab> {
  late final TextEditingController _searchController;

  int _selectedFilterIndex = 0;

  final List<String> _filters = const [
    'All',
    'Overdue',
    'Due Today',
    'Completed',
  ];

  final List<CustomerModel> _customersData = const [
    // CustomerModel(
    //   id: 'CUS-8821',
    //   customerName: 'Mohamed Ali',
    //   customerPhone: '+20 111 234 5678',
    //   address: 'Cairo, Egypt',
    //   groupName: 'Electronics A',
    //   contractDate: '2026-09-18',
    //   contractName: 'Electronics Contract',
    //   purchasePrice: 2000,
    //   sellingPrice: 2400,
    //   downPayment: 600,
    //   debtAmount: 1800,
    //   installmentAmount: 600,
    //   installmentType: 'Monthly',
    //   installmentsCount: 3,
    //   firstInstallmentDate: '12 Oct 2026',
    //   paidValue: 1200,
    //   status: 'Overdue',
    //   nextDueDate: '12 Oct 2026',
    //   description: 'Customer details retrieved from card selection.',
    //   schedule: [
    //     InstallmentModel(
    //       installmentNumber: 1,
    //       dueDate: '12 Oct 2026',
    //       amount: 600,
    //       isPaid: true,
    //     ),
    //     InstallmentModel(
    //       installmentNumber: 2,
    //       dueDate: '12 Nov 2026',
    //       amount: 600,
    //       isPaid: true,
    //     ),
    //     InstallmentModel(
    //       installmentNumber: 3,
    //       dueDate: '12 Dec 2026',
    //       amount: 600,
    //       isPaid: false,
    //     ),
    //   ],
    // ),
  ];

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currency = context.currencySymbol;

    final isEmpty = _customersData.isEmpty;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addNewCustomer);
        },
        child: Icon(Icons.add, color: ColorManager.white, size: 28.r),
      ),
      body: SafeArea(
        child: Padding(
          padding: REdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    appLocalizations.customers,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      CalculatorDialog.show(context);
                    },
                    icon: Icon(
                      Icons.calculate_outlined,
                      size: 26.r,
                      color: theme.brightness == Brightness.dark
                          ? ColorManager.darkAccentGreen
                          : ColorManager.primaryColor,
                    ),
                    tooltip: 'Calculator',
                  ),
                ],
              ),

              if (!isEmpty) ...[
                SizedBox(height: 10.h),

                CustomSearchTextField(
                  controller: _searchController,
                  hintText:
                      '${appLocalizations.search_customers_phone_group}...',
                  onChanged: (value) {},
                ),

                SizedBox(height: 12.h),

                FilterChipsList(
                  filters: _filters,
                  selectedIndex: _selectedFilterIndex,
                  onSelected: (index) {
                    setState(() {
                      _selectedFilterIndex = index;
                    });
                  },
                ),
              ],

              SizedBox(height: 16.h),

              Expanded(
                child: isEmpty
                    ? const CustomersEmptyState()
                    : ListView.separated(
                        padding: REdgeInsets.only(bottom: 20),
                        itemCount: _customersData.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 12.h);
                        },
                        itemBuilder: (context, index) {
                          final customer = _customersData[index];
                          return CustomerCard(
                            customer: customer,
                            currency: currency,
                            onViewDetails: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.customerDetails,
                                arguments: customer,
                              );
                            },
                            onPayInstallment: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.payInstallment,
                                arguments: customer,
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
