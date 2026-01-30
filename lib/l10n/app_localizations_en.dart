// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Audio Journal';

  @override
  String get navJournal => 'Journal';

  @override
  String get navAlbums => 'Albums';

  @override
  String get navSettings => 'Settings';

  @override
  String get homeTitle => 'My Audio Journal';

  @override
  String get searchPlaceholder => 'Search title, content...';

  @override
  String get uploadTitle => 'New Journal Entry';

  @override
  String get uploadSave => 'Save';

  @override
  String get uploadInputTitle => 'Title';

  @override
  String get uploadInputTitleHint => 'What happened today?';

  @override
  String get uploadDateLabel => 'Recorded on:';

  @override
  String get uploadMoodLabel => 'Mood';

  @override
  String get uploadAlbumLabel => 'Album';

  @override
  String get uploadAlbumNew => '+ Create New Album';

  @override
  String get uploadAudioNoFile => 'No audio file selected';

  @override
  String get uploadAudioPick => 'Pick MP3';

  @override
  String get uploadContentLabel => 'Journal Content';

  @override
  String get uploadContentHint => 'Write about your recording...';

  @override
  String get uploadHashtagLabel => 'Add Hashtag';

  @override
  String get uploadAttachments => 'Attachments';

  @override
  String get uploadUploading => 'Uploading...';

  @override
  String get uploadSuccess => 'Journal saved!';

  @override
  String get uploadErrorTitle => 'Please enter a title';

  @override
  String get detailRecorded => 'Recorded:';

  @override
  String get detailRecording => 'Recording';

  @override
  String get detailJournal => 'Journal';

  @override
  String get detailPhotos => 'Photos';

  @override
  String get detailFullScreen => 'Read Full Screen';

  @override
  String get detailEdit => 'Edit feature coming soon';

  @override
  String get detailDelete => 'Delete';

  @override
  String get albumTitle => 'My Albums';

  @override
  String get albumAudios => 'audios';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsProfile => 'Profile';

  @override
  String get settingsTheme => 'Appearance';

  @override
  String get settingsThemeDark => 'Dark Mode';

  @override
  String get settingsThemeDarkSub => 'Use darker colors for night time';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSub => 'Vietnamese / English';

  @override
  String get settingsSecurity => 'Security';

  @override
  String get settingsChangePassword => 'Change Password';

  @override
  String get settingsChangePasswordSub => 'Update your password';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsLogout => 'Log Out';

  @override
  String get settingsLogoutConfirm => 'Logging out...';

  @override
  String get settingsLogoutSuccess => 'See you again!';

  @override
  String get settingsLogoutError => 'Logout Error';

  @override
  String commonError(Object error) {
    return 'Error: $error';
  }

  @override
  String get commonLoading => 'Loading...';
}
