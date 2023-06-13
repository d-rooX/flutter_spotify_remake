part of 'api_bloc.dart';

abstract class ApiState extends Equatable {
  const ApiState();

  List<Object?> get props => [];
}

class ApiNotLoadedState extends ApiState {}

class ApiLoadingState extends ApiState {}

class ApiLoadedState extends ApiState {
  final SpotifyApi api;

  List<Object?> get props => [api];

  const ApiLoadedState({required this.api});
}
