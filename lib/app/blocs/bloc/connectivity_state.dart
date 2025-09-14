part of 'connectivity_bloc.dart';

enum ConnectivityStatus { unknown, none, connected }

extension ConnectivityStatusX on ConnectivityStatus {
  bool get isUnknown => this == ConnectivityStatus.unknown;
  bool get isNone => this == ConnectivityStatus.none;
  bool get isConnected => this == ConnectivityStatus.connected;
}

class ConnectivityState extends Equatable {
  const ConnectivityState({this.status = ConnectivityStatus.none});

  final ConnectivityStatus status;

  ConnectivityState copyWith({ConnectivityStatus? status}) {
    return ConnectivityState(status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}
