import 'package:wanderly/objectbox.g.dart';

late final Store objectBoxStore;
bool _obxInitialized = false;
Future<void>? _obxPending;

Future<void> initObjectBox() {
  // Prevent multiple Store instances and guard concurrent calls.
  if (_obxInitialized) return Future.value();
  if (_obxPending != null) return _obxPending!;
  final future = () async {
    objectBoxStore = await openStore();
    _obxInitialized = true;
  }();
  _obxPending = future;
  return future;
}
