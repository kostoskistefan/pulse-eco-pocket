import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkConnectionListener {
  static final ValueNotifier<bool> isConnectedNotifier = ValueNotifier<bool>(false);
  static StreamSubscription<List<ConnectivityResult>>? _subscription;

  static void initialize() async {
    isConnectedNotifier.value = await (Connectivity().checkConnectivity()) != ConnectivityResult.none;
    _subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      isConnectedNotifier.value = (result.contains(ConnectivityResult.none) == false);
    });
  }

  static void dispose() {
    _subscription?.cancel();
  }
}
