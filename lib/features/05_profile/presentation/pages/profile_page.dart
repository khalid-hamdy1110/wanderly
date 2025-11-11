import 'package:amicons/amicons.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanderly/core/domain/usecases/clear_cache.dart';
import 'package:wanderly/core/presentation/cubits/profile_stats/profile_stats_cubit.dart';
import 'package:wanderly/core/presentation/cubits/profile_stats/profile_stats_state.dart';
import 'package:wanderly/core/presentation/cubits/settings/settings_cubit.dart';
import 'package:wanderly/core/presentation/cubits/settings/settings_state.dart';
import 'package:wanderly/core/route_config/app_router.gr.dart';
import 'package:wanderly/core/ui/error_widget.dart' as app_error;
import 'package:wanderly/core/error/failure_mapper.dart';
import 'package:wanderly/core/ui/snackbars.dart';
import 'package:wanderly/core/domain/usecases/get_supported_currencies.dart';
import 'package:wanderly/core/constants/travel_interests.dart';
import 'package:wanderly/core/ui/custom_text.dart';
import 'package:wanderly/injection/injection.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    context.read<SettingsCubit>().refresh();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 32,
                          backgroundColor: Color.fromRGBO(255, 56, 92, 0.1),
                          child: Icon(
                            Amicons.remix_user,
                            size: 32,
                            color: Color.fromRGBO(255, 56, 92, 1),
                          ),
                        ),
                        const SizedBox(width: 16),
                        CustomText(state.username, fontSize: 20),
                        const Spacer(),
                        InkWell(
                          onTap: () => _showEditDialog(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: const Color(0xFFEBEBEB),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(Amicons.remix_edit, size: 18),
                                SizedBox(width: 4),
                                CustomText(
                                  'Edit',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
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
                                    ),
                                    const CustomText(
                                      'Trips',
                                      fontSize: 12,
                                      color: Color(0xFF717171),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      favoritesCount.toString(),
                                      fontSize: 20,
                                    ),
                                    const CustomText(
                                      'Favorites',
                                      fontSize: 12,
                                      color: Color(0xFF717171),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      countriesExplored.toString(),
                                      fontSize: 20,
                                    ),
                                    const CustomText(
                                      'Explored',
                                      fontSize: 12,
                                      color: Color(0xFF717171),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        };
                      },
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),

                    const CustomText('Preferences', fontSize: 18),
                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CustomText(
                                'Name',
                                fontSize: 14,
                                color: Color(0xFF717171),
                              ),
                              CustomText(state.username, fontSize: 14),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CustomText(
                                'Currency',
                                fontSize: 14,
                                color: Color(0xFF717171),
                              ),
                              CustomText(state.preferredCurrency, fontSize: 14),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const CustomText('Travel Interests', fontSize: 16),
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
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: const Color(0xFFEBEBEB),
                                ),
                              ),
                              child: CustomText(interest, fontSize: 14),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    const CustomText('Settings', fontSize: 16),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => _showConfirmationDialog(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFEBEBEB)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Amicons.remix_delete_bin, size: 20),
                            SizedBox(width: 16),
                            CustomText(
                              'Clear All Data',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    const CustomText('About', fontSize: 16),
                    const SizedBox(height: 12),
                    const CustomText(
                      'Wanderly v1.0.0\n\nWanderly is a travel planning app designed to help you explore the world with ease. Plan your trips, discover new destinations, and keep track of your favorite places all in one app.',
                      fontSize: 14,
                      color: Color(0xFF717171),
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
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            return AlertDialog(
              title: const CustomText(
                'Clear all data?',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.white,
              content: const CustomText(
                'This action will delete all your data including trips, expenses, and settings. This cannot be undone. Are you sure you want to proceed?',
                fontSize: 14,
                color: Color(0xFF717171),
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const CustomText(
                    'Cancel',
                    color: Color(0xFFFF385C),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFF385C),
                  ),
                  onPressed: () async {
                    final clearCache = di<ClearCache>();
                    await clearCache();
                    if (context.mounted) {
                      showSuccessSnackBar(context, 'All data cleared');
                      // ignore: use_build_context_synchronously
                      context.router.replaceAll([const OnboardingRoute()]);
                    }
                  },
                  child: const CustomText(
                    'Clear Data',
                    fontWeight: FontWeight.bold,
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
              title: const CustomText(
                'Edit Preferences',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.white,
              content: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        'Name',
                        fontSize: 14,
                        color: Color(0xFF717171),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFF7F7F7),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Please enter your name'
                            : null,
                      ),
                      const SizedBox(height: 14),
                      const CustomText(
                        'Preferred Currency',
                        fontSize: 14,
                        color: Color(0xFF717171),
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
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFFF7F7F7),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const CustomText(
                                  'Failed to fetch all currencies try again later',
                                  fontSize: 12,
                                  color: Color(0xFF717171),
                                ),
                              ],
                            ),
                            (currencies) {
                              if (currencies.isEmpty) {
                                return const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextField(
                                      enabled: false,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Color(0xFFF7F7F7),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    CustomText(
                                      'No currencies available',
                                      fontSize: 12,
                                      color: Color(0xFF717171),
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
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFFF7F7F7),
                                    border: OutlineInputBorder(
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
                      const CustomText(
                        'Interests',
                        fontSize: 14,
                        color: Color(0xFF717171),
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
                  child: const CustomText(
                    'Cancel',
                    color: Color(0xFFFF385C),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFF385C),
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
                  child: const CustomText('Save', fontWeight: FontWeight.bold),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
