import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/features/main_layout/customers/data/model/customer_model.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class CustomerDetailsHeader extends StatelessWidget {
  final CustomerModel customer;
  final Color primaryColor;
  final bool isDark;

  const CustomerDetailsHeader({
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
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: REdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundColor: primaryColor.withOpacity(0.15),
                child: Text(
                  _initials,
                  style: TextStyle(
                    fontSize: 20.sp,
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
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        _badge(
                          customer.groupName,
                          primaryColor.withOpacity(0.12),
                          primaryColor,
                        ),
                        SizedBox(width: 6.w),
                        _badge(
                          _statusLabel(context),
                          _statusColor(),
                          _statusTextColor(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Divider(height: 1, color: _borderColor()),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _infoTile(
                  context,
                  title: appLocalizations.phoneNumber,
                  value: customer.customerPhone,
                  icon: Icons.phone_outlined,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _infoTile(
                  context,
                  title: appLocalizations.address,
                  value: customer.address.isNotEmpty
                      ? customer.address
                      : appLocalizations.notAvailable,
                  icon: Icons.location_on_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoTile(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: REdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: _borderColor().withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16.r, color: _secondaryColor()),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 9.sp, color: _secondaryColor()),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text, Color backgroundColor, Color textColor) {
    return Flexible(
      child: Container(
        padding: REdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12.5.sp,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }

  String _statusLabel(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    switch (customer.status.toLowerCase()) {
      case 'overdue':
        return appLocalizations.overdue;
      case 'pending':
        return appLocalizations.pending;
      case 'completed':
        return appLocalizations.completed;
      default:
        return customer.status;
    }
  }

  Color _statusColor() {
    switch (customer.status.toLowerCase()) {
      case 'overdue':
        return ColorManager.red.withOpacity(0.12);
      case 'pending':
        return ColorManager.warningOrange.withOpacity(0.12);
      default:
        return primaryColor.withOpacity(0.12);
    }
  }

  Color _statusTextColor() {
    switch (customer.status.toLowerCase()) {
      case 'overdue':
        return ColorManager.red;
      case 'pending':
        return ColorManager.warningOrange;
      default:
        return primaryColor;
    }
  }

  Color _secondaryColor() {
    return isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
  }

  Color _borderColor() {
    return isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      borderRadius: BorderRadius.circular(14.r),
      border: Border.all(color: _borderColor()),
      boxShadow: isDark
          ? []
          : [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
    );
  }
}
