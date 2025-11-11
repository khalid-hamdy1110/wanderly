import 'failures.dart';

String humanizeFailure(Failure failure) {
  if (failure is NetworkFailure) {
    return 'You appear offline. Check your connection and try again.';
  }
  if (failure is TimeoutFailure) {
    return 'Request timed out. Please try again.';
  }
  if (failure is ServerFailure) {
    return 'We\'re having trouble on our end. Please try again.';
  }
  if (failure is CacheFailure) {
    return 'Couldn\'t read saved data. Please retry.';
  }
  // Fallback: use provided message or generic.
  return failure.message.isNotEmpty
      ? failure.message
      : 'Something went wrong. Please try again.';
}
