import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanderly/core/presentation/cubits/exchange_rate/exchange_rate_cubit.dart';
import 'package:wanderly/core/presentation/cubits/favorites/favorites_cubit.dart';
import 'package:wanderly/core/presentation/cubits/profile_stats/profile_stats_cubit.dart';
import 'package:wanderly/core/presentation/cubits/settings/settings_cubit.dart';
import 'package:wanderly/core/presentation/cubits/settings/settings_state.dart';
import 'package:wanderly/core/route_config/app_router.dart';
import 'package:wanderly/core/theming/app_theme.dart';
import 'package:wanderly/features/04_my_trips/presentation/cubit/trips_planning_cubit.dart';
import 'package:wanderly/injection/injection.dart';

import 'injection/injection.dart' as dig;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await dig.init();
  final prefs = dig.di<SharedPreferencesWithCache>();
  final showOnboarding = prefs.getBool('onboarding_completed') ?? true;
  final appRouter = AppRouter(showOnboarding: showOnboarding);
  final isDarkMode = prefs.getBool('is_dark_mode') ?? false;

  runApp(MainApp(appRouter: appRouter, isDarkMode: isDarkMode));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key, required this.appRouter, required this.isDarkMode});

  final AppRouter appRouter;
  final bool isDarkMode;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.get<ExchangeRateCubit>()..fetchExchangeRate(),
        ),
        BlocProvider(
          create: (_) => di.get<FavoritesCubit>()..fetchFavoriteCountries(),
        ),
        BlocProvider(
          create: (_) => di.get<TripsPlanningCubit>()..getAllTrips(),
        ),
        BlocProvider(create: (_) => di.get<SettingsCubit>()),
        BlocProvider(create: (_) => di.get<ProfileStatsCubit>()..load()),
      ],
      child: BlocListener<SettingsCubit, SettingsState>(
        listenWhen: (previous, current) => previous.isDarkMode != current.isDarkMode,
        listener: (context, state) {
          setState(() {
            _themeMode = state.isDarkMode ? ThemeMode.dark : ThemeMode.light;
          });
        },
        child: MaterialApp.router(
            title: 'Wanderly',
            routerConfig: widget.appRouter.config(
              navigatorObservers: () => [di.get<AutoRouteObserver>()],
            ),
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: _themeMode,
            themeAnimationDuration: const Duration(milliseconds: 500),
            themeAnimationCurve: Curves.easeInOut,
            scrollBehavior: const MaterialScrollBehavior().copyWith(
              overscroll: false,
            ),
          ),
      ),
    );
  }
}
