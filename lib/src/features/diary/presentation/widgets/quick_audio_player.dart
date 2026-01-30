import 'package:flutter/material.dart';

class QuickAudioPlayer extends StatefulWidget {
  final double duration;
  final bool isLight;

  const QuickAudioPlayer({
    super.key,
    required this.duration,
    this.isLight = false,
  });

  @override
  State<QuickAudioPlayer> createState() => _QuickAudioPlayerState();
}

class _QuickAudioPlayerState extends State<QuickAudioPlayer> {
  bool _isPlaying = false;
  double _currentPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = widget.isLight ? Colors.white : colorScheme.primary;
    final onPrimaryColor =
        widget.isLight ? colorScheme.primary : colorScheme.onPrimary;
    final textColor =
        widget.isLight ? Colors.white70 : colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: widget.isLight
            ? Colors.black.withOpacity(0.3)
            : colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isPlaying = !_isPlaying;
              });
            },
            child: CircleAvatar(
              backgroundColor: primaryColor,
              radius: 20,
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: onPrimaryColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 6),
                    trackHeight: 4,
                    activeTrackColor: primaryColor,
                    inactiveTrackColor: primaryColor.withOpacity(0.3),
                    thumbColor: primaryColor,
                    overlayColor: primaryColor.withOpacity(0.1),
                  ),
                  child: Slider(
                    value: _currentPosition,
                    min: 0,
                    max: widget.duration,
                    onChanged: (value) {
                      setState(() {
                        _currentPosition = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(_currentPosition),
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: textColor),
                      ),
                      Text(
                        _formatDuration(widget.duration),
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: textColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(double seconds) {
    final duration = Duration(seconds: seconds.toInt());
    final minutes = duration.inMinutes;
    final remainingSeconds = duration.inSeconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
