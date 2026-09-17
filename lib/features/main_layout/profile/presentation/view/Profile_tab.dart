import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/core/routes/app_routes.dart';
import 'package:smart_installment_management/core/theme/cubit/theme_cubit.dart';
import 'package:smart_installment_management/features/main_layout/profile/presentation/widgets/currency_toggle.dart';
import 'package:smart_installment_management/features/main_layout/profile/presentation/widgets/language_toggle.dart';
import 'package:smart_installment_management/features/main_layout/profile/presentation/widgets/logout_button.dart';
import 'package:smart_installment_management/features/main_layout/profile/presentation/widgets/preference_item.dart';
import 'package:smart_installment_management/features/main_layout/profile/presentation/widgets/profile_header.dart';
import 'package:smart_installment_management/features/main_layout/profile/presentation/widgets/profile_menu_item.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: REdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeader(
                name: 'Ahmed Mansour',
                job: 'Field Operations Supervisor',
                phoneNumber: '+966 50 889 9112',
                image: CircleAvatar(
                  radius: 38.r,
                  backgroundColor: ColorManager.navyDark,
                  child: Icon(
                    Icons.person,
                    size: 35.sp,
                    color: ColorManager.white,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              _buildSectionTitle(
                appLocalizations.appearance_PREFERENCES,
                isDark,
              ),
              SizedBox(height: 8.h),
              _buildCardContainer(
                isDark: isDark,
                child: Column(
                  children: [
                    PreferenceItem(
                      icon: Icons.palette_outlined,
                      title: appLocalizations.themeMode,
                      subtitle: appLocalizations.toggle_dark_and_light_theme,
                      isDark: isDark,
                      actionWidget: _buildThemeSwitch(context),
                    ),
                    _buildDivider(isDark),
                    PreferenceItem(
                      icon: Icons.language,
                      title: appLocalizations.appLanguage,
                      subtitle: appLocalizations.current_interface_language,
                      isDark: isDark,
                      actionWidget: LanguageToggle(isDark: isDark),
                    ),
                    _buildDivider(isDark),
                    PreferenceItem(
                      icon: Icons.payments_outlined,
                      title: appLocalizations.currencyDisplay,
                      subtitle:
                          appLocalizations.receipt_and_ledger_metric_standard,
                      isDark: isDark,
                      actionWidget: CurrencyToggle(isDark: isDark),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              _buildSectionTitle(
                appLocalizations.general_settings.toUpperCase(),
                isDark,
              ),
              SizedBox(height: 8.h),
              _buildCardContainer(
                isSetting: true,
                isDark: isDark,
                child: Column(
                  children: [
                    ProfileMenuTile(
                      icon: Icons.person_outline_outlined,
                      title: appLocalizations.editProfile,
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.editProfile),
                    ),
                    ProfileMenuTile(
                      icon: Icons.cloud_done_rounded,
                      title: appLocalizations.backup_Restore,
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.backUp),
                    ),
                    ProfileMenuTile(
                      icon: Icons.security_rounded,
                      title: appLocalizations.account_Security,
                      showDivider: false,
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.accountSecurity,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              LogoutButton(
                isDark: isDark,
                label: appLocalizations.log_out,
                onPressed: () {
                  // handle logout action
                },
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        color: isDark
            ? ColorManager.darkSlateText
            : ColorManager.greyDark.withOpacity(0.6),
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildCardContainer({
    required Widget child,
    required bool isDark,
    bool isSetting = false,
  }) {
    return Container(
      padding: REdgeInsets.all(isSetting ? 0 : 16),
      decoration: BoxDecoration(
        color: isDark ? ColorManager.darkSurface : ColorManager.white,
        borderRadius: BorderRadius.circular(20.r),
        border: isDark
            ? Border.all(color: ColorManager.darkSurfaceVariant, width: 1.w)
            : null,
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: child,
    );
  }

  Widget _buildDivider(bool isDark) {
    return Padding(
      padding: REdgeInsets.symmetric(vertical: 16),
      child: Divider(
        height: 1,
        color: isDark
            ? ColorManager.darkSurfaceVariant
            : ColorManager.blueLightTint.withOpacity(0.5),
      ),
    );
  }

  Widget _buildThemeSwitch(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final isDarkMode = themeCubit.state.themeMode == ThemeMode.dark;
    return Switch(
      value: isDarkMode,
      activeColor: Colors.white,
      activeTrackColor: ColorManager.darkAccentGreen,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: ColorManager.blueSoftBackground,
      onChanged: (bool value) {
        themeCubit.changeTheme(value ? ThemeMode.dark : ThemeMode.light);
      },
    );
  }
}
