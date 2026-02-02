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
}

@riverpod
PostRepository postRepository(PostRepositoryRef ref) {
  return PostRepository(ref.watch(postRemoteDataSourceProvider));
}
