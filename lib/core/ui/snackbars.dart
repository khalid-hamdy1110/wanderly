import 'package:flutter/material.dart';
import 'package:wanderly/core/theming/theme_extensions.dart';

SnackBar _buildBaseSnackBar({
  required Color background,
  required IconData icon,
  required String message,
  required Duration duration,
  required BuildContext context,
}) {
  final customColors = context.theme.customColors;
  return SnackBar(
    content: Row(
      children: [
        Icon(icon, color: customColors.onSuccess),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            style: TextStyle(color: customColors.onSuccess),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
    backgroundColor: background,
    behavior: SnackBarBehavior.floating,
    duration: duration,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  );
}

void showSuccessSnackBar(BuildContext context, String message) {
  final customColors = context.theme.customColors;

  final snackBar = _buildBaseSnackBar(
    background: customColors.success,
    icon: Icons.check_circle,
    message: message,
    duration: const Duration(seconds: 2),
    context: context,
  );
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

void showErrorSnackBar(BuildContext context, String message) {
  final customColors = context.theme.customColors;

  final snackBar = _buildBaseSnackBar(
    background: customColors.destructive,
    icon: Icons.error_outline,
    message: message,
    duration: const Duration(seconds: 3),
    context: context,
  );
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
