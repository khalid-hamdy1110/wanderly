import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wanderly/core/route_config/app_router.dart';
import 'package:wanderly/injection/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await di.init();
  final appRouter = AppRouter();
  runApp(MainApp(appRouter: appRouter));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Wanderly',
      routerConfig: widget.appRouter.config(),
      debugShowCheckedModeBanner: false,
    );
  }
}
