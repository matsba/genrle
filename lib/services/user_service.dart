import 'dart:math';
import 'package:genrle/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  register() async {
    var _prefs = await SharedPreferences.getInstance();
    _prefs.setString("username", createTempUser());
  }

  String createTempUser() {
    return "User#${Random().nextInt(5)}";
  }

  Future<User> get() async {
    var _prefs = await SharedPreferences.getInstance();
    var username = _prefs.getString("username");
    int? points = _prefs.getInt("points");

    if (username == null || username.isEmpty) {
      register();
      username = _prefs.getString("username");
    }

    if (points == null) {
      _prefs.setInt("points", 0);
    }

    return User(username!, points ?? 0);
  }

  Future<void> incrementPointsBy(int points) async {
    var _prefs = await SharedPreferences.getInstance();
    User user = await get();
    _prefs.setInt("points", user.points + points);
  }
}
