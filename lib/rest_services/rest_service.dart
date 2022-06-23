import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sabbar/sabbar.dart';
import 'package:sabbar/rest_services/app_exceptions.dart';

enum ScreenError { noError, internet, unknown }

class RestService {
  Future<bool> _checkConnectivity() async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();

    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }

  Future<RestServiceResponse> get(String url,
      {Map<String, dynamic>? headers,
      Map<String, String>? parameters,
      String mockJsonName = ''}) async {
    dynamic responseJson;
    ScreenError error = ScreenError.noError;
    if (mockJsonName.isNotEmpty) {
      responseJson = jsonDecode(await rootBundle.loadString(
        'assets/mock_response/$mockJsonName',
      ));
    } else {
      if (await _checkConnectivity()) {
        try {
          HttpClient httpClient = HttpClient();

          var request = await httpClient
              .getUrl(Uri.https('maps.googleapis.com', url, parameters));

          headers?.forEach((key, value) {
            request.headers.add(key, value);
          });
          // request.add(utf8.encode(bodyString));
          var response = await request.close();
          httpClient.close();

          responseJson =
              await _returnResponse(response, url, headers: request.headers);
        } on SocketException {
          socketConnectionError();
          error = ScreenError.internet;
        } on Exception catch (e) {
          error = ScreenError.unknown;

          debugPrint(e.toString());
        }
      } else {
        debugPrint('No internet connection for :$url');
        error = ScreenError.internet;
      }
    }

    return RestServiceResponse(responseJson, error: error);
  }

  Future<String> imageDownload(String url, String downloadPath,
      Function(int, int) fileDownloadUpdate) async {
    await Dio().download(url, downloadPath,
        onReceiveProgress: (int count, int total) {
      fileDownloadUpdate(count, total);
    });
    return downloadPath;
  }

  Future<RestServiceResponse> post(
    String url,
    dynamic body, {
    Map<String, dynamic>? headers,
    String mockJsonName = '',
  }) async {
    dynamic responseJson;
    Map<String, List<String>> responseHeader = const <String, List<String>>{};
    ScreenError error = ScreenError.noError;
    if (mockJsonName.isNotEmpty) {
      responseJson = jsonDecode(await rootBundle.loadString(
        'assets/mock_response/$mockJsonName',
      ));
    } else {
      if (await _checkConnectivity()) {
        try {
          HttpClient httpClient = HttpClient();

          var request =
              await httpClient.postUrl(Uri.https('maps.googleapis.com', url));

          headers?.forEach((key, value) {
            request.headers.add(key, value);
          });
          request.add(utf8.encode(jsonEncode(body)));
          var response = await request.close();
          httpClient.close();

          responseJson =
              await _returnResponse(response, url, headers: request.headers);

          // final Response<dynamic> response = await dioClient.postUri<dynamic>(
          //     Uri.parse(url),
          //     data: body,
          //     options: requestOptions);
          // responseHeader = response.headers.map;
          // responseJson = _returnResponse(response, url,
          //     body: body,
          //     headers: await DioInstance().getGlobalHeaders(headers));
        } on SocketException {
          socketConnectionError();
          error = ScreenError.internet;
        } on Exception catch (e) {
          error = ScreenError.unknown;

          debugPrint(e.toString());
        }
      } else {
        debugPrint('No internet connection for :$url');
        error = ScreenError.internet;
      }
    }

    return RestServiceResponse(responseJson,
        error: error, headers: responseHeader);
  }

  Future<RestServiceResponse> put(
    String url,
    dynamic body, {
    Map<String, dynamic>? headers,
    String mockJsonName = '',
  }) async {
    dynamic responseJson;
    ScreenError error = ScreenError.noError;
    if (mockJsonName.isNotEmpty) {
      responseJson = jsonDecode(await rootBundle.loadString(
        'assets/mock_response/$mockJsonName',
      ));
    } else {
      if (await _checkConnectivity()) {
        try {
          HttpClient httpClient = HttpClient();

          var request =
              await httpClient.putUrl(Uri.https('maps.googleapis.com', url));

          headers?.forEach((key, value) {
            request.headers.add(key, value);
          });
          request.add(utf8.encode(jsonEncode(body)));
          var response = await request.close();
          httpClient.close();

          responseJson =
              await _returnResponse(response, url, headers: request.headers);
          // final Dio dioClient = await getDio(headers);
          // final Response<dynamic> response =
          //     await dioClient.putUri<dynamic>(Uri.parse(url), data: body);
          // responseJson = _returnResponse(response, url,
          //     body: body,
          //     headers: await DioInstance().getGlobalHeaders(headers));
        } on SocketException {
          socketConnectionError();
          error = ScreenError.internet;
        } on Exception catch (e) {
          error = ScreenError.unknown;

          debugPrint(
            e.toString(),
          );
        }
      } else {
        debugPrint('No internet connection for :$url');
        error = ScreenError.internet;
      }
    }

    return RestServiceResponse(responseJson, error: error);
  }

  Future<RestServiceResponse> delete(
    String url,
    dynamic body, {
    Map<String, dynamic>? headers,
    String mockJsonName = '',
  }) async {
    dynamic responseJson;
    ScreenError error = ScreenError.noError;
    if (mockJsonName.isNotEmpty) {
      responseJson = jsonDecode(await rootBundle.loadString(
        'assets/mock_response/$mockJsonName',
      ));
    } else {
      if (await _checkConnectivity()) {
        try {
          HttpClient httpClient = HttpClient();

          var request =
              await httpClient.deleteUrl(Uri.https('maps.googleapis.com', url));

          headers?.forEach((key, value) {
            request.headers.add(key, value);
          });
          request.add(utf8.encode(jsonEncode(body)));
          var response = await request.close();
          httpClient.close();

          responseJson =
              await _returnResponse(response, url, headers: request.headers);
          // final Dio dioClient = await getDio(headers);
          // final Response<dynamic> response =
          //     await dioClient.deleteUri<dynamic>(Uri.parse(url), data: body);
          // responseJson = _returnResponse(response, url,
          //     headers: await DioInstance().getGlobalHeaders(headers));
        } on SocketException {
          socketConnectionError();
          error = ScreenError.internet;
        } on Exception catch (e) {
          error = ScreenError.unknown;

          debugPrint(e.toString());
        }
      } else {
        debugPrint('No internet connection for :$url');
        error = ScreenError.internet;
      }
    }

    return RestServiceResponse(responseJson, error: error);
  }

  Future<dynamic> download(
    String url,
    String savePath,
  ) async {
    dynamic responseJson;
    try {
      HttpClient httpClient = HttpClient();

      var request = await httpClient.getUrl(Uri.parse(url));

      final response = await request.close();
      response.pipe(File(savePath).openWrite());

      responseJson = await _returnResponse(response, url, isDownloadCall: true);
      // final Dio dioClient = await getDio();
      // final Response<dynamic> response =
      //     await dioClient.downloadUri(Uri.parse(url), savePath);
      // responseJson = _returnResponse(response, url, isDownloadCall: true);
    } on SocketException {
      socketConnectionError();
    } on Exception catch (e) {
      debugPrint(e.toString());
    }

    return responseJson;
  }
}

dynamic _returnResponse(
  HttpClientResponse response,
  String url, {
  dynamic body,
  HttpHeaders? headers,
  bool isDownloadCall = false,
}) async {
  var reply = await response.transform(utf8.decoder).join();

  switch (response.statusCode) {
    case 200:
      if (!isDownloadCall) {
        if (reply is Map || reply is List) {
          final dynamic responseJson = reply;

          return responseJson;
        } else {
          try {
            final dynamic responseJson = jsonDecode(reply);
            return responseJson;
          } on Exception catch (_) {
            final dynamic responseJson = reply;
            return responseJson;
          }
        }
      } else {
        return true;
      }
    case 400:
      badRequestException(reply);
      break;
    case 401:
    case 403:
      unauthorisedException(reply);
      break;
    case 500:
    default:
      fetchDataException(reply);
      break;
  }
}

void socketConnectionError() {
  throw FetchDataException('No Internet connection');
}

void badRequestException(String message) {
  throw BadRequestException(message);
}

void unauthorisedException(String message) {
  throw UnauthorisedException(message);
}

void fetchDataException(String statusCode) {
  final String error =
      'Error occured while Communication with Server with StatusCode : $statusCode';
  throw FetchDataException(
    error,
  );
}

final RestService restService = RestService();
