import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/widget/error/offline_error_widget.dart';

class OfflineHandler extends StatefulWidget {
  final Widget child;

  const OfflineHandler({super.key, required this.child});

  @override
  State<OfflineHandler> createState() => _OfflineHandlerState();
}

class _OfflineHandlerState extends State<OfflineHandler> {
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      setState(() {
        _isOffline = results.contains(ConnectivityResult.none);
      });
    });
  }

  Future<void> _checkConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    setState(() {
      _isOffline = results.contains(ConnectivityResult.none);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isOffline) {
      return OfflineWidget(
        retry: _checkConnectivity, // When retry button pressed
      );
    }
    return widget.child; // Show actual screen
  }
}
