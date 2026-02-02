import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/post_model.dart';
import '../datasources/post_remote_datasource.dart';

part 'post_repository.g.dart';

class PostRepository {
  final PostRemoteDataSource _dataSource;
  PostRepository(this._dataSource);

  Future<List<AudioPost>> getFeed({int skip = 0, String sortBy = 'newest'}) {
    return _dataSource.getFeed(limit: 10, skip: skip, sortBy: sortBy);
  }

  Future<AudioPost> getPostById(String id) async {
    return _dataSource.getPostById(id);
  }

  Future<void> updatePost(String id, AudioPost updatedPost) async {
    return _dataSource.updatePost(id, updatedPost);
  }

  Future<String> downloadTranscript(String postId, String format) async {
    return _dataSource.downloadTranscript(postId, format);
  }
}

@riverpod
PostRepository postRepository(PostRepositoryRef ref) {
  return PostRepository(ref.watch(postRemoteDataSourceProvider));
}
