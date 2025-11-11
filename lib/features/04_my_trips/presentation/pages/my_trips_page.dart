import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanderly/core/route_config/app_router.gr.dart';
import 'package:wanderly/core/ui/custom_text.dart';
import 'package:wanderly/core/ui/error_widget.dart' as app_error;
import 'package:wanderly/core/ui/snackbars.dart';
import 'package:wanderly/features/04_my_trips/domain/entities/trip.dart';
import 'package:wanderly/features/04_my_trips/presentation/cubit/trips_planning_cubit.dart';
import 'package:wanderly/features/04_my_trips/presentation/cubit/trips_planning_state.dart';
import 'package:wanderly/features/04_my_trips/presentation/widgets/trip_card.dart';

@RoutePage()
class MyTripsPage extends StatefulWidget {
  const MyTripsPage({super.key});

  @override
  State<MyTripsPage> createState() => _MyTripsPageState();
}

class _MyTripsPageState extends State<MyTripsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16) +
                  const EdgeInsets.only(top: 12),
              child: const CustomText('My Trips', fontSize: 24),
            ),
            BlocBuilder<TripsPlanningCubit, TripsPlanningState>(
              builder: (context, state) {
                return switch (state) {
                  TripsPlanningInitial() => const SizedBox.shrink(),
                  TripsPlanningLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  TripsPlanningLoaded(:final trips) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CustomText(
                      '${trips.length} trips planned',
                      fontSize: 14,
                      color: const Color(0xFF717171),
                    ),
                  ),
                  TripsPlanningError(:final message) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: app_error.AppErrorWidget(
                      dense: true,
                      message: message,
                      onRetry: () =>
                          context.read<TripsPlanningCubit>().getAllTrips(),
                    ),
                  ),
                };
              },
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Colors.black),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: BlocBuilder<TripsPlanningCubit, TripsPlanningState>(
                  builder: (context, state) {
                    return switch (state) {
                      TripsPlanningInitial() => const SizedBox.shrink(),
                      TripsPlanningLoading() =>
                        const CircularProgressIndicator(),
                      TripsPlanningLoaded(:final trips) => _tripCardsBuilder(
                        trips,
                      ),
                      TripsPlanningError(:final message) =>
                        app_error.AppErrorWidget(
                          message: message,
                          onRetry: () =>
                              context.read<TripsPlanningCubit>().getAllTrips(),
                        ),
                    };
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tripCardsBuilder(List<Trip> trips) {
    if (trips.isEmpty) {
      return const Center(
        child: CustomText('No Trips!', fontSize: 32, color: Color(0xFF717171)),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];

        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final start = DateTime(
          trip.startDate.year,
          trip.startDate.month,
          trip.startDate.day,
        );
        final end = DateTime(
          trip.endDate.year,
          trip.endDate.month,
          trip.endDate.day,
        );

        final tripType = trip.isManuallyCompleted
            ? TripType.past
            : end.isBefore(start)
            ? TripType.past
            : today.isBefore(start)
            ? TripType.upcoming
            : today.isAfter(end)
            ? TripType.past
            : TripType.ongoing;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: TripCard(
            tripTitle: trip.title,
            countryName: trip.countryName,
            startDate: trip.startDate,
            endDate: trip.endDate,
            budget: trip.budget,
            currency: trip.budgetCurrency,
            tripType: tripType,
            daysUntilTrip: tripType == TripType.upcoming
                ? (trip.startDate.day - today.day).ceil()
                : null,
            onDelete: () {
              context.read<TripsPlanningCubit>().deleteTrip(trip.tripId);
              showSuccessSnackBar(context, 'Trip deleted');
            },
            onTap: () {
              context.router.push(
                TripDetailsRoute(trip: trip, tripType: tripType),
              );
            },
          ),
        );
      },
    );
  }
}
