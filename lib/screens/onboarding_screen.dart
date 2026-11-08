import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/widzew_colors.dart';
import '../widgets/splash_view.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onFinished;

  const OnboardingScreen({
    super.key,
    required this.onFinished,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _slideIcons = [
    Icons.campaign_outlined,
    Icons.home_repair_service_outlined,
    Icons.favorite_outline,
  ];

  final _pages = PageController();
  var _index = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slides = [
      (
        _slideIcons[0],
        context.tr('onboardingTitle1'),
        context.tr('onboardingBody1'),
      ),
      (
        _slideIcons[1],
        context.tr('onboardingTitle2'),
        context.tr('onboardingBody2'),
      ),
      (
        _slideIcons[2],
        context.tr('onboardingTitle3'),
        context.tr('onboardingBody3'),
      ),
    ];
    final last = _index == slides.length - 1;
    return Scaffold(
      backgroundColor: WidzewColors.red,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: widget.onFinished,
                  child: Text(
                    context.tr('onboardingSkip'),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pages,
                  itemCount: slides.length,
                  onPageChanged: (index) => setState(() => _index = index),
                  itemBuilder: (context, index) {
                    final slide = slides[index];
                    return Column(
                      children: [
                        const Spacer(),
                        if (index == 0)
                          const WidzewLMark(size: 96)
                        else
                          Icon(slide.$1, size: 88, color: Colors.white),
                        const SizedBox(height: 16),
                        Text(
                          slide.$2,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          slide.$3,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.4,
                          ),
                        ),
                        const Spacer(),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < slides.length; i++)
                    Container(
                      width: i == _index ? 18 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: i == _index ? 1 : 0.4,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: WidzewColors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: last
                    ? widget.onFinished
                    : () => _pages.nextPage(
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOutCubic,
                        ),
                child: Text(
                  last
                      ? context.tr('onboardingStart')
                      : context.tr('onboardingNext'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
