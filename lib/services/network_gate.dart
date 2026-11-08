import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

abstract interface class NetworkGate {
  bool get current;
  Stream<bool> get changes;
}

class AlwaysOnlineGate implements NetworkGate {
  const AlwaysOnlineGate();

  @override
  bool get current => true;

  @override
  Stream<bool> get changes => const Stream.empty();
}

class ConnectivityNetworkGate implements NetworkGate {
  ConnectivityNetworkGate({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;
  bool _current = true;

  @override
  bool get current => _current;

  @override
  Stream<bool> get changes async* {
    _current = _isOnline(await _connectivity.checkConnectivity());
    yield _current;
    yield* _connectivity.onConnectivityChanged.map((results) {
      _current = _isOnline(results);
      return _current;
    });
  }

  static bool _isOnline(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }
}

class FakeNetworkGate implements NetworkGate {
  FakeNetworkGate({this.current = true, Stream<bool>? changes})
    : changes = changes ?? const Stream.empty();

  @override
  final bool current;

  @override
  final Stream<bool> changes;
}
