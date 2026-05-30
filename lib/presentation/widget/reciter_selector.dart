import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quranplayer/data/model/reciter.dart';
import 'package:quranplayer/presentation/widget/reciter_chip.dart';

class ReciterSelector extends StatelessWidget {
  final List<Reciter> reciters;
  final Rx<Reciter?> selected;
  final ValueChanged<Reciter> onSelect;

  const ReciterSelector({
    super.key,
    required this.reciters,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: reciters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final reciter = reciters[index];
          return Obx(() => ReciterChip(
            label: reciter.name,
            isSelected: selected.value == reciter,
            onTap: () => onSelect(reciter),
          ));
        },
      ),
    );
  }
}