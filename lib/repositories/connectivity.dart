import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final connectivityController =
    ChangeNotifierProvider<ConnectivityChangeNotifier>(
        (ref) => ConnectivityChangeNotifier()..initialLoad());

class ConnectivityChangeNotifier extends ChangeNotifier {
  ConnectivityChangeNotifier() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      resultHandler(result);
    });
  }
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  String _pageText =
      'Currently connected to no network. Please connect to a wifi network!';
  bool _connectivitiyStatus = true;

  ConnectivityResult get connectivity => _connectivityResult;
  String get pageText => _pageText;
  bool get connectivityStatus => _connectivitiyStatus;

  void resultHandler(ConnectivityResult result) {
    _connectivityResult = result;
    if (result == ConnectivityResult.none) {
      _pageText =
          'Currently connected to no network. Please connect to a wifi network!';
      _connectivitiyStatus = false;
    } else if (result == ConnectivityResult.mobile) {
      _pageText =
          'Currently connected to a celluar network. Please connect to a wifi network!';
      _connectivitiyStatus = true;
    } else if (result == ConnectivityResult.wifi) {
      _connectivitiyStatus = true;
      _pageText = 'Connected to a wifi network!';
    }
    notifyListeners();
  }

  void initialLoad() async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    resultHandler(connectivityResult);
  }
}
