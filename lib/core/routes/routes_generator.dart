import 'package:flutter/cupertino.dart';
import 'package:smart_installment_management/core/routes/app_routes.dart';
import 'package:smart_installment_management/features/auth/presentation/view/forget_password.dart';
import 'package:smart_installment_management/features/auth/presentation/view/login_screen.dart';
import 'package:smart_installment_management/features/auth/presentation/view/register_screen.dart';
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
    }
    return null;
  }
}
