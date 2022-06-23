import 'package:flutter_animarker/core/ripple_marker.dart';
import 'package:sabbar/features/route_preview/route_preview.dart';
import 'package:sabbar/sabbar.dart';
import 'package:uuid/uuid.dart';

var session = const Uuid().v4();

Future<List<Marker>> getNearbyLocation(
  double lat,
  double long,
) async {
  final queryParameters = {
    'location': '${lat.toString()},${long.toString()}',
    'radius': '1500',
    'key': 'AIzaSyBtL1g5Hql-UGO3g5n-iuM7RAJaizNDWPE',
    'sessiontoken': session
  };
  var response = await restService.get('/maps/api/place/nearbysearch/json',
      parameters: queryParameters);

  // var response = await HttpClient()
  //     .getUrl(Uri.https('maps.googleapis.com',
  //         '/maps/api/place/nearbysearch/json', queryParameters))
  //     .then((req) => req.close())
  //     .then((res) => res.transform(utf8.decoder).join())
  //     .then((str) => json.decode(str));

  if (response.error == ScreenError.noError && response.response != null) {
    BitmapDescriptor truck = BitmapDescriptor.fromBytes(
        await getBytesFromAsset('assets/images/truck.png', 85));

    if (response.response['status'] == 'OK') {
      List<Marker> address = [];
      for (int i = 0;
          i <
              ((response.response['results'] as List).length > 5
                  ? 5
                  : (response.response['results'] as List).length);
          i++) {
        if ((response.response['results'][i] as Map).containsKey('geometry')) {
          double lat = double.tryParse(response.response['results'][i]
                      ['geometry']['location']['lat']
                  .toString()) ??
              0;
          double lng = double.tryParse(response.response['results'][i]
                      ['geometry']['location']['lng']
                  .toString()) ??
              0;
          address.add(RippleMarker(
              ripple: true,
              markerId: MarkerId('Drive $i'),
              position: LatLng(lat, lng),
              icon: truck,
              rotation: getBearing(
                  i == 0 ? const LatLng(0, 0) : address[i - 1].position,
                  LatLng(lat, lng)),
              infoWindow: InfoWindow(title: 'Driver ${i + 1}')));
        }
      }
      return address;
    }
    if (response.response['status'] == 'ZERO_RESULTS') {
      return [];
    }
    throw Exception(response.response['error_message']);
  } else {
    throw Exception('Failed to fetch suggestion');
  }
}
