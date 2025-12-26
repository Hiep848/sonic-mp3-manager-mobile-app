import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/providers/providers.dart';
import '../../../../core/app_startup/app_startup_provider.dart';

part 'auth_controller.g.dart';

// AsyncNotifier: Tự động quản lý 3 trạng thái: Loading, Data, Error
@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {
    // Hàm build trả về void vì ta chỉ quan tâm trạng thái hành động (Login thành công hay thất bại)
    // chứ không cần hứng dữ liệu User để hiển thị ngay tại nút bấm.
  }

  Future<void> login(String email, String password) async {
    // 1. Chuyển trạng thái sang Loading (UI sẽ hiện vòng xoay)
    state = const AsyncLoading();

    // 2. Gọi UseCase (đã viết hôm kia)
    // AsyncValue.guard là hàm cực xịn: Nó tự động try-catch.
    // Nếu thành công -> state = AsyncData
    // Nếu có lỗi (Exception) -> state = AsyncError
    state = await AsyncValue.guard(() async {
      final loginUseCase = ref.read(loginUseCaseProvider);
      await loginUseCase.call(email: email, password: password);
    });

    // Nếu thành công, kích hoạt flag isLoggedIn để Router redirect
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
