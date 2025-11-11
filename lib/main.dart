import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanderly/core/presentation/cubits/exchange_rate/exchange_rate_cubit.dart';
import 'package:wanderly/core/presentation/cubits/favorites/favorites_cubit.dart';
import 'package:wanderly/core/presentation/cubits/profile_stats/profile_stats_cubit.dart';
import 'package:wanderly/core/presentation/cubits/settings/settings_cubit.dart';
import 'package:wanderly/core/route_config/app_router.dart';
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

  final appRouteObserver = dig.di<AutoRouteObserver>();
  MaterialApp.router(
    routerConfig: appRouter.config(
      navigatorObservers: () => [appRouteObserver],
    ),
  );

  runApp(MainApp(appRouter: appRouter));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.get<ExchangeRateCubit>()..fetchExchangeRate()),
        BlocProvider(create: (_) => di.get<FavoritesCubit>()..fetchFavoriteCountries()),
        BlocProvider(create: (_) => di.get<TripsPlanningCubit>()..getAllTrips()),
        BlocProvider(create: (_) => di.get<SettingsCubit>()),
        BlocProvider(create: (_) => di.get<ProfileStatsCubit>()..load()),
      ],
      child: MaterialApp.router(
        title: 'Wanderly',
        routerConfig: widget.appRouter.config(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
