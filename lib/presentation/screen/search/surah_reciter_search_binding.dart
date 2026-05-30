import 'package:get/get.dart';
import 'package:quranplayer/data/repository/quran_repository.dart';
import 'package:quranplayer/presentation/screen/search/surah_reciter_search_controller.dart';

class SurahReciterSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SurahReciterSearchController(Get.find<QuranRepository>()),
    );
  }
}
