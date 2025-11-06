import 'package:wanderly/features/02_explore/domain/entities/country_image.dart';

class CountryImageModel extends CountryImage {
  const CountryImageModel({required super.imageUrl});

  factory CountryImageModel.fromJson(Map<String, dynamic> json) {
    return CountryImageModel(imageUrl: json['urls']['regular']);
  }

  Map<String, dynamic> toJson() {
    return {
      'results': [
        {
          'urls': {'regular': imageUrl},
        },
      ],
    };
  }
}
