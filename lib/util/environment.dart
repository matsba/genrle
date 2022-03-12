// ignore_for_file: constant_identifier_names

import 'package:genrle/base_config.dart';
import 'package:genrle/dev_config.dart';

//See https://stacksecrets.com/flutter/environment-configuration-in-flutter-app
class Environment {
  factory Environment() {
    //Since the Environment class has a singleton implementation,
    //this ensures that the environment configuration doesn’t change
    //through out the application lifecycle.
    return _singleton;
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  static const String DEV = 'DEV';
  static const String STAGING = 'STAGING';
  static const String PROD = 'PROD';

  late BaseConfig config;

  initConfig(String environment) {
    config = _getConfig(environment);
  }

  BaseConfig _getConfig(String environment) {
    switch (environment) {
      case Environment.PROD:
      //return ProdConfig();
      case Environment.STAGING:
      //return StagingConfig();
      default:
        return DevConfig();
    }
  }
}
