import 'package:get/get.dart';
import 'package:quranplayer/presentation/screen/home/home_binding.dart';
import 'package:quranplayer/presentation/screen/home/home_screen.dart';

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
  ];
}
