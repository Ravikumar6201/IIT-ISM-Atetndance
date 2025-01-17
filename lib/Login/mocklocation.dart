import 'package:flutter/services.dart';

class LocationService {
  static const MethodChannel _channel = MethodChannel('com.jis.ism');

  static Future<bool> isMockLocation() async {
    final bool isMock = await _channel.invokeMethod('isMockLocation');
    return isMock;
  }
}
