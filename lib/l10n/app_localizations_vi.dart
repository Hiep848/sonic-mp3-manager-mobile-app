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

  @override
  String get authWelcome => 'Chào mừng trở lại';

  @override
  String get authLoginTitle => 'Lỗi đăng nhập';

  @override
  String get authLoginSuccess => 'Chào mừng trở lại!';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Mật khẩu';

  @override
  String get authLoginButton => 'ĐĂNG NHẬP';

  @override
  String get authNoAccount => 'Chưa có tài khoản? Đăng ký';

  @override
  String get authEnterEmail => 'Vui lòng nhập Email';

  @override
  String get authInvalidEmail => 'Email không hợp lệ';

  @override
  String get authEnterPassword => 'Vui lòng nhập mật khẩu';

  @override
  String get authShortPassword => 'Mật khẩu phải trên 6 ký tự';

  @override
  String get authRegisterTitle => 'Tạo tài khoản';

  @override
  String get authFullName => 'Họ và tên';

  @override
  String get authConfirmPassword => 'Xác nhận mật khẩu';

  @override
  String get authSignUpButton => 'ĐĂNG KÝ';

  @override
  String get authHaveAccount => 'Đã có tài khoản? Đăng nhập';

  @override
  String get authRegisterSuccess => 'Tài khoản đã được tạo! Đăng nhập ngay.';

  @override
  String get authEnterName => 'Vui lòng nhập tên';

  @override
  String get authConfirmPassEmpty => 'Vui lòng xác nhận mật khẩu';

  @override
  String get authPassMismatch => 'Mật khẩu không khớp';

  @override
  String get authRegisterError => 'Lỗi đăng ký';

  @override
  String get authCreatingAccount => 'Đang khởi tạo tài khoản...';

  @override
  String get authLoggingIn => 'Đang đăng nhập...';

  @override
  String get socialOrContinue => 'Hoặc tiếp tục với';

  @override
  String get socialGoogleError => 'Lỗi Google';

  @override
  String get socialAuthCodeError =>
      'Không lấy được Auth Code. Vui lòng kiểm tra cấu hình Console.';

  @override
  String get socialSignInInit => 'Google Sign-In đang khởi tạo...';

  @override
  String get socialFeatureDev => 'Tính năng đang phát triển';

  @override
  String get uploadScreenTitle => 'Tải lên MP3';

  @override
  String get uploadInBackground => 'Đang tải lên trong nền...';

  @override
  String get uploadNoFileSelected => 'Chưa chọn file nào';

  @override
  String get uploadButtonPick => 'CHỌN FILE MP3';

  @override
  String get uploadButtonStart => 'BẮT ĐẦU UPLOAD';

  @override
  String get uploadButtonChange => 'Chọn file khác';

  @override
  String get albumNoData => 'Không có album nào';

  @override
  String get commonRetry => 'Thử lại';

  @override
  String get albumCreateNew => 'Tạo Album mới';

  @override
  String get albumNameHint => 'Nhập tên album';

  @override
  String get albumCreateButton => 'Tạo';

  @override
  String get feedSortNewest => 'Mới nhất';

  @override
  String get feedSortPopular => 'Nghe nhiều nhất';

  @override
  String get feedNoPosts => 'Chưa có bài đăng nào';

  @override
  String get feedUploading => 'Đang tải lên...';

  @override
  String commonErrorUnknown(Object error) {
    return 'Lỗi không xác định: $error';
  }

  @override
  String get commonCancel => 'Hủy';

  @override
  String get commonDelete => 'Xóa';

  @override
  String get commonSave => 'Lưu';

  @override
  String get commonOpen => 'Mở';

  @override
  String get albumRename => 'Đổi tên Album';

  @override
  String get albumDelete => 'Xóa Album';

  @override
  String get albumDeleteTitle => 'Xóa Album';

  @override
  String get albumDeleteConfirm => 'Bạn có chắc chắn muốn xóa album này không?';

  @override
  String albumDeleteFailed(Object error) {
    return 'Xóa thất bại: $error';
  }

  @override
  String get albumDeleteSuccess => 'Xóa album thành công';

  @override
  String get albumRenameTitle => 'Đổi tên Album';

  @override
  String albumRenameFailed(Object error) {
    return 'Đổi tên thất bại: $error';
  }

  @override
  String get albumRenameSuccess => 'Đổi tên album thành công';

  @override
  String get albumNoTracks => 'Không có bài hát nào trong album này';

  @override
  String get albumUnknownArtist => 'Nghệ sĩ không xác định';

  @override
  String get albumAddMp3Title => 'Thêm MP3 vào Album';

  @override
  String get albumNoMp3s => 'Không tìm thấy MP3 nào';

  @override
  String get albumNoDescription => 'Không có mô tả';

  @override
  String albumAddSuccess(Object title) {
    return 'Đã thêm \"$title\" vào album';
  }

  @override
  String albumAddFailed(Object error) {
    return 'Thêm thất bại: $error';
  }

  @override
  String get detailSaveSuccess => 'Đã lưu thay đổi!';

  @override
  String detailDownloadSuccess(Object format) {
    return 'Tải xong: $format';
  }

  @override
  String detailDownloadError(Object error) {
    return 'Lỗi tải file: $error';
  }

  @override
  String get detailDownloadTooltip => 'Tải xuống Transcript';

  @override
  String get detailDownloadWord => 'Tải file Word (.docx)';

  @override
  String get detailDownloadPdf => 'Tải file PDF (.pdf)';

  @override
  String get detailEditTitle => 'Tiêu đề';

  @override
  String get detailEditMood => 'Cảm xúc:';

  @override
  String get detailEditContentHint => 'Nội dung bài viết...';

  @override
  String get detailNoContent => 'Chưa có nội dung.';

  @override
  String get featureInDevelopment => 'Tính năng đổi mật khẩu đang phát triển';
}
