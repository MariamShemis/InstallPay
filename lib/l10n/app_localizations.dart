import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @iNITIALIZING.
  ///
  /// In en, this message translates to:
  /// **'INITIALIZING'**
  String get iNITIALIZING;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @enterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Phone Number'**
  String get enterYourPhoneNumber;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget Password'**
  String get forgetPassword;

  /// No description provided for @forget_password_.
  ///
  /// In en, this message translates to:
  /// **'Forget Password ?'**
  String get forget_password_;

  /// No description provided for @pleaseEnterYourEmailToReceiveAConfirmationCodeToSetANewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email to receive a confirmation code to set a new password'**
  String get pleaseEnterYourEmailToReceiveAConfirmationCodeToSetANewPassword;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAnAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign_up;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcome_back;

  /// No description provided for @login_with_Google.
  ///
  /// In en, this message translates to:
  /// **'Login with Google'**
  String get login_with_Google;

  /// No description provided for @please_enter_your_email_to_receive_a_confirmation_code_to_set_a_new_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email to receive a confirmation code to set a new password'**
  String get please_enter_your_email_to_receive_a_confirmation_code_to_set_a_new_password;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @general_settings.
  ///
  /// In en, this message translates to:
  /// **'General Settings'**
  String get general_settings;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @account_Security.
  ///
  /// In en, this message translates to:
  /// **'Account & Security'**
  String get account_Security;

  /// No description provided for @log_out.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get log_out;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @are_you_sure_you_want_to_log_out.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out'**
  String get are_you_sure_you_want_to_log_out;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @this_field_is_required.
  ///
  /// In en, this message translates to:
  /// **'this field is required'**
  String get this_field_is_required;

  /// No description provided for @name_must_be_at_least_characters.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 3 characters'**
  String get name_must_be_at_least_characters;

  /// No description provided for @enter_a_valid_email.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get enter_a_valid_email;

  /// No description provided for @enter_a_valid_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get enter_a_valid_phone_number;

  /// No description provided for @password_must_contain_at_least_characters.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least 8 characters'**
  String get password_must_contain_at_least_characters;

  /// No description provided for @passwords_do_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwords_do_not_match;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @choose_your_preferred_language_for_the_app_interface.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language for the app interface.'**
  String get choose_your_preferred_language_for_the_app_interface;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @jobTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Title'**
  String get jobTitle;

  /// No description provided for @enter_your_job.
  ///
  /// In en, this message translates to:
  /// **'Enter your job'**
  String get enter_your_job;

  /// No description provided for @select_your_birthday.
  ///
  /// In en, this message translates to:
  /// **'Select your birthday'**
  String get select_your_birthday;

  /// No description provided for @selectGender.
  ///
  /// In en, this message translates to:
  /// **'Select Gender'**
  String get selectGender;

  /// No description provided for @birthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get birthday;

  /// No description provided for @annualOvertime.
  ///
  /// In en, this message translates to:
  /// **'Annual Overtime'**
  String get annualOvertime;

  /// No description provided for @annualBonus.
  ///
  /// In en, this message translates to:
  /// **'Annual Bonus'**
  String get annualBonus;

  /// No description provided for @take_a_photo.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get take_a_photo;

  /// No description provided for @choose_from_gallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get choose_from_gallery;

  /// No description provided for @something_went_wrong_Please_try_again.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get something_went_wrong_Please_try_again;

  /// No description provided for @this_email_is_already_in_use.
  ///
  /// In en, this message translates to:
  /// **'This email is already in use.'**
  String get this_email_is_already_in_use;

  /// No description provided for @please_enter_a_valid_email_address.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get please_enter_a_valid_email_address;

  /// No description provided for @password_is_too_weak.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak.'**
  String get password_is_too_weak;

  /// No description provided for @no_account_found_with_this_email.
  ///
  /// In en, this message translates to:
  /// **'No account found with this email.'**
  String get no_account_found_with_this_email;

  /// No description provided for @incorrect_email_or_password.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get incorrect_email_or_password;

  /// No description provided for @please_check_your_internet_connection.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection.'**
  String get please_check_your_internet_connection;

  /// No description provided for @too_many_attempts_Please_try_again_later.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later.'**
  String get too_many_attempts_Please_try_again_later;

  /// No description provided for @google_sign_in_was_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Google sign in was cancelled.'**
  String get google_sign_in_was_cancelled;

  /// No description provided for @password_reset_email_sent_successfully.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent successfully.'**
  String get password_reset_email_sent_successfully;

  /// No description provided for @login_successfully.
  ///
  /// In en, this message translates to:
  /// **'login successfully'**
  String get login_successfully;

  /// No description provided for @account_created_successfully.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully.'**
  String get account_created_successfully;

  /// No description provided for @profile_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profile_updated_successfully;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @password_changed_successfully.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get password_changed_successfully;

  /// No description provided for @account_deleted_successfully.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get account_deleted_successfully;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @update_your_account_password.
  ///
  /// In en, this message translates to:
  /// **'Update your account password'**
  String get update_your_account_password;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @permanently_delete_your_account.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account'**
  String get permanently_delete_your_account;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePassword;

  /// No description provided for @this_action_is_permanent_Enter_your_password_to_continue.
  ///
  /// In en, this message translates to:
  /// **'This action is permanent. Enter your password to continue.'**
  String get this_action_is_permanent_Enter_your_password_to_continue;

  /// No description provided for @password_must_contain_letters_and_numbers.
  ///
  /// In en, this message translates to:
  /// **'Password must contain letters and numbers'**
  String get password_must_contain_letters_and_numbers;

  /// No description provided for @verifyEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify Email'**
  String get verifyEmail;

  /// No description provided for @send_verification_email.
  ///
  /// In en, this message translates to:
  /// **'Send verification email'**
  String get send_verification_email;

  /// No description provided for @backup_Restore.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get backup_Restore;

  /// No description provided for @backup_completed_successfully.
  ///
  /// In en, this message translates to:
  /// **'Backup completed successfully'**
  String get backup_completed_successfully;

  /// No description provided for @restore_completed_successfully.
  ///
  /// In en, this message translates to:
  /// **'Restore completed successfully'**
  String get restore_completed_successfully;

  /// No description provided for @no_backup_created_yet.
  ///
  /// In en, this message translates to:
  /// **'No backup created yet'**
  String get no_backup_created_yet;

  /// No description provided for @last_backup.
  ///
  /// In en, this message translates to:
  /// **'Last backup'**
  String get last_backup;

  /// No description provided for @backupLocation.
  ///
  /// In en, this message translates to:
  /// **'Backup Location'**
  String get backupLocation;

  /// No description provided for @googleDrive.
  ///
  /// In en, this message translates to:
  /// **'Google Drive'**
  String get googleDrive;

  /// No description provided for @localDevice.
  ///
  /// In en, this message translates to:
  /// **'Local Device'**
  String get localDevice;

  /// No description provided for @createBackup.
  ///
  /// In en, this message translates to:
  /// **'Create Backup'**
  String get createBackup;

  /// No description provided for @restoreBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore Backup'**
  String get restoreBackup;

  /// No description provided for @operation_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Operation cancelled'**
  String get operation_cancelled;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @account_verified_successfully_with_Google.
  ///
  /// In en, this message translates to:
  /// **'Account verified successfully with Google'**
  String get account_verified_successfully_with_Google;

  /// No description provided for @verify_with_Google.
  ///
  /// In en, this message translates to:
  /// **'Verify with Google'**
  String get verify_with_Google;

  /// No description provided for @lin_your_Google_account_to_verify_this_email_immediately.
  ///
  /// In en, this message translates to:
  /// **'Link your Google account to verify this email immediately'**
  String get lin_your_Google_account_to_verify_this_email_immediately;

  /// No description provided for @emailVerified.
  ///
  /// In en, this message translates to:
  /// **'Email Verified'**
  String get emailVerified;

  /// No description provided for @emailNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Email Not Verified'**
  String get emailNotVerified;

  /// No description provided for @email_does_not_match.
  ///
  /// In en, this message translates to:
  /// **'Email does not match.'**
  String get email_does_not_match;

  /// No description provided for @verification_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Verification cancelled.'**
  String get verification_cancelled;

  /// No description provided for @failed_to_link_Google_account.
  ///
  /// In en, this message translates to:
  /// **'Failed to link Google account.'**
  String get failed_to_link_Google_account;

  /// No description provided for @something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get something_went_wrong;

  /// No description provided for @user_not_found.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get user_not_found;

  /// No description provided for @password_is_required.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get password_is_required;

  /// No description provided for @authentication_failed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed'**
  String get authentication_failed;

  /// No description provided for @noEmailProvided.
  ///
  /// In en, this message translates to:
  /// **'No Email Provided'**
  String get noEmailProvided;

  /// No description provided for @fingerprintLogin.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint Login'**
  String get fingerprintLogin;

  /// No description provided for @secure_access_with_your_fingerprint.
  ///
  /// In en, this message translates to:
  /// **'Secure access with your fingerprint'**
  String get secure_access_with_your_fingerprint;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @emailSent.
  ///
  /// In en, this message translates to:
  /// **'Email Sent'**
  String get emailSent;

  /// No description provided for @we_ve_sent_a_password_reset_link_to.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a password reset link to'**
  String get we_ve_sent_a_password_reset_link_to;

  /// No description provided for @please_check_your_inbox_and_follow_the_instructions_to_reset_your_password.
  ///
  /// In en, this message translates to:
  /// **'Please check your inbox and follow the instructions to reset your password.'**
  String get please_check_your_inbox_and_follow_the_instructions_to_reset_your_password;

  /// No description provided for @back_to_Login.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get back_to_Login;

  /// No description provided for @verification_email_sent_Please_check_your_inbox.
  ///
  /// In en, this message translates to:
  /// **'Verification email sent. Please check your inbox.'**
  String get verification_email_sent_Please_check_your_inbox;

  /// No description provided for @email_verified_successfully.
  ///
  /// In en, this message translates to:
  /// **'Email verified successfully.'**
  String get email_verified_successfully;

  /// No description provided for @verify_your_email_address.
  ///
  /// In en, this message translates to:
  /// **'Verify your email address'**
  String get verify_your_email_address;

  /// No description provided for @congratulations_Your_account_awaits.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! Your account awaits.'**
  String get congratulations_Your_account_awaits;

  /// No description provided for @verify_your_email_to_continue.
  ///
  /// In en, this message translates to:
  /// **'Verify your email to continue.'**
  String get verify_your_email_to_continue;

  /// No description provided for @continue_.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_;

  /// No description provided for @resend_to_Email.
  ///
  /// In en, this message translates to:
  /// **'Resend to Email'**
  String get resend_to_Email;

  /// No description provided for @send_a_verification_email_to_your_email_address.
  ///
  /// In en, this message translates to:
  /// **'Send a verification email to your email address'**
  String get send_a_verification_email_to_your_email_address;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
