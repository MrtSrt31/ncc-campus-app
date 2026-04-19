import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/providers/app_settings_provider.dart';
import '../core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  static const _items = [
    _OnboardingItem(
      icon: Icons.school_rounded,
      title: 'Kampüs Hayatı Tek Uygulamada',
      desc:
          'Ders, duyuru, sosyal alanlar, ulaşım ve daha fazlasını tek yerden yönet.',
    ),
    _OnboardingItem(
      icon: Icons.event_available_rounded,
      title: 'Sınavlarını Kaçırma',
      desc:
          'Sınav takvimini gör, derslerini seç, bildirim hatırlatmalarıyla hazırlan.',
    ),
    _OnboardingItem(
      icon: Icons.tune_rounded,
      title: 'Deneyimi Kendin Özelleştir',
      desc:
          'Tema modu (Açık/Koyu/Sistem) ve dil ayarlarını istediğin gibi belirle.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await context.read<AppSettingsProvider>().markOnboardingSeen();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/welcome');
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _index == _items.length - 1;

    return Scaffold(
      backgroundColor: AppColors.bg(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _finish,
                    child: const Text('Geç'),
                  ),
                  Row(
                    children: List.generate(_items.length, (i) {
                      final active = i == _index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: active ? 22 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: active ? AppColors.primary : AppColors.txtHint(context),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _items.length,
                  onPageChanged: (v) => setState(() => _index = v),
                  itemBuilder: (context, i) {
                    final item = _items[i];
                    return _OnboardingCard(item: item);
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    if (isLast) {
                      await _finish();
                    } else {
                      await _controller.nextPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                  child: Text(isLast ? 'Başlayalım' : 'Devam'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingItem {
  final IconData icon;
  final String title;
  final String desc;

  const _OnboardingItem({
    required this.icon,
    required this.title,
    required this.desc,
  });
}

class _OnboardingCard extends StatelessWidget {
  final _OnboardingItem item;

  const _OnboardingCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(item.icon, size: 40, color: AppColors.primary),
          ),
          const SizedBox(height: 28),
          Text(
            item.title,
            style: TextStyle(
              color: AppColors.txt(context),
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            item.desc,
            style: TextStyle(
              color: AppColors.txtSec(context),
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
