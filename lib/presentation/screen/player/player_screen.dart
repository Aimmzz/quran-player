import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quranplayer/core/utils/app_utils.dart';
import 'package:quranplayer/data/service/audio_service.dart';
import 'package:quranplayer/presentation/screen/player/player_controller.dart';
import 'package:quranplayer/presentation/widget/play_pause_button.dart';

class PlayerScreen extends GetView<PlayerController> {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final audioService = Get.find<AudioService>();

    ever(audioService.currentTrack, (track) {
      if (track == null) {
        Get.until((route) => Get.currentRoute == '/');
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 32),
          onPressed: () => Get.back(),
        ),
        title: const Text('Now Playing'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 2),

              _artworkWidget(context, controller.track.surah.number),

              const Spacer(flex: 2),

              Text(
                controller.track.arabicTitle,
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                controller.track.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                controller.track.subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 2),

              Obx(() {
                final pos = controller.position;
                final dur = controller.duration;
                final maxMs = dur.inMilliseconds.toDouble();
                final currentMs = pos.inMilliseconds
                    .toDouble()
                    .clamp(0, maxMs > 0 ? maxMs : 1);

                return Column(
                  children: [
                    Slider(
                      value: currentMs.toDouble(),
                      min: 0,
                      max: maxMs > 0 ? maxMs : 1,
                      onChanged: maxMs > 0 ? controller.onSeekChanged : null,
                      onChangeEnd: maxMs > 0 ? controller.onSeekEnd : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppUtils.formatDuration(pos),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                              theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          // Buffering indicator
                          if (controller.isBuffering)
                            SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          Text(
                            AppUtils.formatDuration(dur),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                              theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 16),

              Obx(() {
                final state = audioService.playbackState.value;
                final isPlaying = state == PlaybackState.playing;
                final isLoading = state == PlaybackState.loading ||
                    audioService.isBuffering.value;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 36,
                      icon: const Icon(Icons.replay_10_rounded),
                      onPressed: controller.rewind,
                    ),
                    const SizedBox(width: 16),

                    PlayPauseButton(
                      isPlaying: isPlaying,
                      isLoading: isLoading,
                      onTap: controller.togglePlayPause,
                    ),

                    const SizedBox(width: 16),

                    IconButton(
                      iconSize: 36,
                      icon: const Icon(Icons.forward_10_rounded),
                      onPressed: controller.fastForward,
                    ),
                  ],
                );
              }),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _artworkWidget(BuildContext context, int surahNumber) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size.width * 0.72;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.surfaceContainerLow,
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.15),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            surahNumber.toString().padLeft(3, '0'),
            style: theme.textTheme.displaySmall?.copyWith(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 4),
          Icon(
            Icons.menu_book_rounded,
            size: 64,
            color: theme.colorScheme.primary.withValues(alpha: 0.7),
          ),
        ],
      ),
    );
  }
}
