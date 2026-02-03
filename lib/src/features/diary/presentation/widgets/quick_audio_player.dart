import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../audio/presentation/audio_player_controller.dart';
import '../../domain/models/post_model.dart';

class QuickAudioPlayer extends ConsumerWidget {
  final String? audioUrl;
  final double duration;
  final bool isLight;
  final AudioPost post; // Need post to identify track

  final double? progress;
  final String? statusText;

  const QuickAudioPlayer({
    super.key,
    required this.audioUrl,
    required this.duration,
    required this.post,
    this.isLight = false,
    this.progress,
    this.statusText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorPrimary =
        isLight ? Colors.white : Theme.of(context).primaryColor;
    final colorText = isLight ? Colors.white70 : Colors.grey;

    final audioState = ref.watch(audioPlayerProvider);
    final isCurrentTrack = audioState.currentTrack?.id == post.id;
    final isPlaying = isCurrentTrack && audioState.isPlaying;
    final isLoading = isCurrentTrack && audioState.isLoading;

    // Duration/Position logic
    final currentPosition =
        isCurrentTrack ? audioState.position : Duration.zero;
    // Fix: Use actual player duration if available, otherwise fallback to post duration
    final totalDuration = (isCurrentTrack && audioState.duration.inSeconds > 0)
        ? audioState.duration
        : Duration(seconds: duration.toInt());

    final bool isReady = audioUrl != null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isLight ? Colors.black26 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // 1. CONTROL BUTTON
          if (!isReady)
            SizedBox(
                width: 32,
                height: 32,
                child: Center(
                    child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: colorPrimary))))
          else if (isLoading)
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                  color: colorPrimary, strokeWidth: 2),
            )
          else
            IconButton(
              icon: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: 32,
                  color: colorPrimary),
              onPressed: () {
                ref.read(audioPlayerProvider.notifier).playTrack(post);
              },
            ),

          const SizedBox(width: 12),

          // 2. PROGRESS BAR
          Expanded(
            child: !isReady
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(statusText ?? "Đang xử lý...",
                          style: TextStyle(
                              fontSize: 11,
                              color: colorText,
                              fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: colorText.withOpacity(0.1),
                        color: colorPrimary,
                        minHeight: 4,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ],
                  )
                : ProgressBar(
                    progress: currentPosition,
                    total: totalDuration,
                    baseBarColor: colorText.withOpacity(0.3),
                    progressBarColor: colorPrimary,
                    thumbColor: colorPrimary,
                    thumbRadius: 6,
                    timeLabelLocation: TimeLabelLocation.sides,
                    timeLabelTextStyle:
                        TextStyle(color: colorText, fontSize: 12),
                    onSeek: (duration) {
                      if (isCurrentTrack) {
                        ref.read(audioPlayerProvider.notifier).seek(duration);
                      } else {
                        // If seeking a track that isn't playing, maybe play it from there?
                        // For now, simple play
                        ref.read(audioPlayerProvider.notifier).playTrack(post);
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
