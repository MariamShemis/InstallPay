import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/utils/extensions/extensions.dart';
import 'package:smart_installment_management/core/widgets/custom_search_text_field.dart';
import 'package:smart_installment_management/features/main_layout/groups/presentation/widgets/filter_chips_list.dart';
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

  final List<PartnerModel> _partnersData = [
    const PartnerModel(
      id: '1',
      name: 'System Admin Owner',
      address: 'Headquarters - Executive Office',
      phone: '+20 100 000 0000',
      mainCapital: 200000,
      profitMargin: 100,
      type: PartnerType.admin,
    ),
    const PartnerModel(
      id: '2',
      name: 'Michael Abdelaziz',
      address: 'Cairo, Nasrs City - El Tayaran St.',
      phone: '+20 101 234 5678',
      mainCapital: 150000,
      profitMargin: 20,
      type: PartnerType.primary,
    ),
    const PartnerModel(
      id: '3',
      name: 'El-Amal Trading Co. (Sameh El-Ali)',
      address: 'Alexandria, Smouha - Traders Tower',
      phone: '+20 129 876 5432',
      mainCapital: 80000,
      profitMargin: 15,
      type: PartnerType.secondary,
    ),
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

  List<PartnerModel> get _filteredPartners {
    return _partnersData.where((partner) {
      final matchesFilter = switch (_selectedFilterIndex) {
        1 => partner.isAdmin,
        2 => partner.isPrimary,
        3 => partner.type == PartnerType.secondary,
        _ => true,
      };

      final query = _searchQuery.toLowerCase().trim();
      final matchesSearch = query.isEmpty ||
          partner.name.toLowerCase().contains(query) ||
          partner.phone.contains(query) ||
          partner.address.toLowerCase().contains(query);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currency = context.currencySymbol;

    final filters = [
      appLocalizations.all,
      'Admin',
      appLocalizations.primaryPartner,
      appLocalizations.secondaryPartner,
    ];

    final filteredList = _filteredPartners;
    final isTotalEmpty = _partnersData.isEmpty;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AddPartnerBottomSheet.show(
            context,
            onPartnerAdded: (partner) {
              setState(() {
                _partnersData.add(partner);
              });
            },
          );
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
                appLocalizations.partners,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              if (!isTotalEmpty) ...[
                SizedBox(height: 10.h),
                CustomSearchTextField(
                  controller: _searchController,
                  hintText: '${appLocalizations.search_partners}...',
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                SizedBox(height: 12.h),
                FilterChipsList(
                  filters: filters,
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
                child: isTotalEmpty || filteredList.isEmpty
                    ? const PartnersEmptyState()
                    : ListView.separated(
                  padding: REdgeInsets.only(bottom: 20),
                  itemCount: filteredList.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final partner = filteredList[index];
                    return PartnerCard(
                      partner: partner,
                      currency: currency,
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