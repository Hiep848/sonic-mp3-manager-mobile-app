class ApiEndpoints {
  // Không cho phép khởi tạo class này
  ApiEndpoints._();

  // 1. Timeouts
  static const Duration connectionTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // 2. Base URL (Sau này lấy từ .env, giờ tạm để đây)
  static const String baseUrl = 'https://api.example.com/api/v1';

  // 3. Auth Routes
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String userProfile = '/auth/me';

  // 4. Post Routes
  static const String posts = '/posts';

  // 5. Upload Routes
  static const String uploadInit = '/upload/init';
  static const String uploadChunk = '/upload/chunk';
  static const String uploadComplete = '/upload/complete';

  // Helpers để nối chuỗi cho gọn
  static String postDetail(String id) => '$posts/$id';
  static String postComments(String id) => '$posts/$id/comments';
}
