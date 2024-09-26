import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/show_map/bindings/show_map_binding.dart';
import '../modules/show_map/views/show_map_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static const SHOW_MAP = Routes.SHOW_MAP;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SHOW_MAP,
      page: () => const ShowMapView(),
      binding: ShowMapBinding(),
    ),
  ];
}
