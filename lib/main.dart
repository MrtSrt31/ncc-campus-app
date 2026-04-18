import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'core/theme/app_theme.dart';
import 'core/l10n/app_localizations.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/ad_provider.dart';
import 'core/providers/gpa_provider.dart';
import 'core/providers/locale_provider.dart';
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
import 'screens/campus/transportation_screen.dart';
import 'screens/campus/this_week_screen.dart';
import 'screens/social/confessions_screen.dart';
import 'screens/social/marketplace_screen.dart';
import 'screens/social/carpool_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Skip Firebase init if using placeholder config
  final firebaseOptions = DefaultFirebaseOptions.currentPlatform;
  if (!firebaseOptions.apiKey.startsWith('PLACEHOLDER')) {
    try {
      await Firebase.initializeApp(
        options: firebaseOptions,
      );
    } catch (e) {
      debugPrint('Firebase init error: $e');
    }
  } else {
    debugPrint('Firebase: Skipping init - placeholder config detected. Run flutterfire configure to set up.');
  }

  try {
    await AdService.instance.initialize();
  } catch (e) {
    debugPrint('AdService init error: $e');
  }

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
        ChangeNotifierProvider(create: (_) => LocaleProvider(prefs)),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, _) => MaterialApp(
          title: 'NCC Campus',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          locale: localeProvider.locale,
          supportedLocales: const [Locale('tr'), Locale('en')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
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
            '/transportation': (context) => const TransportationScreen(),
            '/this-week': (context) => const ThisWeekScreen(),
            '/confessions': (context) => const ConfessionsScreen(),
            '/marketplace': (context) => const MarketplaceScreen(),
            '/carpool': (context) => const CarpoolScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/admin': (context) => const AdminDashboardScreen(),
          },
        ),
      ),
    );
  }
}
