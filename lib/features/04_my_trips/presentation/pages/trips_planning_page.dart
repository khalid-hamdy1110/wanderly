import 'package:amicons/amicons.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wanderly/core/domain/entities/country.dart';
import 'package:wanderly/core/domain/entities/exchange_rate.dart';
import 'package:wanderly/core/domain/repositories/settings_repository.dart';
import 'package:wanderly/core/presentation/cubits/exchange_rate/exchange_rate_cubit.dart';
import 'package:wanderly/core/presentation/cubits/exchange_rate/exchange_rate_state.dart';
import 'package:wanderly/core/route_config/app_router.gr.dart';
import 'package:wanderly/core/ui/custom_text.dart';
import 'package:wanderly/core/ui/snackbars.dart';
import 'package:wanderly/features/04_my_trips/domain/entities/trip.dart';
import 'package:wanderly/features/04_my_trips/presentation/cubit/trips_planning_cubit.dart';
import 'package:wanderly/features/04_my_trips/presentation/widgets/currency_conversion_container.dart';
import 'package:wanderly/features/04_my_trips/presentation/widgets/custom_date_picker.dart';
import 'package:wanderly/core/ui/custom_text_field.dart';
import 'package:wanderly/injection/injection.dart';

@RoutePage()
class TripsPlanningPage extends StatefulWidget {
  const TripsPlanningPage({super.key, required this.country});

  final Country country;

  @override
  State<TripsPlanningPage> createState() => _TripsPlanningPageState();
}

class _TripsPlanningPageState extends State<TripsPlanningPage> {
  final _formKey = GlobalKey<FormState>();
  final _tripNameController = TextEditingController();
  final _budgetController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  bool _showDateError = false;
  String? _perferredCurrency;

  @override
  void initState() {
    super.initState();
    final settings = di<SettingsRepository>();
    _perferredCurrency = settings.getPreferredCurrency();
  }

  @override
  void dispose() {
    _tripNameController.dispose();
    _budgetController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd/MM/yyyy');
    final hasError =
        (_startDate != null &&
        _endDate != null &&
        _endDate!.isBefore(_startDate!));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Plan Your Trip to ${widget.country.name}'),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: Container(
        width: double.infinity,
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      'Trip Name',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 8.0),
                    CustomTextField(
                      controller: _tripNameController,
                      keyboardType: TextInputType.text,
                      hint: const CustomText(
                        'Enter trip name',
                        fontSize: 16,
                        color: Color(0xFF717171),
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
                            hasError: hasError || _showDateError,
                            label: _startDate != null
                                ? formatter.format(_startDate!)
                                : 'mm/dd/yyyy',
                            icon: Amicons.remix_calendar,
                            onPressed: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: _startDate ?? DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  _startDate = selectedDate;
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomDatePicker(
                            disabled: _startDate == null,
                            hasError: hasError || _showDateError,
                            label: _endDate != null
                                ? formatter.format(_endDate!)
                                : 'mm/dd/yyyy',
                            icon: Amicons.remix_calendar,
                            onPressed: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate:
                                    _endDate ?? _startDate ?? DateTime.now(),
                                firstDate: _startDate ?? DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  _endDate = selectedDate;
                                  _showDateError = false;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
    
                    if (hasError || _showDateError)
                      const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Amicons.remix_error_warning,
                                  size: 14,
                                  color: Color(0xFFE11D48),
                                ),
                                SizedBox(width: 4),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: CustomText(
                                    'Please select valid start and end dates.',
                                    color: Color(0xFFE11D48),
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
                      'Estimated Budget ($_perferredCurrency)',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 8.0),
                    CustomTextField(
                      controller: _budgetController,
                      hint: const CustomText(
                        'Enter amount',
                        fontSize: 16,
                        color: Color(0xFF717171),
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
    
                    BlocBuilder<ExchangeRateCubit, ExchangeRateState>(
                      builder: (context, state) {
                        return switch (state) {
                          ExchangeRateInitial() => const SizedBox.shrink(),
                          ExchangeRateLoading() => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          ExchangeRateError(:String message) => CustomText(
                            'Error: $message',
                            color: Colors.red,
                          ),
                          ExchangeRateLoaded(
                            :List<ExchangeRate> exchangeRate,
                          ) =>
                            ValueListenableBuilder<TextEditingValue>(
                              valueListenable: _budgetController,
                              builder: (context, _, _) {
                                // Determine target currency code: first country currency, fallback to USD if empty/absent
                                String targetCode =
                                    (widget.country.currencies.isNotEmpty &&
                                        widget.country.currencies[0]
                                            .trim()
                                            .isNotEmpty)
                                    ? widget.country.currencies[0]
                                          .trim()
                                          .toUpperCase()
                                    : 'USD';
                                final prefCode = (_perferredCurrency ?? 'USD')
                                    .toUpperCase();
    
                                // Hide container if same currency
                                if (prefCode == targetCode) {
                                  return const SizedBox.shrink();
                                }
    
                                // Parse input amount
                                final raw = _budgetController.text.trim();
                                final amount = double.tryParse(
                                  raw.replaceAll(',', ''),
                                );
                                if (amount == null || amount <= 0) {
                                  return const SizedBox.shrink();
                                }
    
                                // Find USD->currency rates; USD itself treated as 1.0
                                double? usdTo(String code) {
                                  if (code.toUpperCase() == 'USD') return 1.0;
                                  for (final r in exchangeRate) {
                                    if (r.currency.toUpperCase() ==
                                        code.toUpperCase()) {
                                      return r.rate;
                                    }
                                  }
                                  return null;
                                }
    
                                final rPref = usdTo(prefCode);
                                final rTarget = usdTo(targetCode);
                                if (rPref == null ||
                                    rPref == 0 ||
                                    rTarget == null ||
                                    rTarget == 0) {
                                  return const SizedBox.shrink();
                                }
    
                                final factor =
                                    rTarget / rPref; // 1 pref = factor target
                                final converted = amount * factor;
    
                                final amountFmt = NumberFormat('#,##0.0000');
                                final convertedStr = amountFmt.format(
                                  converted,
                                );
                                final rateStr = amountFmt.format(factor);
                                final yourAmtStr = amountFmt.format(amount);
    
                                return CurrencyConversionContainer(
                                  yourBudget: yourAmtStr,
                                  yourCurrency: prefCode,
                                  convertedBudget: convertedStr,
                                  convertedCurrency: targetCode,
                                  conversionRate: rateStr,
                                  countryName: widget.country.name,
                                );
                              },
                            ),
                        };
                      },
                    ),
                    const SizedBox(height: 20.0),
    
                    const CustomText(
                      'Notes (Optional)',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 8.0),
                    CustomTextField(
                      controller: _noteController,
                      hint: const CustomText(
                        'Enter additional notes...',
                        fontSize: 16,
                        color: Color(0xFF717171),
                      ),
                      minLines: 3,
                      maxLines: 9,
                      validator: (_) {
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
    
                    Builder(
                      builder: (context) {
                        return InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate() &&
                                !hasError &&
                                !(_startDate == null || _endDate == null)) {
                              final trip = Trip(
                                tripId: DateTime.now().millisecondsSinceEpoch
                                    .toString(),
                                title: _tripNameController.text.trim(),
                                startDate: _startDate!,
                                endDate: _endDate!,
                                countryName: widget.country.name,
                                countryLatitude: widget.country.latitude,
                                countryLongitude: widget.country.longitude,
                                budget: double.parse(
                                  _budgetController.text.trim(),
                                ),
                                budgetCurrency: _perferredCurrency ?? 'USD',
                                destinationCurrency:
                                    (widget.country.currencies.isNotEmpty &&
                                        widget.country.currencies[0]
                                            .trim()
                                            .isNotEmpty)
                                    ? widget.country.currencies[0]
                                          .trim()
                                          .toUpperCase()
                                    : 'USD',
                                notes: _noteController.text.trim().isNotEmpty
                                    ? _noteController.text.trim()
                                    : null,
                              );
                              context.read<TripsPlanningCubit>().addTrip(
                                trip,
                              );
                              // Success feedback
                              showSuccessSnackBar(context, 'Trip created!');
                              context.router.popUntilRoot();
                              context.router.navigate(
                                const NavigationBarShellRoute(
                                  children: [MyTripsRoute()],
                                ),
                              );
                            }
                          },
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF385C),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Amicons.remix_add_circle,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                CustomText(
                                  'Create Trip',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
