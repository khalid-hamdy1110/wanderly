import 'package:dartz/dartz.dart';
import 'package:wanderly/core/domain/entities/country.dart';
import 'package:wanderly/core/error/failures.dart';
import 'package:wanderly/features/02_explore/domain/entities/country_image.dart';
import 'package:wanderly/features/02_explore/domain/repositories/country_images_repository.dart';

class GetCountryImages {
  
  final CountryImagesRepository repository;

  GetCountryImages(this.repository);

  Future<Either<Failure, List<CountryImage>>> call(Country country) {
    return repository.getCountryImages(country);
  }
}