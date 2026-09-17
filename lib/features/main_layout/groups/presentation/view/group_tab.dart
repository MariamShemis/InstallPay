import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/widgets/custom_search_text_field.dart';
import 'package:smart_installment_management/features/main_layout/groups/presentation/widgets/filter_chips_list.dart';
import 'package:smart_installment_management/features/main_layout/groups/presentation/widgets/groups_card.dart';
import 'package:smart_installment_management/features/main_layout/groups/presentation/widgets/groups_empty_state.dart';

class GroupTab extends StatefulWidget {
  const GroupTab({super.key});

  @override
  State<GroupTab> createState() => _GroupTabState();
}

class _GroupTabState extends State<GroupTab> {
  late final TextEditingController _searchController;
  int _selectedFilterIndex = 0;

  final List<String> _filters = const [
    'All Groups',
    'High Priority',
    'Near Due',
  ];

  final List<Map<String, dynamic>> _groupsData = const [
    {
      'groupTitle': 'Home Appliances Group B',
      'collectorName': 'Sami Al-Otaibi',
      'collectorPhone': '+966 50 123 4567',
      'clientsCount': '36',
      'dueCount': '6',
      'totalValue': '\$124.0k',
      'collectedValue': '\$91.7k',
      'remainingValue': '\$32.2k',
      'progress': 0.74,
    },
    {
      'groupTitle': 'Electronics Group A',
      'collectorName': 'Ahmed Hassan',
      'collectorPhone': '+20 100 890 1234',
      'clientsCount': '24',
      'dueCount': '3',
      'totalValue': '\$85.5k',
      'collectedValue': '\$68.0k',
      'remainingValue': '\$17.5k',
      'progress': 0.795,
    },
    {
      'groupTitle': 'Furniture Group C',
      'collectorName': 'Omar Al-Ghamdi',
      'collectorPhone': '+966 55 987 6543',
      'clientsCount': '18',
      'dueCount': '8',
      'totalValue': '\$50.0k',
      'collectedValue': '\$20.0k',
      'remainingValue': '\$30.0k',
      'progress': 0.40,
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
    final isEmpty = _groupsData.isEmpty;

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
                'Groups',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!isEmpty) ...[
                SizedBox(height: 10.h),
                CustomSearchTextField(
                  controller: _searchController,
                  hintText: 'Search groups, collectors, zones...',
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
                    ? const GroupsEmptyState()
                    : ListView.separated(
                  padding: REdgeInsets.only(bottom: 20),
                  itemCount: _groupsData.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final item = _groupsData[index];
                    return GroupCard(
                      groupTitle: item['groupTitle'],
                      collectorName: item['collectorName'],
                      collectorPhone: item['collectorPhone'],
                      clientsCount: item['clientsCount'],
                      dueCount: item['dueCount'],
                      totalValue: item['totalValue'],
                      collectedValue: item['collectedValue'],
                      remainingValue: item['remainingValue'],
                      progress: item['progress'],
                      onOpenSheetTap: () {},
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

