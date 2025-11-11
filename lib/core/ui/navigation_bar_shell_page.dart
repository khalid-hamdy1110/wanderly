import 'package:amicons/amicons.dart';
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
            backgroundColor: Colors.white,
            indicatorColor: const Color.fromRGBO(225, 29, 72, 0.1),
            elevation: 20,
            height: 64,
            selectedIndex: AutoTabsRouter.of(context).activeIndex,
            onDestinationSelected: context.tabsRouter.setActiveIndex,
            destinations: const [
              NavigationDestination(
                icon: Icon(
                  Amicons.remix_compass_discover,
                  size: 26,
                  color: Color(0xFF717171),
                ),
                selectedIcon: Icon(
                  Amicons.remix_compass_discover,
                  size: 26,
                  color: Color(0xFFFF385C),
                ),
                label: 'Explore',
              ),
              NavigationDestination(
                icon: Icon(
                  Amicons.remix_heart,
                  size: 26,
                  color: Color(0xFF717171),
                ),
                selectedIcon: Icon(
                  Amicons.remix_heart,
                  size: 26,
                  color: Color(0xFFFF385C),
                ),
                label: 'Favorites',
              ),
              NavigationDestination(
                icon: Icon(
                  Amicons.remix_suitcase,
                  size: 26,
                  color: Color(0xFF717171),
                ),
                selectedIcon: Icon(
                  Amicons.remix_suitcase,
                  size: 26,
                  color: Color(0xFFFF385C),
                ),
                label: 'My Trips',
              ),
              NavigationDestination(
                icon: Icon(
                  Amicons.remix_user,
                  size: 26,
                  color: Color(0xFF717171),
                ),
                selectedIcon: Icon(
                  Amicons.remix_user,
                  size: 26,
                  color: Color(0xFFFF385C),
                ),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
