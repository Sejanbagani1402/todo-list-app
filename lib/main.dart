import 'package:app/screens/home_screen/home_screen.dart';
import 'package:app/screens/login_screen/login_screen.dart';
import 'package:app/screens/splash_screen/splash_screen.dart';
import 'package:app/screens/choose_language_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Providers/todo_list_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  debugProfileBuildsEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale("en"), Locale("hi")],
      path: "assets/translations",
      fallbackLocale: const Locale("en"),
      saveLocale: true,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TodoListProvider()),
      ],
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        routes: {
          '/home': (context) => HomeScreen(),
          '/choose-language': (context) => ChooseLanguageScreen(),
          '/login': (context) => LoginScreen(),
        },
      ),
    );
  }
}
