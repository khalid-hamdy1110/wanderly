import 'package:equatable/equatable.dart';

sealed class DestinationDetailsState<T> extends Equatable {
  const DestinationDetailsState();

  @override
  List<Object?> get props => [];
}

class DestinationDetailsInitial<T> extends DestinationDetailsState<T> {}

class DestinationDetailsLoading<T> extends DestinationDetailsState<T> {}

class DestinationDetailsLoaded<T> extends DestinationDetailsState<T> {
  final T countryDetails;

  const DestinationDetailsLoaded(this.countryDetails);

  @override
  List<Object?> get props => [countryDetails];
}

class DestinationDetailsError<T> extends DestinationDetailsState<T> {
  final String message;

  const DestinationDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}