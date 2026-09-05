import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_installment_management/core/costants/assets_manager.dart';

class LogoApp extends StatelessWidget {
  const LogoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Center(
          child: Image.asset(
            ImageAssets.logoApp,
            width: 85.w,
            height: 85.h,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'Smart Installment\nManagement',
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
