import 'package:amicons/amicons.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanderly/core/domain/entities/country.dart';
import 'package:wanderly/core/presentation/cubits/favorites/favorites_cubit.dart';
import 'package:wanderly/core/presentation/cubits/favorites/favorites_state.dart';
import 'package:wanderly/core/route_config/app_router.gr.dart';
import 'package:wanderly/core/theming/theme_extensions.dart';
import 'package:wanderly/core/ui/weather_card.dart';
import 'package:wanderly/features/02_explore/presentation/widgets/bottom_sheet_button.dart';
import 'package:wanderly/core/ui/custom_text.dart';
import 'package:wanderly/core/utilities/useful_functions.dart';
import 'package:wanderly/features/02_explore/domain/entities/country_image.dart';
import 'package:wanderly/features/02_explore/domain/entities/country_weather.dart';
import 'package:wanderly/features/02_explore/domain/extensions/country_extension.dart';
import 'package:wanderly/core/ui/snackbars.dart';
import 'package:wanderly/features/02_explore/presentation/cubit/destination_details/destination_details_state.dart';
import 'package:wanderly/features/02_explore/presentation/cubit/destination_details/images_cubit.dart';
import 'package:wanderly/features/02_explore/presentation/cubit/destination_details/weather_cubit.dart';
import 'package:wanderly/features/02_explore/presentation/widgets/destination_card.dart';
import 'package:wanderly/features/02_explore/presentation/widgets/detail_info.dart';
import 'package:wanderly/injection/injection.dart';

@RoutePage()
class DestinationDetailsPage extends StatefulWidget {
  const DestinationDetailsPage({
    super.key,
    required this.country,
    required this.source,
  });

  final String source;
  final Country country;

  @override
  State<DestinationDetailsPage> createState() => _DestinationDetailsPageState();
}

class _DestinationDetailsPageState extends State<DestinationDetailsPage> {
  final carouselController = CarouselController();

  @override
  void dispose() {
    carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customColors = context.theme.customColors;
    final isFav = context.select<FavoritesCubit, bool>(
      (cubit) =>
          cubit.state is FavoritesLoaded &&
          (cubit.state as FavoritesLoaded).favoriteDestinations.any(
            (country) => country.code == widget.country.code,
          ),
    );

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
        backgroundColor: customColors.background,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: _backButtonBuilder(context),
        ),
        bottomSheet: BottomSheetButton(
          onTap: () =>
              context.router.push(TripsPlanningRoute(country: widget.country)),
          label: 'Plan Your Trip',
        ),
        body:
            BlocBuilder<
              ImagesCubit,
              DestinationDetailsState<List<CountryImage>>
            >(
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _backgroundImageBuilder(state, context),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 360),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1000),
                            child: Column(
                              children: [
                                _firstCardDetailsBuilder(context, isFav)
                                    .animate()
                                    .fadeIn(duration: 400.ms)
                                    .slideY(
                                      begin: 0.5,
                                      end: 0,
                                      duration: 400.ms,
                                      curve: Curves.easeOutBack,
                                    ),
                                const SizedBox(height: 24),
                                BlocBuilder<
                                  WeatherCubit,
                                  DestinationDetailsState<CountryWeather>
                                >(
                                  builder: (context, state) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: WeatherCard(state: state)
                                          .animate()
                                          .fadeIn(duration: 600.ms)
                                          .slideY(
                                            begin: 0.5,
                                            end: 0,
                                            duration: 600.ms,
                                            curve: Curves.easeOutBack,
                                          ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 24),
                                _buildAboutCard(context)
                                    .animate()
                                    .fadeIn(duration: 800.ms)
                                    .slideY(
                                      begin: 0.5,
                                      end: 0,
                                      duration: 800.ms,
                                      curve: Curves.easeOutBack,
                                    ),
                                const SizedBox(height: 24),
                                _essentialInformationCard(context)
                                    .animate()
                                    .fadeIn(duration: 1000.ms)
                                    .slideY(
                                      begin: 0.5,
                                      end: 0,
                                      duration: 1000.ms,
                                      curve: Curves.easeOutBack,
                                    ),
                                const SizedBox(height: 24),
                                _photoGalleryBuilder(state)
                                    .animate()
                                    .fadeIn(duration: 1200.ms)
                                    .slideY(
                                      begin: 0.5,
                                      end: 0,
                                      duration: 1200.ms,
                                      curve: Curves.easeOutBack,
                                    ),
                                const SizedBox(height: 120),
                              ],
                            ),
                          ),
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
    final customColors = context.theme.customColors;
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
                        errorWidget: (context, url, error) => Container(
                          decoration: BoxDecoration(
                            color: customColors.card,
                            border: Border.all(color: customColors.border),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Amicons.iconly_image_broken,
                            color: customColors.destructive,
                          ),
                        ),
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

  DestinationCard _essentialInformationCard(BuildContext context) {
    final customColors = context.theme.customColors;

    return DestinationCard(
      bgColor: customColors.card,
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
          Divider(color: customColors.border),
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

  DestinationCard _buildAboutCard(BuildContext context) {
    final customColors = context.theme.customColors;

    return DestinationCard(
      bgColor: customColors.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CustomText('About', fontSize: 20, fontWeight: FontWeight.bold),
          const SizedBox(height: 12),
          CustomText(
            widget.country.briefInfo,
            fontSize: 16,
            color: customColors.onMuted,
          ),
        ],
      ),
    );
  }

  Widget _backgroundImageBuilder(
    DestinationDetailsState<List<CountryImage>> state,
    BuildContext context,
  ) {
    final customColors = context.theme.customColors;

    return Container(
      height: 400,
      width: double.infinity,
      foregroundDecoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            customColors.background.withValues(alpha: 0),
            customColors.background.withValues(alpha: 0),
            customColors.background.withValues(alpha: 0),
            customColors.background.withValues(alpha: 0),
            customColors.background.withValues(alpha: 0),
            customColors.background.withValues(alpha: 0),
            customColors.background.withValues(alpha: 0.8),
            customColors.background,
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
          CachedNetworkImage(
            imageUrl: images[0].imageUrl,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
                color: customColors.card,
                border: Border.all(color: customColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Amicons.iconly_image_broken,
                color: customColors.destructive,
              ),
            ),
          ),
        DestinationDetailsError() => const Center(
          child: Text('Error loading images'),
        ),
      },
    );
  }

  DestinationCard _firstCardDetailsBuilder(BuildContext context, bool isFav) {
    final customColors = context.theme.customColors;

    return DestinationCard(
      bgColor: customColors.card,
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
                        tag:
                            '${widget.source}_country_flag_${widget.country.flagUrl}',
                        child: AspectRatio(
                          aspectRatio: 3 / 2,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: widget.country.flagUrl,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Container(
                                decoration: BoxDecoration(
                                  color: customColors.card,
                                  border: Border.all(
                                    color: customColors.border,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Amicons.iconly_image_broken,
                                  color: customColors.destructive,
                                ),
                              ),
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
                        Icon(
                          Amicons.remix_map_pin,
                          size: 16,
                          color: customColors.onMuted,
                        ),
                        CustomText(
                          ' ${widget.country.region}',
                          fontSize: 16,
                          color: customColors.onMuted,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Animate(
                key: ValueKey(isFav),
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
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, right: 14),
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: () async {
                        final wasFav = isFav;
                        await context
                            .read<FavoritesCubit>()
                            .toggleFavoriteStatus(widget.country);
                        if (context.mounted) {
                          if (wasFav) {
                            showSuccessSnackBar(
                              context,
                              'Removed from favorites',
                            );
                          } else {
                            showSuccessSnackBar(context, 'Added to favorites');
                          }
                        }
                      },
                      child: Icon(
                        isFav ? Amicons.remix_heart_fill : Amicons.remix_heart,
                        color: isFav ? Colors.red : customColors.onMuted,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: customColors.border),
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
    final customColors = context.theme.customColors;

    return Container(
      decoration: BoxDecoration(
        color: customColors.card.withValues(alpha: 0.9),
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
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(999),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(
              Amicons.remix_arrow_left,
              size: 20,
              color: customColors.onCard,
            ),
          ),
        ),
      ),
    );
  }
}
