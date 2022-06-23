import 'package:sabbar/features/places/places.dart';
import 'package:sabbar/sabbar.dart';

Future<PlaceDetail> getPlaceDetailFromId(String placeId) async {
  final queryParameters = {
    'place_id': placeId,
    'fields': 'formatted_address,name,geometry/location',
    'key': 'AIzaSyBtL1g5Hql-UGO3g5n-iuM7RAJaizNDWPE',
    'sessiontoken': 'sessionToken'
  };
  var result = await HttpClient()
      .getUrl(Uri.https('maps.googleapis.com', '/maps/api/place/details/json',
          queryParameters))
      .then((req) => req.close())
      .then((res) => res.transform(utf8.decoder).join())
      .then((str) => json.decode(str));

  if (result != null) {
    if (result['status'] == 'OK') {
      // build result
      final place = PlaceDetail();
      place.address = result['result']['formatted_address'];
      place.latitude = result['result']['geometry']['location']['lat'];
      place.longitude = result['result']['geometry']['location']['lng'];
      place.name = result['result']['geometry']['name'];
      return place;
    }
    throw Exception(result['error_message']);
  } else {
    throw Exception('Failed to fetch suggestion');
  }
}
