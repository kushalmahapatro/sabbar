import 'package:sabbar/features/places/places.dart';
import 'package:sabbar/sabbar.dart';

Future<PlaceDetail> getPlaceDetailFromId(String placeId) async {
  final queryParameters = {
    'place_id': placeId,
    'fields': 'formatted_address,name,geometry/location',
    'key': 'GOOGLE_MAP_KEY',
    'sessiontoken': 'sessionToken'
  };
  var response = await restService.get('/maps/api/place/details/json',
      parameters: queryParameters);

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
