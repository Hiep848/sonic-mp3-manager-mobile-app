import 'package:mp3_management/src/features/diary/domain/models/post_model.dart';
import 'package:mp3_management/src/features/diary/domain/models/mood.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mock_post_repository.g.dart';

class MockPostRepository {
  final List<AudioPost> _posts = List.generate(15, (index) {
    return AudioPost(
      id: 'post_$index',
      title: 'Journal Entry #$index',
      mp3Path: 'assets/audio/mock_audio.mp3', // Placeholder
      duration: 120.0 + (index * 10),
      fileSize: 1024 * 1024 * (index + 1),
      recordDate: DateTime.now().subtract(Duration(days: index)),
      uploadDate: DateTime.now().subtract(Duration(days: index, hours: 2)),
      mood: Mood.values[index % Mood.values.length],
      albumId: index % 3 == 0 ? 'album_1' : null,
      hashtags: ['#journal', '#day$index'],
      textContent:
          'This is the content for journal entry #$index. \n\nIt was a day full of events. ' *
              5,
      thumbnailUrl: 'https://picsum.photos/seed/$index/200/200',
    );
  });

  Future<List<AudioPost>> getAllPosts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _posts;
  }

  Future<AudioPost?> getPostById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _posts.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<AudioPost>> getPostsByAlbum(String albumId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _posts.where((p) => p.albumId == albumId).toList();
  }
}

@riverpod
MockPostRepository mockPostRepository(MockPostRepositoryRef ref) {
  return MockPostRepository();
}
