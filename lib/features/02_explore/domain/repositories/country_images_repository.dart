import 'package:dartz/dartz.dart';
import 'package:wanderly/core/domain/entities/country.dart';
import 'package:wanderly/core/error/failures.dart';
import 'package:wanderly/features/02_explore/domain/entities/country_image.dart';

abstract interface class CountryImagesRepository {
  Future<Either<Failure, List<CountryImage>>> getCountryImages(Country country);
}