import 'package:amicons/amicons.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanderly/core/constants/travel_interests.dart';
import 'package:wanderly/core/route_config/app_router.gr.dart';
import 'package:wanderly/core/theming/theme_extensions.dart';
import 'package:wanderly/core/ui/custom_text.dart';
import 'package:wanderly/core/ui/custom_text_field.dart';
import 'package:wanderly/core/ui/snackbars.dart';
import 'package:wanderly/features/01_onboarding/presentation/cubit/set_prefs/set_prefs_cubit.dart';
import 'package:wanderly/features/01_onboarding/presentation/cubit/set_prefs/set_prefs_state.dart';
import 'package:wanderly/features/01_onboarding/presentation/widgets/continue_button.dart';
import 'package:wanderly/features/01_onboarding/presentation/widgets/go_back_button.dart';
import 'package:wanderly/features/01_onboarding/presentation/widgets/interest_tile.dart';
import 'package:wanderly/features/01_onboarding/presentation/widgets/search_currencies.dart';
import 'package:wanderly/injection/injection.dart';
import 'package:wanderly/features/01_onboarding/presentation/cubit/onboarding/onboarding_cubit.dart';
import 'package:wanderly/features/01_onboarding/presentation/cubit/onboarding/onboarding_state.dart';

@RoutePage()
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final SetPrefsCubit _setPrefsCubit;
  late final OnboardingCubit _onboardingCubit;
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setPrefsCubit = di.get<SetPrefsCubit>();
    _onboardingCubit = OnboardingCubit();
    _setPrefsCubit.fetchSupportedCurrencies();

    _nameController.addListener(() {
      _onboardingCubit.updateName(_nameController.text);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _onboardingCubit.close();
    super.dispose();
  }

  void _nextPage() => _onboardingCubit.nextPage();
  void _prevPage() => _onboardingCubit.prevPage();

  @override
  Widget build(BuildContext context) {
    final customColors = context.theme.customColors;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _setPrefsCubit),
        BlocProvider.value(value: _onboardingCubit),
      ],
      child: Scaffold(
        backgroundColor: customColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlocBuilder<OnboardingCubit, OnboardingState>(
                  builder: (context, state) {
                    return TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: state.progress),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return LinearProgressIndicator(
                          value: value,
                          backgroundColor: customColors.secondary,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            customColors.primary,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        );
                      },
                    );
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          child: BlocListener<OnboardingCubit, OnboardingState>(
                            listener: (context, state) {
                              _pageController.animateToPage(
                                state.currentPage,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Builder(
                              builder: (context) {
                                return PageView(
                                  controller: _pageController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    _firstPageBuilder(context),
                                    _secondPageBuilder(context),
                                    _thirdPageBuilder(context),
                                    _fourthPageBuilder(context),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _fourthPageBuilder(BuildContext context) {
    final customColors = context.theme.customColors;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomText('🎉', fontSize: 60),
        const SizedBox(height: 22),
        const CustomText(
          'You\'re all set!',
          fontSize: 24,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        CustomText(
          'Ready to explore amazing destinations',
          fontSize: 14,
          color: customColors.onMuted,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        Container(
          padding: const EdgeInsets.all(22),
          color: customColors.secondary.withValues(alpha: 0.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CustomText(
                'Summary',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 16),
              BlocBuilder<OnboardingCubit, OnboardingState>(
                builder: (context, state) {
                  final username = state.name;
                  final travelInterests = state.selectedInterests!;
                  final selectedCurrencyDisplay = state.selectedCurrencyDisplay;
                  final preferredCurrencyCode = selectedCurrencyDisplay!
                      .split(' - ')
                      .first;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomText(
                              'Name',
                              fontSize: 14,
                              color: customColors.onMuted,
                            ),
                          ),
                          Expanded(
                            child: CustomText(
                              username,
                              fontSize: 14,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: CustomText(
                              'Preferred Currency',
                              fontSize: 14,
                              color: customColors.onMuted,
                            ),
                          ),
                          Expanded(
                            child: CustomText(
                              preferredCurrencyCode,
                              fontSize: 14,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CustomText(
                              'Travel Interests',
                              fontSize: 14,
                              color: customColors.onMuted,
                            ),
                          ),
                          Expanded(
                            child: CustomText(
                              travelInterests.join(', '),
                              fontSize: 14,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GoBackButton(
                isDisabled: false,
                onTap: _prevPage,
                label: 'Back',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ContinueButton(
                isDisabled: false,
                onTap: () {
                  final username = context.read<OnboardingCubit>().state.name;
                  final travelInterests = context
                      .read<OnboardingCubit>()
                      .state
                      .selectedInterests!;
                  final selectedCurrencyDisplay = context
                      .read<OnboardingCubit>()
                      .state
                      .selectedCurrencyDisplay;
                  final preferredCurrencyCode = selectedCurrencyDisplay!
                      .split(' - ')
                      .first;

                  context.read<SetPrefsCubit>().setUsernamePref(username);
                  context.read<SetPrefsCubit>().setTravelInterestsPref(
                    travelInterests,
                  );
                  context.read<SetPrefsCubit>().setPreferredCurrency(
                    preferredCurrencyCode,
                  );
                  context.read<SetPrefsCubit>().setOnboardingCompleted(false);

                  context.router.replace(const NavigationBarShellRoute());
                },
                label: 'Get Started',
                icon: Amicons.remix_arrow_right_s,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column _thirdPageBuilder(BuildContext context) {
    final customColors = context.theme.customColors;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const CustomText(
          'What interests you?',
          fontSize: 24,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 8),
        CustomText(
          'Select your travel preferences',
          fontSize: 16,
          color: customColors.onMuted,
        ),
        const SizedBox(height: 32),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: availableTravelInterests.length,
          itemBuilder: (context, index) {
            return Builder(
              builder: (context) {
                return InterestTile(
                  isSelected:
                      context
                          .select<OnboardingCubit, List<String>?>(
                            (c) => c.state.selectedInterests,
                          )
                          ?.contains(
                            availableTravelInterests[index]['title']!,
                          ) ??
                      false,
                  emoji: availableTravelInterests[index]['emoji']!,
                  title: availableTravelInterests[index]['title']!,
                  onTap: () {
                    context.read<OnboardingCubit>().toggleInterest(
                      availableTravelInterests[index]['title']!,
                    );
                  },
                );
              },
            );
          },
        ),
        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GoBackButton(
                isDisabled: false,
                onTap: _prevPage,
                label: 'Back',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ContinueButton(
                isDisabled: !context.select<OnboardingCubit, bool>(
                  (c) => c.state.hasSelectedInterests,
                ),
                onTap: _nextPage,
                label: 'Continue',
                icon: Amicons.remix_arrow_right_s,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column _firstPageBuilder(BuildContext context) {
    final customColors = context.theme.customColors;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomText('✈️', fontSize: 60),
        const SizedBox(height: 22),
        const CustomText(
          'Welcome to Wanderly',
          fontSize: 30,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        CustomText(
          'Plan amazing trips and explore the world with ease.',
          fontSize: 16,
          color: customColors.onMuted,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        CustomTextField(
          controller: _nameController,
          validator: (_) {
            return null;
          },
          hint: CustomText(
            'Enter your name',
            fontSize: 16,
            color: customColors.onMuted,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GoBackButton(
                isDisabled: !context.select<OnboardingCubit, bool>(
                  (c) => c.state.hasName,
                ),
                onTap: () {
                  context.read<SetPrefsCubit>().setUsernamePref(
                    _nameController.text,
                  );
                  context.router.replace(const NavigationBarShellRoute());
                },
                label: 'Skip',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ContinueButton(
                isDisabled: !context.select<OnboardingCubit, bool>(
                  (c) => c.state.hasName,
                ),
                onTap: _nextPage,
                label: 'Continue',
                icon: Amicons.remix_arrow_right_s,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<String?> showCurrencyPicker(
    BuildContext context,
    List<String> currencies,
  ) async {
    final controller = TextEditingController();
    final customColors = context.theme.customColors;

    return showDialog<String>(
      context: context,
      builder: (context) {
        var filtered = currencies;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: customColors.card,
              title: CustomTextField(
                validator: (_) {
                  return null;
                },
                controller: controller,
                hint: CustomText(
                  'Search currencies...',
                  fontSize: 16,
                  color: customColors.onMuted,
                ),
                icon: Icons.search,
                onChanged: (value) {
                  setState(() {
                    filtered = currencies
                        .where(
                          (c) => c.toLowerCase().contains(value.toLowerCase()),
                        )
                        .toList();
                  });
                },
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final item = filtered[i];
                    return ListTile(
                      title: Text(item),
                      onTap: () => Navigator.pop(context, item),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _secondPageBuilder(BuildContext context) {
    final customColors = context.theme.customColors;

    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final selectedCurrency =
            state.selectedCurrencyDisplay ?? 'No currency selected';
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CustomText(
              'Choose your currency',
              fontSize: 24,
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 8),
            CustomText(
              'This will be used for budget planning',
              fontSize: 16,
              color: customColors.onMuted,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                border: Border.all(
                  color: customColors.primary.withValues(alpha: 0.2),
                ),
                color: customColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomText(
                    'Selected Currency',
                    fontSize: 14,
                    color: customColors.onMuted,
                  ),
                  const SizedBox(height: 8),
                  CustomText(
                    selectedCurrency,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const CustomText(
              'Search Currencies',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 8),
            SearchCurrencies(
              label: selectedCurrency == 'No currency selected'
                  ? 'Search from 100+ currencies...'
                  : selectedCurrency,
              onPressed: () async {
                final prefsState = context.read<SetPrefsCubit>().state;
                final String? selected;

                if (prefsState is! SetPrefsSuccess) {
                  selected = 'USD - United States Dollar';
                  context.read<OnboardingCubit>().selectCurrencyDisplay(
                    selected,
                  );
                  showErrorSnackBar(
                    context,
                    'Failed to load currencies, defaulting to USD, can be changed later in the settings.',
                  );
                  return;
                }
                final list = prefsState.currencies;
                if (list == null || list.isEmpty) {
                  selected = 'USD - United States Dollar';
                  context.read<OnboardingCubit>().selectCurrencyDisplay(
                    selected,
                  );
                  showErrorSnackBar(
                    context,
                    'Failed to load currencies, defaulting to USD, can be changed later in the settings.',
                  );
                  return;
                }

                selected = await showCurrencyPicker(
                  context,
                  list.map((c) => '${c.code} - ${c.name}').toList(),
                );
                if (selected != null && context.mounted) {
                  context.read<OnboardingCubit>().selectCurrencyDisplay(
                    selected,
                  );
                }
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GoBackButton(
                    isDisabled: false,
                    onTap: _prevPage,
                    label: 'Back',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ContinueButton(
                    isDisabled: !context.select<OnboardingCubit, bool>(
                      (c) => c.state.isCurrencySeelected,
                    ),
                    onTap: _nextPage,
                    label: 'Continue',
                    icon: Amicons.remix_arrow_right_s,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
