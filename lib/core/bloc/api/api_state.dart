part of 'api_bloc.dart';

class ApiState extends Equatable {
  final SpotifyApi? api;

  const ApiState({this.api});

  List<Object?> get props => [api];
}
