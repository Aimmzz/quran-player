import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quranplayer/data/service/audio_service.dart';

class MiniPlayer extends StatelessWidget {
  final AudioService audioService;

  const MiniPlayer({super.key, required this.audioService});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final track = audioService.currentTrack.value;
      if (track == null) return const SizedBox.shrink();

      final isPlaying =
          audioService.playbackState.value == PlaybackState.playing;
      final dur = audioService.duration.value.inMilliseconds.toDouble();
      final pos = audioService.position.value.inMilliseconds
          .toDouble()
          .clamp(0, dur > 0 ? dur : 1);

      return GestureDetector(
        onTap: () => {},
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHigh,
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(
                value: dur > 0 ? pos / dur : 0,
                minHeight: 2,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
              ),

              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            track.title,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            track.subtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                              theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      icon: Icon(
                        isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        size: 28,
                      ),
                      onPressed: () {
                        if (isPlaying) {
                          audioService.pause();
                        } else {
                          audioService.resume();
                        }
                      },
                    ),

                    IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        size: 22,
                      ),
                      tooltip: 'Close Player',
                      onPressed: () {
                        audioService.stop();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
