import 'package:get/get.dart';
import 'package:quranplayer/presentation/screen/home/home_binding.dart';
import 'package:quranplayer/presentation/screen/home/home_screen.dart';
import 'package:quranplayer/presentation/screen/player/player_binding.dart';
import 'package:quranplayer/presentation/screen/player/player_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.player,
      page: () => const PlayerScreen(),
      binding: PlayerBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 350),
    ),
  ];
}
