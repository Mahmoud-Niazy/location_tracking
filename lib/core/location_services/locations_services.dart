import 'dart:math' as math;
import 'package:fbroadcast/fbroadcast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class LocationServices {
  static final LocationServices singleton = LocationServices._internal();
  LocationServices._internal();
  static LocationServices get shared => singleton;

  Future<bool> handlePermissions()async{
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  Future<LatLng?> getCurrentLocation()async{
    bool hasPermission = await handlePermissions();
    if(!hasPermission){
      return null;
    }
    Position position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }

   getLocationUpdates() async {
    const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 3);

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      FBroadcast.instance().broadcast("update_location", value: position);
    });
  }

  static double calculateDegrees(LatLng startPoint, LatLng endPoint) {
    final double startLat = toRadians(startPoint.latitude);
    final double startLng = toRadians(startPoint.longitude);
    final double endLat = toRadians(endPoint.latitude);
    final double endLng = toRadians(endPoint.longitude);

    final double deltaLng = endLng - startLng;

    final double y = math.sin(deltaLng) * math.cos(endLat);
    final double x = math.cos(startLat) * math.sin(endLat) -
        math.sin(startLat) * math.cos(endLat) * math.cos(deltaLng);

    final double bearing = math.atan2(y, x);
    return (toDegrees(bearing) + 360) % 360;
  }

  static double toRadians(double degrees) {
    return degrees * (math.pi / 180.0);
  }

  static double toDegrees(double radians) {
    return radians * (180.0 / math.pi);
  }


  Stream<LatLng> moveTowards(
      LatLng start,
      LatLng end, {
        double step = 0.01,
        Duration delay = const Duration(milliseconds: 100),
      }) async* {
    double t = 0.0;

    while (t < 1.0) {
      final lat = start.latitude + (end.latitude - start.latitude) * t;
      final lng = start.longitude + (end.longitude - start.longitude) * t;
      yield LatLng(lat, lng);
      await Future.delayed(delay);
      t += step;
    }

    yield end;
  }

  static Future<String> getLocationName(LatLng location) async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(location.latitude, location.longitude);
      if (placeMarks.isNotEmpty) {
        final place = placeMarks.first;
        return "${place.name}, ${place.locality}, ${place.country}";
      }
      else {
        return "مكان غير معروف";
      }
    } catch (e) {
      return "";
    }
  }

  static Future<double> getDistanceInMeters(LatLng start, LatLng end) async {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }
}
