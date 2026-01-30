import 'package:mp3_management/src/features/diary/domain/models/album_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mock_album_repository.g.dart';

class MockAlbumRepository {
  final List<Album> _albums = [
    Album(
      id: 'album_1',
      name: 'Travel 2024',
      description: 'Recordings from my trips.',
      coverUrl: 'https://picsum.photos/seed/travel/200/200',
      postCount: 5,
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
    ),
    Album(
      id: 'album_2',
      name: 'Music Ideas',
      description: 'Riffs and melodies.',
      coverUrl: 'https://picsum.photos/seed/music/200/200',
      postCount: 12,
      createdAt: DateTime.now().subtract(const Duration(days: 200)),
    ),
    Album(
      id: 'album_3',
      name: 'Daily Thoughts',
      coverUrl:
          'https://cdn2.fptshop.com.vn/unsafe/Uploads/images/tin-tuc/172740/Originals/background-la-gi-6.jpg',
      postCount: 45,
      createdAt: DateTime.now().subtract(const Duration(days: 300)),
    ),
    Album(
      id: 'album_4',
      name: 'Work Meetings',
      postCount: 3,
      createdAt: DateTime.now(),
    ),
    Album(
      id: 'album_5',
      name: 'Family',
      coverUrl: 'https://picsum.photos/seed/family/200/200',
      postCount: 8,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
  ];

  Future<List<Album>> getAllAlbums() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _albums;
  }
}

@riverpod
MockAlbumRepository mockAlbumRepository(MockAlbumRepositoryRef ref) {
  return MockAlbumRepository();
}
