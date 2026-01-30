import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mp3_management/src/features/diary/domain/models/mood.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
class AudioPost with _$AudioPost {
  const factory AudioPost({
    required String id,
    required String title,
    required String mp3Path, // Local path or mock URL
    @Default(0.0) double duration,
    @Default(0) int fileSize,
    required DateTime recordDate,
    required DateTime uploadDate,
    @Default(Mood.neutral) Mood mood,
    String? albumId,
    @Default([]) List<String> hashtags,
    String? textContent,
    String? thumbnailUrl,
    @Default([]) List<String> attachedImageUrls, // Up to 3
  }) = _AudioPost;

  factory AudioPost.fromJson(Map<String, dynamic> json) =>
      _$AudioPostFromJson(json);
}
