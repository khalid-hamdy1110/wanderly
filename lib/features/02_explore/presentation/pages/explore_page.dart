import 'package:amicons/amicons.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wanderly/core/route_config/app_router.gr.dart';
import 'package:wanderly/core/ui/custom_text.dart';
import 'package:wanderly/features/02_explore/domain/extensions/country_extension.dart';
import 'package:wanderly/features/02_explore/presentation/cubit/explore/explore_cubit.dart';
import 'package:wanderly/features/02_explore/presentation/cubit/explore/explore_state.dart';
import 'package:wanderly/features/02_explore/presentation/widgets/country_card.dart';
import 'package:wanderly/features/02_explore/presentation/widgets/filter_pill.dart';
import 'package:wanderly/injection/injection.dart';

@RoutePage()
class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  static const sidePadding = 16.0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.get<ExploreCubit>()..fetchAllCountries(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<ExploreCubit, ExploreState>(
            builder: (context, state) {
              return switch (state) {
                ExploreInitial() => const Center(
                  child: Text('Welcome to Explore'),
                ),
                ExploreLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
                ExploreLoaded(
                  filteredCountries: final countries,
                  favorites: final favorites,
                ) =>
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: sidePadding),
                        child: CustomText(
                          'Good morning,',
                          fontSize: 14,
                          color: Color(0XFF717171),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: sidePadding),
                        child: CustomText('Hello, Khalid! 👋', fontSize: 24),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: sidePadding,
                        ),
                        padding: const EdgeInsets.only(
                          left: 16,
                          top: 19,
                          bottom: 19,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.1),
                              spreadRadius: 0, // How much the shadow spreads
                              blurRadius: 3, // How blurred the shadow is
                              offset: Offset(
                                0,
                                1,
                              ), // Offset of the shadow (x, y)
                            ),
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.1),
                              spreadRadius: -1, // How much the shadow spreads
                              blurRadius: 2, // How blurred the shadow is
                              offset: Offset(
                                0,
                                1,
                              ), // Offset of the shadow (x, y)
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Amicons.remix_search,
                              size: 20,
                              color: Color(0xFF717171),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                onChanged: (value) => context
                                    .read<ExploreCubit>()
                                    .filterCountries(value),
                                decoration: const InputDecoration(
                                  hint: CustomText(
                                    'Where to?',
                                    maxLines: 1,
                                    fontSize: 16,
                                    color: Color(0xFF717171),
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        margin: const EdgeInsets.only(left: sidePadding),
                        height: 36,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: FilterPill(
                                fillColor: Colors.white,
                                text: 'All',
                                textStyle: GoogleFonts.arimo(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(color: Color(0xFFEBEBEB)),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: sidePadding,
                        ),
                        child: CustomText(
                          '${countries.length} destinations',
                          fontSize: 14,
                          color: const Color(0XFF717171),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: sidePadding,
                          ),
                          child: RefreshIndicator(
                            onRefresh: () async {
                              await context
                                  .read<ExploreCubit>()
                                  .fetchAllCountries();
                            },
                            child:
                                ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: countries.length,
                                      itemBuilder: (context, index) {
                                        final country = countries[index];

                                        return InkWell(
                                          onTap: () => context.router.push(
                                            DestinationDetailsRoute(
                                              country: country,
                                              isFavorite: favorites.contains(
                                                country,
                                              ),
                                              onFavorite: () {
                                                context
                                                    .read<ExploreCubit>()
                                                    .toggleFavorite(country);
                                              },
                                            ),
                                          ),
                                          child: CountryCard(
                                            backgroundColor: Colors.white,
                                            borderColor: const Color(
                                              0xFFEBEBEB,
                                            ),
                                            countryName: country.name,
                                            flagUrl: country.flagUrl,
                                            region: country.region,
                                            briefInfo: country.briefInfo,
                                            onFavorite: () => context
                                                .read<ExploreCubit>()
                                                .toggleFavorite(country),
                                            isFavorite: favorites.contains(
                                              country,
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ExploreError(message: final message) => Center(
                  child: Text('Error: $message'),
                ),
              };
            },
          ),
        ),
      ),
    );
  }
}
