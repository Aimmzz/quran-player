import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quranplayer/data/service/audio_service.dart';
import 'package:quranplayer/presentation/screen/home/home_controller.dart';
import 'package:quranplayer/presentation/widget/error_view.dart';
import 'package:quranplayer/presentation/widget/mini_player.dart';
import 'package:quranplayer/presentation/widget/reciter_selector.dart';
import 'package:quranplayer/presentation/widget/shimmer_list.dart';
import 'package:quranplayer/presentation/widget/surah_list_tile.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final audioService = Get.find<AudioService>();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'Quran Player',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'القرآن الكريم',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Search',
            onPressed: () => {},
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const ShimmerList();
        }

        if (controller.errorMessage.isNotEmpty) {
          return ErrorView(
            message: controller.errorMessage.value,
            onRetry: controller.retry,
          );
        }

        return Column(
          children: [
            ReciterSelector(
              reciters: controller.reciters,
              selected: controller.selectedReciter,
              onSelect: controller.selectReciter,
            ),
            const Divider(height: 1),

            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshData,
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: controller.surahs.length,
                  itemBuilder: (context, index) {
                    final surah = controller.surahs[index];
                    return Obx(() => SurahListTile(
                      surah: surah,
                      isPlaying: controller.isPlayingTrack(surah.number),
                      onTap: () => controller.openPlayer(surah),
                    ));
                  },
                ),
              ),
            ),
          ],
        );
      }),

      bottomSheet: Obx(() {
        final track = audioService.currentTrack.value;
        if (track == null) return const SizedBox.shrink();
        return MiniPlayer(audioService: audioService);
      }),
    );
  }
}