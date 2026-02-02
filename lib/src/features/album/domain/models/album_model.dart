import 'package:freezed_annotation/freezed_annotation.dart';

part 'album_model.freezed.dart';
part 'album_model.g.dart';

@freezed
class Album with _$Album {
  const factory Album({
    required String id,
    required String name,
    String? description,
    String? coverUrl,
    @Default(0) int postCount,
    required DateTime createdAt,
  }) = _Album;

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);
}
