import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

enum NetworkStatus {online,offline}

class NetworkService{
  StreamController<NetworkStatus> controller = StreamController();

  NetworkService(){
    Connectivity().onConnectivityChanged.listen((event) {
      if (event.isNotEmpty) {
        final ConnectivityResult result = event.first;
        controller.add(_networkStatus(result));
      } else {
        controller.add(NetworkStatus.offline);
      }
    });
  }

  NetworkStatus _networkStatus(ConnectivityResult result) {
    return (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi)
        ? NetworkStatus.online
        : NetworkStatus.offline;
  }
}