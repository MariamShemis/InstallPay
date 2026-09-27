import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';

class InstallmentPayHeader extends StatelessWidget {
  final CustomerModel customer;
  final Color primaryColor;
  final bool isDark;

  const InstallmentPayHeader({
    super.key,
    required this.customer,
    required this.primaryColor,
    required this.isDark,
  });

  String get _initials {
    final names = customer.customerName.trim().split(RegExp(r'\s+'));

    if (names.isEmpty || names.first.isEmpty) {
      return 'C';
    }

    if (names.length == 1) {
      return names.first[0].toUpperCase();
    }

    return '${names.first[0]}${names.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26.r,
            backgroundColor: primaryColor.withOpacity(0.15),
            child: Text(
              _initials,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.customerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        customer.groupName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: _secondaryColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: CircleAvatar(
                        radius: 2.r,
                        backgroundColor: _secondaryColor,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        customer.contractName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color get _secondaryColor {
    return isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
  }

  Color get _borderColor {
    return isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: _borderColor),
    );
  }
}