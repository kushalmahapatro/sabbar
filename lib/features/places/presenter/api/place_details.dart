import 'package:sabbar/features/places/places.dart';
import 'package:sabbar/sabbar.dart';

Future<PlaceDetail> getPlaceDetailFromId(String placeId) async {
  final queryParameters = {
    'place_id': placeId,
    'fields': 'formatted_address,name,geometry/location',
    'key': 'AIzaSyBtL1g5Hql-UGO3g5n-iuM7RAJaizNDWPE',
    'sessiontoken': 'sessionToken'
  };
  var response = await restService.get('/maps/api/place/details/json',
      parameters: queryParameters);

  // var result = await HttpClient()
  //     .getUrl(Uri.https('maps.googleapis.com', '/maps/api/place/details/json',
  //         queryParameters))
  //     .then((req) => req.close())
  //     .then((res) => res.transform(utf8.decoder).join())
  //     .then((str) => json.decode(str));

  if (response.error == ScreenError.noError && response.response != null) {
    if (response.response['status'] == 'OK') {
      // build result
      final place = PlaceDetail();
      place.address = response.response['result']['formatted_address'];
      place.latitude =
          response.response['result']['geometry']['location']['lat'];
      place.longitude =
          response.response['result']['geometry']['location']['lng'];
      place.name = response.response['result']['geometry']['name'];
      return place;
    }
    throw Exception(response.response['error_message']);
  } else {
    throw Exception('Failed to fetch suggestion');
  }
}
