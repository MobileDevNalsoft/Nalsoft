import 'dart:async';
 
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
 
mixin ConnectivityMixin<T extends StatefulWidget> on State<T>{
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late bool _isConnected;
  final StreamController<bool> _connectivityController =
  StreamController<bool>.broadcast();

  Stream<bool> get connectivityStream => _connectivityController.stream;
 
  @override
  void initState() {
    super.initState();
    _isConnected = true; // Assume connected initially
    _initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectivity);
  }
 
  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectivity(result);
    } catch (e) {
      // Handle exceptions, if any
      print('Error initializing connectivity: $e');
    }
  }
 
  void _updateConnectivity(ConnectivityResult result) {
    setState(() {
      _isConnected = (result != ConnectivityResult.none);
      _connectivityController.add(_isConnected);
    });
  }
 
  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
 
  bool isConnected() {
    return _isConnected;
  }
}