import 'package:flutter/material.dart';

SnackBar _buildBaseSnackBar({
  required Color background,
  required IconData icon,
  required String message,
  required Duration duration,
}) {
  return SnackBar(
    content: Row(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(color: Colors.white),
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
  final snackBar = _buildBaseSnackBar(
    background: Colors.green.shade600,
    icon: Icons.check_circle,
    message: message,
    duration: const Duration(seconds: 2),
  );
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

void showErrorSnackBar(BuildContext context, String message) {
  final snackBar = _buildBaseSnackBar(
    background: Colors.red.shade600,
    icon: Icons.error_outline,
    message: message,
    duration: const Duration(seconds: 3),
  );
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
