import 'package:amicons/amicons.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wanderly/core/domain/entities/country.dart';
import 'package:wanderly/core/presentation/cubits/favorites/favorites_cubit.dart';
import 'package:wanderly/core/presentation/cubits/favorites/favorites_state.dart';
import 'package:wanderly/core/presentation/cubits/settings/settings_cubit.dart';
import 'package:wanderly/core/presentation/cubits/settings/settings_state.dart';
import 'package:wanderly/core/route_config/app_router.gr.dart';
import 'package:wanderly/core/ui/custom_text.dart';
import 'package:wanderly/core/ui/custom_text_field.dart';
import 'package:wanderly/features/02_explore/domain/extensions/country_extension.dart';
import 'package:wanderly/features/02_explore/presentation/cubit/explore/explore_cubit.dart';
import 'package:wanderly/features/02_explore/presentation/cubit/explore/explore_state.dart';
import 'package:wanderly/core/ui/country_card.dart';
import 'package:wanderly/features/02_explore/presentation/widgets/filter_pill.dart';
import 'package:wanderly/injection/injection.dart';
import 'package:wanderly/core/ui/error_widget.dart' as app_error;
import 'package:wanderly/core/constants/travel_interests.dart';
import 'package:wanderly/core/ui/snackbars.dart';

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
                  selectedInterest: final selectedInterest,
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
                      BlocSelector<SettingsCubit, SettingsState, String>(
                        selector: (state) => state.username,
                        builder: (context, username) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: sidePadding,
                          ),
                          child: InkWell(
                            onTap: () {
                              final formKey = GlobalKey<FormState>();
                              final controller = TextEditingController(
                                text: username,
                              );
                              showModalBottomSheet(
                                backgroundColor: Colors.white,
                                isScrollControlled: true,
                                showDragHandle: true,
                                context: context,
                                builder: (ctx) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                      top: 16,
                                      bottom:
                                          MediaQuery.of(ctx).viewInsets.bottom +
                                          16,
                                    ),
                                    child: Form(
                                      key: formKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const CustomText(
                                            'Edit name',
                                            fontSize: 20,
                                          ),
                                          const SizedBox(height: 12),
                                          CustomTextField(
                                            controller: controller,
                                            keyboardType: TextInputType.text,
                                            hint: const CustomText(
                                              'Enter your name',
                                              fontSize: 16,
                                              color: Color(0xFF717171),
                                            ),
                                            icon: Amicons.remix_user,
                                            validator: (value) {
                                              final v = value?.trim() ?? '';
                                              if (v.isEmpty) {
                                                return 'Please enter a name';
                                              }
                                              if (v.length < 2) {
                                                return 'Name must be at least 2 characters';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(ctx).pop(),
                                                child: const CustomText(
                                                  'Cancel',
                                                  color: Color(0xFFFF385C),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Spacer(),
                                              FilledButton(
                                                style: FilledButton.styleFrom(
                                                  backgroundColor: const Color(
                                                    0xFFFF385C,
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  if (!formKey.currentState!
                                                      .validate()) {
                                                    return;
                                                  }
                                                  await context
                                                      .read<SettingsCubit>()
                                                      .setUsername(
                                                        controller.text.trim(),
                                                      );
                                                  if (ctx.mounted) {
                                                    Navigator.of(ctx).pop();
                                                    showSuccessSnackBar(
                                                      context,
                                                      'Name updated',
                                                    );
                                                  }
                                                },
                                                child: const CustomText(
                                                  'Save',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: CustomText(
                              'Hello, $username! 👋',
                              fontSize: 24,
                            ),
                          ),
                        ),
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
                              spreadRadius: 0,
                              blurRadius: 3,
                              offset: Offset(0, 1),
                            ),
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.1),
                              spreadRadius: -1,
                              blurRadius: 2,
                              offset: Offset(0, 1),
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
                                    .setSearchQuery(value),
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
                      BlocSelector<SettingsCubit, SettingsState, List<String>>(
                        selector: (s) => s.travelInterests,
                        builder: (context, userInterests) {
                          final items = userInterests.map((title) {
                            final match = availableTravelInterests.firstWhere(
                              (m) => m['title'] == title,
                              orElse: () => {'emoji': '', 'title': title},
                            );
                            return {
                              'title': title,
                              'emoji': match['emoji'] ?? '',
                            };
                          }).toList();

                          return Container(
                            margin: const EdgeInsets.only(left: sidePadding),
                            height: 36,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 1 + items.length,
                              itemBuilder: (context, index) {
                                final bool isAll = index == 0;
                                final String? interestTitle = isAll
                                    ? null
                                    : items[index - 1]['title'] as String;
                                final String emoji = isAll
                                    ? ''
                                    : (items[index - 1]['emoji'] as String);
                                final String label = isAll
                                    ? 'All'
                                    : (emoji.isNotEmpty
                                          ? '$emoji ${items[index - 1]['title']}'
                                          : items[index - 1]['title']
                                                as String);

                                final bool isSelected = isAll
                                    ? selectedInterest == null
                                    : selectedInterest == interestTitle;

                                final Color fillColor = isSelected
                                    ? const Color(0xFFFF385C)
                                    : Colors.white;
                                final TextStyle textStyle = GoogleFonts.arimo(
                                  fontSize: 14,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                );

                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () {
                                      context
                                          .read<ExploreCubit>()
                                          .setSelectedInterest(interestTitle);
                                    },
                                    child: FilterPill(
                                      fillColor: fillColor,
                                      text: label,
                                      textStyle: textStyle,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
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
                            child: BlocBuilder<FavoritesCubit, FavoritesState>(
                              builder: (context, favState) {
                                final favorites = favState is FavoritesLoaded
                                    ? favState.favoriteDestinations
                                    : <Country>[];

                                return ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: countries.length,
                                      itemBuilder: (context, index) {
                                        final country = countries[index];

                                        return InkWell(
                                          onTap: () => context.router.push(
                                            DestinationDetailsRoute(
                                              country: country,
                                              source: 'explore',
                                            ),
                                          ),
                                          child: CountryCard(
                                            source: 'explore',
                                            backgroundColor: Colors.white,
                                            borderColor: const Color(
                                              0xFFEBEBEB,
                                            ),
                                            countryName: country.name,
                                            flagUrl: country.flagUrl,
                                            region: country.region,
                                            briefInfo: country.briefInfo,
                                            onFavorite: () => context
                                                .read<FavoritesCubit>()
                                                .toggleFavoriteStatus(country),
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
                                    .fadeIn(duration: 300.ms);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ExploreError(message: final message) =>
                  app_error.AppErrorWidget(
                    message: message,
                    onRetry: () =>
                        context.read<ExploreCubit>().fetchAllCountries(),
                  ),
              };
            },
          ),
        ),
      ),
    );
  }
}
