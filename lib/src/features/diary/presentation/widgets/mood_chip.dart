import 'package:flutter/material.dart';
import 'package:mp3_management/src/features/diary/domain/models/mood.dart';

class MoodChip extends StatelessWidget {
  final Mood mood;
  final bool isSelected;
  final VoidCallback? onTap;

  const MoodChip({
    super.key,
    required this.mood,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: colorScheme.primary)
              : Border.all(color: Colors.transparent),
        ),
        child: Text(
          mood.label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isSelected
                ? colorScheme.onPrimary
                : colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
