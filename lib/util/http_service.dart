import 'dart:convert';
import 'package:genrle/util/environment.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpService {
  final Uri _baseUrl = Environment().config.fullUri;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<Map<String, String>?> _setHeaders() async {
    var storage = await _prefs;
    var userId = storage.getString("userId");
    var headers = {"Content-Type": "application/json"};

    if (userId == null) {
      print("Setting headers... " + headers.toString());

      return headers;
    } else {
      headers["userid"] = userId;
      print("Setting headers... " + headers.toString());

      return headers;
    }
  }

  bool isSuccess(statusCode) => [200, 201, 204].contains(statusCode);
  Uri requestUrl(String path) => _baseUrl.replace(path: _baseUrl.path + path);

  ///[path] needs to start with "/"
  ///
  ///Throws exception if response status is not successful or not found
  Future<Map<String, dynamic>?> getRequest(String path) async {
    Response res = await get(requestUrl(path), headers: await _setHeaders());

    if (isSuccess(res.statusCode)) {
      Map<String, dynamic> map = jsonDecode(res.body);
      return map;
    } else if (res.statusCode == 404) {
      return null;
    } else {
      final errorMessage =
          "Status code: ${res.statusCode} - ${res.reasonPhrase}";
      throw errorMessage;
    }
  }

  Future<Map<String, dynamic>?> postRequest(String path, Object? body) async {
    late Response res;
    if (body != null) {
      res = await post(requestUrl(path),
          body: jsonEncode(body), headers: await _setHeaders());
    } else {
      res = await post(requestUrl(path), headers: await _setHeaders());
    }

    if (isSuccess(res.statusCode)) {
      Map<String, dynamic> map = jsonDecode(res.body);
      return map;
    } else if (res.statusCode == 404) {
      return null;
    } else {
      final errorMessage =
          "Status code: ${res.statusCode} - ${res.reasonPhrase}";
      throw errorMessage;
    }
  }

  Future<Map<String, dynamic>?> putRequest(String path, Object? body) async {
    Response res = await put(requestUrl(path),
        body: jsonEncode(body), headers: await _setHeaders());

    if (isSuccess(res.statusCode)) {
      if (res.body.isNotEmpty) {
        Map<String, dynamic> map = jsonDecode(res.body);
        return map;
      } else {
        return null;
      }
    } else if (res.statusCode == 404) {
      return null;
    } else {
      final errorMessage =
          "Status code: ${res.statusCode} - ${res.reasonPhrase}";
      throw errorMessage;
    }
  }
}
