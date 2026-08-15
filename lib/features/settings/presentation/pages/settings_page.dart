import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pose_match/app/theme/app_colors.dart';
import 'package:pose_match/core/constants/app_constants.dart';
import 'package:pose_match/core/constants/app_texts.dart';
import 'package:pose_match/features/settings/presentation/widgets/settings_expansion_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.primary,
        surfaceTintColor: Colors.transparent,
        title: SvgPicture.asset(
          AppConstants.settings,
          height: 35,
          fit: BoxFit.contain,
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              SettingsExpansionTile(
                title: AppTexts.aboutPoseMatch,
                child: Text(
                  AppTexts.aboutPoseMatchDescription,
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SettingsExpansionTile(
                title: AppTexts.privacyPolicy,
                child: Text(
                  AppTexts.privacyPolicyDescription,
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SettingsExpansionTile(
                title: AppTexts.termsOfUse,
                child: Text(
                  AppTexts.termsOfUseDescription,
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
