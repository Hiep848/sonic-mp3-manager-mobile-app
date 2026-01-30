import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import '../constants/api_endpoints.dart';

void setupMockApi(Dio dio) {
  final adapter = DioAdapter(dio: dio);

  // ✅ Mock Login Endpoint
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
    data: Matchers.any,
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

  // ✅ Mock Get Post Detail Endpoint
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

  // 1. MOCK INIT UPLOAD
  adapter.onPost(
    ApiEndpoints.uploadInit,
    (server) {
      server.reply(200,
          {'uploadId': 'upload_id_fake_12345', 'key': 'songs/mock_song.mp3'},
          delay: const Duration(milliseconds: 500));
    },
    data: Matchers.any,
  );

  // 2. MOCK PRESIGNED URL
  // adapter.onGet(
  //   ApiEndpoints.getPresignedUrl,
  //   (server) {
  //     server.reply(
  //         200,
  //         {
  //           'url': 'https://fake-s3.com/upload-chunk',
  //         },
  //         delay: const Duration(milliseconds: 200));
  //   },
  // );

  // 3. MOCK S3 PUT
  adapter.onPut(
    'https://fake-s3.com/upload-chunk',
    (server) {
      server.reply(
        200,
        {},
        delay: const Duration(milliseconds: 500),
        headers: {
          // [SỬA LẠI] Phải để trong List [] vì thư viện yêu cầu thế
          'ETag': ['"mock-etag-12345"'],
        },
      );
    },
    // [QUAN TRỌNG NHẤT] Thêm dòng này để Mock chấp nhận mọi headers (như binary, octet-stream...)
    // Nếu thiếu dòng này -> Nó sẽ báo lỗi "Assertion failed" hoặc "Map not subtype of String" khi cố đọc header lạ.
    // headers: {
    //   'Content-Type': 'application/octet-stream',
    // },

    data: Matchers.any,
  );

  // 4. MOCK COMPLETE
  // adapter.onPost(
  //   ApiEndpoints.uploadComplete,
  //   (server) {
  //     server.reply(
  //       200,
  //       {
  //         'message': 'Ghép file thành công!',
  //         'location': 'https://s3.aws.../song.mp3'
  //       },
  //       delay: const Duration(seconds: 2),
  //     );
  //   },
  //   data: Matchers.any,
  // );
}
