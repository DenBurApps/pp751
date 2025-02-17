import 'package:flutter/material.dart';
import 'package:flutter_app_info/flutter_app_info.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:pp751/remote_config.dart';
import 'package:pp751/ui_kit/colors.dart';
import 'package:pp751/ui_kit/text_styles.dart';
import 'package:pp751/utils/assets_paths.dart';
import 'package:pp751/utils/texts.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        surfaceTintColor: AppColors.background,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: Navigator.of(context).pop,
              child: SvgPicture.asset(AppIcons.back),
            ),
            const SizedBox(width: 25),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.surface.withOpacity(.5),
                  ),
                ),
                padding: const EdgeInsets.all(5),
                child: const Center(
                  child: Text('Settings', style: AppStyles.bodyLarge),
                ),
              ),
            ),
          ],
        ),
        titleSpacing: 20,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            _MenuButton(
              title: AppTexts.contactTitle,
              onTap: () async => await FlutterEmailSender.send(
                Email(
                  recipients: ['halepkanarceza@icloud.com'],
                  subject: 'Subject',
                  body: 'Your feedback',
                ),
              ),
            ),
            const SizedBox(height: 10),
            _MenuButton(
              title: AppTexts.rateTitle,
              onTap: () async {
                if (await InAppReview.instance.isAvailable()) {
                  await InAppReview.instance.requestReview();
                }
              },
            ),
            const SizedBox(height: 10),
            _MenuButton(
              title: AppTexts.privacyTitle,
              onTap: () async =>
                  await launchUrlString(RemoteConfigService.privacyLink),
            ),
            const SizedBox(height: 10),
            _MenuButton(
              title: AppTexts.termsTitle,
              onTap: () async =>
                  await launchUrlString(RemoteConfigService.termsLink),
            ),
            const SizedBox(height: 10),
            _MenuButton(
              title:
                  'Version: ${AppInfo.of(context).package.versionWithoutBuild}',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.title, required this.onTap});

  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.surface,
        ),
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.background,
          ),
          padding: const EdgeInsets.all(10),
          child: Center(child: Text(title, style: AppStyles.bodyMedium)),
        ),
      ),
    );
  }
}
