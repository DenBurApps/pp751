import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pp751/navigation/routes.dart';
import 'package:pp751/ui_kit/colors.dart';
import 'package:pp751/ui_kit/text_styles.dart';
import 'package:pp751/ui_kit/widgets/app_elevated_button.dart';
import 'package:pp751/utils/assets_paths.dart';
import 'package:pp751/utils/constants.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  late final PageController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  Future<void> _nextPage() async {
    if (_currentPage == 2) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } else {
      setState(() => _currentPage++);
      await _controller.nextPage(
        duration: AppConstants.duration200,
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = 532 / 812 * MediaQuery.sizeOf(context).height;
    final width = 237 / 375 * MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(150),
                    ),
                    color: AppColors.surface.withOpacity(.4),
                  ),
                  height: height,
                  width: width,
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Expanded(
                        child: SvgPicture.asset(AppImages.onBoarding1),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Welcome\nto the world\nof gardening',
                        style: AppStyles.displayLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Manage your plant care with\nease!',
                        style: AppStyles.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      AppElevatedButton(buttonText: 'Next', onTap: _nextPage),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(150),
                    ),
                    color: AppColors.surface.withOpacity(.4),
                  ),
                  height: height,
                  width: width,
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 52),
                      Expanded(
                        child: SvgPicture.asset(AppImages.onBoarding2),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Add plants',
                        style: AppStyles.displayLarge
                            .apply(color: AppColors.primary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Create a list of your plants and\nkeep track of their condition',
                        style:
                            AppStyles.bodyLarge.apply(color: AppColors.primary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      AppElevatedButton(buttonText: 'Next', onTap: _nextPage),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(150),
                    ),
                    color: AppColors.surface.withOpacity(.4),
                  ),
                  height: height,
                  width: width,
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 23),
                      Expanded(
                        child: Image.asset(AppImages.onBoarding3),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Ready to get\nstarted?',
                        style: AppStyles.displayLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Add your first plant and start\ncaring!',
                        style: AppStyles.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      AppElevatedButton(buttonText: 'Start', onTap: _nextPage),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
