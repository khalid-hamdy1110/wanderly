import 'package:amicons/amicons.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wanderly/core/route_config/app_router.gr.dart';
import 'package:wanderly/core/theming/theme_extensions.dart';

@RoutePage()
class NavigationBarShellPage extends StatelessWidget {
  const NavigationBarShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    final customColors = context.theme.customColors;

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
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: customColors.border)),
            ),
            clipBehavior: Clip.hardEdge,
            child: NavigationBar(
              backgroundColor: customColors.card,
              indicatorColor: customColors.primary.withValues(alpha: 0),
              elevation: 20,
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              labelTextStyle: WidgetStatePropertyAll(
                GoogleFonts.arimo(
                  fontSize: 12,
                  color: customColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              labelPadding: const EdgeInsets.all(0),
              selectedIndex: AutoTabsRouter.of(context).activeIndex,
              onDestinationSelected: context.tabsRouter.setActiveIndex,
              destinations: [
                NavigationDestination(
                  icon: Icon(
                    Amicons.lucide_house,
                    size: 26,
                    color: customColors.onMuted,
                  ),
                  selectedIcon: Icon(
                    Amicons.lucide_house,
                    size: 26,
                    color: customColors.primary,
                  ),
                  label: 'Explore',
                ),
                NavigationDestination(
                  icon: Icon(
                    Amicons.lucide_heart,
                    size: 26,
                    color: customColors.onMuted,
                  ),
                  selectedIcon: Icon(
                    Amicons.lucide_heart,
                    size: 26,
                    color: customColors.primary,
                  ),
                  label: 'Favorites',
                ),
                NavigationDestination(
                  icon: Icon(
                    Amicons.lucide_briefcase,
                    size: 26,
                    color: customColors.onMuted,
                  ),
                  selectedIcon: Icon(
                    Amicons.lucide_briefcase,
                    size: 26,
                    color: customColors.primary,
                  ),
                  label: 'My Trips',
                ),
                NavigationDestination(
                  icon: Icon(
                    Amicons.lucide_user,
                    size: 26,
                    color: customColors.onMuted,
                  ),
                  selectedIcon: Icon(
                    Amicons.lucide_user,
                    size: 26,
                    color: customColors.primary,
                  ),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
