import 'package:equatable/equatable.dart';

class CountryImage extends Equatable {
  final String imageUrl;

  const CountryImage({
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
    imageUrl,
  ];
}