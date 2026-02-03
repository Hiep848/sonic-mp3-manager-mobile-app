import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

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
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Audio Journal'**
  String get appTitle;

  /// No description provided for @navJournal.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get navJournal;

  /// No description provided for @navAlbums.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get navAlbums;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'My Audio Journal'**
  String get homeTitle;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search title, content...'**
  String get searchPlaceholder;

  /// No description provided for @uploadTitle.
  ///
  /// In en, this message translates to:
  /// **'New Journal Entry'**
  String get uploadTitle;

  /// No description provided for @uploadSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get uploadSave;

  /// No description provided for @uploadInputTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get uploadInputTitle;

  /// No description provided for @uploadInputTitleHint.
  ///
  /// In en, this message translates to:
  /// **'What happened today?'**
  String get uploadInputTitleHint;

  /// No description provided for @uploadDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Recorded on:'**
  String get uploadDateLabel;

  /// No description provided for @uploadMoodLabel.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get uploadMoodLabel;

  /// No description provided for @uploadAlbumLabel.
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get uploadAlbumLabel;

  /// No description provided for @uploadAlbumNew.
  ///
  /// In en, this message translates to:
  /// **'+ Create New Album'**
  String get uploadAlbumNew;

  /// No description provided for @uploadAudioNoFile.
  ///
  /// In en, this message translates to:
  /// **'No audio file selected'**
  String get uploadAudioNoFile;

  /// No description provided for @uploadAudioPick.
  ///
  /// In en, this message translates to:
  /// **'Pick MP3'**
  String get uploadAudioPick;

  /// No description provided for @uploadContentLabel.
  ///
  /// In en, this message translates to:
  /// **'Journal Content'**
  String get uploadContentLabel;

  /// No description provided for @uploadContentHint.
  ///
  /// In en, this message translates to:
  /// **'Write about your recording...'**
  String get uploadContentHint;

  /// No description provided for @uploadHashtagLabel.
  ///
  /// In en, this message translates to:
  /// **'Add Hashtag'**
  String get uploadHashtagLabel;

  /// No description provided for @uploadAttachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get uploadAttachments;

  /// No description provided for @uploadUploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get uploadUploading;

  /// No description provided for @uploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Journal saved!'**
  String get uploadSuccess;

  /// No description provided for @uploadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get uploadErrorTitle;

  /// No description provided for @detailRecorded.
  ///
  /// In en, this message translates to:
  /// **'Recorded:'**
  String get detailRecorded;

  /// No description provided for @detailRecording.
  ///
  /// In en, this message translates to:
  /// **'Recording'**
  String get detailRecording;

  /// No description provided for @detailJournal.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get detailJournal;

  /// No description provided for @detailPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get detailPhotos;

  /// No description provided for @detailFullScreen.
  ///
  /// In en, this message translates to:
  /// **'Read Full Screen'**
  String get detailFullScreen;

  /// No description provided for @detailEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit feature coming soon'**
  String get detailEdit;

  /// No description provided for @detailDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get detailDelete;

  /// No description provided for @albumTitle.
  ///
  /// In en, this message translates to:
  /// **'My Albums'**
  String get albumTitle;

  /// No description provided for @albumAudios.
  ///
  /// In en, this message translates to:
  /// **'audios'**
  String get albumAudios;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get settingsProfile;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsTheme;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeDarkSub.
  ///
  /// In en, this message translates to:
  /// **'Use darker colors for night time'**
  String get settingsThemeDarkSub;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSub.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese / English'**
  String get settingsLanguageSub;

  /// No description provided for @settingsSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSecurity;

  /// No description provided for @settingsChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get settingsChangePassword;

  /// No description provided for @settingsChangePasswordSub.
  ///
  /// In en, this message translates to:
  /// **'Update your password'**
  String get settingsChangePasswordSub;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsLogout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get settingsLogout;

  /// No description provided for @settingsLogoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Logging out...'**
  String get settingsLogoutConfirm;

  /// No description provided for @settingsLogoutSuccess.
  ///
  /// In en, this message translates to:
  /// **'See you again!'**
  String get settingsLogoutSuccess;

  /// No description provided for @settingsLogoutError.
  ///
  /// In en, this message translates to:
  /// **'Logout Error'**
  String get settingsLogoutError;

  /// No description provided for @commonError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String commonError(Object error);

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonLoading;

  /// No description provided for @authWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get authWelcome;

  /// No description provided for @authLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login Error'**
  String get authLoginTitle;

  /// No description provided for @authLoginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get authLoginSuccess;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authLoginButton.
  ///
  /// In en, this message translates to:
  /// **'LOGIN'**
  String get authLoginButton;

  /// No description provided for @authNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign Up'**
  String get authNoAccount;

  /// No description provided for @authEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter Email'**
  String get authEnterEmail;

  /// No description provided for @authInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid Email'**
  String get authInvalidEmail;

  /// No description provided for @authEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get authEnterPassword;

  /// No description provided for @authShortPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get authShortPassword;

  /// No description provided for @authRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authRegisterTitle;

  /// No description provided for @authFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get authFullName;

  /// No description provided for @authConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPassword;

  /// No description provided for @authSignUpButton.
  ///
  /// In en, this message translates to:
  /// **'SIGN UP'**
  String get authSignUpButton;

  /// No description provided for @authHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get authHaveAccount;

  /// No description provided for @authRegisterSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created! Please login.'**
  String get authRegisterSuccess;

  /// No description provided for @authEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get authEnterName;

  /// No description provided for @authConfirmPassEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get authConfirmPassEmpty;

  /// No description provided for @authPassMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get authPassMismatch;

  /// No description provided for @authRegisterError.
  ///
  /// In en, this message translates to:
  /// **'Registration Error'**
  String get authRegisterError;

  /// No description provided for @authCreatingAccount.
  ///
  /// In en, this message translates to:
  /// **'Creating account...'**
  String get authCreatingAccount;

  /// No description provided for @authLoggingIn.
  ///
  /// In en, this message translates to:
  /// **'Logging in...'**
  String get authLoggingIn;

  /// No description provided for @socialOrContinue.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get socialOrContinue;

  /// No description provided for @socialGoogleError.
  ///
  /// In en, this message translates to:
  /// **'Google Error'**
  String get socialGoogleError;

  /// No description provided for @socialAuthCodeError.
  ///
  /// In en, this message translates to:
  /// **'Cannot get Auth Code. Check Console config.'**
  String get socialAuthCodeError;

  /// No description provided for @socialSignInInit.
  ///
  /// In en, this message translates to:
  /// **'Initializing Google Sign-In...'**
  String get socialSignInInit;

  /// No description provided for @socialFeatureDev.
  ///
  /// In en, this message translates to:
  /// **'Feature in development'**
  String get socialFeatureDev;

  /// No description provided for @uploadScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload MP3'**
  String get uploadScreenTitle;

  /// No description provided for @uploadInBackground.
  ///
  /// In en, this message translates to:
  /// **'Uploading in background...'**
  String get uploadInBackground;

  /// No description provided for @uploadNoFileSelected.
  ///
  /// In en, this message translates to:
  /// **'No file selected'**
  String get uploadNoFileSelected;

  /// No description provided for @uploadButtonPick.
  ///
  /// In en, this message translates to:
  /// **'PICK MP3 FILE'**
  String get uploadButtonPick;

  /// No description provided for @uploadButtonStart.
  ///
  /// In en, this message translates to:
  /// **'START UPLOAD'**
  String get uploadButtonStart;

  /// No description provided for @uploadButtonChange.
  ///
  /// In en, this message translates to:
  /// **'Choose another file'**
  String get uploadButtonChange;

  /// No description provided for @albumNoData.
  ///
  /// In en, this message translates to:
  /// **'No albums found'**
  String get albumNoData;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @albumCreateNew.
  ///
  /// In en, this message translates to:
  /// **'New Album'**
  String get albumCreateNew;

  /// No description provided for @albumNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter album name'**
  String get albumNameHint;

  /// No description provided for @albumCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get albumCreateButton;

  /// No description provided for @feedSortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get feedSortNewest;

  /// No description provided for @feedSortPopular.
  ///
  /// In en, this message translates to:
  /// **'Most Popular'**
  String get feedSortPopular;

  /// No description provided for @feedNoPosts.
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get feedNoPosts;

  /// No description provided for @feedUploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get feedUploading;

  /// No description provided for @commonErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred: {error}'**
  String commonErrorUnknown(Object error);

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get commonOpen;

  /// No description provided for @albumRename.
  ///
  /// In en, this message translates to:
  /// **'Rename Album'**
  String get albumRename;

  /// No description provided for @albumDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete Album'**
  String get albumDelete;

  /// No description provided for @albumDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Album'**
  String get albumDeleteTitle;

  /// No description provided for @albumDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this album?'**
  String get albumDeleteConfirm;

  /// No description provided for @albumDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete: {error}'**
  String albumDeleteFailed(Object error);

  /// No description provided for @albumDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Delete album successfully'**
  String get albumDeleteSuccess;

  /// No description provided for @albumRenameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename Album'**
  String get albumRenameTitle;

  /// No description provided for @albumRenameFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to rename: {error}'**
  String albumRenameFailed(Object error);

  /// No description provided for @albumRenameSuccess.
  ///
  /// In en, this message translates to:
  /// **'Rename album successfully'**
  String get albumRenameSuccess;

  /// No description provided for @albumNoTracks.
  ///
  /// In en, this message translates to:
  /// **'No tracks in this album'**
  String get albumNoTracks;

  /// No description provided for @albumUnknownArtist.
  ///
  /// In en, this message translates to:
  /// **'Unknown Artist'**
  String get albumUnknownArtist;

  /// No description provided for @albumAddMp3Title.
  ///
  /// In en, this message translates to:
  /// **'Add MP3 to Album'**
  String get albumAddMp3Title;

  /// No description provided for @albumNoMp3s.
  ///
  /// In en, this message translates to:
  /// **'No MP3s found'**
  String get albumNoMp3s;

  /// No description provided for @albumNoDescription.
  ///
  /// In en, this message translates to:
  /// **'No description'**
  String get albumNoDescription;

  /// No description provided for @albumAddSuccess.
  ///
  /// In en, this message translates to:
  /// **'Added \"{title}\" to album'**
  String albumAddSuccess(Object title);

  /// No description provided for @albumAddFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to add: {error}'**
  String albumAddFailed(Object error);

  /// No description provided for @detailSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Changes saved!'**
  String get detailSaveSuccess;

  /// No description provided for @detailDownloadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Download complete: {format}'**
  String detailDownloadSuccess(Object format);

  /// No description provided for @detailDownloadError.
  ///
  /// In en, this message translates to:
  /// **'Download error: {error}'**
  String detailDownloadError(Object error);

  /// No description provided for @detailDownloadTooltip.
  ///
  /// In en, this message translates to:
  /// **'Download Transcript'**
  String get detailDownloadTooltip;

  /// No description provided for @detailDownloadWord.
  ///
  /// In en, this message translates to:
  /// **'Download Word (.docx)'**
  String get detailDownloadWord;

  /// No description provided for @detailDownloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF (.pdf)'**
  String get detailDownloadPdf;

  /// No description provided for @detailEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get detailEditTitle;

  /// No description provided for @detailEditMood.
  ///
  /// In en, this message translates to:
  /// **'Mood:'**
  String get detailEditMood;

  /// No description provided for @detailEditContentHint.
  ///
  /// In en, this message translates to:
  /// **'Content...'**
  String get detailEditContentHint;

  /// No description provided for @detailNoContent.
  ///
  /// In en, this message translates to:
  /// **'No content.'**
  String get detailNoContent;

  /// No description provided for @featureInDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Feature under development'**
  String get featureInDevelopment;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
