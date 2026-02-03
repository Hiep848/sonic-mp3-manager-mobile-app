import 'package:freezed_annotation/freezed_annotation.dart';
import '../../diary/domain/models/post_model.dart';

part 'audio_state.freezed.dart';

@freezed
class AudioState with _$AudioState {
  const factory AudioState({
    @Default([]) List<AudioPost> playlist,
    @Default(0) int currentIndex,
    AudioPost? currentTrack,
    @Default(false) bool isPlaying,
    @Default(Duration.zero) Duration position,
    @Default(Duration.zero) Duration duration,
    @Default(false) bool isLoading,
  }) = _AudioState;
}
