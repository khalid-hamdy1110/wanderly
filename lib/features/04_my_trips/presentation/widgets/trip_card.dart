import 'package:amicons/amicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:wanderly/core/theming/theme_extensions.dart';
import 'package:wanderly/core/ui/custom_text.dart';

enum TripType { ongoing, upcoming, past }

class TripCard extends StatefulWidget {
  const TripCard({
    super.key,
    required this.isManuallyCompleted,
    required this.tripTitle,
    required this.countryName,
    required this.startDate,
    required this.endDate,
    required this.budget,
    required this.currency,
    this.daysUntilTrip,
    required this.tripType,
    required this.onDelete,
    required this.onTap,
  });

  final bool isManuallyCompleted;
  final String tripTitle;
  final String countryName;
  final DateTime startDate;
  final DateTime endDate;
  final double budget;
  final String currency;
  final int? daysUntilTrip;
  final TripType tripType;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  @override
  State<TripCard> createState() => _TripCardState();
}

class _TripCardState extends State<TripCard> {
  final DateFormat dateFormatter = DateFormat('MMM dd, yyyy');

  bool _fading = false;
  bool _shrunk = false;

  void _animateAndDelete() {
    if (_fading || _shrunk) return;
    setState(() => _fading = true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      onEnd: () {
        if (_shrunk) widget.onDelete();
      },
      child: _shrunk
          ? const SizedBox.shrink()
          : _buildCard(context)
                .animate(target: _fading ? 1 : 0)
                .fadeOut(duration: 180.ms, curve: Curves.easeOut)
                .slideY(
                  begin: 0,
                  end: -0.02,
                  duration: 180.ms,
                  curve: Curves.easeOut,
                )
                .then()
                .callback(
                  callback: (_) {
                    setState(() => _shrunk = true);
                  },
                ),
    );
  }

  IntrinsicHeight _buildCard(BuildContext context) {
    final customColors = context.theme.customColors;

    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          color: customColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: customColors.border),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(widget.tripTitle, fontSize: 16),
                          CustomText(
                            widget.countryName,
                            fontSize: 14,
                            color: customColors.onMuted,
                          ),
                        ],
                      ),
                      Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: _animateAndDelete,
                          child: Icon(
                            Amicons.iconly_delete_fill,
                            color: customColors.destructive,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _tripTypePillBuilder(context),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Amicons.remix_calendar,
                        color: customColors.onMuted,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      CustomText(
                        '${dateFormatter.format(widget.startDate)} - ${dateFormatter.format(widget.endDate)}',
                        fontSize: 14,
                        color: customColors.onMuted,
                      ),
                    ],
                  ),
                  if (widget.tripType == TripType.upcoming &&
                      widget.daysUntilTrip != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Amicons.remix_time,
                          color: customColors.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        CustomText(
                          '${widget.daysUntilTrip} days until trip',
                          fontSize: 14,
                          color: customColors.primary,
                        ),
                        Expanded(
                          child: CustomText(
                            '${(_dayProgress() * 100).toInt()}%',
                            fontSize: 12,
                            color: customColors.onMuted,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: _dayProgress()),
                      duration: const Duration(milliseconds: 800),
                      builder: (context, value, child) {
                        return LinearProgressIndicator(
                          value: value,
                          backgroundColor: customColors.accent,
                          color: customColors.primary,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(999),
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 12),
                  Divider(color: customColors.border),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Amicons.lucide_dollar_sign,
                        color: customColors.onMuted,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      CustomText(
                        'Budget',
                        fontSize: 14,
                        color: customColors.onMuted,
                      ),
                      const Spacer(),
                      CustomText(
                        '${widget.budget} ${widget.currency}',
                        fontSize: 14,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tripTypePillBuilder(BuildContext context) {
    final customColors = context.theme.customColors;

    if (widget.isManuallyCompleted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: customColors.completed.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: CustomText(
          'Completed',
          fontSize: 12,
          color: customColors.completed,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    switch (widget.tripType) {
      case TripType.ongoing:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: customColors.ongoing.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: CustomText(
            'Ongoing',
            fontSize: 12,
            color: customColors.ongoing,
            fontWeight: FontWeight.bold,
          ),
        );
      case TripType.upcoming:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: customColors.upcoming.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: CustomText(
            'Upcoming',
            fontSize: 12,
            color: customColors.upcoming,
            fontWeight: FontWeight.bold,
          ),
        );
      case TripType.past:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: customColors.completed.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: CustomText(
            'Completed',
            fontSize: 12,
            color: customColors.completed,
            fontWeight: FontWeight.bold,
          ),
        );
    }
  }

  double _dayProgress() {
    final daysUntilTrip = widget.daysUntilTrip;

    switch (daysUntilTrip) {
      case null:
        return 0.0;
      case 0:
        return 1.0;
      case 1:
        return 0.99;
      case < 7:
        return 0.92;
      case < 15:
        return 0.83;
      case < 30:
        return 0.67;
      case < 45:
        return 0.5;
      case < 60:
        return 0.33;
      case < 90:
        return 0.2;
      default:
        return 0.0;
    }
  }
}
