import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/range_provider.dart';
import 'screens/range_screen.dart';
import 'widgets/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RangeProvider()..fetchRanges(),
      child: MaterialApp(
        title: 'Range Indicator',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        home: const AppInitializer(),
      ),
    );
  }
}

/// Widget that handles app initialization and shows splash screen
class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Show splash screen for at least 2 seconds
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      // Navigate to main screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const RangeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
