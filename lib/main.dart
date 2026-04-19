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
import 'core/providers/exam_provider.dart';
import 'core/providers/app_settings_provider.dart';
import 'core/providers/this_week_provider.dart';
import 'core/services/ad_service.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/onboarding_screen.dart';
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
import 'screens/exams/exams_screen.dart';

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

  // Only initialize ads if Firebase is properly configured
  if (!firebaseOptions.apiKey.startsWith('PLACEHOLDER')) {
    try {
      await AdService.instance.initialize();
    } catch (e) {
      debugPrint('AdService init error: $e');
    }
  } else {
    debugPrint('AdService: Skipping init - placeholder Firebase config.');
  }

  // Notification init is deferred - will be initialized lazily when needed by ExamProvider

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
        ChangeNotifierProvider(create: (_) => ExamProvider(prefs)),
        ChangeNotifierProvider(create: (_) => AppSettingsProvider(prefs)),
        ChangeNotifierProvider(create: (_) => ThisWeekProvider()),
      ],
      child: Consumer2<LocaleProvider, AppSettingsProvider>(
        builder: (context, localeProvider, settingsProvider, _) => MaterialApp(
          title: 'NCC Campus',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settingsProvider.themeMode,
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
            '/onboarding': (context) => const OnboardingScreen(),
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
            '/exams': (context) => const ExamsScreen(),
          },
        ),
      ),
    );
  }
}
