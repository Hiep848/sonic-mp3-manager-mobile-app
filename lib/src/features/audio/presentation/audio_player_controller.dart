import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../domain/audio_state.dart';
import '../../diary/domain/models/post_model.dart'; // Ensure correct import for AudioPost

class AudioPlayerNotifier extends StateNotifier<AudioState> {
  late final AudioPlayer _audioPlayer;

  AudioPlayerNotifier() : super(const AudioState()) {
    _audioPlayer = AudioPlayer();
    _initStreams();
  }

  void _initStreams() {
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;

      state = state.copyWith(
        isPlaying: isPlaying,
        isLoading: processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering,
      );

      if (processingState == ProcessingState.completed) {
        // Auto-next logic
        if (state.playlist.isNotEmpty &&
            state.currentIndex < state.playlist.length - 1) {
          playNext();
        } else {
          _audioPlayer.seek(Duration.zero);
          _audioPlayer.pause();
        }
      }
    });

    _audioPlayer.positionStream.listen((position) {
      state = state.copyWith(position: position);
    });

    _audioPlayer.durationStream.listen((duration) {
      state = state.copyWith(duration: duration ?? Duration.zero);
    });
  }

  Future<void> playPlaylist(List<AudioPost> playlist, int index) async {
    state = state.copyWith(
      playlist: playlist,
      currentIndex: index,
    );
    await playTrack(playlist[index]);
  }

  Future<void> playNext() async {
    if (state.playlist.isEmpty ||
        state.currentIndex >= state.playlist.length - 1) return;

    final nextIndex = state.currentIndex + 1;
    state = state.copyWith(currentIndex: nextIndex);
    await playTrack(state.playlist[nextIndex]);
  }

  Future<void> playPrevious() async {
    if (state.playlist.isEmpty || state.currentIndex <= 0) return;

    final prevIndex = state.currentIndex - 1;
    state = state.copyWith(currentIndex: prevIndex);
    await playTrack(state.playlist[prevIndex]);
  }

  Future<void> playTrack(AudioPost track) async {
    // Check if track is part of current playlist, if not, clear playlist or handle accordingly
    // For now, if played individually, it might not be in playlist.
    // Ensure state consistency.

    // If same track, just toggle play/pause
    if (state.currentTrack?.id == track.id) {
      // ... existing toggle logic
      if (state.isPlaying) {
        _audioPlayer.pause();
      } else {
        _audioPlayer.play();
      }
      return;
    }

    // New track
    try {
      state = state.copyWith(currentTrack: track, isLoading: true);
      if (track.streamUrl != null) {
        print(
            'AudioPlayerController: Playing URL: ${track.streamUrl}'); // Debug log
        try {
          await _audioPlayer.setUrl(track.streamUrl!);
          _audioPlayer.play();
        } catch (e) {
          print('AudioPlayerController: Error setting URL: $e');
        }
      } else {
        print(
            'AudioPlayerController: Stream URL is null for track: ${track.title}');
      }
    } catch (e) {
      // Handle error
      state = state.copyWith(isLoading: false);
    }
  }

  void togglePlay() {
    if (state.isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

final audioPlayerProvider =
    StateNotifierProvider<AudioPlayerNotifier, AudioState>((ref) {
  return AudioPlayerNotifier();
});
