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

  @override
  String get authWelcome => 'Welcome Back';

  @override
  String get authLoginTitle => 'Login Error';

  @override
  String get authLoginSuccess => 'Welcome back!';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authLoginButton => 'LOGIN';

  @override
  String get authNoAccount => 'Don\'t have an account? Sign Up';

  @override
  String get authEnterEmail => 'Please enter Email';

  @override
  String get authInvalidEmail => 'Invalid Email';

  @override
  String get authEnterPassword => 'Please enter password';

  @override
  String get authShortPassword => 'Password must be at least 6 characters';

  @override
  String get authRegisterTitle => 'Create Account';

  @override
  String get authFullName => 'Full Name';

  @override
  String get authConfirmPassword => 'Confirm Password';

  @override
  String get authSignUpButton => 'SIGN UP';

  @override
  String get authHaveAccount => 'Already have an account? Login';

  @override
  String get authRegisterSuccess => 'Account created! Please login.';

  @override
  String get authEnterName => 'Please enter your name';

  @override
  String get authConfirmPassEmpty => 'Please confirm your password';

  @override
  String get authPassMismatch => 'Passwords do not match';

  @override
  String get authRegisterError => 'Registration Error';

  @override
  String get authCreatingAccount => 'Creating account...';

  @override
  String get authLoggingIn => 'Logging in...';

  @override
  String get socialOrContinue => 'Or continue with';

  @override
  String get socialGoogleError => 'Google Error';

  @override
  String get socialAuthCodeError =>
      'Cannot get Auth Code. Check Console config.';

  @override
  String get socialSignInInit => 'Initializing Google Sign-In...';

  @override
  String get socialFeatureDev => 'Feature in development';

  @override
  String get uploadScreenTitle => 'Upload MP3';

  @override
  String get uploadInBackground => 'Uploading in background...';

  @override
  String get uploadNoFileSelected => 'No file selected';

  @override
  String get uploadButtonPick => 'PICK MP3 FILE';

  @override
  String get uploadButtonStart => 'START UPLOAD';

  @override
  String get uploadButtonChange => 'Choose another file';

  @override
  String get albumNoData => 'No albums found';

  @override
  String get commonRetry => 'Retry';

  @override
  String get albumCreateNew => 'New Album';

  @override
  String get albumNameHint => 'Enter album name';

  @override
  String get albumCreateButton => 'Create';

  @override
  String get feedSortNewest => 'Newest';

  @override
  String get feedSortPopular => 'Most Popular';

  @override
  String get feedNoPosts => 'No posts yet';

  @override
  String get feedUploading => 'Uploading...';

  @override
  String commonErrorUnknown(Object error) {
    return 'An unexpected error occurred: $error';
  }

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonSave => 'Save';

  @override
  String get commonOpen => 'Open';

  @override
  String get albumRename => 'Rename Album';

  @override
  String get albumDelete => 'Delete Album';

  @override
  String get albumDeleteTitle => 'Delete Album';

  @override
  String get albumDeleteConfirm =>
      'Are you sure you want to delete this album?';

  @override
  String albumDeleteFailed(Object error) {
    return 'Failed to delete: $error';
  }

  @override
  String get albumDeleteSuccess => 'Delete album successfully';

  @override
  String get albumRenameTitle => 'Rename Album';

  @override
  String albumRenameFailed(Object error) {
    return 'Failed to rename: $error';
  }

  @override
  String get albumRenameSuccess => 'Rename album successfully';

  @override
  String get albumNoTracks => 'No tracks in this album';

  @override
  String get albumUnknownArtist => 'Unknown Artist';

  @override
  String get albumAddMp3Title => 'Add MP3 to Album';

  @override
  String get albumNoMp3s => 'No MP3s found';

  @override
  String get albumNoDescription => 'No description';

  @override
  String albumAddSuccess(Object title) {
    return 'Added \"$title\" to album';
  }

  @override
  String albumAddFailed(Object error) {
    return 'Failed to add: $error';
  }

  @override
  String get detailSaveSuccess => 'Changes saved!';

  @override
  String detailDownloadSuccess(Object format) {
    return 'Download complete: $format';
  }

  @override
  String detailDownloadError(Object error) {
    return 'Download error: $error';
  }

  @override
  String get detailDownloadTooltip => 'Download Transcript';

  @override
  String get detailDownloadWord => 'Download Word (.docx)';

  @override
  String get detailDownloadPdf => 'Download PDF (.pdf)';

  @override
  String get detailEditTitle => 'Title';

  @override
  String get detailEditMood => 'Mood:';

  @override
  String get detailEditContentHint => 'Content...';

  @override
  String get detailNoContent => 'No content.';

  @override
  String get featureInDevelopment => 'Feature under development';
}
