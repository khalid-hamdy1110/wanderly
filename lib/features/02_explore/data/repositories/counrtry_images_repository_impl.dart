import 'package:dartz/dartz.dart';
import 'package:wanderly/core/domain/entities/country.dart';
import 'package:wanderly/core/error/failures.dart';
import 'package:wanderly/features/02_explore/data/datasources/country_images_remote_data_source.dart';
import 'package:wanderly/features/02_explore/domain/entities/country_image.dart';
import 'package:wanderly/features/02_explore/domain/repositories/country_images_repository.dart';

class CountryImagesRepositoryImpl implements CountryImagesRepository{
  final CountryImagesRemoteDataSource countryImagesRemoteDataSource;

  CountryImagesRepositoryImpl({required this.countryImagesRemoteDataSource});

  @override
  Future<Either<Failure, List<CountryImage>>> getCountryImages(Country country) async {
    try {
      final countryImages = await countryImagesRemoteDataSource.getCountryImages(country.name);
      if (countryImages.isEmpty) {
        return Left(ServerFailure('No images found for country: ${country.name}'));
      }
      return Right(countryImages);
    } on Failure catch(failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch country details: ${e.toString()}'));
    }
  }
}