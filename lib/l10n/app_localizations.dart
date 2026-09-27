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

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

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

  /// No description provided for @sign_in_to_access_your_installment_management_workspace.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your installment management workspace'**
  String get sign_in_to_access_your_installment_management_workspace;

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

  /// No description provided for @smartFinancialSolutions_FieldCollection.
  ///
  /// In en, this message translates to:
  /// **'Smart Financial Solutions & Field Collection'**
  String get smartFinancialSolutions_FieldCollection;

  /// No description provided for @initializingSecureWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Initializing Secure Workspace'**
  String get initializingSecureWorkspace;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @nET_SALARY.
  ///
  /// In en, this message translates to:
  /// **'NET SALARY'**
  String get nET_SALARY;

  /// No description provided for @lE.
  ///
  /// In en, this message translates to:
  /// **'LE'**
  String get lE;

  /// No description provided for @basicSalary.
  ///
  /// In en, this message translates to:
  /// **'Basic Salary'**
  String get basicSalary;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @bonus.
  ///
  /// In en, this message translates to:
  /// **'Bonus'**
  String get bonus;

  /// No description provided for @deductions.
  ///
  /// In en, this message translates to:
  /// **'Deductions'**
  String get deductions;

  /// No description provided for @days_remaining_from.
  ///
  /// In en, this message translates to:
  /// **'days remaining from'**
  String get days_remaining_from;

  /// No description provided for @count.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get count;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @totalSalary.
  ///
  /// In en, this message translates to:
  /// **'Total Salary'**
  String get totalSalary;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @partners.
  ///
  /// In en, this message translates to:
  /// **'Partners'**
  String get partners;

  /// No description provided for @groups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groups;

  /// No description provided for @customers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// No description provided for @tracker.
  ///
  /// In en, this message translates to:
  /// **'Tracker'**
  String get tracker;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @capital.
  ///
  /// In en, this message translates to:
  /// **'Capital'**
  String get capital;

  /// No description provided for @totalNetCapital.
  ///
  /// In en, this message translates to:
  /// **'Total Net Capital'**
  String get totalNetCapital;

  /// No description provided for @activeVault.
  ///
  /// In en, this message translates to:
  /// **'Active Vault'**
  String get activeVault;

  /// No description provided for @this_week.
  ///
  /// In en, this message translates to:
  /// **'this week'**
  String get this_week;

  /// No description provided for @collection.
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get collection;

  /// No description provided for @liquidityRate.
  ///
  /// In en, this message translates to:
  /// **'Liquidity Rate'**
  String get liquidityRate;

  /// No description provided for @safe.
  ///
  /// In en, this message translates to:
  /// **'Safe'**
  String get safe;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @moM.
  ///
  /// In en, this message translates to:
  /// **'MoM'**
  String get moM;

  /// No description provided for @outMoney.
  ///
  /// In en, this message translates to:
  /// **'Out Money'**
  String get outMoney;

  /// No description provided for @accounts_due.
  ///
  /// In en, this message translates to:
  /// **'accounts due'**
  String get accounts_due;

  /// No description provided for @monthCollection.
  ///
  /// In en, this message translates to:
  /// **'Month Collection'**
  String get monthCollection;

  /// No description provided for @vs_last_month.
  ///
  /// In en, this message translates to:
  /// **'vs last month'**
  String get vs_last_month;

  /// No description provided for @monthTarget.
  ///
  /// In en, this message translates to:
  /// **'Month Target'**
  String get monthTarget;

  /// No description provided for @onTrack.
  ///
  /// In en, this message translates to:
  /// **'On Track'**
  String get onTrack;

  /// No description provided for @todayCollection.
  ///
  /// In en, this message translates to:
  /// **'Today Collection'**
  String get todayCollection;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @hubs_assigned.
  ///
  /// In en, this message translates to:
  /// **'Hubs assigned'**
  String get hubs_assigned;

  /// No description provided for @goodStanding.
  ///
  /// In en, this message translates to:
  /// **'Good Standing'**
  String get goodStanding;

  /// No description provided for @delinquentInstallments.
  ///
  /// In en, this message translates to:
  /// **'Delinquent Installments'**
  String get delinquentInstallments;

  /// No description provided for @delinquent.
  ///
  /// In en, this message translates to:
  /// **'Delinquent'**
  String get delinquent;

  /// No description provided for @accounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accounts;

  /// No description provided for @overdue_action_required.
  ///
  /// In en, this message translates to:
  /// **'Overdue action required'**
  String get overdue_action_required;

  /// No description provided for @payOut.
  ///
  /// In en, this message translates to:
  /// **'Pay Out'**
  String get payOut;

  /// No description provided for @scheduled_this_week.
  ///
  /// In en, this message translates to:
  /// **'Scheduled this week'**
  String get scheduled_this_week;

  /// No description provided for @appearance_PREFERENCES.
  ///
  /// In en, this message translates to:
  /// **'APPEARANCE & PREFERENCES'**
  String get appearance_PREFERENCES;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @toggle_dark_and_light_theme.
  ///
  /// In en, this message translates to:
  /// **'Toggle dark & light theme'**
  String get toggle_dark_and_light_theme;

  /// No description provided for @current_interface_language.
  ///
  /// In en, this message translates to:
  /// **'Current interface language'**
  String get current_interface_language;

  /// No description provided for @currencyDisplay.
  ///
  /// In en, this message translates to:
  /// **'Currency Display'**
  String get currencyDisplay;

  /// No description provided for @receipt_and_ledger_metric_standard.
  ///
  /// In en, this message translates to:
  /// **'Receipt & ledger metric standard'**
  String get receipt_and_ledger_metric_standard;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @search_customers_phone_group.
  ///
  /// In en, this message translates to:
  /// **'Search customers, phone, group'**
  String get search_customers_phone_group;

  /// No description provided for @paymentProgress.
  ///
  /// In en, this message translates to:
  /// **'Payment Progress'**
  String get paymentProgress;

  /// No description provided for @noCustomersFound.
  ///
  /// In en, this message translates to:
  /// **'No Customers Found'**
  String get noCustomersFound;

  /// No description provided for @start_adding_customers_to_track_their_installments_and_payments.
  ///
  /// In en, this message translates to:
  /// **'Start adding customers to track their installments and payments.'**
  String get start_adding_customers_to_track_their_installments_and_payments;

  /// No description provided for @addNewCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add New Customer'**
  String get addNewCustomer;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @group.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// No description provided for @selectGroup.
  ///
  /// In en, this message translates to:
  /// **'Select Group'**
  String get selectGroup;

  /// No description provided for @customerName.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customerName;

  /// No description provided for @enter_customer_name.
  ///
  /// In en, this message translates to:
  /// **'Enter customer name'**
  String get enter_customer_name;

  /// No description provided for @enter_customer_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Enter customer phone number'**
  String get enter_customer_phone_number;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @enter_customer_address.
  ///
  /// In en, this message translates to:
  /// **'Enter customer address'**
  String get enter_customer_address;

  /// No description provided for @contractDetails.
  ///
  /// In en, this message translates to:
  /// **'Contract Details'**
  String get contractDetails;

  /// No description provided for @contractDate.
  ///
  /// In en, this message translates to:
  /// **'Contract Date'**
  String get contractDate;

  /// No description provided for @contractName.
  ///
  /// In en, this message translates to:
  /// **'Contract Name'**
  String get contractName;

  /// No description provided for @purchasePrice.
  ///
  /// In en, this message translates to:
  /// **'Purchase Price'**
  String get purchasePrice;

  /// No description provided for @installmentAmount.
  ///
  /// In en, this message translates to:
  /// **'Installment Amount'**
  String get installmentAmount;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get period;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @firstInstallmentDate.
  ///
  /// In en, this message translates to:
  /// **'First Installment Date'**
  String get firstInstallmentDate;

  /// No description provided for @downPayment.
  ///
  /// In en, this message translates to:
  /// **'Down Payment'**
  String get downPayment;

  /// No description provided for @totalCost.
  ///
  /// In en, this message translates to:
  /// **'Total Cost'**
  String get totalCost;

  /// No description provided for @netDebtAmount.
  ///
  /// In en, this message translates to:
  /// **'Net Debt Amount'**
  String get netDebtAmount;

  /// No description provided for @netDebt.
  ///
  /// In en, this message translates to:
  /// **'Net Debt'**
  String get netDebt;

  /// No description provided for @basic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get basic;

  /// No description provided for @additional_contract_notes.
  ///
  /// In en, this message translates to:
  /// **'Additional contract notes'**
  String get additional_contract_notes;

  /// No description provided for @confirmCustomer_Contract.
  ///
  /// In en, this message translates to:
  /// **'Confirm Customer & Contract'**
  String get confirmCustomer_Contract;

  /// No description provided for @are_you_sure_you_want_to_add_this_customer.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to add this customer'**
  String get are_you_sure_you_want_to_add_this_customer;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get personalDetails;

  /// No description provided for @installment.
  ///
  /// In en, this message translates to:
  /// **'Installment'**
  String get installment;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @search_groups_collectors_zones.
  ///
  /// In en, this message translates to:
  /// **'Search groups, collectors, zones'**
  String get search_groups_collectors_zones;

  /// No description provided for @addNewGroup.
  ///
  /// In en, this message translates to:
  /// **'Add New Group'**
  String get addNewGroup;

  /// No description provided for @groupName.
  ///
  /// In en, this message translates to:
  /// **'Group Name'**
  String get groupName;

  /// No description provided for @enter_group_name.
  ///
  /// In en, this message translates to:
  /// **'Enter group name'**
  String get enter_group_name;

  /// No description provided for @collectorName.
  ///
  /// In en, this message translates to:
  /// **'Collector Name'**
  String get collectorName;

  /// No description provided for @enter_responsible_person_name.
  ///
  /// In en, this message translates to:
  /// **'Enter responsible person name'**
  String get enter_responsible_person_name;

  /// No description provided for @enter_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enter_phone_number;

  /// No description provided for @enter_address.
  ///
  /// In en, this message translates to:
  /// **'Enter address'**
  String get enter_address;

  /// No description provided for @due.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get due;

  /// No description provided for @totalValue.
  ///
  /// In en, this message translates to:
  /// **'Total Value'**
  String get totalValue;

  /// No description provided for @collected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get collected;

  /// No description provided for @collectionProgress.
  ///
  /// In en, this message translates to:
  /// **'Collection Progress'**
  String get collectionProgress;

  /// No description provided for @noGroupsFound.
  ///
  /// In en, this message translates to:
  /// **'No Groups Found'**
  String get noGroupsFound;

  /// No description provided for @start_managing_your_collections_by_adding_a_new_group.
  ///
  /// In en, this message translates to:
  /// **'Start managing your collections by adding a new group'**
  String get start_managing_your_collections_by_adding_a_new_group;

  /// No description provided for @sellingPrice.
  ///
  /// In en, this message translates to:
  /// **'Selling Price'**
  String get sellingPrice;

  /// No description provided for @debt.
  ///
  /// In en, this message translates to:
  /// **'Debt'**
  String get debt;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @customerDetails.
  ///
  /// In en, this message translates to:
  /// **'Customer Details'**
  String get customerDetails;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// No description provided for @contract.
  ///
  /// In en, this message translates to:
  /// **'Contract'**
  String get contract;

  /// No description provided for @debtAmount.
  ///
  /// In en, this message translates to:
  /// **'Debt Amount'**
  String get debtAmount;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @firstPayment.
  ///
  /// In en, this message translates to:
  /// **'First Payment'**
  String get firstPayment;

  /// No description provided for @nextDueDate.
  ///
  /// In en, this message translates to:
  /// **'Next Due Date'**
  String get nextDueDate;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @payInstallment.
  ///
  /// In en, this message translates to:
  /// **'Pay Installment'**
  String get payInstallment;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @paidAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount} {currency} paid'**
  String paidAmount(String amount, String currency);

  /// No description provided for @remainingAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount} {currency} remaining'**
  String remainingAmount(String amount, String currency);

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// No description provided for @installmentsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Installments'**
  String installmentsCount(int count);

  /// No description provided for @agreedTotalDebt.
  ///
  /// In en, this message translates to:
  /// **'Agreed Total Debt'**
  String get agreedTotalDebt;

  /// No description provided for @contractValue.
  ///
  /// In en, this message translates to:
  /// **'Contract Value'**
  String get contractValue;

  /// No description provided for @paidPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% Paid'**
  String paidPercent(String percent);

  /// No description provided for @installmentsLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} Left'**
  String installmentsLeft(int count);

  /// No description provided for @settledInstallmentsAndDownPayment.
  ///
  /// In en, this message translates to:
  /// **'Settled Installments & Down Payment'**
  String get settledInstallmentsAndDownPayment;

  /// No description provided for @dueNow.
  ///
  /// In en, this message translates to:
  /// **'Due Now'**
  String get dueNow;

  /// No description provided for @paidUpfrontCommitment.
  ///
  /// In en, this message translates to:
  /// **'Paid Upfront Commitment'**
  String get paidUpfrontCommitment;

  /// No description provided for @upfrontCommitmentDue.
  ///
  /// In en, this message translates to:
  /// **'Upfront Commitment Due'**
  String get upfrontCommitmentDue;

  /// No description provided for @unpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaid;

  /// No description provided for @installmentNumber.
  ///
  /// In en, this message translates to:
  /// **'Installment {number}'**
  String installmentNumber(int number);

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due: {date}'**
  String dueDate(String date);

  /// No description provided for @paidOn.
  ///
  /// In en, this message translates to:
  /// **'Paid on: {date}'**
  String paidOn(String date);

  /// No description provided for @selectedForPayment.
  ///
  /// In en, this message translates to:
  /// **'Selected for Payment'**
  String get selectedForPayment;

  /// No description provided for @alreadyPaid.
  ///
  /// In en, this message translates to:
  /// **'Already Paid'**
  String get alreadyPaid;

  /// No description provided for @paySelectedInstallment.
  ///
  /// In en, this message translates to:
  /// **'Pay Selected Installment'**
  String get paySelectedInstallment;

  /// No description provided for @paymentOptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'{title} Payment Options'**
  String paymentOptionsTitle(Object title);

  /// No description provided for @paymentOptionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Do you want to pay the full installment amount or record a custom amount?'**
  String get paymentOptionsSubtitle;

  /// No description provided for @dueDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get dueDateLabel;

  /// No description provided for @paymentDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Date'**
  String get paymentDateLabel;

  /// No description provided for @payFullInstallmentBtn.
  ///
  /// In en, this message translates to:
  /// **'Pay Full Installment ({amount})'**
  String payFullInstallmentBtn(Object amount);

  /// No description provided for @customPartialAmountBtn.
  ///
  /// In en, this message translates to:
  /// **'Custom / Partial Amount'**
  String get customPartialAmountBtn;

  /// No description provided for @enterCustomAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter Custom Amount'**
  String get enterCustomAmountLabel;

  /// No description provided for @confirmCustomPaymentBtn.
  ///
  /// In en, this message translates to:
  /// **'Confirm Custom Payment'**
  String get confirmCustomPaymentBtn;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;
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
