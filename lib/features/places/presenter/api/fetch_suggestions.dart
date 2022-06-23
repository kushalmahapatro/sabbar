import 'package:sabbar/features/places/places.dart';
import 'package:sabbar/sabbar.dart';

Future<List<Suggestions>> fetchSuggestions(
    String input, String sessionToken) async {
  final queryParameters = {
    'input': input,
    'components': 'country:ae',
    'key': 'AIzaSyBtL1g5Hql-UGO3g5n-iuM7RAJaizNDWPE',
    'sessiontoken': sessionToken
  };
  var response = await HttpClient()
      .getUrl(Uri.https('maps.googleapis.com',
          '/maps/api/place/autocomplete/json', queryParameters))
      .then((req) => req.close())
      .then((res) => res.transform(utf8.decoder).join())
      .then((str) => json.decode(str));

  if (response != null) {
    if (response['status'] == 'OK') {
      return response['predictions']
          .map<Suggestions>((p) => Suggestions(p['place_id'], p['description'],
              p['structured_formatting']['main_text']))
          .toList();
    }
    if (response['status'] == 'ZERO_RESULTS') {
      return [];
    }
    throw Exception(response['error_message']);
  } else {
    throw Exception('Failed to fetch suggestion');
  }
}