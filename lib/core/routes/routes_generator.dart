import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_installment_management/core/routes/app_routes.dart';
import 'package:smart_installment_management/features/account_security/data/cubit/account_security_cubit.dart';
import 'package:smart_installment_management/features/account_security/presentation/view/account_security_screen.dart';
import 'package:smart_installment_management/features/add_customer/presentation/view/add_customer_screen.dart';
import 'package:smart_installment_management/features/app_startup_auth_screen/app_lock_screen.dart';
import 'package:smart_installment_management/features/auth/presentation/view/forget_password.dart';
import 'package:smart_installment_management/features/auth/presentation/view/login_screen.dart';
import 'package:smart_installment_management/features/auth/presentation/view/register_screen.dart';
import 'package:smart_installment_management/features/backup_restore/presentation/view/backup_restore_screen.dart';
import 'package:smart_installment_management/features/customer_details&pay/presentation/view/customer_details_screen.dart';
import 'package:smart_installment_management/features/edit_profile/data/cubit/edit_profile_cubit.dart';
import 'package:smart_installment_management/features/edit_profile/presentation/view/edit_profile_screen.dart';
import 'package:smart_installment_management/features/group_details/data/cubit/group_details_cubit.dart';
import 'package:smart_installment_management/features/group_details/presentation/view/group_details_page.dart';
import 'package:smart_installment_management/features/installment_schedule_payment/data/cubit/installment_payment_cubit.dart';
import 'package:smart_installment_management/features/installment_schedule_payment/presentation/view/installment_schedule_pay_screen.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';
import 'package:smart_installment_management/features/main_layout/groups/data/cubit/group_cubit.dart';
import 'package:smart_installment_management/features/main_layout/groups/data/model/group_model.dart';
import 'package:smart_installment_management/features/main_layout/home/data/cubit/home_cubit.dart';
import 'package:smart_installment_management/features/main_layout/main_layout.dart';
import 'package:smart_installment_management/features/main_layout/profile/data/cubit/profile_cubit.dart';
import 'package:smart_installment_management/features/splash_screen/splash_screen.dart';
import 'package:smart_installment_management/features/verify_email/data/cubit/verify_email_cubit.dart';
import 'package:smart_installment_management/features/verify_email/presentation/view/verify_email_screen.dart';

abstract class RoutesGenerator {
  static Route? router(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splashScreen:
        {
          return CupertinoPageRoute(builder: (context) => SplashScreen());
        }
      case AppRoutes.login:
        {
          return CupertinoPageRoute(builder: (context) => LoginScreen());
        }
      case AppRoutes.register:
        {
          return CupertinoPageRoute(builder: (context) => RegisterScreen());
        }
      case AppRoutes.forgetPassword:
        {
          return CupertinoPageRoute(builder: (context) => ForgetPassword());
        }
      case AppRoutes.mainLayout:
        {
          return CupertinoPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => GroupsCubit()..loadGroups()),
                BlocProvider(create: (context) => ProfileCubit()),
                BlocProvider(create: (context) => HomeCubit()),
              ],
              child: MainLayout(),
            ),
          );
        }
      case AppRoutes.addNewCustomer:
        {
          final args = settings.arguments;

          return CupertinoPageRoute(
            builder: (context) => AddCustomerScreen(
              customer: args is CustomerModel ? args : null,
            ),
          );
        }
      case AppRoutes.accountSecurity:
        {
          return CupertinoPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => AccountSecurityCubit(),
              child: AccountSecurityScreen(),
            ),
          );
        }
      case AppRoutes.editProfile:
        {
          return CupertinoPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => EditProfileCubit(),
              child: EditProfileScreen(),
            ),
          );
        }
      case AppRoutes.payInstallment:
        {
          final customer = settings.arguments as CustomerModel;
          return CupertinoPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => InstallmentPaymentCubit(customer),
              child: InstallmentSchedulePayScreen(customer: customer),
            ),
          );
        }
      case AppRoutes.customerDetails:
        {
          final customer = settings.arguments as CustomerModel;

          return CupertinoPageRoute(
            builder: (context) => CustomerDetailsScreen(customer: customer),
          );
        }

      case AppRoutes.verifyEmail:
        {
          final arguments = settings.arguments;

          String? email;
          bool fromAccountSecurity = false;

          if (arguments is String) {
            // Existing usage, such as after registration.
            email = arguments;
          } else if (arguments is Map) {
            email = arguments['email'] as String?;
            fromAccountSecurity = arguments['fromAccountSecurity'] == true;
          }

          return CupertinoPageRoute<bool>(
            builder: (_) => BlocProvider(
              create: (_) => VerifyEmailCubit(),
              child: VerifyEmailScreen(
                email: email,
                fromAccountSecurity: fromAccountSecurity,
              ),
            ),
          );
        }
      case AppRoutes.appStartupAuthScreen:
        {
          return CupertinoPageRoute(builder: (_) => const AppLockScreen());
        }
      case AppRoutes.backUp:
        {
          return CupertinoPageRoute(builder: (_) => BackupRestoreScreen());
        }
      case AppRoutes.groupDetails:
        final group = settings.arguments as GroupModel;

        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => GroupDetailsCubit(),
            child: GroupDetailsPage(group: group),
          ),
        );
    }
    return null;
  }
}
