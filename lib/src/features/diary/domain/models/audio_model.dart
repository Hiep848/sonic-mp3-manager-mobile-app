import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_model.freezed.dart';
part 'audio_model.g.dart';

enum ProcessingStatus {
  PENDING,
  PROCESSING,
  COMPLETED,
  FAILED,
}

@freezed
class TranscriptSegment with _$TranscriptSegment {
  const factory TranscriptSegment({
    required double start,
    required double end,
    required String text,
  }) = _TranscriptSegment;

  factory TranscriptSegment.fromJson(Map<String, dynamic> json) =>
      _$TranscriptSegmentFromJson(json);
}

@freezed
class AudioMetadata with _$AudioMetadata {
  const factory AudioMetadata({
    String? originalUrl,
    String? hlsUrl,
    @Default(0.0) double duration,
    @Default(0) int fileSize,
  }) = _AudioMetadata;

  factory AudioMetadata.fromJson(Map<String, dynamic> json) =>
      _$AudioMetadataFromJson(json);
}

@freezed
class Audio with _$Audio {
  const factory Audio({
    required String audioId,
    @Default(ProcessingStatus.PENDING) ProcessingStatus status,
    String? jobId,
    @Default(AudioMetadata()) AudioMetadata audioMeta,
    @Default([]) List<TranscriptSegment> transcript,
  }) = _Audio;

  factory Audio.fromJson(Map<String, dynamic> json) => _$AudioFromJson(json);
}
