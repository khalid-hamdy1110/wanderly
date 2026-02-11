import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanderly/core/route_config/app_router.gr.dart';
import 'package:wanderly/core/theming/theme_extensions.dart';
import 'package:wanderly/core/ui/country_card.dart';
import 'package:wanderly/core/ui/custom_text.dart';
import 'package:wanderly/features/02_explore/domain/extensions/country_extension.dart';
import 'package:wanderly/core/presentation/cubits/favorites/favorites_cubit.dart';
import 'package:wanderly/core/presentation/cubits/favorites/favorites_state.dart';
import 'package:wanderly/core/ui/filter_pill.dart';
import 'package:google_fonts/google_fonts.dart';

@RoutePage()
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    final customColors = context.theme.customColors;

    return Scaffold(
      backgroundColor: customColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16) +
                  const EdgeInsets.only(top: 12),
              child: const CustomText('Favorites', fontSize: 24),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomText(
                'Swipe left to remove a favorite!',
                fontSize: 14,
                color: customColors.onMuted,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) {
                  final String activeSort = state is FavoritesLoaded
                      ? state.sortKey
                      : 'recent';

                  Widget buildPill(String key, String label) {
                    final bool selected = activeSort == key;
                    final Color fillColor = selected
                        ? customColors.primary
                        : customColors.card;
                    final textStyle = GoogleFonts.arimo(
                      fontSize: 14,
                      color: selected
                          ? customColors.onPrimary
                          : customColors.onCard,
                      fontWeight: FontWeight.bold,
                    );
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterPill(
                        fillColor: fillColor,
                        text: label,
                        textStyle: textStyle,
                        onTap: () =>
                            context.read<FavoritesCubit>().setSort(key),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        buildPill('alpha', 'Alphabetical'),
                        buildPill('recent', 'Recently added'),
                        buildPill('region', 'Region'),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Divider(height: 1, color: customColors.border),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocBuilder<FavoritesCubit, FavoritesState>(
                  builder: (context, state) {
                    if (state is FavoritesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is FavoritesLoaded) {
                      if (state.favoriteDestinations.isEmpty) {
                        return Center(
                          child: CustomText(
                            'No Favorites!',
                            fontSize: 32,
                            color: customColors.onMuted,
                          ),
                        );
                      }
                      final countries = state.favoriteDestinations;
                      return RefreshIndicator(
                        onRefresh: () async {
                          await context
                              .read<FavoritesCubit>()
                              .fetchFavoriteCountries();
                        },
                        child:
                            ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: countries.length,
                                  itemBuilder: (context, index) {
                                    final country = countries[index];

                                    return Dismissible(
                                      key: Key(country.code),
                                      direction: DismissDirection.endToStart,
                                      onDismissed: (direction) {
                                        context
                                            .read<FavoritesCubit>()
                                            .toggleFavoriteStatus(country);
                                      },
                                      child: CountryCard(
                                        source: 'favorites',
                                        backgroundColor: customColors.card,
                                        borderColor: customColors.border,
                                        countryName: country.name,
                                        flagUrl: country.flagUrl,
                                        region: country.region,
                                        briefInfo: country.briefInfo,
                                        onFavorite: () {},
                                        isFavorite: true,
                                        includeFavoriteIcon: false,
                                        onTap: () => context.router.push(
                                          DestinationDetailsRoute(
                                            source: 'favorites',
                                            country: country,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                                .animate()
                                .slideX(
                                  duration: 300.ms,
                                  begin: 0.5,
                                  end: 0,
                                  curve: Curves.easeIn,
                                )
                                .fadeIn(duration: 300.ms),
                      );
                    } else if (state is FavoritesError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
