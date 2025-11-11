import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanderly/core/route_config/app_router.gr.dart';
import 'package:wanderly/core/ui/country_card.dart';
import 'package:wanderly/core/ui/custom_text.dart';
import 'package:wanderly/features/02_explore/domain/extensions/country_extension.dart';
import 'package:wanderly/core/presentation/cubits/favorites/favorites_cubit.dart';
import 'package:wanderly/core/presentation/cubits/favorites/favorites_state.dart';
import 'package:wanderly/features/02_explore/presentation/widgets/filter_pill.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: CustomText(
                'Swipe left to remove a favorite!',
                fontSize: 14,
                color: Color(0xFF717171),
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
                        ? const Color(0xFFFF385C)
                        : Colors.white;
                    final textStyle = GoogleFonts.arimo(
                      fontSize: 14,
                      color: selected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    );
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () =>
                            context.read<FavoritesCubit>().setSort(key),
                        child: FilterPill(
                          fillColor: fillColor,
                          text: label,
                          textStyle: textStyle,
                        ),
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
            const Divider(height: 1, color: Colors.black),
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
                        return const Center(
                          child: CustomText(
                            'No Favorites!',
                            fontSize: 32,
                            color: Color(0xFF717171),
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
                                      child: InkWell(
                                        onTap: () => context.router.push(
                                          DestinationDetailsRoute(
                                            source: 'favorites',
                                            country: country,
                                          ),
                                        ),
                                        child: CountryCard(
                                          source: 'favorites',
                                          backgroundColor: Colors.white,
                                          borderColor: const Color(0xFFEBEBEB),
                                          countryName: country.name,
                                          flagUrl: country.flagUrl,
                                          region: country.region,
                                          briefInfo: country.briefInfo,
                                          onFavorite: () {},
                                          isFavorite: true,
                                          includeFavoriteIcon: false,
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
