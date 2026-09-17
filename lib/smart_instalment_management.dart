import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:smart_installment_management/core/cubits/language/language_cubit.dart';
import 'package:smart_installment_management/core/cubits/language/language_state.dart';
import 'package:smart_installment_management/core/routes/app_routes.dart';
import 'package:smart_installment_management/core/routes/routes_generator.dart';
import 'package:smart_installment_management/core/theme/cubit/theme_cubit.dart';
import 'package:smart_installment_management/core/theme/cubit/theme_state.dart';
import 'package:smart_installment_management/core/theme/theme_manager.dart';

import 'l10n/app_localizations.dart';

class SmartInstalmentManagement extends StatelessWidget {
  const SmartInstalmentManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 882),
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (context, child) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return BlocBuilder<LanguageCubit, LanguageState>(
              builder: (context, languageState) {
                return MaterialApp(
                  title: 'Smart Installment Management',
                  debugShowCheckedModeBanner: false,
                  onGenerateRoute: RoutesGenerator.router,
                  initialRoute: AppRoutes.splashScreen,
                  theme: ThemeManager.light,
                  darkTheme: ThemeManager.dark,
                  themeMode: themeState.themeMode,
                  locale: languageState.locale,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    MonthYearPickerLocalizations.delegate,
                  ],
                  supportedLocales: AppLocalizations.supportedLocales,
                );
              },
            );
          },
        );
      },
    );
  }
}