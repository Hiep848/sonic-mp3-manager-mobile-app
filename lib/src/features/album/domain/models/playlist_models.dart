import 'package:freezed_annotation/freezed_annotation.dart';

part 'playlist_models.freezed.dart';
part 'playlist_models.g.dart';

@freezed
class PlaylistTrackMeta with _$PlaylistTrackMeta {
  const factory PlaylistTrackMeta({
    required String postId,
    required String audioId,
    String? artist,
    double? duration,
  }) = _PlaylistTrackMeta;

  factory PlaylistTrackMeta.fromJson(Map<String, dynamic> json) =>
      _$PlaylistTrackMetaFromJson(json);
}

@freezed
class PlaylistTrack with _$PlaylistTrack {
  const factory PlaylistTrack({
    required String title,
    required String file,
    String? poster,
    Map<String, dynamic>? howl,
    required PlaylistTrackMeta meta,
  }) = _PlaylistTrack;

  factory PlaylistTrack.fromJson(Map<String, dynamic> json) =>
      _$PlaylistTrackFromJson(json);
}

@freezed
class AlbumPlaylist with _$AlbumPlaylist {
  const factory AlbumPlaylist({
    required String id,
    required String album,
    required List<PlaylistTrack> tracks,
    @Default(0) double totalDuration,
  }) = _AlbumPlaylist;

  factory AlbumPlaylist.fromJson(Map<String, dynamic> json) =>
      _$AlbumPlaylistFromJson(json);
}
