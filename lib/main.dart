import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'core/theme/app_theme.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/ad_provider.dart';
import 'core/providers/gpa_provider.dart';
import 'core/services/ad_service.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/gpa/gpa_screen.dart';
import 'screens/gpa/gpa_simulator_screen.dart';
import 'screens/campus/campus_directory_screen.dart';
import 'screens/campus/announcements_screen.dart';
import 'screens/campus/ring_schedule_screen.dart';
import 'screens/campus/cafeteria_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await AdService.instance.initialize();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  final prefs = await SharedPreferences.getInstance();

  runApp(NccApp(prefs: prefs));
}

class NccApp extends StatelessWidget {
  final SharedPreferences prefs;

  const NccApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(prefs)),
        ChangeNotifierProvider(create: (_) => AdProvider(prefs)),
        ChangeNotifierProvider(create: (_) => GpaProvider(prefs)),
      ],
      child: MaterialApp(
        title: 'NCC Campus',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/welcome': (context) => const WelcomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/gpa': (context) => const GpaScreen(),
          '/gpa-simulator': (context) => const GpaSimulatorScreen(),
          '/campus': (context) => const CampusDirectoryScreen(),
          '/announcements': (context) => const AnnouncementsScreen(),
          '/ring-schedule': (context) => const RingScheduleScreen(),
          '/cafeteria': (context) => const CafeteriaScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/admin': (context) => const AdminDashboardScreen(),
        },
      ),
    );
  }
}
