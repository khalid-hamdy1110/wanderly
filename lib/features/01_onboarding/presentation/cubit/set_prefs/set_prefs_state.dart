import 'package:equatable/equatable.dart';
import 'package:wanderly/core/domain/entities/currency.dart';

sealed class SetPrefsState extends Equatable {
  const SetPrefsState();

  @override
  List<Object?> get props => [];
}

class SetPrefsInitial extends SetPrefsState {}

class SetPrefsLoading extends SetPrefsState {}

class SetPrefsSuccess extends SetPrefsState {
  final List<Currency>? currencies;

  const SetPrefsSuccess({this.currencies});

  @override
  List<Object?> get props => [currencies ?? []];
}

class SetPrefsError extends SetPrefsState {
  final String message;

  const SetPrefsError(this.message);

  @override
  List<Object?> get props => [message];
}