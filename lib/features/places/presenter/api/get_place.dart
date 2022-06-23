import 'package:sabbar/sabbar.dart';

Future<List<String>> getPlace(
    String lat, String long, String sessionToken) async {
  final queryParameters = {
    'latlng': '$lat,$long',
    'sensor': 'true',
    'key': 'AIzaSyBtL1g5Hql-UGO3g5n-iuM7RAJaizNDWPE',
    'sessiontoken': sessionToken
  };
  var response = await HttpClient()
      .getUrl(Uri.https(
          'maps.googleapis.com', '/maps/api/geocode/json', queryParameters))
      .then((req) => req.close())
      .then((res) => res.transform(utf8.decoder).join())
      .then((str) => json.decode(str));

  if (response != null) {
    if (response['status'] == 'OK') {
      List<String> address = [];
      for (var element in ((response['results'] as List)
          .first['address_components'] as List)) {
        address.add(element['long_name']);
      }
      return address;
    }
    if (response['status'] == 'ZERO_RESULTS') {
      return [];
    }
    throw Exception(response['error_message']);
  } else {
    throw Exception('Failed to fetch suggestion');
  }
}
