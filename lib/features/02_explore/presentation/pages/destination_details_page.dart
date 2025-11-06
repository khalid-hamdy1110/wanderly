import 'package:amicons/amicons.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanderly/core/domain/entities/country.dart';
import 'package:wanderly/core/ui/custom_text.dart';
import 'package:wanderly/core/utilities/useful_functions.dart';
import 'package:wanderly/features/02_explore/domain/entities/country_image.dart';
import 'package:wanderly/features/02_explore/domain/entities/country_weather.dart';
import 'package:wanderly/features/02_explore/domain/extensions/country_extension.dart';
import 'package:wanderly/features/02_explore/presentation/cubit/destination_details/destination_details_state.dart';
import 'package:wanderly/features/02_explore/presentation/cubit/destination_details/images_cubit.dart';
import 'package:wanderly/features/02_explore/presentation/cubit/destination_details/weather_cubit.dart';
import 'package:wanderly/features/02_explore/presentation/widgets/destination_card.dart';
import 'package:wanderly/features/02_explore/presentation/widgets/detailInfo.dart';
import 'package:wanderly/injection/injection.dart';

@RoutePage()
class DestinationDetailsPage extends StatefulWidget {
  const DestinationDetailsPage({
    super.key,
    required this.country,
    required this.isFavorite,
    required this.onFavorite,
  });

  final Country country;
  final bool isFavorite;
  final VoidCallback onFavorite;

  @override
  State<DestinationDetailsPage> createState() => _DestinationDetailsPageState();
}

class _DestinationDetailsPageState extends State<DestinationDetailsPage> {
  late bool isCurFavorite;
  final carouselController = CarouselController();

  @override
  void initState() {
    isCurFavorite = widget.isFavorite;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              di.get<WeatherCubit>()..loadCountryWeather(widget.country),
        ),
        BlocProvider(
          create: (_) =>
              di.get<ImagesCubit>()..loadCountryImages(widget.country),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: _backButtonBuilder(context),
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                spreadRadius: -5,
                blurRadius: 25,
                offset: Offset(0, -10),
              ),
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                spreadRadius: -6,
                blurRadius: 10,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: InkWell(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFFF385C),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Center(
                child: CustomText(
                  'Plan Your Trip',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        body:
            BlocBuilder<
              ImagesCubit,
              DestinationDetailsState<List<CountryImage>>
            >(
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _backgroundImageBuilder(state),
                      Transform.translate(
                        offset: const Offset(0, -60),
                        child: Column(
                          children: [
                            _firstCardDetailsBuilder(),
                            const SizedBox(height: 24),

                            BlocBuilder<
                              WeatherCubit,
                              DestinationDetailsState<CountryWeather>
                            >(
                              builder: (context, state) {
                                return _buildWeatherCard(state);
                              },
                            ),
                            const SizedBox(height: 24),
                            _buildAboutCard(),
                            const SizedBox(height: 24),
                            _essentialInformationCard(),
                            const SizedBox(height: 24),
                            _photoGalleryBuilder(state),
                            const SizedBox(height: 65),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      ),
    );
  }

  Column _photoGalleryBuilder(
    DestinationDetailsState<List<CountryImage>> state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const CustomText(
          'Photo Gallery',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        switch (state) {
          DestinationDetailsInitial<List<CountryImage>>() => const Center(
            child: Text('Loading data!'),
          ),
          DestinationDetailsLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          DestinationDetailsLoaded<List<CountryImage>>(
            countryDetails: final images,
          ) =>
            AspectRatio(
              aspectRatio: 16 / 9,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final ratio = MediaQuery.of(context).devicePixelRatio;
                  final width = (constraints.maxWidth * ratio * 0.8).round();
                  final height = (constraints.maxHeight * ratio * 0.8).round();
                  return CarouselView.weighted(
                    itemSnapping: true,
                    controller: carouselController,
                    flexWeights: const [1, 7, 1],
                    children: List.generate(
                      images.length,
                      (index) => CachedNetworkImage(
                        imageUrl: images[index].imageUrl,
                        fit: BoxFit.cover,
                        memCacheWidth: width,
                        memCacheHeight: height,
                      ),
                    ),
                  );
                },
              ),
            ),
          DestinationDetailsError() => const Center(
            child: Text('Error loading images'),
          ),
        },
      ],
    );
  }

  DestinationCard _essentialInformationCard() {
    return DestinationCard(
      bgColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            'Essential Information',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 16),
          DetailInfo(
            icon: Amicons.remix_currency,
            title: 'Currency',
            info: widget.country.currencies.join(', '),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          DetailInfo(
            icon: Amicons.remix_global,
            title: 'Languages',
            info: widget.country.languages.join(', '),
          ),
        ],
      ),
    );
  }

  DestinationCard _buildAboutCard() {
    return DestinationCard(
      bgColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText('About', fontSize: 20, fontWeight: FontWeight.bold),
          const SizedBox(height: 12),
          CustomText(
            widget.country.briefInfo,
            fontSize: 16,
            color: const Color(0xFF717171),
          ),
        ],
      ),
    );
  }

  Container _buildWeatherCard(DestinationDetailsState<CountryWeather> state) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
              CustomText(
                '${temperatureKToC(weather.temperature)}°C',
                fontSize: 48,
                color: Colors.white,
              ),
              Row(
                children: [
                  const Icon(Amicons.remix_drop, color: Colors.white, size: 16),
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
        DestinationDetailsError(message: final message) => Center(
          child: Text(message, style: const TextStyle(color: Colors.white)),
        ),
      },
    );
  }

  Widget _backgroundImageBuilder(
    DestinationDetailsState<List<CountryImage>> state,
  ) {
    return Container(
      height: 400,
      width: double.infinity,
      foregroundDecoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(255, 255, 255, 0),
            Color.fromRGBO(255, 255, 255, 0),
            Color.fromRGBO(255, 255, 255, 0),
            Color.fromRGBO(255, 255, 255, 0),
            Color.fromRGBO(255, 255, 255, 0),
            Color.fromRGBO(255, 255, 255, 0),
            Color.fromRGBO(255, 255, 255, 0.7),
            Color.fromRGBO(255, 255, 255, 1),
          ],
        ),
      ),
      child: switch (state) {
        DestinationDetailsInitial<List<CountryImage>>() => const Center(
          child: Text('Loading data!'),
        ),
        DestinationDetailsLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        DestinationDetailsLoaded<List<CountryImage>>(
          countryDetails: final images,
        ) =>
          CachedNetworkImage(imageUrl: images[0].imageUrl, fit: BoxFit.cover),
        DestinationDetailsError() => const Center(
          child: Text('Error loading images'),
        ),
      },
    );
  }

  DestinationCard _firstCardDetailsBuilder() {
    return DestinationCard(
      bgColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 60,
                        minHeight: 40,
                        maxWidth: double.infinity,
                      ),
                      child: Hero(
                        tag: 'country_flag_${widget.country.flagUrl}',
                        child: AspectRatio(
                          aspectRatio: 3 / 2,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: widget.country.flagUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomText(widget.country.name, fontSize: 30),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Amicons.remix_map_pin,
                          size: 16,
                          color: Color(0xFF717171),
                        ),
                        CustomText(
                          ' ${widget.country.region}',
                          fontSize: 16,
                          color: const Color(0xFF717171),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, right: 14),
                child: InkWell(
                  onTap: () {
                    widget.onFavorite();
                    setState(() {
                      isCurFavorite = !isCurFavorite;
                    });
                  },
                  child: Animate(
                    key: ValueKey(isCurFavorite),
                    effects: [
                      ScaleEffect(
                        duration: 200.ms,
                        curve: Curves.easeInOut,
                        begin: const Offset(0.9, 0.9),
                      ),
                      FadeEffect(
                        duration: 200.ms,
                        curve: Curves.easeInOut,
                        begin: 0.8,
                      ),
                    ],
                    child: Icon(
                      isCurFavorite
                          ? Amicons.remix_heart_fill
                          : Amicons.remix_heart,
                      color: isCurFavorite
                          ? const Color(0xFFFF385C)
                          : const Color(0xFF717171),
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            children: [
              DetailInfo(
                icon: Amicons.remix_group,
                title: 'Population',
                info: formatNumber(widget.country.population),
              ),
              const Spacer(),
              DetailInfo(
                icon: Amicons.remix_time,
                title: 'Timezone',
                info: widget.country.timezones[0],
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  Container _backButtonBuilder(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.9),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            spreadRadius: -3,
            blurRadius: 15,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            spreadRadius: -3,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).pop(),
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(Amicons.remix_arrow_left, size: 20),
        ),
      ),
    );
  }
}
