import 'package:auto_route/auto_route.dart';
import 'package:wanderly/core/route_config/app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter({super.navigatorKey, required this.showOnboarding});

  final bool showOnboarding;

  @override
  RouteType get defaultRouteType => RouteType.custom(
    duration: const Duration(milliseconds: 300),
    reverseDuration: const Duration(milliseconds: 300),
    transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
  );

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: OnboardingRoute.page, initial: showOnboarding),
    AutoRoute(
      page: NavigationBarShellRoute.page,
      initial: !showOnboarding,
      children: [
        AutoRoute(page: ExploreRoute.page, initial: true),
        AutoRoute(page: FavoritesRoute.page),
        AutoRoute(page: MyTripsRoute.page),
        AutoRoute(page: ProfileRoute.page),
      ],
    ),
    AutoRoute(page: DestinationDetailsRoute.page),
    AutoRoute(page: TripsPlanningRoute.page),
    AutoRoute(page: TripDetailsRoute.page),
  ];
}
