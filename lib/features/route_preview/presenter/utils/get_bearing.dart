import 'dart:math';

import 'package:sabbar/sabbar.dart';
// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math.dart' show degrees;

double getBearing(LatLng begin, LatLng end) {
  double lat = (begin.latitude - end.latitude).abs();

  double lng = (begin.longitude - end.longitude).abs();

  if (begin.latitude < end.latitude && begin.longitude < end.longitude) {
    return degrees(atan(lng / lat));
  } else if (begin.latitude >= end.latitude &&
      begin.longitude < end.longitude) {
    return (90 - degrees(atan(lng / lat))) + 90;
  } else if (begin.latitude >= end.latitude &&
      begin.longitude >= end.longitude) {
    return degrees(atan(lng / lat)) + 180;
  } else if (begin.latitude < end.latitude &&
      begin.longitude >= end.longitude) {
    return (90 - degrees(atan(lng / lat))) + 270;
  }

  return -1;
}
