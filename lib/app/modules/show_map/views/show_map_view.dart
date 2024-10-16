import 'package:converter_latlong/app/models/place_model.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/show_map_controller.dart';

class ShowMapView extends GetView<ShowMapController> {
  const ShowMapView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShowMapController());
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: TextFormField(
          controller: controller.searchTextController,
          onChanged: (value) => controller.query.value = value,
          decoration: InputDecoration(
            hintText: 'Search for a place',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  30.0), // Adjust the value for rounder corners
            ),
            suffixIcon: IconButton(
                onPressed: () {
                  controller.searchTextController.text = '';
                  controller.searchResults.clear();
                },
                icon: Icon(Icons.close)),
            prefixIcon: Icon(Icons.search),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GetBuilder<ShowMapController>(
            builder: (_) => Obx(() => GoogleMap(
                  mapType: MapType.hybrid,
                  onMapCreated: (GoogleMapController controllers) {
                    controller.onMapCreated(controllers);
                    controller.googleMapController.complete(controllers);

                    print('Map Loaded');
                  },
                  //onMapCreated: controller.onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: controller.destination,
                    zoom: 12.0,
                  ),
                  markers: controller.markers.value,
                  polylines: {
                    Polyline(
                      polylineId: PolylineId('animated_polyline'),
                      points: controller.polylineCoordinates.value,
                      color: Colors.red,
                      width: 4,
                    ),
                  },
                  onTap: (LatLng position) {
                    controller.moveToPosition(position);
                  },
                )),
          ),
          Positioned(
              child: Obx(() => controller.isSearchTextFieldEmpty.value ||
                      controller.searchResults.isEmpty
                  ? SizedBox()
                  : Container(
                      height: MediaQuery.of(context).size.height * .5,
                      color: Colors.white,
                      width: double.infinity,
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (controller.searchResults.isEmpty) {
                          return Center(child: Text('No results found'));
                        }

                        return ListView.builder(
                          itemCount: controller.searchResults.length,
                          itemBuilder: (context, index) {
                            final place = controller.searchResults[index];
                            return ListTile(
                              leading: Icon(
                                Icons.person_pin_circle,
                                color: Colors.blue,
                              ),
                              title: Text(
                                  '${place.properties!.city ?? ''} ${place.properties!.name ?? ''}'),
                              onTap: () {
                                controller.polylineCoordinates.value = [];
                                controller.markers.value = {};
                                controller.isSearchTextFieldEmpty.value = true;
                                controller.destination = LatLng(
                                    place.geometry!.coordinates![1],
                                    place.geometry!.coordinates![0]);

                                controller.markerId.value =
                                    place.geometry!.coordinates![1].toString();

                                controller.fetchRoute();
                                controller
                                    .moveToPosition(controller.destination);
                              },
                            );
                          },
                        );
                      }),
                    ))),
        ],
      ),
    );
  }
}
