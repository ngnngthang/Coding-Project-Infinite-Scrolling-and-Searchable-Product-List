part of 'connectivity_bloc.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();
  @override
  List<Object> get props => [];
}

class ConnectivityInit extends ConnectivityEvent {
  @override
  List<Object> get props => [];
}

class ConnectivityChanged extends ConnectivityEvent {
  const ConnectivityChanged({required this.results});
  final List<ConnectivityResult> results;
  @override
  List<Object> get props => [results];
}
