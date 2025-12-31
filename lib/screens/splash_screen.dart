import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/range_provider.dart';
import 'range_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  _initApp() async {
    // Use Future.microtask to ensure context is available for Provider
    Future.microtask(() async {
      final provider = Provider.of<RangeProvider>(context, listen: false);
      
      await Future.wait([
        Future.delayed(const Duration(seconds: 2)),
        provider.fetchRanges(),
      ]);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RangeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Image.asset(
                'assets/icon/range.png',
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Range Indicator',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
