import 'package:flutter/material.dart';
import 'package:dxmd_app/core/routing/app_router.dart';
import 'package:dxmd_app/core/theme/app_theme.dart';
import 'core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'DXMD Vietnam',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
