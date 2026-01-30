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
