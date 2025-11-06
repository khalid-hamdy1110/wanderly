// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i10;
import 'package:flutter/material.dart' as _i11;
import 'package:wanderly/core/domain/entities/country.dart' as _i12;
import 'package:wanderly/core/ui/navigation_bar_shell_page.dart' as _i5;
import 'package:wanderly/features/01_onboarding/presentation/pages/onboarding_page.dart'
    as _i6;
import 'package:wanderly/features/02_explore/presentation/pages/destination_details_page.dart'
    as _i1;
import 'package:wanderly/features/02_explore/presentation/pages/explore_page.dart'
    as _i2;
import 'package:wanderly/features/04_my_trips/presentation/pages/trips_planning_page.dart'
    as _i9;
import 'package:wanderly/features/03_favorites/presentation/pages/favorites_page.dart'
    as _i3;
import 'package:wanderly/features/04_my_trips/presentation/pages/my_trips_page.dart'
    as _i4;
import 'package:wanderly/features/04_my_trips/presentation/pages/trip_details_page.dart'
    as _i8;
import 'package:wanderly/features/05_profile/presentation/pages/profile_page.dart'
    as _i7;

/// generated route for
/// [_i1.DestinationDetailsPage]
class DestinationDetailsRoute
    extends _i10.PageRouteInfo<DestinationDetailsRouteArgs> {
  DestinationDetailsRoute({
    _i11.Key? key,
    required _i12.Country country,
    required bool isFavorite,
    required _i11.VoidCallback onFavorite,
    List<_i10.PageRouteInfo>? children,
  }) : super(
         DestinationDetailsRoute.name,
         args: DestinationDetailsRouteArgs(
           key: key,
           country: country,
           isFavorite: isFavorite,
           onFavorite: onFavorite,
         ),
         initialChildren: children,
       );

  static const String name = 'DestinationDetailsRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DestinationDetailsRouteArgs>();
      return _i1.DestinationDetailsPage(
        key: args.key,
        country: args.country,
        isFavorite: args.isFavorite,
        onFavorite: args.onFavorite,
      );
    },
  );
}

class DestinationDetailsRouteArgs {
  const DestinationDetailsRouteArgs({
    this.key,
    required this.country,
    required this.isFavorite,
    required this.onFavorite,
  });

  final _i11.Key? key;

  final _i12.Country country;

  final bool isFavorite;

  final _i11.VoidCallback onFavorite;

  @override
  String toString() {
    return 'DestinationDetailsRouteArgs{key: $key, country: $country, isFavorite: $isFavorite, onFavorite: $onFavorite}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DestinationDetailsRouteArgs) return false;
    return key == other.key &&
        country == other.country &&
        isFavorite == other.isFavorite &&
        onFavorite == other.onFavorite;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      country.hashCode ^
      isFavorite.hashCode ^
      onFavorite.hashCode;
}

/// generated route for
/// [_i2.ExplorePage]
class ExploreRoute extends _i10.PageRouteInfo<void> {
  const ExploreRoute({List<_i10.PageRouteInfo>? children})
    : super(ExploreRoute.name, initialChildren: children);

  static const String name = 'ExploreRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i2.ExplorePage();
    },
  );
}

/// generated route for
/// [_i3.FavoritesPage]
class FavoritesRoute extends _i10.PageRouteInfo<void> {
  const FavoritesRoute({List<_i10.PageRouteInfo>? children})
    : super(FavoritesRoute.name, initialChildren: children);

  static const String name = 'FavoritesRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i3.FavoritesPage();
    },
  );
}

/// generated route for
/// [_i4.MyTripsPage]
class MyTripsRoute extends _i10.PageRouteInfo<void> {
  const MyTripsRoute({List<_i10.PageRouteInfo>? children})
    : super(MyTripsRoute.name, initialChildren: children);

  static const String name = 'MyTripsRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i4.MyTripsPage();
    },
  );
}

/// generated route for
/// [_i5.NavigationBarShellPage]
class NavigationBarShellRoute extends _i10.PageRouteInfo<void> {
  const NavigationBarShellRoute({List<_i10.PageRouteInfo>? children})
    : super(NavigationBarShellRoute.name, initialChildren: children);

  static const String name = 'NavigationBarShellRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i5.NavigationBarShellPage();
    },
  );
}

/// generated route for
/// [_i6.OnboardingPage]
class OnboardingRoute extends _i10.PageRouteInfo<void> {
  const OnboardingRoute({List<_i10.PageRouteInfo>? children})
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i6.OnboardingPage();
    },
  );
}

/// generated route for
/// [_i7.ProfilePage]
class ProfileRoute extends _i10.PageRouteInfo<void> {
  const ProfileRoute({List<_i10.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i7.ProfilePage();
    },
  );
}

/// generated route for
/// [_i8.TripDetailsPage]
class TripDetailsRoute extends _i10.PageRouteInfo<void> {
  const TripDetailsRoute({List<_i10.PageRouteInfo>? children})
    : super(TripDetailsRoute.name, initialChildren: children);

  static const String name = 'TripDetailsRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i8.TripDetailsPage();
    },
  );
}

/// generated route for
/// [_i9.TripsPlanningPage]
class TripsPlanningRoute extends _i10.PageRouteInfo<void> {
  const TripsPlanningRoute({List<_i10.PageRouteInfo>? children})
    : super(TripsPlanningRoute.name, initialChildren: children);

  static const String name = 'TripsPlanningRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i9.TripsPlanningPage();
    },
  );
}
