import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/features/main_layout/tracker/data/cubit/tracker_money_management_cubit.dart';
import 'package:smart_installment_management/features/main_layout/tracker/data/cubit/tracker_money_management_state.dart';
import 'package:smart_installment_management/features/main_layout/tracker/presentation/widgets/money_management/tracker_capital_section.dart';
import 'package:smart_installment_management/features/main_layout/tracker/presentation/widgets/money_management/tracker_customer_summary_section.dart';
import 'package:smart_installment_management/features/main_layout/tracker/presentation/widgets/money_management/tracker_partner_summary_section.dart';
import 'package:smart_installment_management/features/main_layout/tracker/presentation/widgets/money_management/tracker_shared_widgets.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class TrackerMoneyManagementWidget extends StatefulWidget {
  const TrackerMoneyManagementWidget({super.key});

  @override
  State<TrackerMoneyManagementWidget> createState() =>
      _TrackerMoneyManagementWidgetState();
}

class _TrackerMoneyManagementWidgetState
    extends State<TrackerMoneyManagementWidget> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<TrackerMoneyManagementCubit>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<
      TrackerMoneyManagementCubit,
      TrackerMoneyManagementState
    >(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.errorMessage != null) {
          return Center(
            child: Padding(
              padding: REdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 40.r,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  SizedBox(height: 12.h),
                  Text(l10n.trackerLoadError, textAlign: TextAlign.center),
                  SizedBox(height: 8.h),
                  Text(state.errorMessage!, textAlign: TextAlign.center),
                  SizedBox(height: 12.h),
                  OutlinedButton.icon(
                    onPressed: () {
                      context.read<TrackerMoneyManagementCubit>().loadData();
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(l10n.retry),
                  ),
                ],
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: REdgeInsets.fromLTRB(5, 16, 5, 32),
          child: Column(
            children: [
              TrackerCapitalSection(state: state),
              SizedBox(height: 16.h),
              TrackerPartnerSummarySection(state: state),
              SizedBox(height: 16.h),
              TrackerCustomerSummarySection(state: state),
              SizedBox(height: 14.h),
              //TrackerAutoUpdateNote(text: l10n.trackerAutoUpdateNote),
            ],
          ),
        );
      },
    );
  }
}
