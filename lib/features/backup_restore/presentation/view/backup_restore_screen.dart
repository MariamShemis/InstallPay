import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class BackupRestoreScreen extends StatefulWidget {
  const BackupRestoreScreen({super.key});

  @override
  State<BackupRestoreScreen> createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends State<BackupRestoreScreen> {
  String _backupType = "drive";
  DateTime? _lastBackup;

  Future<void> _showComingSoonDialog(String title) async {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
          isDark ? ColorManager.darkSurface : ColorManager.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          icon: Icon(
            Icons.cloud_sync_outlined,
            size: 40.r,
            color: isDark
                ? ColorManager.darkAccentGreen
                : ColorManager.primaryColor,
          ),
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            l10n.something_went_wrong_Please_try_again,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.ok),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryColor = isDark
        ? ColorManager.darkAccentGreen
        : ColorManager.primaryColor;

    final cardBgColor =
    isDark ? ColorManager.darkSurface : ColorManager.white;

    final cardBorderColor = isDark
        ? ColorManager.darkSurfaceVariant
        : ColorManager.blueLightTint;

    final secondaryTextColor =
    isDark ? ColorManager.darkMutedText : ColorManager.greyDark;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.backup_Restore),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: REdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Container(
                  width: double.infinity,
                  padding: REdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(color: cardBorderColor, width: 1.w),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.cloud_done_outlined,
                        size: 60.r,
                        color: primaryColor,
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        l10n.backup_Restore,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        _lastBackup == null
                            ? (l10n.no_account_found_with_this_email ??
                            "No backup created yet")
                            : "${_lastBackup.toString().split('.').first}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Material(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(20.r),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    padding: REdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: cardBorderColor, width: 1.w),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: REdgeInsets.only(left: 8, bottom: 8, right: 8),
                          child: Text(
                            l10n.appearance_PREFERENCES,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        RadioListTile<String>(
                          value: "drive",
                          groupValue: _backupType,
                          activeColor: primaryColor,
                          onChanged: (value) {
                            setState(() {
                              _backupType = value!;
                            });
                          },
                          title: const Text("Google Drive"),
                          secondary: Icon(
                            Icons.cloud,
                            color: primaryColor,
                          ),
                        ),
                        RadioListTile<String>(
                          value: "local",
                          groupValue: _backupType,
                          activeColor: primaryColor,
                          onChanged: (value) {
                            setState(() {
                              _backupType = value!;
                            });
                          },
                          title: Text(l10n.localDevice),
                          secondary: Icon(
                            Icons.phone_android,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 36.h),
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        _showComingSoonDialog(l10n.backup_Restore),
                    icon: const Icon(Icons.cloud_upload_outlined),
                    label: Text(
                      l10n.createBackup.toUpperCase(),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        _showComingSoonDialog(l10n.backup_Restore),
                    icon: const Icon(Icons.settings_backup_restore_rounded),
                    label: Text(
                      l10n.restoreBackup.toUpperCase(),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}