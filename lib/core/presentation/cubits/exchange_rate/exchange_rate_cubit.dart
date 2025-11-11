import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanderly/core/domain/usecases/get_exchange_rate.dart';
import 'package:wanderly/core/presentation/cubits/exchange_rate/exchange_rate_state.dart';

class ExchangeRateCubit extends Cubit<ExchangeRateState> {
  final GetExchangeRate getExchangeRate;

  ExchangeRateCubit({required this.getExchangeRate})
    : super(ExchangeRateInitial());

  Future<void> fetchExchangeRate() async {
    emit(ExchangeRateLoading());

    final result = await getExchangeRate();

    result.fold(
      (failure) => emit(ExchangeRateError(failure.message)),
      (rates) => emit(ExchangeRateLoaded(rates)),
    );
  }
}
