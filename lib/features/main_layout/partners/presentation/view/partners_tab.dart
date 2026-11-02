import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/utils/extensions/extensions.dart';
import 'package:smart_installment_management/core/utils/ui_utils.dart';
import 'package:smart_installment_management/core/widgets/custom_search_text_field.dart';
import 'package:smart_installment_management/features/main_layout/groups/presentation/widgets/filter_chips_list.dart';
import 'package:smart_installment_management/features/main_layout/partners/data/cubit/partner_cubit.dart';
import 'package:smart_installment_management/features/main_layout/partners/data/cubit/partner_state.dart';
import 'package:smart_installment_management/features/main_layout/partners/data/model/partner_model.dart';
import 'package:smart_installment_management/features/main_layout/partners/presentation/widgets/add_partner_bottom_sheet.dart';
import 'package:smart_installment_management/features/main_layout/partners/presentation/widgets/partner_card.dart';
import 'package:smart_installment_management/features/main_layout/partners/presentation/widgets/partners_empty_state.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class PartnersTab extends StatefulWidget {
  const PartnersTab({super.key});

  @override
  State<PartnersTab> createState() => _PartnersTabState();
}

class _PartnersTabState extends State<PartnersTab> {
  late final TextEditingController _searchController;

  int _selectedFilterIndex = 0;
  String _searchQuery = '';

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

  List<PartnerModel> _filterPartners(List<PartnerModel> partners) {
    final query = _searchQuery.trim().toLowerCase();

    return partners.where((partner) {
      final matchesFilter = switch (_selectedFilterIndex) {
        1 => partner.isAdmin,
        2 => partner.isPrimary,
        3 => partner.isSecondary,
        _ => true,
      };

      final matchesSearch =
          query.isEmpty ||
          partner.name.toLowerCase().contains(query) ||
          partner.phone.toLowerCase().contains(query) ||
          partner.address.toLowerCase().contains(query);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  void _showAddPartnerSheet(BuildContext context) {
    final cubit = context.read<PartnerCubit>();

    AddPartnerBottomSheet.show(
      context,
      adminProfitMargin: cubit.adminProfitMargin,
      secondaryProfitTotal: cubit.secondaryProfitTotal,
      onPartnerAdded: cubit.addPartner,
    );
  }

  void _showEditPartnerSheet(BuildContext context, PartnerModel partner) {
    final cubit = context.read<PartnerCubit>();

    AddPartnerBottomSheet.show(
      context,
      partnerToEdit: partner,
      adminProfitMargin: cubit.adminProfitMargin,
      secondaryProfitTotal: cubit.secondaryProfitTotal,
      onPartnerAdded: cubit.updatePartner,
    );
  }

  Future<void> _confirmDeletePartner(
    BuildContext context,
    PartnerModel partner,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final dialogL10n = AppLocalizations.of(dialogContext)!;

        return AlertDialog(
          title: Text(dialogL10n.deletePartner),
          content: Text(dialogL10n.confirmDeletePartner(partner.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(dialogL10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(
                dialogL10n.delete,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    final cubit = context.read<PartnerCubit>();

    UiUtils.showLoading(context);

    var success = false;

    try {
      success = await cubit.deletePartner(partner.id);
    } catch (error, stackTrace) {
      debugPrint('Delete partner error: $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      UiUtils.hideLoading(context);
    }

    if (!context.mounted) return;

    if (success) {
      UiUtils.showToast(l10n.partnerDeletedSuccessfully);
    } else {
      UiUtils.showError(context, l10n.operationFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final filters = [
      l10n.all,
      l10n.admin,
      l10n.primaryPartner,
      l10n.secondaryPartner,
    ];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPartnerSheet(context),
        backgroundColor: ColorManager.primaryColor,
        child: Icon(Icons.add, color: ColorManager.white, size: 28.r),
      ),
      body: BlocBuilder<PartnerCubit, PartnerState>(
        builder: (context, state) {
          if (state.isLoading && state.partners.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final filteredPartners = _filterPartners(state.partners);

          return SafeArea(
            child: Padding(
              padding: REdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  Text(
                    l10n.partners,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  CustomSearchTextField(
                    controller: _searchController,
                    hintText: '${l10n.search_partners}...',
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                  ),
                  SizedBox(height: 12.h),
                  FilterChipsList(
                    filters: filters,
                    selectedIndex: _selectedFilterIndex,
                    onSelected: (index) {
                      setState(() => _selectedFilterIndex = index);
                    },
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: state.partners.isEmpty
                        ? const PartnersEmptyState()
                        : filteredPartners.isEmpty
                        ? Center(
                            child: Text(
                              l10n.noPartnersFound,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium,
                            ),
                          )
                        : ListView.separated(
                            padding: REdgeInsets.only(bottom: 24),
                            itemCount: filteredPartners.length,
                            separatorBuilder: (_, __) => SizedBox(height: 12.h),
                            itemBuilder: (context, index) {
                              final partner = filteredPartners[index];

                              return PartnerCard(
                                partner: partner,
                                currency: context.currencySymbol,
                                secondaryProfitTotal: context
                                    .read<PartnerCubit>()
                                    .secondaryProfitTotal,
                                onEdit: () {
                                  _showEditPartnerSheet(context, partner);
                                },
                                onDelete: () {
                                  _confirmDeletePartner(context, partner);
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
