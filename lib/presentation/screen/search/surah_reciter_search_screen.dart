import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quranplayer/presentation/screen/search/surah_reciter_search_controller.dart';
import 'package:quranplayer/presentation/widget/reciter_chip.dart';
import 'package:quranplayer/presentation/widget/surah_list_tile.dart';

class SurahReciterSearchScreen extends GetView<SurahReciterSearchController> {
  const SurahReciterSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: controller.queryController,
          autofocus: true,
          onChanged: controller.onQueryChanged,
          decoration: const InputDecoration(
            hintText: 'Search surah or reciter...',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(12.0),
            filled: false,
          ),
          style: theme.textTheme.bodyLarge,
        ),
        actions: [
          Obx(() => controller.query.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear_rounded),
            onPressed: controller.clearQuery,
          )
              : const SizedBox.shrink()),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final hasSurahs = controller.filteredSurahs.isNotEmpty;
        final hasReciters = controller.filteredReciters.isNotEmpty;

        if (!hasSurahs && !hasReciters) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search_off_rounded,
                    size: 64,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
                const SizedBox(height: 16),
                Text(
                  'No results for "${controller.query.value}"',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            if (hasReciters) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Reciters',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 48,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.filteredReciters.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final reciter = controller.filteredReciters[index];
                      return Obx(() => ReciterChip(
                        label: reciter.name,
                        isSelected:
                        controller.selectedReciter.value == reciter,
                        onTap: () => controller.selectReciter(reciter),
                      ));
                    },
                  ),
                ),
              ),
            ],

            if (hasSurahs) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Surahs',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final surah = controller.filteredSurahs[index];
                    return SurahListTile(
                      surah: surah,
                      isPlaying: false,
                      onTap: () => controller.openPlayer(surah),
                    );
                  },
                  childCount: controller.filteredSurahs.length,
                ),
              ),
            ],
          ],
        );
      }),
    );
  }
}
