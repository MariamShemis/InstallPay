import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/utils/extensions/extensions.dart';
import 'package:smart_installment_management/features/main_layout/groups/data/model/group_model.dart';
import 'package:smart_installment_management/features/main_layout/groups/presentation/widgets/add_group_bottom_sheet.dart';
import 'package:smart_installment_management/features/main_layout/groups/presentation/widgets/filter_chips_list.dart';
import 'package:smart_installment_management/features/main_layout/groups/presentation/widgets/groups_card.dart';
import 'package:smart_installment_management/features/main_layout/groups/presentation/widgets/groups_empty_state.dart';
import 'package:smart_installment_management/core/widgets/custom_search_text_field.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

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

  final List<GroupModel> _groupsData = const [
    // GroupModel(
    //   groupTitle: 'Home Appliances Group B',
    //   collectorName: 'Sami Al-Otaibi',
    //   collectorPhone: '+966 50 123 4567',
    //   clientsCount: 36,
    //   dueCount: 6,
    //   totalValue: 124000,
    //   collectedValue: 91700,
    //   remainingValue: 32200,
    // ),
    // GroupModel(
    //   groupTitle: 'Electronics Group A',
    //   collectorName: 'Ahmed Hassan',
    //   collectorPhone: '+20 100 890 1234',
    //   clientsCount: 24,
    //   dueCount: 3,
    //   totalValue: 85500,
    //   collectedValue: 68000,
    //   remainingValue: 17500,
    // ),
    // GroupModel(
    //   groupTitle: 'Furniture Group C',
    //   collectorName: 'Omar Al-Ghamdi',
    //   collectorPhone: '+966 55 987 6543',
    //   clientsCount: 18,
    //   dueCount: 8,
    //   totalValue: 50000,
    //   collectedValue: 20000,
    //   remainingValue: 30000,
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

    final isEmpty = _groupsData.isEmpty;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AddGroupBottomSheet.show(context);
        },
        child: Icon(
          Icons.add,
          color: ColorManager.white,
          size: 28.r,
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: REdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),

              Text(
                appLocalizations.groups,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              if (!isEmpty) ...[
                SizedBox(height: 10.h),

                CustomSearchTextField(
                  controller: _searchController,
                  hintText:
                  '${appLocalizations.search_groups_collectors_zones}...',
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
                    ? const GroupsEmptyState()
                    : ListView.separated(
                  padding:
                  REdgeInsets.only(bottom: 20),
                  itemCount: _groupsData.length,
                  separatorBuilder:
                      (context, index) {
                    return SizedBox(
                      height: 12.h,
                    );
                  },
                  itemBuilder:
                      (context, index) {
                    final group =
                    _groupsData[index];

                    return GroupCard(
                      group: group,
                      currency: currency,
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