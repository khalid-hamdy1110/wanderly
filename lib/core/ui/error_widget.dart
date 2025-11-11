import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final iconSize = dense ? 28.0 : 48.0;
    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
    );
    final messageStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: isDark ? 0.8 : 0.7),
    );

    final content = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: dense ? 8 : 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: dense
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize, color: theme.colorScheme.error),
          SizedBox(height: dense ? 8 : 12),
          Text(
            title,
            style: titleStyle,
            textAlign: dense ? TextAlign.start : TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: messageStyle,
            textAlign: dense ? TextAlign.start : TextAlign.center,
          ),
          SizedBox(height: dense ? 10 : 16),
          FilledButton(
            onPressed: onRetry,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(const Color(0xFFFF385C)),
            ),
            child: Text(retryLabel),
          ),
        ],
      ),
    );

    if (dense) return content;
    return Center(child: content);
  }
}
