import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class QuickAudioPlayer extends StatefulWidget {
  final String? audioUrl;
  final double duration;
  final bool isLight;

  final double? progress;
  final String? statusText;

  const QuickAudioPlayer({
    super.key,
    required this.audioUrl,
    required this.duration,
    this.isLight = false,
    this.progress,
    this.statusText,
  });

  @override
  State<QuickAudioPlayer> createState() => _QuickAudioPlayerState();
}

class _QuickAudioPlayerState extends State<QuickAudioPlayer> {
  late AudioPlayer _player;
  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _initAndPlay() async {
    if (widget.audioUrl == null) return;
    try {
      await _player.setUrl(widget.audioUrl!);
      _isInit = true;
      _player.play();
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorPrimary =
        widget.isLight ? Colors.white : Theme.of(context).primaryColor;
    final colorText = widget.isLight ? Colors.white70 : Colors.grey;

    // [LOGIC MỚI] Kiểm tra xem có URL chưa
    final bool isReady = widget.audioUrl != null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: widget.isLight ? Colors.black26 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // 1. NÚT ĐIỀU KHIỂN (Play hoặc Loading Icon)
          if (!isReady)
            // Đang xử lý: Hiện icon loading hoặc sync
            SizedBox(
                width: 32,
                height: 32,
                child: Center(
                    child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: colorPrimary))))
          else
            // Đã sẵn sàng: Hiện nút Play/Pause
            StreamBuilder<PlayerState>(
              stream: _player.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;

                if (processingState == ProcessingState.loading ||
                    processingState == ProcessingState.buffering) {
                  return SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                        color: colorPrimary, strokeWidth: 2),
                  );
                } else if (playing != true) {
                  return IconButton(
                    icon: Icon(Icons.play_arrow_rounded,
                        size: 32, color: colorPrimary),
                    onPressed: () {
                      if (!_isInit)
                        _initAndPlay();
                      else
                        _player.play();
                    },
                  );
                } else if (processingState != ProcessingState.completed) {
                  return IconButton(
                    icon: Icon(Icons.pause_rounded,
                        size: 32, color: colorPrimary),
                    onPressed: _player.pause,
                  );
                } else {
                  return IconButton(
                    icon: Icon(Icons.replay_rounded,
                        size: 32, color: colorPrimary),
                    onPressed: () => _player.seek(Duration.zero),
                  );
                }
              },
            ),

          const SizedBox(width: 12),

          // 2. THANH TIẾN TRÌNH (Seek Bar hoặc Progress Bar)
          Expanded(
            child: !isReady
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text trạng thái
                      Text(widget.statusText ?? "Đang xử lý...",
                          style: TextStyle(
                              fontSize: 11,
                              color: colorText,
                              fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 6),
                      // Thanh upload/process
                      LinearProgressIndicator(
                        value: widget.progress, // Nếu null sẽ chạy qua chạy lại
                        backgroundColor: colorText.withOpacity(0.1),
                        color: colorPrimary,
                        minHeight: 4,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ],
                  )
                : StreamBuilder<Duration?>(
                    stream: _player.durationStream,
                    builder: (context, snapshotDuration) {
                      var totalDuration = snapshotDuration.data ??
                          Duration(seconds: widget.duration.toInt());
                      if (totalDuration.inSeconds == 0) {
                        totalDuration = const Duration(seconds: 0);
                      }

                      return StreamBuilder<Duration>(
                        stream: _player.positionStream,
                        builder: (context, snapshotPosition) {
                          final position =
                              snapshotPosition.data ?? Duration.zero;
                          return ProgressBar(
                            progress: position,
                            total: totalDuration,
                            baseBarColor: colorText.withOpacity(0.3),
                            progressBarColor: colorPrimary,
                            thumbColor: colorPrimary,
                            thumbRadius: 6,
                            timeLabelLocation: TimeLabelLocation.sides,
                            timeLabelTextStyle:
                                TextStyle(color: colorText, fontSize: 12),
                            onSeek: (duration) {
                              if (!_isInit) _initAndPlay();
                              _player.seek(duration);
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
