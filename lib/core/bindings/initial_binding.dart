import 'package:get/get.dart';
import 'package:quranplayer/core/network/dio_client.dart';
import 'package:quranplayer/data/repository/quran_repository.dart';
import 'package:quranplayer/data/service/audio_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Network client — singleton
    Get.put(DioClient(), permanent: true);

    // Quran data repository — singleton
    Get.put(QuranRepository(Get.find()), permanent: true);

    // Audio playback service — singleton
    Get.put(AudioService(), permanent: true);
  }
}
