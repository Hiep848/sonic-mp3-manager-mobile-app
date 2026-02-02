import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class QuickAudioPlayer extends StatefulWidget {
  final String? audioUrl;
  final double duration; // Có thể là 0 từ DB
  final bool isLight;

  const QuickAudioPlayer({
    super.key,
    required this.audioUrl,
    required this.duration,
    this.isLight = false,
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
      // Load file từ URL (HLS .m3u8 vẫn chạy tốt)
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: widget.isLight ? Colors.black26 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Nút Play/Pause (Giữ nguyên logic)
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
                  icon:
                      Icon(Icons.pause_rounded, size: 32, color: colorPrimary),
                  onPressed: _player.pause,
                );
              } else {
                return IconButton(
                  icon:
                      Icon(Icons.replay_rounded, size: 32, color: colorPrimary),
                  onPressed: () => _player.seek(Duration.zero),
                );
              }
            },
          ),
          const SizedBox(width: 12),

          // Thanh Progress Bar
          Expanded(
            child: StreamBuilder<Duration?>(
              // [QUAN TRỌNG] Lắng nghe duration thật từ stream thay vì widget.duration
              stream: _player.durationStream,
              builder: (context, snapshotDuration) {
                // Nếu chưa load xong stream, dùng duration từ DB. Nếu DB là 0 thì dùng tạm 10s để hiển thị UI
                var totalDuration = snapshotDuration.data ??
                    Duration(seconds: widget.duration.toInt());
                if (totalDuration.inSeconds == 0) {
                  totalDuration = const Duration(
                      seconds: 0); // Hiển thị 0:00 cho đến khi load được
                }

                return StreamBuilder<Duration>(
                  stream: _player.positionStream,
                  builder: (context, snapshotPosition) {
                    final position = snapshotPosition.data ?? Duration.zero;

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
