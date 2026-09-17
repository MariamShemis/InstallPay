import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/widgets/custom_search_text_field.dart';
import 'package:smart_installment_management/features/main_layout/customers/presentation/widgets/customer_card.dart';
import 'package:smart_installment_management/features/main_layout/customers/presentation/widgets/customers_empty_state.dart';
import 'package:smart_installment_management/features/main_layout/groups/presentation/widgets/filter_chips_list.dart';

class CustomersTab extends StatefulWidget {
  const CustomersTab({super.key});

  @override
  State<CustomersTab> createState() => _CustomersTabState();
}

class _CustomersTabState extends State<CustomersTab> {
  late final TextEditingController _searchController;
  int _selectedFilterIndex = 0;

  final List<String> _filters = const [
    'All Customers',
    'Overdue',
    'Due Today',
    'Completed',
  ];

  final List<Map<String, dynamic>> _customersData = const [
    {
      'customerName': 'Mohamed Ali',
      'customerPhone': '+20 111 234 5678',
      'groupName': 'Electronics A',
      'status': 'Overdue',
      'totalValue': '\$2,400',
      'paidValue': '\$1,800',
      'remainingValue': '\$600',
      'nextDueDate': '12 Oct 2026',
      'progress': 0.75,
    },
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
    final theme = Theme.of(context);
    final isEmpty = _customersData.isEmpty;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add, color: ColorManager.white, size: 28.r),
      ),
      body: SafeArea(
        child: Padding(
          padding: REdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),
              Text(
                'Customers',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!isEmpty) ...[
                SizedBox(height: 10.h),
                CustomSearchTextField(
                  controller: _searchController,
                  hintText: 'Search customers, phone, group...',
                  onChanged: (value) {},
                ),
                SizedBox(height: 12.h),
                FilterChipsList(
                  filters: _filters,
                  selectedIndex: _selectedFilterIndex,
                  onSelected: (index) {
                    setState(() => _selectedFilterIndex = index);
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
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          final item = _customersData[index];
                          return CustomerCard(
                            customerName: item['customerName'],
                            customerPhone: item['customerPhone'],
                            groupName: item['groupName'],
                            status: item['status'],
                            totalValue: item['totalValue'],
                            paidValue: item['paidValue'],
                            remainingValue: item['remainingValue'],
                            nextDueDate: item['nextDueDate'],
                            progress: item['progress'],
                            onTap: () {},
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
