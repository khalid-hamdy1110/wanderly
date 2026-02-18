import 'package:amicons/amicons.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wanderly/core/constants/expenses_categories.dart';
import 'package:wanderly/core/data/models/exchange_rate_model.dart';
import 'package:wanderly/core/domain/entities/country.dart';
import 'package:wanderly/core/domain/entities/exchange_rate.dart';
import 'package:wanderly/core/presentation/cubits/exchange_rate/exchange_rate_cubit.dart';
import 'package:wanderly/core/presentation/cubits/exchange_rate/exchange_rate_state.dart';
import 'package:wanderly/core/theming/theme_extensions.dart';
import 'package:wanderly/core/ui/custom_text.dart';
import 'package:wanderly/core/ui/custom_text_field.dart';
import 'package:wanderly/core/ui/snackbars.dart';
import 'package:wanderly/core/ui/weather_card.dart';
import 'package:wanderly/features/02_explore/domain/entities/country_weather.dart';
import 'package:wanderly/features/02_explore/presentation/cubit/destination_details/destination_details_state.dart';
import 'package:wanderly/features/02_explore/presentation/cubit/destination_details/weather_cubit.dart';
import 'package:wanderly/features/04_my_trips/domain/entities/expense.dart';
import 'package:wanderly/features/04_my_trips/domain/entities/trip.dart';
import 'package:wanderly/features/04_my_trips/presentation/cubit/trip_expenses_cubit.dart';
import 'package:wanderly/features/04_my_trips/presentation/cubit/trip_expenses_state.dart';
import 'package:wanderly/features/04_my_trips/presentation/cubit/trips_planning_cubit.dart';
import 'package:wanderly/features/04_my_trips/presentation/cubit/trips_planning_state.dart';
import 'package:wanderly/features/04_my_trips/presentation/widgets/budget_tiles.dart';
import 'package:wanderly/features/04_my_trips/presentation/widgets/budget_usage_progress_painter.dart';
import 'package:wanderly/features/04_my_trips/presentation/widgets/custom_date_picker.dart';
import 'package:wanderly/features/04_my_trips/presentation/widgets/trip_card.dart';
import 'package:wanderly/injection/injection.dart';

@RoutePage()
class TripDetailsPage extends StatefulWidget {
  const TripDetailsPage({
    super.key,
    required this.trip,
    required this.tripType,
  });

  final Trip trip;
  final TripType tripType;

  @override
  State<TripDetailsPage> createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends State<TripDetailsPage> {
  final DateFormat dateFormatter = DateFormat('MMM dd, yyyy');
  final Set<int> _removingExpenseIds = <int>{};
  static const Duration _removeAnimDuration = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    final customColors = context.theme.customColors;
    final Trip trip = context.select<TripsPlanningCubit, Trip>(
      (cubit) => cubit.state is TripsPlanningLoaded
          ? (cubit.state as TripsPlanningLoaded).trips.firstWhere(
              (t) => t.tripId == widget.trip.tripId,
              orElse: () => widget.trip,
            )
          : widget.trip,
    );

    final double countryLatitude = trip.countryLatitude;
    final double countryLongitude = trip.countryLongitude;
    final Country country = Country(
      code: 'UNK',
      flagUrl: '',
      name: trip.countryName,
      latitude: countryLatitude,
      longitude: countryLongitude,
      capital: '',
      region: '',
      population: 0,
      languages: const [],
      currencies: const [],
      timezones: const [],
    );

    return Scaffold(
      backgroundColor: customColors.background,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) =>
                di.get<TripExpensesCubit>()..loadExpenses(trip.tripId),
          ),
          BlocProvider(
            create: (_) => di.get<WeatherCubit>()..loadCountryWeather(country),
          ),
        ],
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Amicons.remix_arrow_left,
                          size: 20,
                          color: customColors.onMuted,
                        ),
                        const SizedBox(width: 8),
                        CustomText(
                          'Back',
                          fontSize: 14,
                          color: customColors.onMuted,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        trip.title,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: customColors.card,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: customColors.border),
                        ),
                        child: Material(
                          type: MaterialType.transparency,
                          child: InkWell(
                            onTap: () => _showEditDialog(context, trip),
                            borderRadius: BorderRadius.circular(999),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 8,
                              ),
                              child: Icon(
                                Amicons.remix_edit,
                                size: 18,
                                color: customColors.onCard,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomText(
                    trip.countryName,
                    fontSize: 14,
                    color: customColors.onMuted,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          '${dateFormatter.format(trip.startDate)} - ${dateFormatter.format(trip.endDate)}',
                          fontSize: 14,
                          color: customColors.onMuted,
                        ),
                      ),
                      if (trip.isManuallyCompleted ||
                          widget.tripType != TripType.past)
                        Container(
                          decoration: BoxDecoration(
                            color: customColors.card,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: customColors.border),
                          ),
                          child: Material(
                            type: MaterialType.transparency,
                            child: InkWell(
                              onTap: () {
                                Trip updatedTrip = Trip(
                                  tripId: trip.tripId,
                                  title: trip.title,
                                  countryName: trip.countryName,
                                  countryLatitude: trip.countryLatitude,
                                  countryLongitude: trip.countryLongitude,
                                  startDate: trip.startDate,
                                  endDate: trip.endDate,
                                  budget: trip.budget,
                                  budgetCurrency: trip.budgetCurrency,
                                  destinationCurrency: trip.destinationCurrency,
                                  notes: trip.notes,
                                  isManuallyCompleted:
                                      !trip.isManuallyCompleted,
                                );

                                context.read<TripsPlanningCubit>().updateTrip(
                                  updatedTrip,
                                );
                                if (mounted) {
                                  showSuccessSnackBar(
                                    context,
                                    updatedTrip.isManuallyCompleted
                                        ? 'Trip marked completed'
                                        : 'Trip marked incomplete',
                                  );
                                }
                              },
                              borderRadius: BorderRadius.circular(999),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 8,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      !trip.isManuallyCompleted
                                          ? Amicons.remix_checkbox_circle
                                          : Amicons.remix_checkbox_circle_fill,
                                      size: 18,
                                      color: trip.isManuallyCompleted
                                          ? customColors.success
                                          : customColors.onCard,
                                    ),
                                    const SizedBox(width: 8),
                                    CustomText(
                                      trip.isManuallyCompleted
                                          ? 'Completed'
                                          : 'Complete',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: customColors.onCard,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomText(
                    trip.notes == null || trip.notes!.isEmpty
                        ? 'No additional notes.'
                        : trip.notes!,
                    fontSize: 14,
                    color: customColors.onMuted,
                  ),
                ),
                const SizedBox(height: 12),

                Divider(height: 0, color: customColors.border),

                Expanded(
                  child: BlocBuilder<TripExpensesCubit, TripExpensesState>(
                    builder: (context, state) {
                      return switch (state) {
                        TripExpensesInitial() => const SizedBox.shrink(),
                        TripExpensesLoading() => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        TripExpensesLoaded(:final expenses) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: CustomScrollView(
                            slivers: [
                              const SliverToBoxAdapter(
                                child: SizedBox(height: 16),
                              ),
                              const SliverToBoxAdapter(
                                child: CustomText(
                                  'Weather',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SliverToBoxAdapter(
                                child: SizedBox(height: 16),
                              ),
                              SliverToBoxAdapter(
                                child:
                                    BlocBuilder<
                                      WeatherCubit,
                                      DestinationDetailsState<CountryWeather>
                                    >(
                                      builder: (context, state) {
                                        return WeatherCard(state: state);
                                      },
                                    ),
                              ),
                              const SliverToBoxAdapter(
                                child: SizedBox(height: 22),
                              ),
                              const SliverToBoxAdapter(
                                child: CustomText(
                                  'Budget',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SliverToBoxAdapter(
                                child: SizedBox(height: 16),
                              ),
                              SliverToBoxAdapter(
                                child: TweenAnimationBuilder(
                                  tween: Tween<double>(
                                    begin: 0,
                                    end: _getBudgetUsage(expenses, trip),
                                  ),
                                  duration: const Duration(milliseconds: 800),
                                  builder: (context, value, child) {
                                    return CustomPaint(
                                      painter: BudgetUsageProgressPainter(
                                        progress: value,
                                        backgroundColor: customColors.accent,
                                        fillColor: value >= 1
                                            ? const Color(0xFFE11D48)
                                            : value >= 0.75
                                            ? const Color(0xFFFBBF24)
                                            : const Color(0xFF34D399),
                                      ),
                                      child: const SizedBox(height: 12),
                                    );
                                  },
                                ),
                              ),
                              const SliverToBoxAdapter(
                                child: SizedBox(height: 8),
                              ),
                              SliverToBoxAdapter(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CustomText(
                                      '${(_getBudgetUsage(expenses, trip) * 100).toInt().clamp(0, 100)}% used',
                                      fontSize: 12,
                                      color: customColors.onMuted,
                                    ),
                                  ],
                                ),
                              ),
                              const SliverToBoxAdapter(
                                child: SizedBox(height: 16),
                              ),

                              SliverToBoxAdapter(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: BudgetTiles(
                                        title: 'Budget',
                                        amount: trip.budget,
                                        currency: trip.budgetCurrency,
                                        color: customColors.secondary,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: BudgetTiles(
                                        title: 'Spent',
                                        amount: _getBudgetSpent(expenses),
                                        currency: trip.budgetCurrency,
                                        color: customColors.secondary,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: BudgetTiles(
                                        title: 'Left',
                                        amount: _getBudgetLeft(expenses, trip),
                                        currency: trip.budgetCurrency,
                                        color:
                                            _getBudgetUsage(expenses, trip) >= 1
                                            ? customColors.destructive
                                                  .withValues(alpha: 0.2)
                                            : customColors.success.withValues(
                                                alpha: 0.2,
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SliverToBoxAdapter(
                                child: SizedBox(height: 20),
                              ),

                              SliverToBoxAdapter(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const CustomText(
                                      'Expenses',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: customColors.primary,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(999),
                                        ),
                                      ),
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: InkWell(
                                          onTap: () => _showAddExpenseDialog(
                                            context,
                                            trip,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(999),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 6,
                                              horizontal: 12,
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Amicons.remix_add,
                                                  size: 16,
                                                  color: customColors.onPrimary,
                                                ),
                                                const SizedBox(width: 4),
                                                CustomText(
                                                  'Add',
                                                  fontSize: 14,
                                                  color: customColors.onPrimary,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SliverToBoxAdapter(
                                child: SizedBox(height: 12),
                              ),

                              expenses.isEmpty
                                  ? SliverFillRemaining(
                                      hasScrollBody: false,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: expenses.isEmpty
                                              ? customColors.accent
                                              : customColors.background,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const CustomText(
                                                '💰',
                                                fontSize: 40,
                                              ),
                                              const SizedBox(height: 12),
                                              CustomText(
                                                'No expenses yet.',
                                                fontSize: 16,
                                                color:
                                                    customColors.onBackground,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : SliverList.builder(
                                      itemCount: expenses.length,
                                      itemBuilder: (context, index) {
                                        final expense = expenses[index];
                                        return _buildExpenseTile(
                                          expense,
                                          trip,
                                          context,
                                        );
                                      },
                                    ),
                            ],
                          ),
                        ),
                        TripExpensesError(:final message) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: CustomText(
                            'Error: $message',
                            fontSize: 14,
                            color: customColors.onMuted,
                          ),
                        ),
                      };
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpenseTile(Expense expense, Trip trip, BuildContext context) {
    final bool isRemoving = _removingExpenseIds.contains(expense.id);
    final customColors = context.theme.customColors;

    return AnimatedSize(
      duration: _removeAnimDuration,
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: AnimatedOpacity(
        key: ValueKey('expense_${expense.id}'),
        duration: _removeAnimDuration,
        curve: Curves.easeInOut,
        opacity: isRemoving ? 0 : 1,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: customColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: customColors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomText(
                          '${expense.category}  • ',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: customColors.onCard,
                        ),
                        CustomText(
                          DateFormat('dd MMM yyyy').format(expense.date),
                          fontSize: 12,
                          color: customColors.onMuted,
                        ),
                      ],
                    ),
                    CustomText(
                      expense.title,
                      fontSize: 12,
                      color: customColors.onMuted,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomText(
                    '${expense.amount.toStringAsFixed(2)} ${trip.budgetCurrency}',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  BlocBuilder<ExchangeRateCubit, ExchangeRateState>(
                    builder: (context, state) {
                      if (state is ExchangeRateLoading) {
                        return CustomText(
                          'Loading...',
                          fontSize: 12,
                          color: customColors.onMuted,
                        );
                      } else if (state is ExchangeRateLoaded) {
                        final exchangeRate = state.exchangeRate;
                        final convertedAmount =
                            expense.amount *
                            _getExchangeRateFor(
                              exchangeRate,
                              widget.trip.destinationCurrency,
                            ) /
                            _getExchangeRateFor(
                              exchangeRate,
                              widget.trip.budgetCurrency,
                            );
                        return CustomText(
                          '≈ ${convertedAmount.toStringAsFixed(2)} ${trip.destinationCurrency}',
                          fontSize: 12,
                          color: customColors.onMuted,
                        );
                      } else {
                        return CustomText(
                          'N/A',
                          fontSize: 12,
                          color: customColors.onMuted,
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: isRemoving
                      ? null
                      : () async {
                          setState(() {
                            _removingExpenseIds.add(expense.id);
                          });
                          await Future.delayed(_removeAnimDuration);
                          if (!context.mounted) return;
                          try {
                            context
                                .read<TripExpensesCubit>()
                                .deleteExistingExpense(expense.id, trip.tripId);
                            if (mounted) {
                              showSuccessSnackBar(context, 'Expense removed');
                            }
                          } catch (e) {
                            if (mounted) {
                              showErrorSnackBar(
                                context,
                                'Failed to remove expense',
                              );
                            }
                          } finally {
                            // Restore visibility state (removed if success, visible if failure)
                            if (mounted) {
                              setState(() {
                                _removingExpenseIds.remove(expense.id);
                              });
                            }
                          }
                        },
                  child: Icon(
                    Amicons.remix_delete_bin,
                    color: customColors.destructive,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getExchangeRateFor(List<ExchangeRate> exchangeRate, String currency) {
    return exchangeRate
        .firstWhere(
          (rate) => rate.currency == currency,
          orElse: () => const ExchangeRateModel(currency: 'USD', rate: 1),
        )
        .rate;
  }

  Future<void> _showAddExpenseDialog(
    BuildContext cubitContext,
    Trip trip,
  ) async {
    final customColors = cubitContext.theme.customColors;
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController();
    String selectedCategory = 'Other';
    final descriptionController = TextEditingController();
    DateTime? expenseDate;
    final formatter = DateFormat('dd/MM/yyyy');

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            return AlertDialog(
              title: const CustomText(
                'Add Expense',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              backgroundColor: customColors.card,
              content: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  width: double.maxFinite,
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 22),
                        CustomText(
                          'Amount (${trip.budgetCurrency})',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.start,
                          color: customColors.onCard,
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an amount';
                            }
                            final amount = double.tryParse(value);
                            if (amount == null || amount <= 0) {
                              return 'Please enter a valid amount';
                            }
                            return null;
                          },
                          hint: CustomText(
                            0.00.toString(),
                            fontSize: 16,
                            color: customColors.textFieldPlaceholder,
                          ),
                          controller: amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                        const SizedBox(height: 16),

                        CustomText(
                          'Category',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.start,
                          color: customColors.onCard,
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          initialValue: 'Other',
                          dropdownColor: customColors.card,
                          items: expenseCategories
                              .map(
                                (category) => DropdownMenuItem<String>(
                                  value: category,
                                  child: CustomText(category, fontSize: 14),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            selectedCategory = value!;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            filled: true,
                            fillColor: customColors.secondary,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        const CustomText(
                          'Description',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                          hint: CustomText(
                            'Enter a description',
                            fontSize: 16,
                            color: customColors.textFieldPlaceholder,
                          ),
                          controller: descriptionController,
                          keyboardType: TextInputType.text,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),

                        const CustomText(
                          'Date',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 8),
                        CustomDatePicker(
                          label: expenseDate != null
                              ? formatter.format(expenseDate!)
                              : 'mm/dd/yyyy',
                          icon: Amicons.remix_calendar,
                          onPressed: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: expenseDate ?? DateTime.now(),
                              firstDate: DateTime(trip.startDate.year),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              setLocalState(() {
                                expenseDate = selectedDate;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: CustomText(
                                  'Cancel',
                                  color: customColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: customColors.primary,
                                ),
                                onPressed: () async {
                                  if (!formKey.currentState!.validate()) return;
                                  final amount = double.parse(
                                    amountController.text,
                                  );

                                  try {
                                    cubitContext
                                        .read<TripExpensesCubit>()
                                        .addNewExpense(
                                          Expense(
                                            id: 0,
                                            tripId: trip.tripId,
                                            amount: amount,
                                            category: selectedCategory,
                                            title: descriptionController.text,
                                            date: expenseDate ?? DateTime.now(),
                                          ),
                                        );

                                    if (mounted) {
                                      Navigator.of(context).pop();
                                      showSuccessSnackBar(
                                        context,
                                        'Expense added',
                                      );
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      showErrorSnackBar(
                                        context,
                                        'Failed to add expense',
                                      );
                                    }
                                  }
                                },
                                child: CustomText(
                                  'Add',
                                  fontWeight: FontWeight.bold,
                                  color: customColors.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showEditDialog(BuildContext cubitContext, Trip trip) async {
    final customColors = cubitContext.theme.customColors;
    final formKey = GlobalKey<FormState>();
    final tripNameController = TextEditingController(text: trip.title);
    final budgetController = TextEditingController(
      text: trip.budget.toStringAsFixed(2),
    );
    final noteController = TextEditingController(text: trip.notes ?? '');

    DateTime? startDate = trip.startDate;
    DateTime? endDate = trip.endDate;
    bool showDateError = false;
    final formatter = DateFormat('dd/MM/yyyy');

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            final hasError =
                startDate == null ||
                endDate == null ||
                endDate!.isBefore(startDate!);

            return AlertDialog(
              title: const CustomText(
                'Edit Trip Details',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              backgroundColor: customColors.background,
              content: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  width: double.maxFinite,
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          'Trip Name',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: customColors.onBackground,
                        ),
                        const SizedBox(height: 8.0),
                        CustomTextField(
                          controller: tripNameController,
                          keyboardType: TextInputType.text,
                          hint: CustomText(
                            'Enter trip name',
                            fontSize: 16,
                            color: customColors.textFieldPlaceholder,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name for your trip';
                            }
                            return null;
                          },
                          icon: Amicons.remix_pencil_fill,
                        ),
                        const SizedBox(height: 20.0),

                        const Row(
                          children: [
                            Expanded(
                              child: CustomText(
                                'Start Date',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 12.0),
                            Expanded(
                              child: CustomText(
                                'End Date',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            Expanded(
                              child: CustomDatePicker(
                                hasError: hasError || showDateError,
                                label: startDate != null
                                    ? formatter.format(startDate!)
                                    : ' - ',
                                icon: Amicons.remix_calendar,
                                onPressed: () async {
                                  final selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate: startDate ?? DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100),
                                  );
                                  if (selectedDate != null) {
                                    setLocalState(() {
                                      startDate = selectedDate;
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomDatePicker(
                                disabled: startDate == null,
                                hasError: hasError || showDateError,
                                label: endDate != null
                                    ? formatter.format(endDate!)
                                    : ' - ',
                                icon: Amicons.remix_calendar,
                                onPressed: () async {
                                  final selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        endDate ?? startDate ?? DateTime.now(),
                                    firstDate: startDate ?? DateTime.now(),
                                    lastDate: DateTime(2100),
                                  );
                                  if (selectedDate != null) {
                                    setLocalState(() {
                                      endDate = selectedDate;
                                      showDateError = false;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),

                        if (hasError || showDateError)
                          Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Amicons.remix_error_warning,
                                      size: 14,
                                      color: customColors.destructive,
                                    ),
                                    const SizedBox(width: 4),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: CustomText(
                                        'Please select valid start and end dates.',
                                        color: customColors.destructive,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .animate()
                              .slideY(
                                begin: -0.5,
                                end: 0.0,
                                curve: Curves.easeOut,
                              )
                              .fadeIn(duration: 300.ms),
                        const SizedBox(height: 20.0),

                        CustomText(
                          'Estimated Budget (${trip.budgetCurrency})',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: customColors.onBackground,
                        ),
                        const SizedBox(height: 8.0),
                        CustomTextField(
                          controller: budgetController,
                          hint: CustomText(
                            'Enter amount',
                            fontSize: 16,
                            color: customColors.textFieldPlaceholder,
                          ),
                          keyboardType: TextInputType.number,
                          icon: Amicons.remix_currency,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a budget';
                            }
                            final number = double.tryParse(value);
                            if (number == null || number <= 0) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),

                        CustomText(
                          'Notes (Optional)',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: customColors.onBackground,
                        ),
                        const SizedBox(height: 8.0),
                        CustomTextField(
                          controller: noteController,
                          hint: CustomText(
                            'Enter additional notes...',
                            fontSize: 16,
                            color: customColors.textFieldPlaceholder,
                          ),
                          minLines: 3,
                          maxLines: 9,
                          validator: (_) {
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),

                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: CustomText(
                                  'Cancel',
                                  color: customColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: customColors.primary,
                                ),
                                onPressed: () async {
                                  if (!formKey.currentState!.validate()) return;
                                  if (hasError) {
                                    setLocalState(() {
                                      showDateError = true;
                                    });
                                    return;
                                  }

                                  try {
                                    final updatedTrip = Trip(
                                      tripId: trip.tripId,
                                      title: tripNameController.text,
                                      startDate: startDate!,
                                      endDate: endDate!,
                                      countryName: trip.countryName,
                                      countryLatitude: trip.countryLatitude,
                                      countryLongitude: trip.countryLongitude,
                                      budget: double.parse(
                                        budgetController.text,
                                      ),
                                      budgetCurrency: trip.budgetCurrency,
                                      destinationCurrency:
                                          trip.destinationCurrency,
                                      notes: noteController.text,
                                      isManuallyCompleted:
                                          trip.isManuallyCompleted,
                                    );

                                    cubitContext
                                        .read<TripsPlanningCubit>()
                                        .updateTrip(updatedTrip);

                                    if (mounted) Navigator.of(context).pop();
                                    if (mounted) {
                                      showSuccessSnackBar(
                                        context,
                                        'Trip updated',
                                      );
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      showErrorSnackBar(
                                        context,
                                        'Failed to update trip',
                                      );
                                    }
                                  }
                                },
                                child: CustomText(
                                  'Edit',
                                  fontWeight: FontWeight.bold,
                                  color: customColors.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  double _getBudgetUsage(List<Expense> expenses, Trip trip) {
    return expenses.isEmpty
        ? 0
        : expenses.map((e) => e.amount).reduce((a, b) => a + b) / trip.budget;
  }

  double _getBudgetSpent(List<Expense> expenses) {
    return expenses.isEmpty
        ? 0
        : expenses.map((e) => e.amount).reduce((a, b) => a + b);
  }

  double _getBudgetLeft(List<Expense> expenses, Trip trip) {
    return trip.budget - _getBudgetSpent(expenses);
  }
}
