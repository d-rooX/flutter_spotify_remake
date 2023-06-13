part of 'api_bloc.dart';

abstract class ApiEvent extends Equatable {
  const ApiEvent();

  List<Object?> get props => [];
}

class ApiInitEvent extends ApiEvent {
  final BuildContext context;

  get props => [context];

  const ApiInitEvent({required this.context});
}
