import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:quranplayer/core/routes/app_pages.dart';
import 'package:quranplayer/data/model/reciter.dart';
import 'package:quranplayer/data/model/surah.dart';
import 'package:quranplayer/data/model/track.dart';
import 'package:quranplayer/data/repository/quran_repository.dart';

class SurahReciterSearchController extends GetxController {
  final QuranRepository _repository;

  SurahReciterSearchController(this._repository);

  final TextEditingController queryController = TextEditingController();

  final RxList<Surah> allSurahs = <Surah>[].obs;
  final RxList<Reciter> allReciters = <Reciter>[].obs;
  final RxList<Surah> filteredSurahs = <Surah>[].obs;
  final RxList<Reciter> filteredReciters = <Reciter>[].obs;
  final Rx<Reciter?> selectedReciter = Rx<Reciter?>(null);
  final RxBool isLoading = true.obs;
  final RxString query = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
    debounce(query, (_) => _applyFilter(), time: const Duration(milliseconds: 300));
  }

  @override
  void onClose() {
    queryController.dispose();
    super.onClose();
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Public Methods ////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  void onQueryChanged(String value) => query.value = value;

  void clearQuery() {
    queryController.clear();
    query.value = '';
  }

  void selectReciter(Reciter reciter) {
    selectedReciter.value = reciter;
  }

  void openPlayer(Surah surah) {
    final reciter = selectedReciter.value;
    if (reciter == null) return;
    final track = Track(surah: surah, reciter: reciter);
    Get.toNamed(Routes.player, arguments: track);
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Internal Methods //////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<void> _loadData() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        _repository.fetchSurahs(),
        _repository.fetchReciters(),
      ]);
      allSurahs.assignAll(results[0] as List<Surah>);
      allReciters.assignAll(results[1] as List<Reciter>);
      selectedReciter.value = allReciters.firstWhereOrNull(
            (r) => r.identifier == 'ar.alafasy',
      ) ??
          allReciters.firstOrNull;
      _applyFilter();
    } finally {
      isLoading.value = false;
    }
  }

  void _applyFilter() {
    final q = query.value.toLowerCase().trim();
    if (q.isEmpty) {
      filteredSurahs.assignAll(allSurahs);
      filteredReciters.assignAll(allReciters);
      return;
    }

    filteredSurahs.assignAll(
      allSurahs.where((s) =>
      s.englishName.toLowerCase().contains(q) ||
          s.englishNameTranslation.toLowerCase().contains(q) ||
          s.number.toString() == q),
    );

    filteredReciters.assignAll(
      allReciters.where((r) => r.name.toLowerCase().contains(q)),
    );
  }
}