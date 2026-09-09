import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';

class ThemeManager {
  // ==========================================================
  // LIGHT THEME
  // ==========================================================
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: ColorManager.primaryColor,
    scaffoldBackgroundColor: ColorManager.bgLight,

    colorScheme: const ColorScheme.light(
      primary: ColorManager.primaryColor,
      onPrimary: ColorManager.white,
      secondary: ColorManager.secondary,
      onSecondary: ColorManager.black,
      surface: ColorManager.white,
      onSurface: ColorManager.black,
      surfaceVariant: ColorManager.blueSoftBackground,
      error: ColorManager.red,
      onError: ColorManager.white,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: ColorManager.black),
      titleTextStyle: GoogleFonts.inter(
        color: ColorManager.black,
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
      ),
    ),

    cardTheme: CardThemeData(
      color: ColorManager.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: ColorManager.blueLightTint, width: 1.w),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorManager.darkAccentGreen,
        foregroundColor: ColorManager.white,
        minimumSize: Size(double.infinity, 52.h),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        textStyle: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.bold),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: Size(double.infinity, 52.h),
        side: BorderSide(color: ColorManager.darkAccentGreen, width: 1.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        textStyle: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.bold),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorManager.white,
      contentPadding: REdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: GoogleFonts.inter(color: ColorManager.greySecondaryText, fontSize: 14.sp),
      labelStyle: GoogleFonts.inter(color: ColorManager.greyDark, fontSize: 14.sp),
      floatingLabelStyle: GoogleFonts.inter(
        color: ColorManager.primaryColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
      prefixIconColor: ColorManager.greyDark,
      suffixIconColor: ColorManager.greyDark,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: ColorManager.blueLightTint, width: 1.0.w),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: ColorManager.primaryColor, width: 1.5.w),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: ColorManager.red, width: 1.0.w),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: ColorManager.red, width: 1.5.w),
      ),
      errorStyle: GoogleFonts.inter(
        color: ColorManager.red,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      ),
    ),

    textTheme: TextTheme(
      headlineLarge: GoogleFonts.inter(fontSize: 26.sp, fontWeight: FontWeight.bold, color: ColorManager.black),
      headlineMedium: GoogleFonts.inter(fontSize: 22.sp, fontWeight: FontWeight.bold, color: ColorManager.black),
      titleMedium: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w600, color: ColorManager.black),
      bodyLarge: GoogleFonts.inter(fontSize: 16.sp, color: ColorManager.black),
      bodyMedium: GoogleFonts.inter(fontSize: 14.sp, color: ColorManager.greyDark),
      bodySmall: GoogleFonts.inter(fontSize: 12.sp, color: ColorManager.greySecondaryText),
    ),

    // ================= NAVBAR LIGHT =================
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: ColorManager.white,
      elevation: 0,
      indicatorColor: ColorManager.greenOpacity15,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      height: 75.h,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.inter(
            color: ColorManager.green,
            fontWeight: FontWeight.bold,
            fontSize: 11.sp,
          );
        }
        return GoogleFonts.inter(
          color: ColorManager.greyDark,
          fontWeight: FontWeight.w500,
          fontSize: 11.sp,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(
            color: ColorManager.green,
            size: 26.r,
          );
        }
        return IconThemeData(
          color: ColorManager.greyDark,
          size: 24.r,
        );
      }),
    ),
  );

  // ==========================================================
  // DARK THEME
  // ==========================================================
  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: ColorManager.darkAccentGreen,
    scaffoldBackgroundColor: ColorManager.bgDark,

    colorScheme: const ColorScheme.dark(
      primary: ColorManager.darkAccentGreen,
      onPrimary: ColorManager.white,
      secondary: ColorManager.secondary,
      onSecondary: ColorManager.white,
      surface: ColorManager.darkSurface,
      onSurface: ColorManager.white,
      surfaceVariant: ColorManager.darkSurfaceVariant,
      error: ColorManager.redErrorDark,
      onError: ColorManager.white,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: ColorManager.white),
      titleTextStyle: GoogleFonts.inter(
        color: ColorManager.white,
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
      ),
    ),

    cardTheme: CardThemeData(
      color: ColorManager.darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: ColorManager.darkSurfaceVariant, width: 1.w),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorManager.darkAccentGreen,
        foregroundColor: ColorManager.white,
        minimumSize: Size(double.infinity, 52.h),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        textStyle: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.bold),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: Size(double.infinity, 52.h),
        side: BorderSide(color: ColorManager.darkAccentGreen, width: 1.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        textStyle: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.bold),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorManager.darkSurfaceVariant,
      contentPadding: REdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: GoogleFonts.inter(color: ColorManager.darkMutedText, fontSize: 14.sp),
      labelStyle: GoogleFonts.inter(color: ColorManager.darkMutedText, fontSize: 14.sp),
      floatingLabelStyle: GoogleFonts.inter(
        color: ColorManager.darkAccentGreen,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
      prefixIconColor: ColorManager.darkMutedText,
      suffixIconColor: ColorManager.darkMutedText,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: ColorManager.whiteOpacity20, width: 1.0.w),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: ColorManager.darkAccentGreen, width: 1.5.w),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: ColorManager.redErrorDark, width: 1.0.w),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: ColorManager.redErrorDark, width: 1.5.w),
      ),
      errorStyle: GoogleFonts.inter(
        color: ColorManager.redErrorDark,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      ),
    ),

    textTheme: TextTheme(
      headlineLarge: GoogleFonts.inter(fontSize: 26.sp, fontWeight: FontWeight.bold, color: ColorManager.white),
      headlineMedium: GoogleFonts.inter(fontSize: 22.sp, fontWeight: FontWeight.bold, color: ColorManager.white),
      titleMedium: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w600, color: ColorManager.white),
      bodyLarge: GoogleFonts.inter(fontSize: 16.sp, color: ColorManager.white),
      bodyMedium: GoogleFonts.inter(fontSize: 14.sp, color: ColorManager.darkMutedText),
      bodySmall: GoogleFonts.inter(fontSize: 12.sp, color: ColorManager.darkSlateText),
    ),

    // ================= NAVBAR DARK =================
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: ColorManager.darkSurface,
      elevation: 0,
      indicatorColor: ColorManager.darkGreenOpacity30,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      height: 75.h,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.inter(
            color: ColorManager.darkAccentGreen,
            fontWeight: FontWeight.bold,
            fontSize: 11.sp,
          );
        }
        return GoogleFonts.inter(
          color: ColorManager.darkMutedText,
          fontWeight: FontWeight.w500,
          fontSize: 11.sp,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(
            color: ColorManager.darkAccentGreen,
            size: 26.r,
          );
        }
        return IconThemeData(
          color: ColorManager.darkMutedText,
          size: 24.r,
        );
      }),
    ),
  );
}