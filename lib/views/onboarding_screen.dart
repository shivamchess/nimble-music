import 'package:flutter/material.dart';
import '../widgets/soundwave_widget.dart';
import '../core/theme/app_colors.dart';
import 'main_scaffold.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 40),
              Column(
                children: const [
                  SoundwaveWidget(),
                  SizedBox(height: 24),
                  Text(
                    'Nimble',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                    ),
                  ),
                  SizedBox(height: 14),
                  Text(
                    'Good music.\nAnytime, anywhere.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      color: AppColors.lightTextSub,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const MainScaffold()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lightPillDark,
                        foregroundColor: AppColors.lightPillText,
                        shape: const StadiumBorder(),
                        elevation: 4,
                      ),
                      child: const Text('Get started', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const MainScaffold(initialIndex: 2)),
                      );
                    },
                    child: const Text('Skip to Library', style: TextStyle(color: AppColors.lightTextSub, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
