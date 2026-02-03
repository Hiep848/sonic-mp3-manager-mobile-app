import 'package:freezed_annotation/freezed_annotation.dart';

part 'album_model.freezed.dart';
part 'album_model.g.dart';

@freezed
class Album with _$Album {
  const factory Album({
    @JsonKey(name: '_id', readValue: _idReader) required String id,
    @JsonKey(name: 'title', readValue: _nameReader) required String name,
    String? description,
    @JsonKey(name: 'cover_url') String? coverUrl,
    @JsonKey(name: 'postCount', readValue: _postCountReader)
    @Default(0)
    int postCount,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Album;

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);
}

Object? _postCountReader(Map map, String key) {
  // Debug print to see what we actually get
  // print('Album JSON Keys: ${map.keys}');

  if (map.containsKey('postCount')) return map['postCount'];
  if (map.containsKey('post_ids')) {
    final list = map['post_ids'];
    if (list is List) return list.length;
  }
  if (map.containsKey('post_count')) return map['post_count'];
  if (map.containsKey('count')) return map['count'];
  if (map.containsKey('tracks') && map['tracks'] is List) {
    return (map['tracks'] as List).length;
  }
  // Try 'posts' just in case
  if (map.containsKey('posts') && map['posts'] is List) {
    return (map['posts'] as List).length;
  }
  return 0;
}

Object? _idReader(Map map, String key) {
  if (map.containsKey('_id') && map['_id'] != null)
    return map['_id'].toString();
  if (map.containsKey('id') && map['id'] != null) {
    final val = map['id'];
    if (val is Map && val.isEmpty)
      return 'unknown_id_${DateTime.now().millisecondsSinceEpoch}'; // Handle empty object case
    return val.toString();
  }
  return '';
}

Object? _nameReader(Map map, String key) {
  if (map.containsKey('title') && map['title'] != null) return map['title'];
  if (map.containsKey('name') && map['name'] != null) return map['name'];
  return 'Untitled Album';
}
