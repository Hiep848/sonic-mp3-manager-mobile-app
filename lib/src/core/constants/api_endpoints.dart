class ApiEndpoints {
  // Không cho phép khởi tạo class này
  ApiEndpoints._();

  // 1. Timeouts
  static const Duration connectionTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // 2. Base URL (Localhost backend)
  // Android Emulator: 'http://10.0.2.2:8000/api/v1'
  // iOS Simulator: 'http://localhost:8000/api/v1'
  static const String baseUrl = 'http://localhost:8000/api/v1';

  // 3. Auth Routes
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String userProfile = '/auth/me';

  // 4. Post Routes
  static const String posts = '/posts';

  // 5. Upload Routes
  static const String uploadInit = '/upload/init';
  static String uploadConfirm(String jobId) => '/upload/$jobId/confirm';


  // Helpers để nối chuỗi cho gọn
  static String postDetail(String id) => '$posts/$id';
  static String postComments(String id) => '$posts/$id/comments';
}
