import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanderly/core/domain/entities/country.dart';
import 'package:wanderly/features/02_explore/domain/entities/country_image.dart';
import 'package:wanderly/features/02_explore/domain/usecases/get_country_images.dart';
import 'package:wanderly/features/02_explore/presentation/cubit/destination_details/destination_details_state.dart';

class ImagesCubit extends Cubit<DestinationDetailsState<List<CountryImage>>> {

  final GetCountryImages _getCountryImages;

  ImagesCubit(this._getCountryImages) : super(DestinationDetailsInitial());

  Future<void> loadCountryImages(Country country) async {
    emit(DestinationDetailsLoading());

    final result = await _getCountryImages(country);
    
    result.fold(
      (failure) => emit(DestinationDetailsError(failure.message)),
      (countryImages) => emit(DestinationDetailsLoaded(countryImages)),
    );
  }
}