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
import 'package:wanderly/core/theming/theme_extensions.dart';
import 'package:wanderly/core/ui/custom_text.dart';
import 'package:wanderly/core/ui/custom_text_field.dart';
import 'package:wanderly/features/02_explore/domain/extensions/country_extension.dart';
import 'package:wanderly/features/02_explore/presentation/cubit/explore/explore_cubit.dart';
import 'package:wanderly/features/02_explore/presentation/cubit/explore/explore_state.dart';
import 'package:wanderly/core/ui/country_card.dart';
import 'package:wanderly/core/ui/filter_pill.dart';
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
    final customColors = context.theme.customColors;

    return BlocProvider(
      create: (_) => di.get<ExploreCubit>()..fetchAllCountries(),
      child: Scaffold(
        backgroundColor: customColors.background,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: sidePadding,
                        ),
                        child: CustomText(
                          'Good morning,',
                          fontSize: 14,
                          color: customColors.onMuted,
                        ),
                      ),
                      _buildGreeting(context),
                      const SizedBox(height: 18),
                      _buildSearchBar(context),
                      const SizedBox(height: 16),
                      _buildTravelInterests(selectedInterest, context),
                      const SizedBox(height: 8),
                      Divider(color: customColors.border),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: sidePadding,
                        ),
                        child: CustomText(
                          '${countries.length} destinations',
                          fontSize: 14,
                          color: customColors.onMuted,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildCountryCardList(context, countries),
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

  Expanded _buildCountryCardList(
    BuildContext context,
    List<Country> countries,
  ) {
    final customColors = context.theme.customColors;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: sidePadding),
        child: RefreshIndicator(
          edgeOffset: -25,
          onRefresh: () async {
            await context.read<ExploreCubit>().fetchAllCountries();
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

                      return CountryCard(
                        source: 'explore',
                        backgroundColor: customColors.card,
                        borderColor: customColors.border,
                        countryName: country.name,
                        flagUrl: country.flagUrl,
                        region: country.region,
                        briefInfo: country.briefInfo,
                        onFavorite: () => context
                            .read<FavoritesCubit>()
                            .toggleFavoriteStatus(country),
                        isFavorite: favorites.contains(country),
                        onTap: () => context.router.push(
                          DestinationDetailsRoute(
                            country: country,
                            source: 'explore',
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
    );
  }

  BlocSelector<SettingsCubit, SettingsState, List<String>>
  _buildTravelInterests(String? selectedInterest, BuildContext context) {
    final customColors = context.theme.customColors;

    return BlocSelector<SettingsCubit, SettingsState, List<String>>(
      selector: (s) => s.travelInterests,
      builder: (context, userInterests) {
        final items = userInterests.map((title) {
          final match = availableTravelInterests.firstWhere(
            (m) => m['title'] == title,
            orElse: () => {'emoji': '', 'title': title},
          );
          return {'title': title, 'emoji': match['emoji'] ?? ''};
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
                        : items[index - 1]['title'] as String);

              final bool isSelected = isAll
                  ? selectedInterest == null
                  : selectedInterest == interestTitle;

              final Color fillColor = isSelected
                  ? customColors.primary
                  : customColors.card;
              final TextStyle textStyle = GoogleFonts.arimo(
                fontSize: 14,
                color: isSelected
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
                  onTap: () {
                    context.read<ExploreCubit>().setSelectedInterest(
                      interestTitle,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Container _buildSearchBar(BuildContext context) {
    final customColors = context.theme.customColors;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: sidePadding),
      padding: const EdgeInsets.only(left: 16, top: 19, bottom: 19),
      decoration: BoxDecoration(
        color: customColors.card,
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
          Icon(
            Amicons.remix_search,
            size: 20,
            color: customColors.textFieldPlaceholder,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: (value) =>
                  context.read<ExploreCubit>().setSearchQuery(value),
              decoration: InputDecoration(
                hint: CustomText(
                  'Where to?',
                  maxLines: 1,
                  fontSize: 16,
                  color: customColors.textFieldPlaceholder,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.all(0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BlocSelector<SettingsCubit, SettingsState, String> _buildGreeting(
    BuildContext context,
  ) {
    final customColors = context.theme.customColors;

    return BlocSelector<SettingsCubit, SettingsState, String>(
      selector: (state) => state.username,
      builder: (context, username) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: sidePadding),
        child: InkWell(
          onTap: () {
            final formKey = GlobalKey<FormState>();
            final controller = TextEditingController(text: username);
            showModalBottomSheet(
              backgroundColor: customColors.background,
              isScrollControlled: true,
              showDragHandle: true,
              context: context,
              builder: (ctx) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          controller: controller,
                          keyboardType: TextInputType.text,
                          hint: CustomText(
                            'Enter your name',
                            fontSize: 16,
                            color: customColors.textFieldPlaceholder,
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
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: CustomText(
                                'Cancel',
                                color: customColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: customColors.primary,
                              ),
                              onPressed: () async {
                                if (!formKey.currentState!.validate()) {
                                  return;
                                }
                                await context.read<SettingsCubit>().setUsername(
                                  controller.text.trim(),
                                );
                                if (ctx.mounted) {
                                  Navigator.of(ctx).pop();
                                  showSuccessSnackBar(context, 'Name updated');
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
          child: CustomText('Hello, $username! 👋', fontSize: 24),
        ),
      ),
    );
  }
}
