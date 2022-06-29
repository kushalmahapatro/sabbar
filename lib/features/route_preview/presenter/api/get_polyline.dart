import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:sabbar/sabbar.dart';

Future<List<LatLng>> getPolyPoints(
    LatLng pickupLocation, LatLng dropoffLocation) async {
  List<LatLng> ltln = [];
  PolylinePoints polylinePoints = PolylinePoints();
  PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    'GOOGLE_MAP_KEY', // Your Google Map Key
    PointLatLng(pickupLocation.latitude, pickupLocation.longitude),
    PointLatLng(dropoffLocation.latitude, dropoffLocation.longitude),
  );
  if (result.points.isNotEmpty) {
    for (var point in result.points) {
      ltln.add(
        LatLng(point.latitude, point.longitude),
      );
    }
  }
  return ltln;
}
