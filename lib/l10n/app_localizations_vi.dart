// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Nhật ký Audio';

  @override
  String get navJournal => 'Nhật ký';

  @override
  String get navAlbums => 'Album';

  @override
  String get navSettings => 'Cài đặt';

  @override
  String get homeTitle => 'Nhật ký Audio của tôi';

  @override
  String get searchPlaceholder => 'Tìm kiếm tiêu đề, nội dung...';

  @override
  String get uploadTitle => 'Nhật ký mới';

  @override
  String get uploadSave => 'Lưu';

  @override
  String get uploadInputTitle => 'Tiêu đề';

  @override
  String get uploadInputTitleHint => 'Hôm nay có gì vui?';

  @override
  String get uploadDateLabel => 'Ngày ghi âm:';

  @override
  String get uploadMoodLabel => 'Cảm xúc';

  @override
  String get uploadAlbumLabel => 'Album';

  @override
  String get uploadAlbumNew => '+ Tạo Album mới';

  @override
  String get uploadAudioNoFile => 'Chưa chọn file audio';

  @override
  String get uploadAudioPick => 'Chọn MP3';

  @override
  String get uploadContentLabel => 'Nội dung nhật ký';

  @override
  String get uploadContentHint => 'Viết gì đó về bản ghi âm này...';

  @override
  String get uploadHashtagLabel => 'Thêm Hashtag';

  @override
  String get uploadAttachments => 'Đính kèm ảnh';

  @override
  String get uploadUploading => 'Đang tải lên...';

  @override
  String get uploadSuccess => 'Đã lưu nhật ký!';

  @override
  String get uploadErrorTitle => 'Vui lòng nhập tiêu đề';

  @override
  String get detailRecorded => 'Ngày ghi:';

  @override
  String get detailRecording => 'Bản ghi âm';

  @override
  String get detailJournal => 'Nhật ký';

  @override
  String get detailPhotos => 'Hình ảnh';

  @override
  String get detailFullScreen => 'Đọc toàn màn hình';

  @override
  String get detailEdit => 'Tính năng sửa đang phát triển';

  @override
  String get detailDelete => 'Xóa';

  @override
  String get albumTitle => 'Album của tôi';

  @override
  String get albumAudios => 'bản ghi';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get settingsProfile => 'Thông tin cá nhân';

  @override
  String get settingsTheme => 'Giao diện';

  @override
  String get settingsThemeDark => 'Chế độ tối';

  @override
  String get settingsThemeDarkSub => 'Sử dụng màu tối cho ban đêm';

  @override
  String get settingsLanguage => 'Ngôn ngữ';

  @override
  String get settingsLanguageSub => 'Tiếng Việt / English';

  @override
  String get settingsSecurity => 'Bảo mật';

  @override
  String get settingsChangePassword => 'Đổi mật khẩu';

  @override
  String get settingsChangePasswordSub => 'Cập nhật mật khẩu mới';

  @override
  String get settingsAbout => 'Giới thiệu';

  @override
  String get settingsLogout => 'Đăng xuất';

  @override
  String get settingsLogoutConfirm => 'Đang đăng xuất...';

  @override
  String get settingsLogoutSuccess => 'Hẹn gặp lại bạn!';

  @override
  String get settingsLogoutError => 'Lỗi đăng xuất';

  @override
  String commonError(Object error) {
    return 'Lỗi: $error';
  }

  @override
  String get commonLoading => 'Đang tải...';
}
