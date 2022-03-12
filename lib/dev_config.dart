import 'package:genrle/base_config.dart';

class DevConfig implements BaseConfig {
  String get apiHost => "10.0.2.2";
  int get apiPort => 3000;
  String get apiPath => "/dev";
  bool get useHttps => false;

  @override
  Uri get fullUri => Uri(
      scheme: this.useHttps ? "https" : "http",
      port: this.apiPort,
      host: this.apiHost,
      path: this.apiPath);
}
