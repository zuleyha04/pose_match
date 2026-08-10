import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pose_match/core/constants/app_texts.dart';
import 'package:provider/provider.dart';
import 'package:pose_match/app/theme/app_colors.dart';
import 'package:pose_match/features/home/domain/entities/home_banner_entities.dart';
import 'package:pose_match/features/home/presentation/stores/home_banner_store.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeBannerStore>(
      builder: (context, store, child) {
        switch (store.status) {
          case HomeBannerStatus.initial:
          case HomeBannerStatus.loading:
            return const _BannerLoadingState();

          case HomeBannerStatus.error:
            return _BannerErrorState(
              message: store.errorMessage,
              onRetry: store.loadBanners,
            );

          case HomeBannerStatus.success:
            if (store.banners.isEmpty) {
              return const SizedBox.shrink();
            }

            return _BannerCarousel(banners: store.banners);
        }
      },
    );
  }
}

class _BannerCarousel extends StatefulWidget {
  const _BannerCarousel({required this.banners});
  final List<HomeBannerEntity> banners;

  @override
  State<_BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<_BannerCarousel> {
  static const Duration _autoScrollDuration = Duration(seconds: 3);

  static const Duration _pageAnimationDuration = Duration(milliseconds: 450);

  late final PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    if (widget.banners.length <= 1) {
      return;
    }

    _autoScrollTimer = Timer.periodic(_autoScrollDuration, (_) {
      if (!_pageController.hasClients) {
        return;
      }

      final nextPage = (_currentPage + 1) % widget.banners.length;

      _pageController.animateToPage(
        nextPage,
        duration: _pageAnimationDuration,
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 7,
          child: PageView.builder(
            controller: _pageController,
            clipBehavior: Clip.none,
            itemCount: widget.banners.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final banner = widget.banners[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _BannerItem(imageSource: banner.imageSource),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        _BannerIndicator(
          itemCount: widget.banners.length,
          currentIndex: _currentPage,
        ),
      ],
    );
  }
}

class _BannerItem extends StatelessWidget {
  const _BannerItem({required this.imageSource});

  final String imageSource;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Image.asset(
        imageSource,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _BannerIndicator extends StatelessWidget {
  const _BannerIndicator({required this.itemCount, required this.currentIndex});

  final int itemCount;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final isActive = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 18 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(100),
          ),
        );
      }),
    );
  }
}

class _BannerLoadingState extends StatelessWidget {
  const _BannerLoadingState();

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 16 / 7,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _BannerErrorState extends StatelessWidget {
  const _BannerErrorState({required this.message, required this.onRetry});

  final String? message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 7,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 28),
            const SizedBox(height: 8),
            Text(
              message ?? 'Bannerlar yüklenemedi.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            TextButton(onPressed: onRetry, child: const Text(AppTexts.retry)),
          ],
        ),
      ),
    );
  }
}
