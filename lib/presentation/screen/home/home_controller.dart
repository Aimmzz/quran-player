import 'package:get/get.dart';
import 'package:quranplayer/core/routes/app_pages.dart';
import 'package:quranplayer/data/model/reciter.dart';
import 'package:quranplayer/data/model/surah.dart';
import 'package:quranplayer/data/model/track.dart';
import 'package:quranplayer/data/repository/quran_repository.dart';
import 'package:quranplayer/data/service/audio_service.dart';

class HomeController extends GetxController {
  final QuranRepository _repository;
  final AudioService _audioService;

  HomeController(this._repository, this._audioService);

  final RxList<Surah> surahs = <Surah>[].obs;
  final RxList<Reciter> reciters = <Reciter>[].obs;
  final Rx<Reciter?> selectedReciter = Rx<Reciter?>(null);
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;


  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Public Methods ////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  void retry() => _loadData();

  Future<void> refreshData() async {
    surahs.clear();
    reciters.clear();
    selectedReciter.value = null;
    await _loadData();
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
    errorMessage.value = '';

    try {
      final results = await Future.wait([
        _repository.fetchSurahs(),
        _repository.fetchReciters(),
      ]);

      surahs.assignAll(results[0] as List<Surah>);
      reciters.assignAll(results[1] as List<Reciter>);

      // Default reciter: Mishary Alafasy
      selectedReciter.value = reciters.firstWhereOrNull(
            (r) => r.identifier == 'ar.alafasy',
      ) ??
          reciters.firstOrNull;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Convenience Getters ///////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  bool isPlayingTrack(int surahNumber) {
    final current = _audioService.currentTrack.value;
    return current?.surah.number == surahNumber &&
        _audioService.playbackState.value == PlaybackState.playing;
  }
}