import 'package:get/get.dart';
import 'package:quranplayer/data/repository/quran_repository.dart';
import 'package:quranplayer/data/service/audio_service.dart';
import 'package:quranplayer/presentation/screen/home/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(Get.find<QuranRepository>(), Get.find<AudioService>()));
  }
}
