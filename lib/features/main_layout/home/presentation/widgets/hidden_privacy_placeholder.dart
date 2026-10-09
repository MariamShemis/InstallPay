import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';

class HiddenPrivacyPlaceholder extends StatelessWidget {
  final String userName;
  final VoidCallback onUnhideTap;

  const HiddenPrivacyPlaceholder({
    super.key,
    required this.userName,
    required this.onUnhideTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: REdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                ColorManager.darkSurfaceVariant,
                ColorManager.darkSurface,
              ]
                  : [
                ColorManager.primaryColor,
                ColorManager.green5f,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black38 : ColorManager.greenOpacity20,
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 32.r,
                backgroundColor: Colors.white.withOpacity(0.15),
                child: Icon(
                  Icons.shield_outlined,
                  color: Colors.white,
                  size: 34.r,
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                'Financial Privacy Active',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Your account balances and transaction totals are currently hidden for security.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: Colors.white.withOpacity(0.85),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 16.h),
              ElevatedButton.icon(
                onPressed: onUnhideTap,
                icon: Icon(
                  Icons.visibility_outlined,
                  size: 18.r,
                  color: isDark
                      ? ColorManager.darkSurface
                      : ColorManager.primaryColor,
                ),
                label: Text(
                  'Show Dashboard Details',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? ColorManager.darkSurface
                        : ColorManager.primaryColor,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(180.w, 42.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildQuickFeatureTile(
                context: context,
                isDark: isDark,
                icon: Icons.lock_clock_outlined,
                title: 'Data Safe',
                subtitle: 'Protected Mode',
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildQuickFeatureTile(
                context: context,
                isDark: isDark,
                icon: Icons.verified_user_outlined,
                title: 'Private',
                subtitle: 'Session Shield',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickFeatureTile({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: REdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? ColorManager.darkSurfaceVariant
              : ColorManager.blueLightTint,
          width: 1.w,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: REdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark
                  ? ColorManager.darkSurfaceVariant
                  : ColorManager.blueSoftBackground,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              size: 20.r,
              color: isDark
                  ? ColorManager.darkAccentGreen
                  : ColorManager.primaryColor,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 10.5.sp,
                    color: isDark
                        ? ColorManager.darkSlateText
                        : ColorManager.greySecondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}