import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/features/main_layout/profile/presentation/widgets/user_image_profile.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.name,
    required this.job,
    required this.phoneNumber,
    required this.image,
  });

  final String name;
  final String job;
  final String phoneNumber;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? ColorManager.darkSurface : ColorManager.white,
        borderRadius: BorderRadius.circular(24.r),
        border: isDark
            ? Border.all(color: ColorManager.darkSurfaceVariant, width: 1.w)
            : null,
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
      ),
      child: Column(
        children: [
          UserImageProfile(image: image,),
          SizedBox(height: 12.h),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? ColorManager.white : ColorManager.navyDark,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            job,
            style: TextStyle(
              color: isDark
                  ? ColorManager.darkAccentGreen1
                  : ColorManager.primaryColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10.h),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ?phoneNumber.isNotEmpty
                    ? Icon(
                        Icons.phone,
                        color: ColorManager.primaryColor,
                        size: 16.sp,
                      )
                    : null,
                SizedBox(width: 5.w),
                Text(
                  phoneNumber,
                  style: TextStyle(
                    color: isDark
                        ? ColorManager.darkSlateText
                        : ColorManager.greySecondaryText,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
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
