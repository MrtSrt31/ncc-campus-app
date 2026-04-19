import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../core/providers/auth_provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'NCC',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'NCC Campus\'a\nHoş Geldin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.txt(context),
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'GPA hesapla, kampüs işletmelerini keşfet,\nders ve hoca yorumlarını gör.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.txtSec(context),
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const Spacer(flex: 2),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: const Text('Üye Ol'),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: const Text('Giriş Yap'),
                ),
              ),
              const SizedBox(height: 14),
              TextButton(
                onPressed: () {
                  context.read<AuthProvider>().continueAsGuest();
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: Text(
                  'Reklamlı olarak devam et',
                  style: TextStyle(
                    color: AppColors.txtHint(context),
                    fontSize: 14,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
