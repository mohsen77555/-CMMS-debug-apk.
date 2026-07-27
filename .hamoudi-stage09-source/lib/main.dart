import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'providers/memory_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/security_provider.dart';
import 'screens/main_shell.dart';
import 'screens/notification_coordinator.dart';
import 'screens/security_gate.dart';
import 'screens/startup_recovery_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = FlutterError.presentError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stack,
        library: 'Hamoodi asynchronous error',
      ),
    );
    return true;
  };

  ErrorWidget.builder = (details) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ColoredBox(
        color: const Color(0xFFF7F3EA),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'تعذر عرض هذا الجزء من التطبيق.\n'
              'أغلق الصفحة وأعد المحاولة.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF7A1F1F),
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  };

  await initializeDateFormatting('ar');
  runApp(const HamoodiApp());
}

class HamoodiApp extends StatelessWidget {
  const HamoodiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MemoryProvider()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => SecurityProvider()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationProvider()..initialize(),
        ),
      ],
      child: Consumer3<MemoryProvider, SecurityProvider, NotificationProvider>(
        builder: (context, memory, security, notifications, _) {
          final ready =
              memory.isReady && security.isReady && notifications.isReady;
          final criticalErrors = <Object>[
            if (memory.initializationError != null)
              memory.initializationError!,
            if (security.initializationError != null)
              security.initializationError!,
          ];

          Widget home;
          if (!ready) {
            home = const HamoodiSplashScreen();
          } else if (criticalErrors.isNotEmpty) {
            home = StartupRecoveryScreen(
              message: criticalErrors.join('\n\n'),
              onRetry: () async {
                await Future.wait([
                  memory.retryInitialization(),
                  security.retryInitialization(),
                  notifications.retryInitialization(),
                ]);
              },
            );
          } else {
            const securedApp = SecurityGate(child: MainShell());
            home = notifications.initializationError == null
                ? const NotificationCoordinator(child: securedApp)
                : securedApp;
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'حمودي',
            locale: const Locale('ar'),
            supportedLocales: const [
              Locale('ar'),
              Locale('en'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: memory.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: home,
          );
        },
      ),
    );
  }
}

class HamoodiSplashScreen extends StatelessWidget {
  const HamoodiSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF111B2E),
              Color(0xFF263A5C),
            ],
          ),
        ),
        child: Center(
          child: Semantics(
            label: 'جارٍ تشغيل تطبيق حمودي',
            liveRegion: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.asset(
                    'assets/icon/hamoodi_icon.png',
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'حمودي',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
                const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
