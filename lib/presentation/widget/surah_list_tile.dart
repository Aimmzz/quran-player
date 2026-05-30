import 'package:flutter/material.dart';
import 'package:quranplayer/data/model/surah.dart';

class SurahListTile extends StatelessWidget {
  final Surah surah;
  final bool isPlaying;
  final VoidCallback onTap;

  const SurahListTile({
    super.key,
    required this.surah,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isPlaying
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHigh,
        ),
        child: Center(
          child: isPlaying
              ? Icon(Icons.volume_up_rounded,
              size: 20, color: theme.colorScheme.onPrimary)
              : Text(
            surah.number.toString(),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
      title: Text(
        surah.englishName,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: isPlaying ? FontWeight.w600 : FontWeight.normal,
          color: isPlaying ? theme.colorScheme.primary : null,
        ),
      ),
      subtitle: Text(
        '${surah.englishNameTranslation} · ${surah.numberOfAyahs} verses',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      trailing: Text(
        surah.name,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.primary.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}