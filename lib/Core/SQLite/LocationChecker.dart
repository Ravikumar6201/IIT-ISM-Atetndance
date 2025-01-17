// import 'dart:math';

// class LocationHelper {
//   // Haversine formula to calculate distance between two points
//   double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//     const R = 6371000; // Earth's radius in meters
//     double dLat = _degreesToRadians(lat2 - lat1);
//     double dLon = _degreesToRadians(lon2 - lon1);
//     double a = sin(dLat / 2) * sin(dLat / 2) +
//         cos(_degreesToRadians(lat1)) *
//             cos(_degreesToRadians(lat2)) *
//             sin(dLon / 2) *
//             sin(dLon / 2);
//     double c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     double distance = R * c;
//     return distance; // distance in meters
//   }

//   // Convert degrees to radians
//   double _degreesToRadians(double degrees) {
//     return degrees * pi / 360;
//   }

//   // Check if the current location is within 100 meters of the target location
//   bool isWithinRadius(double currentLat, double currentLon, double targetLat,
//       double targetLon, double radius) {
//     double distance =
//         calculateDistance(currentLat, currentLon, targetLat, targetLon);
//     return distance <= radius;
//   }
// }

import 'package:geolocator/geolocator.dart';

class LocationHelper {
// Function to check if a point is within a 100-meter radius
  bool isPointWithinRadius(double centerLat, double centerLng, double pointLat,
      double pointLng, double radiusInMeters) {
    // Calculate the distance between the two points
    double distanceInMeters =
        Geolocator.distanceBetween(centerLat, centerLng, pointLat, pointLng);

    // Check if the distance is within the radius
    return distanceInMeters <= radiusInMeters;
  }

  // Check if the current location is within a specified radius of the target location
  bool isWithinRadius(double currentLat, double currentLon, double targetLat,
      double targetLon, double radius) {
    // bool distance = 
    return isPointWithinRadius(
        currentLat, currentLon, targetLat, targetLon, radius);
  }
}

// working

// import 'dart:math';

// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class LocationHelper {
//   final double customRadius;

//   LocationHelper(this.customRadius);

//   // Spherical Law of Cosines formula to calculate distance between two points
//   double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//     final double radLat1 = _degreesToRadians(lat1);
//     final double radLat2 = _degreesToRadians(lat2);
//     final double dLon = _degreesToRadians(lon2 - lon1);

//     final double distance = acos(sin(radLat1) * sin(radLat2) +
//             cos(radLat1) * cos(radLat2) * cos(dLon)) *
//         customRadius;

//     return distance; // distance in custom units
//   }

//   // Convert degrees to radians
//   double _degreesToRadians(double degrees) {
//     return degrees * pi / 180;
//   }

  // Check if the current location is within a specified radius of the target location
//   bool isWithinRadius(double currentLat, double currentLon, double targetLat,
//       double targetLon, double radius) {
//     final double distance =
//         calculateDistance(currentLat, currentLon, targetLat, targetLon);
//     return distance <= radius;
//   }

// }
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'dart:math' as math;

// class LocationHelper {
//   static const double _earthRadius = 6371000; // in meters

//   bool isLatLngWithinCircle(LatLng point, LatLng center, double radius) {
//     double dLat = _degreesToRadians(point.latitude - center.latitude);
//     double dLng = _degreesToRadians(point.longitude - center.longitude);

//     double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
//         math.cos(_degreesToRadians(center.latitude)) *
//             math.cos(_degreesToRadians(point.latitude)) *
//             math.sin(dLng / 2) *
//             math.sin(dLng / 2);

//     double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
//     double distance = _earthRadius * c;

//     return distance 
//     <= radius;
//   }

//   double _degreesToRadians(double degrees) {
//     return degrees * math.pi / 180;
//   }
// }
