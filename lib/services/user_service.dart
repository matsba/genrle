import 'package:genrle/models/user.dart';
import 'package:genrle/util/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<User> _register(HttpService http) async {
    final storage = await _prefs;
    await storage.clear();
    var response = await http.postRequest("/user/register", null);

    if (response == null) {
      throw "Registartion failed!";
    }

    var user = User.fromJson(response);

    storage.setString("userId", user.id);
    return user;
  }

  Future<User> get(HttpService http) async {
    var response = await http.getRequest("/user");

    if (response == null) {
      User registeredUser = await _register(http);
      return registeredUser;
    } else {
      return User.fromJson(response);
    }
  }

  Future<void> incrementPoints(HttpService http) async {
    await http.putRequest("/user/update/score", {"points": "3"});
  }
}
