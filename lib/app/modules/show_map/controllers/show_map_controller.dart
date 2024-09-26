import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowMapController extends GetxController {
  LatLng initialPosition =
      LatLng(14.5619, 121.0579); //West Rembo, Makati City, Philippines

  late GoogleMapController mapController;

  final Set<Marker> markers = {};
  @override
  void onInit() {
    super.onInit();

    markers.add(
      Marker(
        markerId: MarkerId('marker_1'),
        position: initialPosition,
        infoWindow: InfoWindow(title: 'Marker in San Francisco'),
      ),
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}
