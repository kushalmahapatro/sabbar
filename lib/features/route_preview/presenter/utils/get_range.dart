import 'dart:math';

import 'package:sabbar/sabbar.dart';

double getRange(LatLng current, LatLng dest) {
  var ky = 40000 / 360;
  var kx = cos(pi * current.latitude / 180.0) * ky;
  var dx = ((dest.longitude - current.longitude) * kx).abs();
  var dy = ((dest.latitude - current.latitude) * ky).abs();
  var dist = sqrt(dx * dx + dy * dy) * 1000;
  return dist;
}
