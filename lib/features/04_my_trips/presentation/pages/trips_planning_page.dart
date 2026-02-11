import 'dart:async';

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
import 'package:wanderly/core/theming/custom_components/custom_colors.dart';
import 'package:wanderly/core/theming/theme_extensions.dart';
import 'package:wanderly/core/ui/custom_text.dart';
import 'package:wanderly/core/ui/snackbars.dart';
import 'package:wanderly/features/04_my_trips/domain/entities/trip.dart';
import 'package:wanderly/features/04_my_trips/presentation/cubit/trips_planning_cubit.dart';
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
  bool _isConverting = false;
  Timer? _debounceTimer;

  DateTime? _startDate;
  DateTime? _endDate;
  bool _showDateError = false;
  String? _perferredCurrency;
  String? _rate;
  String? _budgetErrorMsg;

  @override
  void initState() {
    super.initState();
    final settings = di<SettingsRepository>();
    _perferredCurrency = settings.getPreferredCurrency();

    _budgetController.addListener(_onBudgetChanged);
  }

  void _onBudgetChanged() {
    final raw = _budgetController.text.trim();
    final amount = double.tryParse(raw.replaceAll(',', ''));

    if (amount != null && amount > 0) {
      setState(() => _isConverting = true);
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _isConverting = false);
      });
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _budgetController.removeListener(_onBudgetChanged);
    _tripNameController.dispose();
    _budgetController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customColors = context.theme.customColors;
    final formatter = DateFormat('dd/MM/yyyy');
    final hasError =
        (_startDate != null &&
        _endDate != null &&
        _endDate!.isBefore(_startDate!));

    return Scaffold(
      backgroundColor: customColors.background,
      body: SafeArea(
        child: Container(
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
                      _buildBackButton(context, customColors),
                      CustomText(
                        'Plan Your Trip',
                        fontSize: 20,
                        color: customColors.onBackground,
                      ),
                      CustomText(
                        widget.country.name,
                        fontSize: 14,
                        color: customColors.onMuted,
                      ),
                      const SizedBox(height: 8.0),
                      Divider(color: customColors.border),
                      const SizedBox(height: 16.0),
                      const CustomText(
                        'Trip Name*',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 8.0),
                      CustomTextField(
                        controller: _tripNameController,
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
                              'Start Date*',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 12.0),
                          Expanded(
                            child: CustomText(
                              'End Date*',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      _buildDateSelectors(hasError, formatter, context),
                      if (hasError || _showDateError)
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

                      const CustomText(
                        'Estimated Budget*',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 8.0),
                      _buildBudgetSection(customColors),
                      if (_rate != null)
                        Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: CustomText(
                                'Rate: 1 ${_perferredCurrency!.toUpperCase()} ≈ $_rate ${widget.country.currencies.isNotEmpty ? widget.country.currencies[0].trim().toUpperCase() : 'USD'}',
                                fontSize: 13,
                                color: customColors.textFieldPlaceholder,
                              ),
                            )
                            .animate()
                            .slideY(
                              begin: -0.5,
                              end: 0.0,
                              curve: Curves.easeOut,
                            )
                            .fadeIn(duration: 300.ms),

                      if (_budgetErrorMsg != null)
                        Padding(
                              padding: const EdgeInsets.only(top: 4.0),
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
                                      _budgetErrorMsg ?? '',
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

                      const CustomText(
                        'Notes',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 8.0),
                      CustomTextField(
                        controller: _noteController,
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

                      _buildCreateTripButton(customColors, hasError),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Builder _buildCreateTripButton(CustomColors customColors, bool hasError) {
    return Builder(
      builder: (context) {
        return Container(
          height: 56,
          decoration: BoxDecoration(
            color: customColors.primary,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () {
                final datesValid = !(_startDate == null || _endDate == null);
                if (!datesValid) {
                  setState(() => _showDateError = true);
                  return;
                }

                if (_formKey.currentState!.validate() &&
                    !hasError &&
                    datesValid) {
                  final trip = Trip(
                    tripId: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: _tripNameController.text.trim(),
                    startDate: _startDate!,
                    endDate: _endDate!,
                    countryName: widget.country.name,
                    countryLatitude: widget.country.latitude,
                    countryLongitude: widget.country.longitude,
                    budget: double.parse(_budgetController.text.trim()),
                    budgetCurrency: _perferredCurrency ?? 'USD',
                    destinationCurrency:
                        (widget.country.currencies.isNotEmpty &&
                            widget.country.currencies[0].trim().isNotEmpty)
                        ? widget.country.currencies[0].trim().toUpperCase()
                        : 'USD',
                    notes: _noteController.text.trim().isNotEmpty
                        ? _noteController.text.trim()
                        : null,
                  );
                  context.read<TripsPlanningCubit>().addTrip(trip);
                  // Success feedback
                  showSuccessSnackBar(context, 'Trip created!');
                  context.router.popUntilRoot();
                  context.router.navigate(
                    const NavigationBarShellRoute(children: [MyTripsRoute()]),
                  );
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Amicons.remix_add_circle,
                    color: customColors.onPrimary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  CustomText(
                    'Create Trip',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: customColors.onPrimary,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Row _buildBudgetSection(CustomColors customColors) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            controller: _budgetController,
            hint: CustomText(
              '0.00',
              fontSize: 16,
              color: customColors.textFieldPlaceholder,
              textAlign: TextAlign.center,
            ),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            validator: (value) {
              setState(() {});
              if (value == null || value.isEmpty) {
                _budgetErrorMsg = 'Please enter a budget';
                return 'Please enter a budget';
              }
              final number = double.tryParse(value);
              if (number == null || number <= 0) {
                _budgetErrorMsg = 'Please enter a valid number';
                return 'Please enter a valid number';
              }
              _budgetErrorMsg = null;
              return null;
            },
            showErrorMsg: false,
            trailingText: _perferredCurrency,
          ),
        ),
        const SizedBox(width: 8),

        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _budgetController,
          builder: (context, _, _) {
            if (_isConverting) {
              return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: customColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Amicons.lucide_refresh_cw,
                      size: 16,
                      color: customColors.primary,
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .rotate(duration: 500.ms, curve: Curves.linear);
            }

            return Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: customColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child:
                  Icon(
                        Amicons.lucide_arrow_left_right,
                        size: 16,
                        color: customColors.primary,
                      )
                      .animate()
                      .fadeIn(duration: 200.ms)
                      .slideY(begin: -0.2, end: 0.0, curve: Curves.easeOut),
            );
          },
        ),
        const SizedBox(width: 8),

        Expanded(
          child: BlocBuilder<ExchangeRateCubit, ExchangeRateState>(
            builder: (context, state) {
              return switch (state) {
                ExchangeRateInitial() => const SizedBox.shrink(),
                ExchangeRateLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
                ExchangeRateError(:String message) => CustomText(
                  'Error: $message',
                  color: customColors.destructive,
                ),
                ExchangeRateLoaded(:List<ExchangeRate> exchangeRate) =>
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _budgetController,
                    builder: (context, _, _) {
                      // Determine target currency code: first country currency, fallback to USD if empty/absent
                      String targetCode =
                          (widget.country.currencies.isNotEmpty &&
                              widget.country.currencies[0].trim().isNotEmpty)
                          ? widget.country.currencies[0].trim().toUpperCase()
                          : 'USD';
                      final prefCode = (_perferredCurrency ?? 'USD')
                          .toUpperCase();

                      // Hide container if same currency
                      if (prefCode == targetCode) {
                        return _buildConversionContainer(
                          customColors,
                          '0.00',
                          null,
                          targetCode,
                        );
                      }

                      // Parse input amount
                      final raw = _budgetController.text.trim();
                      final amount = double.tryParse(raw.replaceAll(',', ''));
                      if (amount == null || amount <= 0) {
                        return _buildConversionContainer(
                          customColors,
                          '0.00',
                          null,
                          targetCode,
                        );
                      }

                      // Find USD->currency rates; USD itself treated as 1.0
                      double? usdTo(String code) {
                        if (code.toUpperCase() == 'USD') {
                          return 1.0;
                        }
                        for (final r in exchangeRate) {
                          if (r.currency.toUpperCase() == code.toUpperCase()) {
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
                        return _buildConversionContainer(
                          customColors,
                          'N/A',
                          null,
                          targetCode,
                        );
                      }

                      final factor = rTarget / rPref; // 1 pref = factor target
                      final converted = amount * factor;

                      final amountFmt = NumberFormat('#,##0.00');
                      final convertedStr = amountFmt.format(converted);
                      final rateStr = amountFmt.format(factor);

                      return _buildConversionContainer(
                        customColors,
                        convertedStr,
                        rateStr,
                        targetCode,
                      );
                    },
                  ),
              };
            },
          ),
        ),
      ],
    );
  }

  Row _buildDateSelectors(
    bool hasError,
    DateFormat formatter,
    BuildContext context,
  ) {
    return Row(
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
                  if (_endDate != null && _endDate!.isBefore(selectedDate)) {
                    _endDate = null;
                  }
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
              final firstDate = _startDate ?? DateTime.now();
              final initial = (_endDate != null && _endDate!.isAfter(firstDate))
                  ? _endDate!
                  : firstDate;

              final selectedDate = await showDatePicker(
                context: context,
                initialDate: initial,
                firstDate: firstDate,
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
    );
  }

  Padding _buildBackButton(BuildContext context, CustomColors customColors) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
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
            CustomText('Back', fontSize: 14, color: customColors.onMuted),
          ],
        ),
      ),
    );
  }

  Container _buildConversionContainer(
    CustomColors customColors,
    String label,
    String? rate,
    String currency,
  ) {
    if (rate != null) {
      _rate = rate;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      decoration: BoxDecoration(
        color: customColors.secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: customColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child:
                  CustomText(
                        label,
                        fontSize: 16,
                        color: label == '0.00'
                            ? customColors.textFieldPlaceholder
                            : customColors.onSecondary,
                      )
                      .animate(key: ValueKey(label), delay: 500.ms)
                      .fadeIn(duration: 200.ms)
                      .slideY(begin: -0.2, end: 0.0, curve: Curves.easeOut),
            ),
          ),
          CustomText(
            currency,
            fontSize: 12,
            color: customColors.textFieldPlaceholder,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
