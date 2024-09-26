import 'package:get/get.dart';

import '../controllers/show_map_controller.dart';

class ShowMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShowMapController>(
      () => ShowMapController(),
    );
  }
}
