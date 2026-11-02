import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/services/session_services.dart';
import 'package:smart_installment_management/features/main_layout/customers/presentation/widgets/calculator_dialog.dart';
import 'package:smart_installment_management/features/main_layout/home/data/cubit/home_cubit.dart';
import 'package:smart_installment_management/features/main_layout/home/data/cubit/home_state.dart';
import 'package:smart_installment_management/features/main_layout/home/presentation/widgets/financial_summary_section.dart';
import 'package:smart_installment_management/features/main_layout/home/presentation/widgets/hidden_privacy_placeholder.dart';
import 'package:smart_installment_management/features/main_layout/home/presentation/widgets/home_title.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late bool _isPrivacyHidden;

  @override
  void initState() {
    super.initState();
    _isPrivacyHidden = SessionServices.getPrivacyHidden();
    context.read<HomeCubit>().loadUser();
  }

  Future<void> _togglePrivacy() async {
    setState(() {
      _isPrivacyHidden = !_isPrivacyHidden;
    });

    await SessionServices.setPrivacyHidden(_isPrivacyHidden);
  }

  Widget _buildProfileImage(String? imageUrl) {
    final url = imageUrl?.trim() ?? '';

    if (url.isNotEmpty) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _defaultProfileImage();
        },
      );
    }

    return _defaultProfileImage();
  }

  Widget _defaultProfileImage() {
    return Container(
      color: ColorManager.navyDark,
      alignment: Alignment.center,
      child: Icon(
        Icons.person,
        color: ColorManager.white,
        size: 24.r,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return Center(
              child: CircularProgressIndicator(
                color: isDark
                    ? ColorManager.darkAccentGreen
                    : ColorManager.primaryColor,
              ),
            );
          }

          if (state is HomeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  SizedBox(height: 12.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeCubit>().loadUser();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          String name = '';
          String? imageUrl;
          double cashPartner = 0;
          double outMoney = 0;

          if (state is HomeSuccess) {
            name = state.user.name.trim();
            imageUrl = state.user.image;
            cashPartner = state.cashPartner;
            outMoney = state.outMoney;
          }
          return SingleChildScrollView(
            child: Padding(
              padding: REdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeTitle(
                    name: name,
                    image: _buildProfileImage(imageUrl),
                    isPrivacyHidden: _isPrivacyHidden,
                    onTogglePrivacy: _togglePrivacy,
                    onCalculatorTap: () {
                      CalculatorDialog.show(context);
                    },
                  ),
                  SizedBox(height: 5.h),
                  Divider(
                    color: isDark
                        ? colorScheme.onSurface.withOpacity(0.2)
                        : theme.dividerColor.withOpacity(0.15),
                    thickness: 1,
                    indent: 2,
                    endIndent: 2,
                  ),
                  SizedBox(height: 12.h),
                  _isPrivacyHidden
                      ? HiddenPrivacyPlaceholder(
                    userName: name,
                    onUnhideTap: _togglePrivacy,
                  )
                      : FinancialSummarySection(
                    cashPartner: cashPartner,
                    outMoney: outMoney,
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}