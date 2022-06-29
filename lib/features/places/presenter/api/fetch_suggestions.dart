import 'package:sabbar/features/places/places.dart';
import 'package:sabbar/sabbar.dart';

Future<List<Suggestions>> fetchSuggestions(
    String input, String sessionToken) async {
  final queryParameters = {
    'input': input,
    'components': 'country:ae',
    'key': 'GOOGLE_MAP_KEY',
    'sessiontoken': sessionToken
  };
  var response = await restService.get('/maps/api/place/autocomplete/json',
      parameters: queryParameters);

  if (response.error == ScreenError.noError && response.response != null) {
    if (response.response['status'] == 'OK') {
      return response.response['predictions']
          .map<Suggestions>((p) => Suggestions(p['place_id'], p['description'],
              p['structured_formatting']['main_text']))
          .toList();
    }
    if (response.response['status'] == 'ZERO_RESULTS') {
      return [];
    }
    throw Exception(response.response['error_message']);
  } else {
    throw Exception('Failed to fetch suggestion');
  }
}
