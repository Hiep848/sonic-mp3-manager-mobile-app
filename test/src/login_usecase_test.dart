import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mp3_management/src/features/auth/domain/entities/user_entity.dart';
import 'package:mp3_management/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:mp3_management/src/features/auth/domain/usecases/login_usecase.dart';

// 1. Tạo class Mock để giả lập Repository
// MockAuthRepository sẽ đóng vai "diễn viên đóng thế" cho AuthRepository thật
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase loginUseCase;
  late MockAuthRepository mockAuthRepository;

  // Dữ liệu giả để test
  const tEmail = 'test@gmail.com';
  const tPassword = 'password123';
  const tUser = UserEntity(id: '1', name: 'Test User', email: tEmail);

  // setUp chạy trước mỗi bài test
  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
  });

  // Nhóm các bài test lại
  group('LoginUseCase', () {
    // Test case 1: Thành công
    test('Nên trả về UserEntity khi login thành công', () async {
      // Arrange (Chuẩn bị): Khi gọi repo.login thì trả về tUser ngay lập tức
      when(() => mockAuthRepository.login(email: tEmail, password: tPassword))
          .thenAnswer((_) async => tUser);

      // Act (Hành động): Gọi hàm usecase
      final result =
          await loginUseCase.call(email: tEmail, password: tPassword);

      // Assert (Kiểm tra): Kết quả trả về có đúng là tUser không?
      expect(result, tUser);
      // Kiểm tra xem repo.login có thực sự được gọi 1 lần không?
      verify(() => mockAuthRepository.login(email: tEmail, password: tPassword))
          .called(1);
    });

    // Test case 2: Thất bại do logic validation (Email sai)
    test('Nên ném Exception khi email không hợp lệ (thiếu @)', () async {
      // Act & Assert: Gọi hàm và mong đợi nó ném lỗi
      expect(
        () => loginUseCase.call(email: 'invalid-email', password: tPassword),
        throwsA(isA<Exception>()),
      );

      // Đảm bảo Repository KHÔNG bao giờ được gọi (vì lỗi ngay từ UseCase)
      verifyZeroInteractions(mockAuthRepository);
    });

    // Test case 3: Thất bại do logic validation (Password ngắn)
    test('Nên ném Exception khi password quá ngắn (<6 ký tự)', () async {
      expect(
        () => loginUseCase.call(email: tEmail, password: '123'),
        throwsA(isA<Exception>()),
      );
      verifyZeroInteractions(mockAuthRepository);
    });
  });
}
