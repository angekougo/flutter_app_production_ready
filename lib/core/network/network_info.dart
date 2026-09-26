import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstraction de l'état réseau, injectée dans les Repositories pour choisir
/// entre TMDB et le cache Isar (et facilement mockée dans les tests).
abstract interface class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onStatusChange;
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl(this._connectivity);

  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async =>
      _hasNetwork(await _connectivity.checkConnectivity());

  @override
  Stream<bool> get onStatusChange =>
      _connectivity.onConnectivityChanged.map(_hasNetwork).distinct();

  /// Une interface active ne garantit pas l'accès à Internet : les
  /// Repositories retombent aussi sur le cache en cas de [NetworkException].
  static bool _hasNetwork(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);
}
