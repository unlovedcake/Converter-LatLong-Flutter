import 'dart:convert';

import 'package:converter_latlong/app/models/place_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class ShowMapController extends GetxController {
  final searchTextController = TextEditingController();
  LatLng initialPosition =
      LatLng(14.5619, 121.0579); //West Rembo, Makati City, Philippines

  late GoogleMapController mapController;

  final markers = <Marker>{}.obs;

  var searchResults = <Feature>[].obs;
  final isLoading = false.obs;

  final isSearchTextFieldEmpty = false.obs;

  final query = ''.obs;

  final markerId = '14.5619'.obs;

  // Fetch data from the API
  Future<void> searchPlaces(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      isSearchTextFieldEmpty.value = true;

      print('EMPTY searchResults: $searchResults');
      return;
    }
    isSearchTextFieldEmpty.value = false;
    isLoading.value = true;

    final url = Uri.parse('https://photon.komoot.io/api/?q=$query');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['features'];
        searchResults.value =
            data.map((placeJson) => Feature.fromJson(placeJson)).toList();
      } else {
        searchResults.clear();
        isLoading.value = false;
      }
    } catch (e) {
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();

    debounce(query, (_) => searchPlaces(query.value),
        time: Duration(milliseconds: 300));

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
        markerId: MarkerId(markerId.value),
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
