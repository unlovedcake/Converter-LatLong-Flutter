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

    addMarker(initialPosition);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void addMarker(LatLng position) {
    markers.add(
      Marker(
        markerId: MarkerId('marker_1'),
        position: initialPosition,
        infoWindow: InfoWindow(
            title: 'Marker in San Francisco', snippet: '14.5619, 121.0579'),
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    moveToPosition(initialPosition);
  }

  void moveToPosition(LatLng position) {
    mapController.animateCamera(
      CameraUpdate.newLatLng(position),
    );
    addMarker(position);
  }
}
