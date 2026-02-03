import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'audio_player_controller.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioPlayerProvider);
    final track = audioState.currentTrack;

    if (track == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Spotify-like mini player color
    final backgroundColor = isDark
        ? const Color(0xFF3E3E3E)
        : const Color(0xFFE0F2F1); // Dark grey or Light Teal variant

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        dense: true,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: track.thumbnailUrl != null
              ? Image.network(track.thumbnailUrl!,
                  width: 40, height: 40, fit: BoxFit.cover)
              : Container(
                  width: 40,
                  height: 40,
                  color: Colors.grey,
                  child: const Icon(Icons.music_note, color: Colors.white),
                ),
        ),
        title: Text(
          track.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style:
              theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          track.mood?.label ?? '', // Fixed: Use .label and handle null
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Connect to device button? (Spotify has one), omitting for now
            IconButton(
              icon: Icon(audioState.isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () {
                ref.read(audioPlayerProvider.notifier).togglePlay();
              },
            ),
          ],
        ),
        onTap: () {
          // Open Detail Screen
          context.push('/detail/${track.id}');
        },
      ),
    );
  }
}
