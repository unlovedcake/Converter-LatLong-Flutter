import 'package:get/get.dart';

class HomeController extends GetxController {
  final latitudeDD = ''.obs;
  final longitudeDD = ''.obs;
  var latitudeDMS = ''.obs;
  var longitudeDMS = ''.obs;

  String convertToDMS(double decimalDegree) {
    int degrees = decimalDegree.floor(); // Get the whole degrees
    double decimalMinutes =
        (decimalDegree - degrees) * 60.0; // Get the minutes part
    int minutes = decimalMinutes.floor(); // Get the whole minutes
    double seconds = (decimalMinutes - minutes) * 60.0; // Get the seconds part

    return "$degrees° $minutes' ${seconds.toStringAsFixed(2)}\"";
  }

  double convertToDecimal(int scaledCoordinate) {
    return scaledCoordinate / 10000.0;
  }

  void convertCoordinates() {
    try {
      // Convert to decimal degrees
      double latitudeDecimal = convertToDecimal(int.parse(latitudeDD.value));
      double longitudeDecimal = convertToDecimal(int.parse(longitudeDD.value));

      // Convert to DMS format
      latitudeDMS.value = convertToDMS(latitudeDecimal);
      longitudeDMS.value = convertToDMS(longitudeDecimal);
    } catch (e) {
      Get.snackbar(
          'Error', 'Invalid coordinate values. Please enter valid numbers.');
    }
  }

  // Function to simulate saving converted coordinates to the database
  Future<void> saveCoordinatesToDB() async {
    try {
      // Simulate an AJAX POST request (replace with actual endpoint)
      final response = await Future.delayed(Duration(seconds: 2), () {
        return {
          'status': 'success',
          'message': 'Coordinates saved to the database'
        };
      });

      if (response['status'] == 'success') {
        Get.snackbar('Success', response['message']!);
      } else {
        Get.snackbar('Error', 'Failed to save coordinates');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while saving coordinates.');
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
