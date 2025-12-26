import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/domain/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'app_startup_provider.g.dart';

@Riverpod(keepAlive: true)
class AppStartup extends _$AppStartup {
  @override
  FutureOr<void> build() async {
    // 1. Kiểm tra trạng thái đăng nhập
    final authRepo = ref.watch(authRepositoryProvider);
    final isLoggedIn = await authRepo.checkAuthStatus();

    // 2. Lưu trạng thái này vào memory để Router dùng
    ref.read(isLoggedInProvider.notifier).state = isLoggedIn;
  }
}

// StateProvider đơn giản để lưu biến bool isLogged
final isLoggedInProvider = StateProvider<bool>((ref) => false);
