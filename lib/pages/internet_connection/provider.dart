import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetConnectionProvider extends ChangeNotifier {
  bool _hasInternet = false;
  bool get hasInternet => _hasInternet;

  Future<void> _initConnectionState() async {
    try {
      var status = await InternetConnectionChecker().hasConnection;
      if (status) {
        _hasInternet = true;
        notifyListeners();
      } else {
        _hasInternet = false;
        notifyListeners();
      }
    } on PlatformException catch (e) {
      debugPrint('PlatformException $e');
    }
  }

  Future<bool> _updateConnectionStatus() async{
    late bool isConnected;
    try{
      final List<InternetAddress> result = await InternetAddress.lookup('google.com');
      if(result.isNotEmpty && result.first.rawAddress.isNotEmpty){
        isConnected = true;
      }
    }on SocketException catch (_){
      isConnected = false;
    }
    return isConnected;
  }

  listenTheStatus() async {
    await _initConnectionState();
    InternetConnectionChecker()
        .onStatusChange
        .listen((InternetConnectionStatus event) async {
      if (event == InternetConnectionStatus.connected) {
        await _updateConnectionStatus().then((bool isConnected){
          _hasInternet = isConnected;
          notifyListeners();
        });
      } else {
        _hasInternet = false;
        notifyListeners();
      }
    });
    debugPrint('*** Internet: $_hasInternet ***');
  }
}
