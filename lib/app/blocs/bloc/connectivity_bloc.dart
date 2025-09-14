import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  ConnectivityBloc() : super(const ConnectivityState()) {
    on<ConnectivityInit>(_onConnectivityInit);
    on<ConnectivityChanged>(_onConnectivityChanged);

    add(ConnectivityInit());
  }

  final _connectivity = Connectivity();

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  Future<void> _onConnectivityInit(
    ConnectivityInit event,
    Emitter<ConnectivityState> emit,
  ) async {
    try {
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
        connectivityResult,
      ) {
        add(ConnectivityChanged(results: connectivityResult));
      });
    } catch (e) {
      emit(state.copyWith(status: ConnectivityStatus.unknown));
    }
  }

  Future<void> _onConnectivityChanged(
    ConnectivityChanged event,
    Emitter<ConnectivityState> emit,
  ) async {
    final connectivityResult = event.results;

    // Handle no connection
    if (connectivityResult.contains(ConnectivityResult.none)) {
      emit(state.copyWith(status: ConnectivityStatus.none));
    }

    // Handle internet connection
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet) ||
        connectivityResult.contains(ConnectivityResult.vpn)) {
      emit(state.copyWith(status: ConnectivityStatus.connected));
    }

    // Handle unknown connection
    if (connectivityResult.contains(ConnectivityResult.bluetooth) ||
        connectivityResult.contains(ConnectivityResult.other)) {
      emit(state.copyWith(status: ConnectivityStatus.unknown));
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
