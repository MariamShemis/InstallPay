import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/routes/app_routes.dart';
import 'package:smart_installment_management/core/utils/extensions/extensions.dart';
import 'package:smart_installment_management/core/widgets/custom_search_text_field.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/cubit/customers_cubit.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/cubit/customers_state.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';
import 'package:smart_installment_management/features/main_layout/customers/presentation/widgets/calculator_dialog.dart';
import 'package:smart_installment_management/features/main_layout/customers/presentation/widgets/custom_filter_search.dart';
import 'package:smart_installment_management/features/main_layout/customers/presentation/widgets/customer_card.dart';
import 'package:smart_installment_management/features/main_layout/customers/presentation/widgets/customers_empty_state.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class CustomersTab extends StatefulWidget {
  const CustomersTab({super.key});

  @override
  State<CustomersTab> createState() => _CustomersTabState();
}

class _CustomersTabState extends State<CustomersTab> {
  late final CustomersCubit _customersCubit;
  late final TextEditingController _searchController;

  List<String> getFilter(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    return [l10n.all, l10n.paid, l10n.unpaid, l10n.due, l10n.overdue];
  }

  @override
  void initState() {
    super.initState();

    _customersCubit = CustomersCubit();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _customersCubit.close();
    super.dispose();
  }

  int _getSelectedGroupIndex(CustomersState state) {
    if (state.selectedGroupId == '__all__') return 0;
    if (state.selectedGroupId == '__other__') return 1;

    for (int i = 0; i < state.groups.length; i++) {
      if (state.groups[i].id == state.selectedGroupId) {
        return i + 2;
      }
    }

    return 0;
  }

  Future<void> _showCustomersFilter(
    BuildContext context,
    CustomersState state,
  ) async {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    final cubit = context.read<CustomersCubit>();

    String selectedGroupId = state.selectedGroupId;
    int selectedStatusIndex = state.selectedFilterIndex;

    final groups = state.groups;

    if (selectedStatusIndex >= getFilter(context).length) {
      selectedStatusIndex = 0;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final theme = Theme.of(context);

            return CustomFilterSearch(
              isCustomer: true,
              valueDropDownGroups:
                  [
                    '__all__',
                    '__other__',
                    ...groups.map((group) => group.id),
                  ].contains(selectedGroupId)
                  ? selectedGroupId
                  : '__all__',
              itemsGroups: [
                DropdownMenuItem(value: '__all__', child: Text(l10n.allGroups)),
                DropdownMenuItem(value: '__other__', child: Text(l10n.other)),
                ...groups.map(
                  (group) => DropdownMenuItem<String>(
                    value: group.id,
                    child: Text(
                      group.groupTitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
              onChangedGroups: (value) {
                if (value == null) return;

                setSheetState(() {
                  selectedGroupId = value;
                });
              },
              valueDropDownStatus: selectedStatusIndex,
              itemsStatus: [
                for (int i = 0; i < getFilter(context).length; i++)
                  DropdownMenuItem<int>(
                    value: i,
                    child: Text(getFilter(context)[i]),
                  ),
              ],
              onChangedStatus: (value) {
                if (value == null) return;

                setSheetState(() {
                  selectedStatusIndex = value;
                });
              },
              onPressedReset: () {
                setSheetState(() {
                  selectedGroupId = '__all__';
                  selectedStatusIndex = 0;
                });
              },
              onPressedApply: () {
                cubit.changeGroupFilter(selectedGroupId);
                cubit.changeFilter(selectedStatusIndex);
                Navigator.pop(sheetContext);
              },
              theme: theme,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomersCubit>.value(
      value: _customersCubit,
      child: BlocBuilder<CustomersCubit, CustomersState>(
        builder: (context, state) {
          final appLocalizations = AppLocalizations.of(context)!;
          final theme = Theme.of(context);
          final currency = context.currencySymbol;

          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await Navigator.pushNamed(context, AppRoutes.addNewCustomer);

                // Firestore stream updates the list automatically.
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

                    if (state.isLoading && state.allCustomers.isEmpty)
                      const Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (state.errorMessage.isNotEmpty &&
                        state.allCustomers.isEmpty)
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: REdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.cloud_off_outlined, size: 48),
                                SizedBox(height: 12.h),
                                Text(
                                  state.errorMessage,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 12.h),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    context
                                        .read<CustomersCubit>()
                                        .loadCustomers();
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: Text(appLocalizations.retry),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else if (state.allCustomers.isEmpty)
                      const Expanded(child: CustomersEmptyState())
                    else ...[
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Expanded(
                            child: CustomSearchTextField(
                              controller: _searchController,
                              hintText:
                                  '${appLocalizations.search_customers_phone_group}...',
                              onChanged: (value) {
                                context.read<CustomersCubit>().searchCustomers(
                                  value,
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            decoration: BoxDecoration(
                              color: theme.brightness == Brightness.dark
                                  ? ColorManager.darkSurfaceVariant
                                  : ColorManager.white,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: theme.brightness == Brightness.dark
                                    ? ColorManager.darkAccentGreen1
                                    : ColorManager.primaryColor,
                              ),
                            ),
                            child: IconButton(
                              tooltip: 'Filter Customers',
                              onPressed: () =>
                                  _showCustomersFilter(context, state),
                              icon: Icon(
                                Icons.tune_rounded,
                                color: theme.brightness == Brightness.dark
                                    ? ColorManager.darkAccentGreen1
                                    : ColorManager.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Expanded(
                        child: state.customers.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: REdgeInsets.all(20),
                                  child: Text(
                                    appLocalizations.no_customers_match_your_search_or_filter,
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                padding: REdgeInsets.only(bottom: 20),
                                itemCount: state.customers.length,
                                separatorBuilder: (context, index) {
                                  return SizedBox(height: 12.h);
                                },
                                itemBuilder: (context, index) {
                                  final CustomerModel customer =
                                      state.customers[index];

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
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
