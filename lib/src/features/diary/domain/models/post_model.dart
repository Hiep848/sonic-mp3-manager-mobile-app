import 'package:freezed_annotation/freezed_annotation.dart';

import 'mood.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
class AudioPost with _$AudioPost {
  const factory AudioPost({
    required String id,
    required String title,
    @Default(0.0) double duration,
    @Default(0) int fileSize,
    DateTime? recordDate,
    required DateTime uploadDate,
    @JsonKey(fromJson: _moodFromJson, toJson: _moodToJson) Mood? mood,
    String? albumId,
    @Default([]) List<String> hashtags,
    String? textContent,
    String? thumbnailUrl,
    @Default([]) List<String> attachedImageUrls,
    String? streamUrl,
  }) = _AudioPost;

  factory AudioPost.fromJson(Map<String, dynamic> json) =>
      _$AudioPostFromJson(json);
}

Mood? _moodFromJson(Object? json) {
  if (json is String) {
    return Mood.values.firstWhere(
      (e) => e.name.toLowerCase() == json.toLowerCase(),
      orElse: () => Mood.neutral,
    );
  }
  return null;
}

String? _moodToJson(Mood? mood) => mood?.name;
