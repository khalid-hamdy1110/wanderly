import 'dart:async';

import 'package:wanderly/core/error/failures.dart';

/// Retries an async [action] up to [maxAttempts] with exponential backoff.
///
/// By default, retries only when the thrown error is a [NetworkFailure]
/// or [TimeoutFailure]. Provide [isRetryable] to customize retry conditions.
///
/// Backoff sequence: [initialDelay] * [multiplier]^(attempt-1)
/// Example (defaults): 200ms -> 400ms -> 800ms
Future<T> retry<T>(
  Future<T> Function() action, {
  int maxAttempts = 3,
  Duration initialDelay = const Duration(milliseconds: 200),
  double multiplier = 2.0,
  bool Function(Object error)? isRetryable,
}) async {
  assert(maxAttempts >= 1, 'maxAttempts must be >= 1');
  assert(multiplier >= 1.0, 'multiplier must be >= 1.0');

  Duration delay = initialDelay;
  int attempt = 0;

  while (true) {
    attempt += 1;
    try {
      return await action();
    } catch (error) {
      final retryable = isRetryable != null
          ? isRetryable(error)
          : (error is NetworkFailure || error is TimeoutFailure);

      if (!retryable || attempt >= maxAttempts) rethrow;

      // Wait before next attempt.
      await Future.delayed(delay);
      // Increase delay for next backoff step.
      delay = Duration(
        milliseconds: (delay.inMilliseconds * multiplier).toInt(),
      );
    }
  }
}
