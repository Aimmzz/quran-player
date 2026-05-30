import 'package:get/get.dart';
import 'package:quranplayer/data/service/audio_service.dart';
import 'player_controller.dart';

class PlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PlayerController(Get.find<AudioService>()));
  }
}
