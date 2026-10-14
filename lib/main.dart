import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_installment_management/core/cubits/currency/currency_cubit.dart';
import 'package:smart_installment_management/core/cubits/language/language_cubit.dart';
import 'package:smart_installment_management/core/services/session_services.dart';
import 'package:smart_installment_management/core/theme/cubit/theme_cubit.dart';
import 'package:smart_installment_management/features/auth/data/cubit/auth_cubit.dart';
import 'package:smart_installment_management/firebase_options.dart';
import 'package:smart_installment_management/smart_instalment_management.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SessionServices.init();
  final themeCubit = ThemeCubit();
  await themeCubit.loadTheme();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CurrencyCubit()),
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => LanguageCubit()),
      ],
      child: BlocProvider.value(
        value: themeCubit,
        child: const SmartInstalmentManagement(),
      ),
    ),
  );
}
