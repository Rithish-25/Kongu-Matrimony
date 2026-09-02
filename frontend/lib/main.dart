import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'core/theme/theme.dart';
import 'core/assets/mock_data.dart';
import 'core/localization/app_language.dart';
import 'screens/main_layout.dart';
import 'screens/auth/login_screen.dart';

Future<void> main() async {
  // Ensure Flutter engine is initialized before setup
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  
  // Preserve splash screen during initialization
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Load persisted language preference & mock user state before launching the app
  await AppLanguageController.init();
  await ProfileDatabase.init();

  // Set orientation lock to Portrait Up (Android-only compliance requested)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const KonguMatrimonyApp());
  
  // Remove splash screen once app is running
  FlutterNativeSplash.remove();
}

class KonguMatrimonyApp extends StatelessWidget {
  const KonguMatrimonyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kongu Matrimony',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: ProfileDatabase.isLoggedIn ? const MainLayout() : const LoginScreen(),
    );
  }
}
