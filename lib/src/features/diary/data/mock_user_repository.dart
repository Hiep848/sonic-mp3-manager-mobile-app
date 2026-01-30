import 'package:mp3_management/src/features/diary/domain/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mock_user_repository.g.dart';

class MockUserRepository {
  final User _user = const User(
    id: 'u1',
    username: 'JournalUser',
    email: 'user@example.com',
    avatarUrl: 'https://i.pravatar.cc/300',
    bio: 'My personal audio space.',
  );

  Future<User> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _user;
  }
}

@riverpod
MockUserRepository mockUserRepository(MockUserRepositoryRef ref) {
  return MockUserRepository();
}
