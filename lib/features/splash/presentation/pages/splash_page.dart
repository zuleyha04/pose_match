import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pose_match/app/router/app_routes.dart';
import 'package:pose_match/core/constants/app_constants.dart';
import 'package:pose_match/core/constants/app_durations.dart';
import 'package:pose_match/core/constants/app_sizes.dart';
import 'package:pose_match/core/services/app_preferences.dart';
import 'package:pose_match/core/services/haptic_service.dart';
import 'package:pose_match/core/widgets/app_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;
  late final Animation<double> _sloganOpacity;
  late final Animation<Offset> _sloganPosition;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: AppDurations.splashAnimation,
    );

    _logoOpacity = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
    );

    _logoScale = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.90, curve: Curves.easeOutCubic),
      ),
    );

    _sloganOpacity = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.30, 0.70, curve: Curves.easeOut),
    );

    _sloganPosition =
        Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.30, 0.75, curve: Curves.easeOutCubic),
          ),
        );

    _startSplashFlow();
  }

  Future<void> _startSplashFlow() async {
    await HapticService.light();
    _animationController.forward();
    await Future<void>.delayed(AppDurations.splashDisplay);

    final bool isOnboardingCompleted =
        await AppPreferences.isOnboardingCompleted();
    if (!mounted) return;
    context.go(isOnboardingCompleted ? AppRoutes.home : AppRoutes.onboarding);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AppPage(
      backgroundColor: colorScheme.primary,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double logoWidth = (constraints.maxWidth * 0.55)
                .clamp(170.0, 220.0)
                .toDouble();

            final double sloganWidth = (constraints.maxWidth * 0.90)
                .clamp(240.0, 340.0)
                .toDouble();

            final double loadingWidth = (constraints.maxWidth * 0.75)
                .clamp(220.0, 360.0)
                .toDouble();

            return Stack(
              fit: StackFit.expand,
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FadeTransition(
                        opacity: _logoOpacity,
                        child: ScaleTransition(
                          scale: _logoScale,
                          child: SvgPicture.asset(
                            AppConstants.logo,
                            width: logoWidth,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.spacing12),
                      FadeTransition(
                        opacity: _sloganOpacity,
                        child: SlideTransition(
                          position: _sloganPosition,
                          child: SvgPicture.asset(
                            AppConstants.slogan,
                            width: sloganWidth,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  left: 0,
                  right: 0,
                  bottom: AppSizes.spacing24,
                  child: Center(
                    child: FadeTransition(
                      opacity: _sloganOpacity,
                      child: Lottie.asset(
                        AppConstants.loadingAnimationPath,
                        width: loadingWidth,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
