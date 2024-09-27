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
            border: OutlineInputBorder(),
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
          Obx(() => GoogleMap(
                mapType: MapType.hybrid,
                onMapCreated: controller.onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: controller.initialPosition,
                  zoom: 12.0,
                ),
                markers: controller.markers.value,
                onTap: (LatLng position) {
                  controller.moveToPosition(position);
                },
              )),
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
                              leading: Icon(Icons.location_city_rounded),
                              title: Text(
                                  '${place.properties!.city ?? ''} ${place.properties!.name ?? ''}'),
                              onTap: () {
                                controller.markers.value = {};
                                controller.isSearchTextFieldEmpty.value = true;
                                controller.initialPosition = LatLng(
                                    place.geometry!.coordinates![1],
                                    place.geometry!.coordinates![0]);

                                controller.markerId.value =
                                    place.geometry!.coordinates![1].toString();
                                controller
                                    .moveToPosition(controller.initialPosition);
                                // controller
                                //     .addMarker(controller.initialPosition);

                                print(place.geometry!.coordinates![0]);
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
