import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/generated/app_localizations.dart';
import 'onboarding_controller.dart';

class _Page {
  const _Page(this.icon, this.title, this.body);
  final IconData icon;
  final String title;
  final String body;
}

/// First-launch storyboard: a swipeable carousel introducing the core value
/// props, with Skip and Get Started actions.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _index = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<_Page> _pages(AppLocalizations l10n) => [
        _Page(Icons.calculate_outlined, l10n.onboardingEqualTitle,
            l10n.onboardingEqualBody),
        _Page(Icons.receipt_long_outlined, l10n.onboardingItemizedTitle,
            l10n.onboardingItemizedBody),
        _Page(Icons.handshake_outlined, l10n.onboardingSettleTitle,
            l10n.onboardingSettleBody),
        _Page(Icons.history_outlined, l10n.onboardingHistoryTitle,
            l10n.onboardingHistoryBody),
      ];

  void _finish() => context.read<OnboardingController>().complete();

  void _next(int pageCount) {
    if (_index >= pageCount - 1) {
      _finish();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final pages = _pages(l10n);
    final isLast = _index == pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _finish,
                child: Text(l10n.onboardingSkip),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _index = i),
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(page.icon,
                            size: 96, color: theme.colorScheme.primary),
                        const SizedBox(height: 32),
                        Text(page.title,
                            style: theme.textTheme.headlineSmall,
                            textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        Text(
                          page.body,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            _Dots(count: pages.length, index: _index),
            Padding(
              padding: const EdgeInsets.all(24),
              child: FilledButton(
                onPressed: () => _next(pages.length),
                child: Text(
                    isLast ? l10n.onboardingGetStarted : l10n.onboardingNext),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index});
  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: i == index ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == index
                  ? scheme.primary
                  : scheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ],
    );
  }
}
