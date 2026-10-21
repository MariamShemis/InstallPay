import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/utils/extensions/extensions.dart';
import 'package:smart_installment_management/core/widgets/custom_search_text_field.dart';
import 'package:smart_installment_management/features/main_layout/groups/data/cubit/group_cubit.dart';
import 'package:smart_installment_management/features/main_layout/groups/data/cubit/group_state.dart';
import 'package:smart_installment_management/features/main_layout/groups/data/model/group_model.dart';
import 'package:smart_installment_management/features/main_layout/groups/presentation/widgets/add_group_bottom_sheet.dart';
import 'package:smart_installment_management/features/main_layout/groups/presentation/widgets/filter_chips_list.dart';
import 'package:smart_installment_management/features/main_layout/groups/presentation/widgets/groups_card.dart';
import 'package:smart_installment_management/features/main_layout/groups/presentation/widgets/groups_empty_state.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class GroupTab extends StatefulWidget {
  const GroupTab({super.key});

  @override
  State<GroupTab> createState() => _GroupTabState();
}

class _GroupTabState extends State<GroupTab> {
  late final TextEditingController _searchController;
  late final GroupsCubit _groupsCubit;

  int _selectedFilterIndex = 0;

  final List<String> _filters = const [
    'All Groups',
    'High Priority',
    'Near Due',
  ];

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
    _groupsCubit = GroupsCubit()..loadGroups();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _groupsCubit.close();
    super.dispose();
  }

  List<GroupModel> _getFilteredGroups(List<GroupModel> groups) {
    final searchText = _searchController.text.trim().toLowerCase();

    final List<GroupModel> filteredGroups = [];

    for (final group in groups) {
      final matchesSearch =
          group.groupTitle.toLowerCase().contains(searchText) ||
          group.collectorName.toLowerCase().contains(searchText) ||
          group.collectorPhone.toLowerCase().contains(searchText) ||
          group.address.toLowerCase().contains(searchText);

      if (!matchesSearch) continue;

      if (_selectedFilterIndex == 1 && group.dueCount < 5) {
        continue;
      }

      if (_selectedFilterIndex == 2 && group.dueCount == 0) {
        continue;
      }

      filteredGroups.add(group);
    }

    return filteredGroups;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GroupsCubit>.value(
      value: _groupsCubit,
      child: _buildGroupsPage(context),
    );
  }

  Widget _buildGroupsPage(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currency = context.currencySymbol;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AddGroupBottomSheet.show(context);
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

              Text(
                appLocalizations.groups,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 10.h),

              Expanded(
                child: BlocBuilder<GroupsCubit, GroupsState>(
                  builder: (context, state) {
                    final allGroups = _groupsCubit.groups;

                    // Loading
                    if (state is GroupsLoading && allGroups.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Error
                    if (state is GroupsError && allGroups.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: REdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 42,
                                color: Colors.redAccent,
                              ),
                              SizedBox(height: 12.h),
                              Text(state.message, textAlign: TextAlign.center),
                              SizedBox(height: 12.h),
                              ElevatedButton(
                                onPressed: _groupsCubit.loadGroups,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // No groups found
                    if (state is GroupsLoaded && allGroups.isEmpty) {
                      return const GroupsEmptyState();
                    }

                    final filteredGroups = _getFilteredGroups(allGroups);

                    return Column(
                      children: [
                        CustomSearchTextField(
                          controller: _searchController,
                          hintText:
                              '${appLocalizations.search_groups_collectors_zones}...',
                          onChanged: (_) {
                            setState(() {});
                          },
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

                        SizedBox(height: 16.h),

                        Expanded(
                          child: filteredGroups.isEmpty
                              ? Center(
                                  child: Text(
                                    'No groups found',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                )
                              : ListView.separated(
                                  padding: REdgeInsets.only(bottom: 20),
                                  itemCount: filteredGroups.length,
                                  separatorBuilder: (_, __) =>
                                      SizedBox(height: 12.h),
                                  itemBuilder: (context, index) {
                                    final group = filteredGroups[index];

                                    return GroupCard(
                                      group: group,
                                      currency: currency,
                                      onOpenSheetTap: () {
                                        // We'll connect group details here later.
                                      },
                                    );
                                  },
                                ),
                        ),
                      ],
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
