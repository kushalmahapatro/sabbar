import 'package:sabbar/sabbar.dart';

class DioInstance {
  factory DioInstance() {
    return _instance;
  }

  DioInstance._internal();

  DioInstance.resetinternal() {
    _instance = DioInstance._internal();
  }

  static DioInstance _instance = DioInstance._internal();

  Dio dio = Dio();

  Future<Dio> getDioInstance([Map<String, dynamic>? headers]) async {
    dio.options = BaseOptions(
        baseUrl: "https://maps.googleapis.com",
        headers: await getGlobalHeaders(headers),
        connectTimeout: 30000);
    return dio;
  }

  Future<Map<String, dynamic>> getGlobalHeaders(
      Map<String, dynamic>? headers) async {
    final Map<String, dynamic> globalHeaders = <String, dynamic>{};
    globalHeaders['Content-Type'] = 'application/json';

    if (headers != null && headers.isNotEmpty) {
      headers.forEach((String key, dynamic value) {
        globalHeaders[key] = value;
      });
    }

    return globalHeaders;
  }
}
