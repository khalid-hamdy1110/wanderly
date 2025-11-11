import 'package:amicons/amicons.dart';
import 'package:flutter/material.dart';
import 'package:wanderly/core/ui/custom_text.dart';
import 'package:wanderly/core/ui/custom_weather_icon.dart';
import 'package:wanderly/core/utilities/useful_functions.dart';
import 'package:wanderly/features/02_explore/domain/entities/country_weather.dart';
import 'package:wanderly/features/02_explore/presentation/cubit/destination_details/destination_details_state.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key, required this.state});

  final DestinationDetailsState<CountryWeather> state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(43, 127, 255, 1),
            Color.fromRGBO(0, 184, 219, 1),
          ],
          stops: [0, 1],
        ),
      ),
      child: switch (state) {
        DestinationDetailsInitial<CountryWeather>() => const Center(
          child: Text(
            'Loading weather data!',
            style: TextStyle(color: Colors.white),
          ),
        ),
        DestinationDetailsLoading() => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        DestinationDetailsLoaded<CountryWeather>(
          countryDetails: final weather,
        ) =>
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                'Current Weather, ${weather.weatherDescription}',
                fontSize: 14,
                color: Colors.white,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        '${temperatureKToC(weather.temperature)}°C',
                        fontSize: 48,
                        color: Colors.white,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Amicons.remix_drop,
                            color: Colors.white,
                            size: 16,
                          ),
                          CustomText(
                            ' ${weather.humidity}%',
                            fontSize: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Amicons.remix_windy,
                            color: Colors.white,
                            size: 16,
                          ),
                          CustomText(
                            ' ${weather.windSpeed} km/h',
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const CustomWeatherIcon(),
                ],
              ),
            ],
          ),
        DestinationDetailsError(message: final message) => Center(
          child: Text(message, style: const TextStyle(color: Colors.white)),
        ),
      },
    );
  }
}
