import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  /// Check the current connectivity status
  static Future<List<ConnectivityResult>> checkConnectivity() async {
    return await Connectivity().checkConnectivity();
  }

  /// Listen for connectivity changes
  static Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return Connectivity().onConnectivityChanged;
  }
}
