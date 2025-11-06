import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:wanderly/core/route_config/app_router.gr.dart';

@RoutePage()
class NavigationBarShellPage extends StatelessWidget {
  const NavigationBarShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        ExploreRoute(),
        FavoritesRoute(),
        MyTripsRoute(),
        ProfileRoute(),
      ],
      builder: (context, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: NavigationBar(
            selectedIndex: AutoTabsRouter.of(context).activeIndex,
            onDestinationSelected: context.tabsRouter.setActiveIndex,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.explore),
                label: 'Explore',
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite),
                label: 'Favorites',
              ),
              NavigationDestination(
                icon: Icon(Icons.card_travel),
                label: 'My Trips',
              ),
              NavigationDestination(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      }
    );
  }
}
