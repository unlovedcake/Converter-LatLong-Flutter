import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/show_map_controller.dart';

class ShowMapView extends GetView<ShowMapController> {
  const ShowMapView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show Map'),
        centerTitle: true,
      ),
      body: GoogleMap(
        mapType: MapType.terrain,
        onMapCreated: controller.onMapCreated,
        initialCameraPosition: CameraPosition(
          target: controller.initialPosition,
          zoom: 12.0,
        ),
        markers: controller.markers,
      ),
    );
  }
}
