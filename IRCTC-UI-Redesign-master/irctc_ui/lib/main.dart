// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:irctc_ui/get_started.dart';
import 'package:irctc_ui/theme_controller.dart';
import 'package:irctc_ui/authentication/app_lock_screen.dart';
import 'package:irctc_ui/homescreen/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appThemeController,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'IRCTC Travel',

          // ====================================================
          // THEME MODE
          // ====================================================

          themeMode: appThemeController.themeMode,

          // ====================================================
          // WHITE THEME
          // ====================================================

          theme: ThemeData(
            brightness: Brightness.light,
            useMaterial3: true,
            scaffoldBackgroundColor: Color(0xFFF5F7FA),

            colorScheme: ColorScheme.fromSeed(
              seedColor: Color(0xFF2475EE),
              brightness: Brightness.light,
            ),

            appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
              centerTitle: true,
            ),

            cardTheme: CardThemeData(
              color: Colors.white,
              elevation: 0,
            ),

            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Color(0xFFF1F3F6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),

            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2475EE),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          // ====================================================
          // BLACK THEME
          // ====================================================

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
            scaffoldBackgroundColor: Color(0xFF030509),

            colorScheme: ColorScheme.fromSeed(
              seedColor: Color(0xFF2475EE),
              brightness: Brightness.dark,
            ),

            appBarTheme: AppBarTheme(
              backgroundColor: Color(0xFF030509),
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
            ),

            cardTheme: CardThemeData(
              color: Color(0xFF101318),
              elevation: 0,
            ),

            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Color(0xFF15171C),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),

            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2475EE),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          // ====================================================
          // ROUTES
          // ====================================================

          routes: {
            '/home': (context) => const HomeScreen(),
          },

          home: SplashScreen(),
        );
      },
    );
  }
}

// ================================================================
// SPLASH SCREEN
// ================================================================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
      Duration(milliseconds: 1600),
      () {
        _checkStartup();
      },
    );
  }

  // ==============================================================
  // CHECK LOGIN + APP LOCK
  // ==============================================================

  Future<void> _checkStartup() async {
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();

    final bool isLoggedIn =
        prefs.getBool('is_logged_in') ?? false;

    final bool appLockEnabled =
        prefs.getBool('app_lock_enabled') ?? false;

    if (!mounted) return;

    // ------------------------------------------------------------
    // USER NOT LOGGED IN
    // ------------------------------------------------------------

    if (!isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GetStartedScreen(),
        ),
      );

      return;
    }

    // ------------------------------------------------------------
    // USER LOGGED IN + APP LOCK ENABLED
    // ------------------------------------------------------------

    if (appLockEnabled) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AppLockScreen(),
        ),
      );

      return;
    }

    // ------------------------------------------------------------
    // USER LOGGED IN + APP LOCK DISABLED
    // ------------------------------------------------------------

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? Color(0xFF010101) : Colors.white,
      body: Center(
        child: Image.asset(
          "sf/img/irctc_logo.png",
        ),
      ),
    );
  }
}