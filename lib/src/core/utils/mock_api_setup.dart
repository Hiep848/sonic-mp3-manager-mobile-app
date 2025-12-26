import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import '../constants/api_endpoints.dart';

void setupMockApi(Dio dio) {
  final adapter = DioAdapter(dio: dio);

  // ✅ Mock Login Endpoint
  // Thêm data: Matchers.any để chấp nhận mọi body request
  adapter.onPost(
    '${ApiEndpoints.baseUrl}${ApiEndpoints.login}',
    (server) {
      server.reply(
        200,
        {
          'id': '12345',
          'email': 'hiep@gmail.com',
          'name': 'Hiep Tran',
          'token': 'sample_jwt_token_12345',
        },
        delay: const Duration(seconds: 1),
      );
    },
    data: Matchers.any, // <--- QUAN TRỌNG: Chấp nhận mọi data gửi lên
  );

  // ✅ Mock Register Endpoint
  adapter.onPost(
    '${ApiEndpoints.baseUrl}${ApiEndpoints.register}',
    (server) {
      server.reply(
        201,
        {
          'id': '12346',
          'email': 'newuser@gmail.com',
          'name': 'New User',
          'token': 'sample_jwt_token_12346',
        },
        delay: const Duration(seconds: 1),
      );
    },
    data: Matchers.any,
  );

  // ✅ Mock User Profile Endpoint
  adapter.onGet(
    '${ApiEndpoints.baseUrl}${ApiEndpoints.userProfile}',
    (server) {
      server.reply(
        200,
        {
          'id': '12345',
          'email': 'hiep@gmail.com',
          'name': 'Hiep Tran',
          'avatar': 'https://via.placeholder.com/150',
        },
        delay: const Duration(milliseconds: 500),
      );
    },
  );

  // ✅ Mock Get All Posts Endpoint
  adapter.onGet(
    '${ApiEndpoints.baseUrl}${ApiEndpoints.posts}',
    (server) {
      server.reply(
        200,
        [
          {
            'id': '1',
            'title': 'Sample Post 1',
            'content': 'This is a sample post content',
            'authorId': '12345',
            'createdAt': '2024-01-01T10:00:00Z',
          },
          {
            'id': '2',
            'title': 'Sample Post 2',
            'content': 'Another sample post content',
            'authorId': '12345',
            'createdAt': '2024-01-02T10:00:00Z',
          },
        ],
        delay: const Duration(milliseconds: 800),
      );
    },
  );

  // ✅ Mock Get Post Detail Endpoint (SỬA LỖI REGEXP)
  // Không dùng r'' (raw string) khi có biến nội suy ${...}
  // Dùng \\d+ để thay thế cho \d+ trong chuỗi thường
  adapter.onGet(
    RegExp('${ApiEndpoints.baseUrl}${ApiEndpoints.posts}/\\d+'),
    (server) {
      server.reply(
        200,
        {
          'id': '1',
          'title': 'Sample Post Detail',
          'content': 'This is a detailed sample post content',
          'authorId': '12345',
          'createdAt': '2024-01-01T10:00:00Z',
          'comments': [],
        },
        delay: const Duration(milliseconds: 600),
      );
    },
  );

  // ✅ Mock Create Post Endpoint
  adapter.onPost(
    '${ApiEndpoints.baseUrl}${ApiEndpoints.posts}',
    (server) {
      server.reply(
        201,
        {
          'id': '3',
          'title': 'New Post',
          'content': 'New post content',
          'authorId': '12345',
          'createdAt': DateTime.now().toIso8601String(),
        },
        delay: const Duration(seconds: 1),
      );
    },
    data: Matchers.any,
  );

  // ---------------- UPLOAD MOCKS ----------------

  // 1. Mock Init Upload
  adapter.onPost(
    '${ApiEndpoints.baseUrl}${ApiEndpoints.uploadInit}',
    (server) {
      server.reply(
        200,
        {
          // Trả về một ID giả ngẫu nhiên
          'uploadId': 'upload_session_${DateTime.now().millisecondsSinceEpoch}',
        },
        delay: const Duration(milliseconds: 500),
      );
    },
    data: Matchers.any,
  );

  // 2. Mock Chunk Upload
  // Logic: Server nhận chunk -> Trả lời OK ngay
  adapter.onPost(
    '${ApiEndpoints.baseUrl}${ApiEndpoints.uploadChunk}',
    (server) {
      server.reply(
        200,
        {'status': 'chunk_received'}, 
        // Delay giả lập mạng chậm (quan trọng để thấy thanh progress chạy)
        delay: const Duration(milliseconds: 300), 
      );
    },
    data: Matchers.any,
  );

  // 3. Mock Complete Upload
  adapter.onPost(
    '${ApiEndpoints.baseUrl}${ApiEndpoints.uploadComplete}',
    (server) {
      server.reply(
        200,
        {
          'fileUrl': 'https://server.com/uploads/song_final.mp3',
          'message': 'Merge success',
        },
        delay: const Duration(seconds: 2), // Giả lập server đang ghép file mất thời gian
      );
    },
    data: Matchers.any,
  );
}
