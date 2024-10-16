import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  final latitudeDD = ''.obs;
  final longitudeDD = ''.obs;
  var latitudeDMS = ''.obs;
  var longitudeDMS = ''.obs;

  var isLoading = false.obs;

  String convertToDMS(double decimalDegree) {
    int degrees = decimalDegree.floor(); // Get the whole degrees
    double decimalMinutes =
        (decimalDegree - degrees) * 60.0; // Get the minutes part
    int minutes = decimalMinutes.floor(); // Get the whole minutes
    double seconds = (decimalMinutes - minutes) * 60.0; // Get the seconds part

    return "$degrees° $minutes' ${seconds.toStringAsFixed(2)}\"";
  }

  double convertToDecimal(int scaledCoordinate) {
    return scaledCoordinate / 100000.0;
  }

  String convertToDMSS(double latitude) {
    // Get the degree part
    int degrees = latitude.floor();

    // Get the decimal part and convert it to minutes
    double decimalMinutes = (latitude - degrees) * 60;
    int minutes = decimalMinutes.floor();

    // Get the decimal part of the minutes and convert it to seconds
    double decimalSeconds = (decimalMinutes - minutes) * 60;
    double seconds = decimalSeconds;

    // Return formatted DMS string
    return '$degrees° $minutes\' ${seconds.toStringAsFixed(2)}"';
  }

  bool isValidLatitude(String input) {
    double? value = double.tryParse(input);
    if (value == null) return false;
    return value >= -90 && value <= 90;
  }

  bool isValidLongitude(String input) {
    double? value = double.tryParse(input);
    if (value == null) return false;
    return value >= -180 && value <= 180;
  }

  Future<void> convertCoordinates() async {
    try {
      // Convert to decimal degrees

      if (isValidLatitude(latitudeDD.value)) {
        print('Valid Latitude');
      } else {
        print('Invalid Latitude');
      }

      if (isValidLongitude(longitudeDD.value)) {
        print('Valid Longitude');
      } else {
        print('Invalid Longitude');
      }

      print('Convert latitude' + convertToDMSS(double.parse(latitudeDD.value)));
      print(
          'Convert longitude' + convertToDMSS(double.parse(longitudeDD.value)));

      // double latitudeDecimal = convertToDecimal(int.parse(latitudeDD.value));
      // double longitudeDecimal = convertToDecimal(int.parse(longitudeDD.value));
      // print('Convert' + convertToDMSS(123.8392));
      // print('Convert Decimal' + latitudeDecimal.toString());

      // // Convert to DMS format
      // latitudeDMS.value = convertToDMS(latitudeDecimal);
      // longitudeDMS.value = convertToDMS(longitudeDecimal);
      // await saveCoordinatesToDB();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Invalid coordinate values. Please enter valid numbers.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> saveCoordinatesToDB() async {
    isLoading(true);
    try {
      var url = Uri.parse('http://10.0.2.2:3000/coords');
      var response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "notes": 'notes',
              "lat": latitudeDMS.value,
              "lng": longitudeDMS.value,
            }),
          )
          .timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Coordinates added successfully");
      } else {
        isLoading(false);
        Get.snackbar(
          "Error",
          "Failed to add coordinates",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      print('ERROR: $e');
      Get.snackbar(
          colorText: Colors.white,
          backgroundColor: Colors.red,
          "Error",
          "Something went wrong");
    } finally {
      isLoading(false);
    }
  }
}
