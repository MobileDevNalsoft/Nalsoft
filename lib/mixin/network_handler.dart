import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:meals_management/views/custom_widgets/custom_snackbar.dart';

mixin ConnectivityMixin<T extends StatefulWidget> on State<T> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late bool _isConnected;

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
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void showConnectivitySnackBar(BuildContext context) {
    CustomSnackBar.showSnackBar(context, _isConnected ? 'Connected to the Internet' : 'No Internet Connection', _isConnected ? Colors.green : Colors.red);

  }
}
