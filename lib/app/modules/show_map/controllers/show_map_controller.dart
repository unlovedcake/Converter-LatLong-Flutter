import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:converter_latlong/app/models/place_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class ShowMapController extends GetxController {
  final searchTextController = TextEditingController();

  late LatLng _userLocation =
      LatLng(14.5619, 121.0579); //West Rembo, Makati City, Philippines

  LatLng destination = LatLng(10.2518, 123.8542);

  late GoogleMapController mapController;

  final polylineCoordinates = <LatLng>[].obs;

  final updateCoordinates = Rx<LatLng>(LatLng(14.5619, 121.0579));
  Completer<GoogleMapController> googleMapController = Completer();

  final markers = <Marker>{}.obs;

  var searchResults = <Feature>[].obs;
  final isLoading = false.obs;

  final isSearchTextFieldEmpty = false.obs;

  final query = ''.obs;

  final markerId = 'destinationId'.obs;

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

  Uint8List? markerIAnimate;

  Future<void> _loadMarkerIcon() async {
    markerIAnimate =
        await getBytesFromAsset('assets/images/car_icon.png', 80, 80);
  }

  Future<Uint8List> getBytesFromAsset(
      String path, int width, int height) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
      targetHeight: height,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> _animateRoute(List<LatLng> polylinePoints) async {
    const int updateInterval =
        100; // Interval between position updates in milliseconds

    final List<LatLng> points = polylinePoints;
    final GoogleMapController controller = await googleMapController.future;

    Timer.periodic(Duration(milliseconds: updateInterval), (Timer timer) {
      if (points.isEmpty) {
        log('Timer Cancel' + markers.toString());

        timer.cancel();
        return;
      }

      markers.removeWhere((marker) =>
          marker.markerId.value == 'marker1'); // Remove the old marker

      updateCoordinates.value = points.removeAt(0);

      markers.add(
        Marker(
          markerId: MarkerId('marker1'),
          position: updateCoordinates.value,
          icon: BitmapDescriptor.fromBytes(markerIAnimate!),
        ),
      );

      polylineCoordinates.value.add(updateCoordinates.value);

      controller.animateCamera(CameraUpdate.newLatLng(updateCoordinates.value));
      update();
      //moveToPosition(updateCoordinates.value);
    });
  }

  Future<void> fetchRoute() async {
    final apiKey = ''; // Replace with your API key
    final url = 'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${_userLocation.latitude},${_userLocation.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      log('Response' + data['status'].toString());

      if (data['status'].toString() == 'ZERO_RESULTS') {
        print('ZERO_RESULTS');
        return;
      }

      final encodedPolyline = data['routes'][0]['overview_polyline']['points'];

      final polylinePoints = _decodePolyline(encodedPolyline);

      _animateRoute(polylinePoints);
    } else {
      // Handle the error
      print('Failed to fetch route');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0;
    int lat = 0;
    int lng = 0;
    while (index < encoded.length) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int deltaLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += deltaLat;
      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int deltaLng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += deltaLng;
      polyline.add(LatLng(
        (lat / 1E5).toDouble(),
        (lng / 1E5).toDouble(),
      ));
    }
    return polyline;
  }

  @override
  void onInit() {
    super.onInit();

    debounce(query, (_) => searchPlaces(query.value),
        time: Duration(milliseconds: 300));

    addMarker();
    _loadMarkerIcon();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    mapController.dispose();
    searchTextController.dispose();
  }

  void addMarker() {
    if (markerId.value != 'destinationId') {
      markers.add(
        Marker(
          markerId: MarkerId(markerId.value),
          position: destination,
          infoWindow: InfoWindow(title: 'Destination'),
        ),
      );
    }
    markers.add(
      Marker(
        markerId: MarkerId('userID'),
        position: _userLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(
            title: 'Marker in San Francisco', snippet: '14.5619, 121.0579'),
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    moveToPosition(_userLocation);
  }

  void moveToPosition(LatLng position) {
    mapController.animateCamera(
      CameraUpdate.newLatLng(position),
    );
    addMarker();
  }
}

// import 'dart:convert';

// import 'package:converter_latlong/app/models/place_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;

// class ShowMapController extends GetxController {
//   final searchTextController = TextEditingController();
//   LatLng destination =
//       LatLng(14.5619, 121.0579); //West Rembo, Makati City, Philippines

//   late GoogleMapController mapController;

//   final markers = <Marker>{}.obs;

//   var searchResults = <Feature>[].obs;
//   final isLoading = false.obs;

//   final isSearchTextFieldEmpty = false.obs;

//   final query = ''.obs;

//   final markerId = '14.5619'.obs;

//   // Fetch data from the API
//   Future<void> searchPlaces(String query) async {
//     if (query.isEmpty) {
//       searchResults.clear();
//       isSearchTextFieldEmpty.value = true;

//       print('EMPTY searchResults: $searchResults');
//       return;
//     }
//     isSearchTextFieldEmpty.value = false;
//     isLoading.value = true;

//     final url = Uri.parse('https://photon.komoot.io/api/?q=$query');

//     try {
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body)['features'];
//         searchResults.value =
//             data.map((placeJson) => Feature.fromJson(placeJson)).toList();
//       } else {
//         searchResults.clear();
//         isLoading.value = false;
//       }
//     } catch (e) {
//       searchResults.clear();
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   @override
//   void onInit() {
//     super.onInit();

//     debounce(query, (_) => searchPlaces(query.value),
//         time: Duration(milliseconds: 300));

//     addMarker(destination);
//   }

//   @override
//   void onReady() {
//     super.onReady();
//   }

//   @override
//   void onClose() {
//     super.onClose();
//   }

//   void addMarker(LatLng position) {
//     markers.add(
//       Marker(
//         markerId: MarkerId(markerId.value),
//         position: destination,
//         infoWindow: InfoWindow(
//             title: 'Marker in San Francisco', snippet: '14.5619, 121.0579'),
//       ),
//     );
//   }

//   void onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//     moveToPosition(destination);
//   }

//   void moveToPosition(LatLng position) {
//     mapController.animateCamera(
//       CameraUpdate.newLatLng(position),
//     );
//     addMarker(position);
//   }
// }
