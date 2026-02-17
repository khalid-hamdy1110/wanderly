import 'package:amicons/amicons.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wanderly/core/domain/usecases/clear_cache.dart';
import 'package:wanderly/core/presentation/cubits/favorites/favorites_cubit.dart';
import 'package:wanderly/core/presentation/cubits/profile_stats/profile_stats_cubit.dart';
import 'package:wanderly/core/presentation/cubits/profile_stats/profile_stats_state.dart';
import 'package:wanderly/core/presentation/cubits/settings/settings_cubit.dart';
import 'package:wanderly/core/presentation/cubits/settings/settings_state.dart';
import 'package:wanderly/core/route_config/app_router.gr.dart';
import 'package:wanderly/core/theming/theme_extensions.dart';
import 'package:wanderly/core/ui/error_widget.dart' as app_error;
import 'package:wanderly/core/error/failure_mapper.dart';
import 'package:wanderly/core/ui/snackbars.dart';
import 'package:wanderly/core/domain/usecases/get_supported_currencies.dart';
import 'package:wanderly/core/constants/travel_interests.dart';
import 'package:wanderly/core/ui/custom_text.dart';
import 'package:wanderly/features/04_my_trips/presentation/cubit/trips_planning_cubit.dart';
import 'package:wanderly/injection/injection.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutoRouteAwareStateMixin<ProfilePage> {
  @override
  void didChangeTabRoute(TabPageRoute previousRoute) {
    context.read<ProfileStatsCubit>().load();
    context.read<SettingsCubit>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    final customColors = context.theme.customColors;

    return Scaffold(
      backgroundColor: customColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: customColors.primary.withValues(
                            alpha: 0.1,
                          ),
                          child: Icon(
                            Amicons.remix_user,
                            size: 32,
                            color: customColors.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        CustomText(state.username, fontSize: 20),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: customColors.card,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: customColors.border),
                          ),
                          child: Material(
                            type: MaterialType.transparency,
                            child: InkWell(
                              onTap: () => _showEditDialog(context),
                              borderRadius: BorderRadius.circular(999),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 8,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Amicons.remix_edit,
                                      size: 18,
                                      color: customColors.onCard,
                                    ),
                                    const SizedBox(width: 4),
                                    CustomText(
                                      'Edit',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: customColors.onCard,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    BlocBuilder<ProfileStatsCubit, ProfileStatsState>(
                      builder: (context, profileStatsState) {
                        return switch (profileStatsState) {
                          ProfileStatsInitial() => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          ProfileStatsLoading() => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          ProfileStatsError(:final failure) =>
                            app_error.AppErrorWidget(
                              message: humanizeFailure(failure),
                              onRetry: () =>
                                  context.read<ProfileStatsCubit>().load(),
                            ),
                          ProfileStatsLoaded(
                            :final totalTrips,
                            :final countriesExplored,
                            :final favoritesCount,
                          ) =>
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      totalTrips.toString(),
                                      fontSize: 20,
                                      color: customColors.onBackground,
                                    ),
                                    CustomText(
                                      'Trips',
                                      fontSize: 12,
                                      color: customColors.onMuted,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      favoritesCount.toString(),
                                      fontSize: 20,
                                      color: customColors.onBackground,
                                    ),
                                    CustomText(
                                      'Favorites',
                                      fontSize: 12,
                                      color: customColors.onMuted,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      countriesExplored.toString(),
                                      fontSize: 20,
                                      color: customColors.onBackground,
                                    ),
                                    CustomText(
                                      'Explored',
                                      fontSize: 12,
                                      color: customColors.onMuted,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        };
                      },
                    ),
                    const SizedBox(height: 16),
                    Divider(color: customColors.border),
                    const SizedBox(height: 16),

                    CustomText(
                      'Preferences',
                      fontSize: 18,
                      color: customColors.onBackground,
                    ),
                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: customColors.secondary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                'Name',
                                fontSize: 14,
                                color: customColors.onMuted,
                              ),
                              CustomText(
                                state.username,
                                fontSize: 14,
                                color: customColors.onSecondary,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                'Currency',
                                fontSize: 14,
                                color: customColors.onMuted,
                              ),
                              CustomText(
                                state.preferredCurrency,
                                fontSize: 14,
                                color: customColors.onSecondary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomText(
                      'Travel Interests',
                      fontSize: 16,
                      color: customColors.onBackground,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: state.travelInterests
                          .map(
                            (interest) => Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: customColors.card,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: customColors.border),
                              ),
                              child: CustomText(
                                interest,
                                fontSize: 14,
                                color: customColors.onCard,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    CustomText(
                      'Settings',
                      fontSize: 16,
                      color: customColors.onBackground,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: customColors.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: customColors.border),
                      ),
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () {
                            final settingsCubit = di<SettingsCubit>();
                            settingsCubit.setIsDarkMode(!state.isDarkMode);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                      state.isDarkMode
                                          ? Amicons.lucide_sun
                                          : Amicons.lucide_moon,
                                      size: 20,
                                      color: customColors.onCard,
                                    )
                                    .animate(key: ValueKey(state.isDarkMode))
                                    .fadeIn(duration: 200.ms)
                                    .slideY(
                                      duration: 200.ms,
                                      curve: Curves.easeInOut,
                                      begin: 0.1,
                                    ),
                                const SizedBox(width: 16),
                                CustomText(
                                      state.isDarkMode
                                          ? 'Light Mode'
                                          : 'Dark Mode',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: customColors.onCard,
                                    )
                                    .animate(
                                      key: ValueKey('${state.isDarkMode}_text'),
                                    )
                                    .fadeIn(duration: 200.ms)
                                    .slideY(
                                      duration: 200.ms,
                                      curve: Curves.easeInOut,
                                      begin: 0.1,
                                    ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: customColors.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: customColors.border),
                      ),
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () => _showConfirmationDialog(context),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Amicons.remix_delete_bin,
                                  size: 20,
                                  color: customColors.onCard,
                                ),
                                const SizedBox(width: 16),
                                CustomText(
                                  'Clear All Data',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: customColors.onCard,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    CustomText(
                      'About',
                      fontSize: 16,
                      color: customColors.onBackground,
                    ),
                    const SizedBox(height: 12),
                    CustomText(
                      'Wanderly is a travel planning app designed to help you explore the world with ease. Plan your trips, discover new destinations, and keep track of your favorite places all in one app.\n\n Developed by Khalid Hamdy\n © 2026 Wanderly.',
                      fontSize: 14,
                      color: customColors.onMuted,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _showConfirmationDialog(BuildContext cubitContext) async {
    final customColors = cubitContext.theme.customColors;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            return AlertDialog(
              title: CustomText(
                'Clear all data?',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
                color: customColors.onBackground,
              ),
              backgroundColor: customColors.background,
              content: CustomText(
                'This action will delete all your data including trips, expenses, and settings. This cannot be undone. Are you sure you want to proceed?',
                fontSize: 14,
                color: customColors.onMuted,
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: CustomText(
                    'Cancel',
                    color: customColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: customColors.primary,
                  ),
                  onPressed: () async {
                    final clearCache = di<ClearCache>();
                    await clearCache();

                    if (context.mounted) {
                      final favoritesCubit = context.read<FavoritesCubit>();
                      final tripsCubit = context.read<TripsPlanningCubit>();
                      final profileStatsCubit = context
                          .read<ProfileStatsCubit>();
                      final settingsCubit = context.read<SettingsCubit>();

                      favoritesCubit.fetchFavoriteCountries();
                      tripsCubit.getAllTrips();
                      profileStatsCubit.load();
                      settingsCubit.refresh();

                      showSuccessSnackBar(context, 'All data cleared');
                      context.router.replaceAll([const OnboardingRoute()]);
                    }
                  },
                  child: CustomText(
                    'Clear Data',
                    fontWeight: FontWeight.bold,
                    color: customColors.onPrimary,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showEditDialog(BuildContext dialogContext) async {
    final customColors = dialogContext.theme.customColors;
    final settingsCubit = di<SettingsCubit>();
    final s = settingsCubit.state;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: s.username);
    String? selectedCurrency = s.preferredCurrency;
    final selectedInterests = s.travelInterests.toSet();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            return AlertDialog(
              title: CustomText(
                'Edit Preferences',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
                color: customColors.onBackground,
              ),
              backgroundColor: customColors.background,
              content: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        'Name',
                        fontSize: 14,
                        color: customColors.onMuted,
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: customColors.secondary,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Please enter your name'
                            : null,
                      ),
                      const SizedBox(height: 14),
                      CustomText(
                        'Preferred Currency',
                        fontSize: 14,
                        color: customColors.onMuted,
                      ),
                      const SizedBox(height: 6),
                      FutureBuilder(
                        future: di<GetSupportedCurrencies>()(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final either = snapshot.data!;
                          return either.fold(
                            (failure) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  enabled: false,
                                  initialValue: s.preferredCurrency,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: customColors.secondary,
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                CustomText(
                                  'Failed to fetch all currencies try again later',
                                  fontSize: 12,
                                  color: customColors.onMuted,
                                ),
                              ],
                            ),
                            (currencies) {
                              if (currencies.isEmpty) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextField(
                                      enabled: false,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: customColors.secondary,
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    CustomText(
                                      'No currencies available',
                                      fontSize: 12,
                                      color: customColors.onMuted,
                                    ),
                                  ],
                                );
                              }
                              if (selectedCurrency == null ||
                                  !currencies.any(
                                    (c) => c.code == selectedCurrency,
                                  )) {
                                selectedCurrency = currencies.first.code;
                              }
                              return SizedBox(
                                width: double.maxFinite,
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  initialValue: selectedCurrency,
                                  items: currencies
                                      .map(
                                        (c) => DropdownMenuItem<String>(
                                          value: c.code,
                                          child: CustomText(
                                            '${c.code} - ${c.name}',
                                            fontSize: 14,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (val) => setLocalState(
                                    () => selectedCurrency = val,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: customColors.secondary,
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                    ),
                                  ),
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? 'Select a currency'
                                      : null,
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 14),
                      CustomText(
                        'Interests',
                        fontSize: 14,
                        color: customColors.onMuted,
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: -8,
                        children: [
                          for (final item in availableTravelInterests)
                            FilterChip(
                              label: Text('${item['emoji']}  ${item['title']}'),
                              selected: selectedInterests.contains(
                                item['title'] as String,
                              ),
                              onSelected: (isSelected) {
                                setLocalState(() {
                                  final title = item['title'] as String;
                                  if (isSelected) {
                                    selectedInterests.add(title);
                                  } else {
                                    selectedInterests.remove(title);
                                  }
                                });
                              },
                              selectedColor: customColors.primary,
                              labelStyle: GoogleFonts.arimo(
                                color: selectedInterests.contains(item['title'])
                                    ? customColors.onPrimary
                                    : customColors.onCard,
                                fontSize: 14,
                              ),
                              shadowColor: customColors.primary.withValues(
                                alpha: 0.3,
                              ),
                              checkmarkColor: customColors.onPrimary,
                              backgroundColor: customColors.accent,
                              surfaceTintColor: customColors.accent,
                              selectedShadowColor: customColors.primary
                                  .withValues(alpha: 0.5),
                              color: WidgetStateColor.resolveWith((states) {
                                if (states.contains(WidgetState.selected)) {
                                  return customColors.primary;
                                }
                                return customColors.accent;
                              }),
                              side: BorderSide(color: customColors.border),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: CustomText(
                    'Cancel',
                    color: customColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: customColors.primary,
                  ),
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;
                    final name = nameController.text.trim();
                    final currency = (selectedCurrency ?? '').toUpperCase();
                    final interests = selectedInterests.toList();
                    await settingsCubit.setUsername(name);
                    await settingsCubit.setPreferredCurrency(currency);
                    await settingsCubit.setTravelInterests(interests);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      showSuccessSnackBar(context, 'Preferences updated');
                    }
                  },
                  child: CustomText(
                    'Save',
                    fontWeight: FontWeight.bold,
                    color: customColors.onPrimary,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
