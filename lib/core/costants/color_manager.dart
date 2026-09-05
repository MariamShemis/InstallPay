import 'package:flutter/material.dart';

abstract class ColorManager {
  // ==========================================
  // Common & Brand Colors
  // ==========================================
  static const Color primaryColor = Color(0xFF005C55);
  static const Color green = Color(0xFF006C4D);
  static const Color green5f = Color(0xFF006B5F);
  static const Color greenMedium = Color(0xFF007352);
  static const Color greenAccent = Color(0xFF88F8C8);
  static const Color secondary = Color(0xFFA3FAEF);

  static const Color red = Color(0xFFBA1A1A);
  static const Color redDark = Color(0xFF93000A);
  static const Color redLight = Color(0xFFFFDAD6);
  static const Color redErrorDark = Color(0xFFEF4444);

  static const Color warningOrange = Color(0xFFC18F2E);
  static const Color warningYellow = Color(0xFFF5BD58);
  static const Color lightBrown = Color(0xFFB45309);

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF181C1C);

  // ==========================================
  // Light Mode Colors
  // ==========================================
  static const Color bgLight = Color(0xFFF9F9FF);
  static const Color greyLight = Color(0xFFF1F4F3);
  static const Color greyText = Color(0xFF6E7977);
  static const Color greyDark = Color(0xFF43474D);
  static const Color greyDark80 = Color(0xCC43474D); // 80% Opacity
  static const Color greySecondaryText = Color(0xFF74777E);

  // Blue Tints (Light Theme)
  static const Color blueLightTint = Color(0xFFDFE8FF);
  static const Color blueSoftBackground = Color(0xFFF0F3FF);
  static const Color blueAccent = Color(0xFFD1E4FF);
  static const Color blueCardBg = Color(0xFFD9E3FB);
  static const Color blueSubtleBg = Color(0xFFE8EEFF);
  static const Color darkBlueSurface = Color(0xFF001D36);
  static const Color navyText = Color(0xFF111C2D);
  static const Color navyDark = Color(0xFF17324D);

  // Brand Opacities (Light)
  static const Color greenOpacity10 = Color(0x1A006C4D); // 10% Opacity
  static const Color greenOpacity15 = Color(0x26006C4D); // 15% Opacity
  static const Color greenOpacity20 = Color(0x33006C4D); // 20% Opacity

  // ==========================================
  // Dark Mode Colors
  // ==========================================
  static const Color bgDark = Color(0xFF0B1117);
  static const Color darkSurface = Color(0xFF151F28);
  static const Color darkSurfaceVariant = Color(0xFF1D2933);
  static const Color darkCardBg = Color(0xFF243444);
  static const Color darkAccentGreen = Color(0xFF15966D);
  static const Color darkMutedText = Color(0xFFAAB4BE);
  static const Color darkSlateText = Color(0xFF819ABA);
  static const Color darkBrownContainer = Color(0xFF422C00);
  static const Color darkRedContainer = Color(0xFF451010);
  static const Color darkGreenContainer = Color(0xFF104938);

  // Dark Mode Opacities & Overlays
  static const Color darkSurface95 = Color(0xF2151F28); // 95% Opacity
  static const Color darkGreenOpacity40 = Color(0x6615966D); // 40% Opacity
  static const Color darkGreenOpacity30 = Color(0x4D15966D); // 30% Opacity
  static const Color darkRedOpacity30 = Color(0x4DEF4444); // 30% Opacity
  static const Color darkYellowOpacity30 = Color(0x4DF5BD58); // 30% Opacity
  static const Color whiteOpacity20 = Color(0x33FFFFFF); // 20% Opacity
  static const Color whiteOpacity02 = Color(0x05FFFFFF); // 0.2% Opacity
}