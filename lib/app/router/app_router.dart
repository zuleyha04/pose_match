import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pose_match/app/navigation/main_shell_page.dart';
import 'package:pose_match/app/navigation/main_shell_scope.dart';
import 'package:pose_match/app/router/app_routes.dart';
import 'package:pose_match/app/router/app_transitions.dart';
import 'package:pose_match/features/favorites/presentation/pages/favorites_page.dart';
import 'package:pose_match/features/home/presentation/pages/home_page.dart';
import 'package:pose_match/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:pose_match/features/poses/presentation/pages/pose_detail_page.dart';
import 'package:pose_match/features/poses/presentation/pages/poses_page.dart';
import 'package:pose_match/features/poses/presentation/stores/pose_store.dart';
import 'package:pose_match/features/settings/presentation/pages/settings_page.dart';
import 'package:pose_match/features/splash/presentation/pages/splash_page.dart';
import 'package:provider/provider.dart';

abstract final class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    routes: [
      // Splash
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) {
          return AppTransitions.fade(state: state, child: const SplashPage());
        },
      ),

      // Onboarding
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) {
          return AppTransitions.fadeScale(
            state: state,
            child: const OnboardingPage(),
          );
        },
      ),

      // Main Navigation
      StatefulShellRoute(
        navigatorContainerBuilder: (context, navigationShell, children) {
          return _AnimatedBranchContainer(
            currentIndex: navigationShell.currentIndex,
            children: children,
          );
        },
        builder: (context, state, navigationShell) {
          return MainShellScope(
            child: MainShellPage(
              navigationShell: navigationShell,
              onAddPosePressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Poz ekleme akışı yakında eklenecek.'),
                  ),
                );
              },
            ),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.favorites,
                builder: (context, state) => const FavoritesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.poses,
                builder: (context, state) => const PosesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),

      // Pose Detail
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.poseDetail,
        pageBuilder: (context, state) {
          final poseId = state.pathParameters['poseId'];
          final poseStore = state.extra as PoseStore?;

          if (poseId == null || poseStore == null) {
            throw StateError('PoseDetail için gerekli veri bulunamadı.');
          }

          return AppTransitions.fadeScale(
            state: state,
            child: ChangeNotifierProvider<PoseStore>.value(
              value: poseStore,
              child: PoseDetailPage(poseId: poseId),
            ),
          );
        },
      ),
    ],
  );
}

class _AnimatedBranchContainer extends StatelessWidget {
  const _AnimatedBranchContainer({
    required this.currentIndex,
    required this.children,
  });

  final int currentIndex;
  final List<Widget> children;

  static const Duration _duration = Duration(milliseconds: 220);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(children.length, (index) {
        final isActive = index == currentIndex;

        return IgnorePointer(
          ignoring: !isActive,
          child: AnimatedOpacity(
            opacity: isActive ? 1 : 0,
            duration: _duration,
            curve: Curves.easeOut,
            child: AnimatedScale(
              scale: isActive ? 1 : 0.985,
              duration: _duration,
              curve: Curves.easeOutCubic,
              child: TickerMode(enabled: isActive, child: children[index]),
            ),
          ),
        );
      }),
    );
  }
}
