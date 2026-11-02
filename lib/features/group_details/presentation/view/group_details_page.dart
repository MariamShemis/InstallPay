import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/utils/extensions/extensions.dart';
import 'package:smart_installment_management/core/utils/ui_utils.dart';
import 'package:smart_installment_management/features/group_details/data/cubit/group_details_cubit.dart';
import 'package:smart_installment_management/features/group_details/data/cubit/group_details_state.dart';
import 'package:smart_installment_management/features/group_details/presentation/widgets/group_details_customer_card.dart';
import 'package:smart_installment_management/features/group_details/presentation/widgets/group_details_summary.dart';
import 'package:smart_installment_management/features/main_layout/groups/data/model/group_model.dart';
import 'package:smart_installment_management/features/main_layout/groups/presentation/widgets/add_group_bottom_sheet.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class GroupDetailsPage extends StatefulWidget {
  final GroupModel group;

  const GroupDetailsPage({super.key, required this.group});

  @override
  State<GroupDetailsPage> createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  late final GroupDetailsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = GroupDetailsCubit()..loadDetails(widget.group.id);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _editGroup(GroupModel group) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await AddGroupBottomSheet.showEdit(context, group);
    if (!mounted || result != true) return;
    await _cubit.loadDetails(group.id);
    if (!mounted) return;
    UiUtils.showSuccess(context, l10n.groupUpdatedSuccessfully);
  }

  Future<void> _deleteGroup(GroupModel group) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
          title: Text(l10n.deleteGroup),
          content: Text(l10n.deleteGroupConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.deleteGroup),
            ),
          ],
        );
      },
    );
    if (!mounted || confirmed != true) return;
    UiUtils.showLoading(context);
    bool success = false;
    try {
      success = await _cubit.deleteGroup();
    } catch (_) {
      success = false;
    } finally {
      if (mounted) UiUtils.hideLoading(context);
    }
    if (!mounted) return;
    if (success) {
      UiUtils.showSuccess(context, l10n.groupDeletedSuccessfully);
      Navigator.of(context).pop(true);
    } else {
      UiUtils.showError(context, l10n.operationFailed);
      await _cubit.loadDetails(group.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currency = context.currencySymbol;

    return BlocProvider<GroupDetailsCubit>.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.groupDetails),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<GroupDetailsCubit, GroupDetailsState>(
            builder: (context, state) {
              if (state is GroupDetailsLoading ||
                  state is GroupDetailsInitial ||
                  state is GroupDetailsSaving ||
                  state is GroupDetailsDeleting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is GroupDetailsError) {
                return Center(
                  child: Padding(
                    padding: REdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          color: theme.colorScheme.error,
                          size: 42.r,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          l10n.errorLoadingGroup,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall,
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton.icon(
                          onPressed: () => _cubit.loadDetails(widget.group.id),
                          icon: const Icon(Icons.refresh),
                          label: Text(l10n.retry),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is! GroupDetailsLoaded) {
                return const SizedBox.shrink();
              }
              final group = state.group;
              final customers = state.customers;
              return RefreshIndicator(
                onRefresh: () => _cubit.loadDetails(group.id),
                child: ListView(
                  padding: REdgeInsets.fromLTRB(16, 12, 16, 28),
                  children: [
                    GroupDetailsSummary(
                      group: group,
                      totalValue: _cubit.totalValue,
                      collectedValue: _cubit.collectedValue,
                      remainingValue: _cubit.remainingValue,
                      customerCount: customers.length,
                      completedCount: _cubit.completedCount,
                      overdueCount: _cubit.overdueCount,
                      currency: currency,
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.groupCustomers,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: REdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            '${customers.length} ${l10n.customers}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    if (customers.isEmpty)
                      Container(
                        padding: REdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 32,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: theme.dividerColor.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.people_outline_rounded,
                              size: 42.r,
                              color: ColorManager.greySecondaryText,
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              l10n.noCustomersInGroup,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      )
                    else
                      ...customers.map(
                        (customer) => Padding(
                          padding: REdgeInsets.only(bottom: 12),
                          child: GroupDetailsCustomerCard(
                            customer: customer,
                            currency: currency,
                            onTap: () {},
                          ),
                        ),
                      ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48.h,
                            child: FilledButton.icon(
                              onPressed: () => _editGroup(group),
                              icon: Icon(Icons.edit_outlined, size: 18.r),
                              label: Text(l10n.edit),
                              style: FilledButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: theme.colorScheme.onPrimary,
                                shape: const StadiumBorder(),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: SizedBox(
                            height: 48.h,
                            child: OutlinedButton.icon(
                              onPressed: () => _deleteGroup(group),
                              icon: Icon(
                                Icons.delete_outline_rounded,
                                size: 18.r,
                                color: ColorManager.red,
                              ),
                              label: Text(
                                l10n.delete,
                                style: const TextStyle(
                                  color: ColorManager.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: ColorManager.red.withOpacity(0.6),
                                  width: 1.2.w,
                                ),
                                shape: const StadiumBorder(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
