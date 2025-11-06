import 'package:dartz/dartz.dart';
import 'package:wanderly/core/data/models/country_model.dart';
import 'package:wanderly/core/domain/entities/country.dart';
import 'package:wanderly/core/domain/repositories/favorite_repository.dart';
import 'package:wanderly/core/error/failures.dart';
import 'package:wanderly/objectbox.g.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final Box<CountryModel> box;

  FavoriteRepositoryImpl({required this.box});

  @override
  Future<Either<Failure, List<Country>>> getFavoriteCountries() async {
    try {
      final models = box.getAll();
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(CacheFailure('Failed to read favorites: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavoriteCountry(Country country) async {
    final q = box.query(CountryModel_.code.equals(country.code)).build();
    try {
      final existing = q.findFirst();
      if (existing != null) {
        box.remove(existing.id);
      } else {
        final model = CountryModel.fromEntity(country);
        box.put(model);
      }

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to toggle favorite: $e'));
    } finally {
      q.close();
    }
  }

}