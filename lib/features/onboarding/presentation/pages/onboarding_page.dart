import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pose_match/app/router/app_routes.dart';
import 'package:pose_match/core/constants/app_constants.dart';
import 'package:pose_match/core/constants/app_durations.dart';
import 'package:pose_match/core/constants/app_sizes.dart';
import 'package:pose_match/core/constants/app_texts.dart';
import 'package:pose_match/core/services/app_preferences.dart';
import 'package:pose_match/core/services/haptic_service.dart';
import 'package:pose_match/core/widgets/app_page.dart';
import 'package:pose_match/features/onboarding/presentation/widgets/onboarding_item.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const int _pageCount = 3;
  static const double _indicatorSize = 8;
  static const double _activeIndicatorWidth = 24;
  static const double _buttonMinHeight = 52;
  static const double _indicatorSpacing = 8;

  final PageController _pageController = PageController();

  int _currentPage = 0;

  bool get _isLastPage => _currentPage == _pageCount - 1;

  List<_OnboardingData> get _pages => const [
    _OnboardingData(
      imagePath: AppConstants.onboardingSelectPose,
      title: AppTexts.onboardingSelectPoseTitle,
      description: AppTexts.onboardingSelectPoseDescription,
    ),
    _OnboardingData(
      imagePath: AppConstants.onboardingAlignPose,
      title: AppTexts.onboardingAlignPoseTitle,
      description: AppTexts.onboardingAlignPoseDescription,
    ),
    _OnboardingData(
      imagePath: AppConstants.onboardingCapturePhoto,
      title: AppTexts.onboardingCapturePhotoTitle,
      description: AppTexts.onboardingCapturePhotoDescription,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _handlePageChanged(int pageIndex) async {
    if (_currentPage == pageIndex) return;

    setState(() {
      _currentPage = pageIndex;
    });

    await HapticService.selection();
  }

  Future<void> _handleNext() async {
    await HapticService.light();

    if (_isLastPage) {
      _completeOnboarding();
      return;
    }

    await _pageController.nextPage(
      duration: AppDurations.medium,
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _handleSkip() async {
    await HapticService.light();

    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    await AppPreferences.completeOnboarding();
    if (!mounted) return;
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AppPage(
      backgroundColor: colorScheme.surface,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: AnimatedOpacity(
              duration: AppDurations.short,
              opacity: _isLastPage ? 0 : 1,
              child: IgnorePointer(
                ignoring: _isLastPage,
                child: TextButton(
                  onPressed: _handleSkip,
                  child: const Text(AppTexts.skip),
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              physics: const BouncingScrollPhysics(),
              onPageChanged: _handlePageChanged,
              itemBuilder: (context, index) {
                final _OnboardingData page = _pages[index];
                return OnboardingItem(
                  imagePath: page.imagePath,
                  title: page.title,
                  description: page.description,
                );
              },
            ),
          ),
          const SizedBox(height: AppSizes.spacing12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pageCount, (index) {
              final bool isActive = index == _currentPage;

              return AnimatedContainer(
                duration: AppDurations.medium,
                curve: Curves.easeOutCubic,
                width: isActive ? _activeIndicatorWidth : _indicatorSize,
                height: _indicatorSize,
                margin: const EdgeInsets.symmetric(
                  horizontal: _indicatorSpacing / 2,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? colorScheme.primary
                      : colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(_indicatorSize),
                ),
              );
            }),
          ),
          const SizedBox(height: AppSizes.spacing32),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: _buttonMinHeight),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _handleNext,
                child: AnimatedSwitcher(
                  duration: AppDurations.short,
                  child: Text(
                    _isLastPage ? 'Başla' : 'İleri',
                    key: ValueKey<bool>(_isLastPage),
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingData {
  const _OnboardingData({
    required this.imagePath,
    required this.title,
    required this.description,
  });

  final String imagePath;
  final String title;
  final String description;
}
