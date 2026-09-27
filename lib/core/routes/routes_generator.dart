import 'package:flutter/cupertino.dart';
import 'package:smart_installment_management/core/routes/app_routes.dart';
import 'package:smart_installment_management/features/add_customer/presentation/view/add_customer_screen.dart';
import 'package:smart_installment_management/features/auth/presentation/view/forget_password.dart';
import 'package:smart_installment_management/features/auth/presentation/view/login_screen.dart';
import 'package:smart_installment_management/features/auth/presentation/view/register_screen.dart';
import 'package:smart_installment_management/features/customer_details&pay/presentation/view/customer_details_screen.dart';
import 'package:smart_installment_management/features/installment_schedule_payment/presentation/view/installment_schedule_pay_screen.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';
import 'package:smart_installment_management/features/main_layout/main_layout.dart';
import 'package:smart_installment_management/features/splash_screen/splash_screen.dart';

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
          return CupertinoPageRoute(builder: (context) => MainLayout());
        }
      case AppRoutes.addNewCustomer:
        {
          return CupertinoPageRoute(builder: (context) => AddCustomerScreen());
        }
      case AppRoutes.payInstallment:
        {
          final customer = settings.arguments as CustomerModel;
          return CupertinoPageRoute(
            builder: (context) =>
                InstallmentSchedulePayScreen(customer: customer),
          );
        }
      case AppRoutes.customerDetails:
        {
          final customer = settings.arguments as CustomerModel;

          return CupertinoPageRoute(
            builder: (context) => CustomerDetailsScreen(customer: customer),
          );
        }
    }
    return null;
  }
}
