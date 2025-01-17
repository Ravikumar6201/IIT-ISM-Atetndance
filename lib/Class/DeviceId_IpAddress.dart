import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

Future<String> getDeviceId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print(androidInfo.device);
     SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('DeviceID', androidInfo.device);
    return androidInfo.device;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    print(iosInfo.identifierForVendor);
    return iosInfo.identifierForVendor!;
  } else {
    throw UnsupportedError('Unsupported platform');
  }
}

Future<String> getIpAddress() async {
  final response =
      await http.get(Uri.parse('https://api.ipify.org?format=json'));
  if (response.statusCode == 200) {
    print(jsonDecode(response.body)['ip']);
    return jsonDecode(response.body)['ip'];
  } else {
    throw Exception('Failed to get IP address');
  }
}

// Example usage:
void main() async {
  try {
    String deviceId = await getDeviceId();
    String ipAddress = await getIpAddress();

    print('Device ID: $deviceId');
    print('IP Address: $ipAddress');

    // Call function to store in database or perform other operations
    // storeDeviceInfo(deviceId, ipAddress);
  } catch (e) {
    print('Error: $e');
  }
}
