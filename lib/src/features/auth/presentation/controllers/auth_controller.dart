import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/app_startup/app_startup_provider.dart';
import '../../domain/providers/providers.dart';

part 'auth_controller.g.dart';

// AsyncNotifier: Tự động quản lý 3 trạng thái: Loading, Data, Error
@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {
    // Hàm build trả về void vì ta chỉ quan tâm trạng thái hành động (Login thành công hay thất bại)
    // chứ không cần hứng dữ liệu User để hiển thị ngay tại nút bấm.
  }

  Future<void> traditionalLogin(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(traditionalLoginUseCaseProvider);
      await useCase({
        'email': email,
        'password': password,
      });
    });
    if (state is AsyncData) {
      ref.read(isLoggedInProvider.notifier).state = true;
    }
  }

  Future<void> googleLogin(String authCode) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(googleLoginUseCaseProvider);
      await useCase({'authCode': authCode});
    });
    if (state is AsyncData) {
      ref.read(isLoggedInProvider.notifier).state = true;
    }
  }

  Future<void> register(String email, String password, String name) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // SỬA: Gọi UseCase thay vì Repository
      final registerUseCase = ref.read(registerUseCaseProvider);
      await registerUseCase.call(email: email, password: password, name: name);
    });

    // Nếu đăng ký thành công -> active isLoggedIn flag
    if (state is AsyncData) {
      ref.read(isLoggedInProvider.notifier).state = true;
    }
  }

  Future<void> logout() async {
    // SỬA: Gọi UseCase thay vì Repository
    final logoutUseCase = ref.read(logoutUseCaseProvider);
    await logoutUseCase.call();

    ref.read(isLoggedInProvider.notifier).state = false;
  }
}
