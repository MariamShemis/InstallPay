import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:smart_installment_management/core/cubits/currency/currency_cubit.dart';
import 'package:smart_installment_management/core/cubits/language/language_cubit.dart';
import 'package:smart_installment_management/core/theme/cubit/theme_cubit.dart';
import 'package:smart_installment_management/smart_instalment_management.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeCubit = ThemeCubit();
  await themeCubit.loadTheme();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CurrencyCubit()),
        BlocProvider(create: (context) => LanguageCubit()),
      ],
      child: BlocProvider.value(
        value: themeCubit,
        child: const SmartInstalmentManagement(),
      ),
    ),
  );
}
