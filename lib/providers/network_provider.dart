import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class NetworkProvider extends ChangeNotifier {
  bool _noInternet = false;
  bool get noInternet => _noInternet;

  NetworkProvider() {
    checkConnectivity();

    Connectivity().onConnectivityChanged.listen((result) async {
      await checkConnectivity(); // Recheck with real internet test
      notifyListeners();

    });
  }

  Future<void> checkConnectivity() async {

    final connectivityResult = await Connectivity().checkConnectivity();



    bool hasInternet = await _hasInternetAccess();

    _noInternet = !hasInternet;
    notifyListeners();

  }

  Future<bool> _hasInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (e) {

      return false;
    }
  }
}