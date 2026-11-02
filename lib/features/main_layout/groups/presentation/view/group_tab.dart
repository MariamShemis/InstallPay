import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/routes/app_routes.dart';
import 'package:smart_installment_management/core/utils/extensions/extensions.dart';
import 'package:smart_installment_management/core/widgets/custom_search_text_field.dart';
import 'package:smart_installment_management/features/main_layout/customers/presentation/widgets/custom_filter_search.dart';
import 'package:smart_installment_management/features/main_layout/groups/data/cubit/group_cubit.dart';
import 'package:smart_installment_management/features/main_layout/groups/data/cubit/group_state.dart';
import 'package:smart_installment_management/features/main_layout/groups/data/model/group_model.dart';
import 'package:smart_installment_management/features/main_layout/groups/presentation/widgets/add_group_bottom_sheet.dart';
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

  String _selectedFilterKey = 'all';

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

  Map<String, String> _getFilterOptions(AppLocalizations l10n) {
    return {
      'all': l10n.all,
      'paid': l10n.paid,
      'unpaid': l10n.unpaid,
      'due': l10n.due,
      'overdue': l10n.overdue,
    };
  }

  List<GroupModel> _getFilteredGroups(List<GroupModel> groups) {
    final searchText = _searchController.text.trim().toLowerCase();
    final List<GroupModel> filteredGroups = [];

    for (final group in groups) {
      final matchesSearch =
          searchText.isEmpty ||
          group.groupTitle.toLowerCase().contains(searchText) ||
          group.collectorName.toLowerCase().contains(searchText) ||
          group.collectorPhone.toLowerCase().contains(searchText) ||
          group.address.toLowerCase().contains(searchText);

      if (!matchesSearch) continue;

      bool matchesStatus = true;

      if (_selectedFilterKey != 'all') {
        if (_selectedFilterKey == 'paid') {
          matchesStatus =
              group.clientsCount > 0 &&
              group.completedCount == group.clientsCount;
        } else if (_selectedFilterKey == 'overdue') {
          matchesStatus = group.overdueCount > 0;
        } else if (_selectedFilterKey == 'due') {
          matchesStatus = group.dueTodayCount > 0;
        } else if (_selectedFilterKey == 'unpaid') {
          matchesStatus = group.dueCount > 0;
        }
      }

      if (matchesStatus) {
        filteredGroups.add(group);
      }
    }

    return filteredGroups;
  }

  Future<void> _showGroupsFilter() async {
    final l10n = AppLocalizations.of(context)!;
    final filterOptions = _getFilterOptions(l10n);
    String tempSelectedKey = _selectedFilterKey;

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
              valueDropDownGroups: tempSelectedKey,
              itemsGroups: filterOptions.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChangedGroups: (value) {
                if (value == null) return;
                setSheetState(() {
                  tempSelectedKey = value;
                });
              },
              onPressedReset: () {
                setSheetState(() {
                  tempSelectedKey = 'all';
                });
              },
              onPressedApply: () {
                setState(() {
                  _selectedFilterKey = tempSelectedKey;
                });
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

                    if (state is GroupsLoading && allGroups.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

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
                                child: Text(appLocalizations.retry),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state is GroupsLoaded && allGroups.isEmpty) {
                      return const GroupsEmptyState();
                    }

                    final filteredGroups = _getFilteredGroups(allGroups);

                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomSearchTextField(
                                controller: _searchController,
                                hintText:
                                    '${appLocalizations.search_groups_collectors_zones}...',
                                onChanged: (_) {
                                  setState(() {});
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
                                onPressed: _showGroupsFilter,
                                tooltip: appLocalizations.filterGroups,
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
                          child: filteredGroups.isEmpty
                              ? Center(
                                  child: Text(
                                    appLocalizations
                                        .no_customers_match_your_search_or_filter,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                )
                              : ListView.separated(
                                  padding: REdgeInsets.only(bottom: 20),
                                  itemCount: filteredGroups.length,
                                  separatorBuilder: (_, __) =>
                                      SizedBox(height: 14.h),
                                  itemBuilder: (context, index) {
                                    final group = filteredGroups[index];
                                    return GroupCard(
                                      group: group,
                                      currency: currency,
                                      onOpenSheetTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.groupDetails,
                                          arguments: group,
                                        );
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
