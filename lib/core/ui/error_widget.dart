import 'package:flutter/material.dart';
import 'package:wanderly/core/theming/theme_extensions.dart';
import 'package:wanderly/core/ui/custom_text.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
    this.title = 'Something went wrong',
    this.retryLabel = 'Try again',
    this.icon = Icons.error_outline,
    this.dense = false,
  });

  final String message;
  final VoidCallback onRetry;
  final String title;
  final String retryLabel;
  final IconData icon;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final customColors = context.theme.customColors;

    final iconSize = dense ? 28.0 : 48.0;

    final content = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: dense ? 8 : 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: dense
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize, color: customColors.destructive),
          SizedBox(height: dense ? 8 : 12),
          CustomText(
            title,
            color: customColors.onBackground,
            fontWeight: FontWeight.bold,
            textAlign: dense ? TextAlign.start : TextAlign.center,
          ),
          const SizedBox(height: 6),
          CustomText(
            message,
            color: customColors.onMuted,
            textAlign: dense ? TextAlign.start : TextAlign.center,
          ),
          SizedBox(height: dense ? 10 : 16),
          FilledButton(
            onPressed: onRetry,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(customColors.primary),
            ),
            child: CustomText(retryLabel, color: customColors.onPrimary),
          ),
        ],
      ),
    );

    if (dense) return content;
    return Center(child: content);
  }
}
