import 'package:auto_route/auto_route.dart';
import 'package:example/main.dart';
import 'package:example/onboarding/core/application/onboard_data.dart';
import 'package:example/onboarding/core/presentation/new_text_button.dart';
import 'package:example/onboarding/core/presentation/onboard_nav_bar.dart';
import 'package:example/provider/providers.dart';
import 'package:example/routes/router.gr.dart';
import 'package:example/screens/niveau/widget/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  int currentPage = 0;

  final PageController _pageController = PageController(initialPage: 0);

  AnimatedContainer dotIndicator(index) {
    return AnimatedContainer(
      margin: const EdgeInsets.only(right: 5),
      duration: const Duration(milliseconds: 400),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : kSecondaryColor,
        shape: BoxShape.circle,
      ),
    );
  }

  Future setSeenonboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    seenOnboard = await prefs.setBool('seenOnboard', true);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // initialize size config
    SizeConfig().init(context);
    double sizeH = SizeConfig.blockSizeH!;
    double sizeV = SizeConfig.blockSizeV!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.only(left: 50, right: 50),
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: onboardingContents.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    SizedBox(
                      height: sizeV * 5,
                    ),
                    Text(
                      onboardingContents[index].title,
                      style: kTitle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: sizeV * 5,
                    ),
                    Container(
                      height: sizeV * 50,
                      child: Image.asset(
                        onboardingContents[index].image,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: sizeV * 5,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: onboardingBody,
                        children: [
                          TextSpan(
                              text: onboardingContents[index]
                                  .description
                                  .toString()),
                          // TextSpan(
                          //     text: 'HELP YOU ',
                          //     style: TextStyle(
                          //       color: kPrimaryColor,
                          //     )),
                          // TextSpan(text: 'TO BE A BETTER '),
                          // TextSpan(text: 'VERSION OF '),
                          // TextSpan(
                          //   text: 'YOURSELF ',
                          //   style: TextStyle(
                          //     color: kPrimaryColor,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: sizeV * 5,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  currentPage == onboardingContents.length - 1
                      ? MyTextButton(
                          buttonName: 'Commencer',
                          onPressed: () async {
                            await ref
                                .read(onBoardingProvider.notifier)
                                .setOnboarded();
                            // context.router.push(const NiveauRoute());
                          },
                          bgColor: kPrimaryColor,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            OnBoardNavBtn(
                              name: 'Sauter',
                              onPressed: () async {
                                await ref
                                    .read(onBoardingProvider.notifier)
                                    .setOnboarded();
                                // context.router.push(const NiveauRoute());
                              },
                            ),
                            Row(
                              children: List.generate(
                                onboardingContents.length,
                                (index) => dotIndicator(index),
                              ),
                            ),
                            OnBoardNavBtn(
                              name: 'Suivant',
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              },
                            )
                          ],
                        ),
                  SizedBox(
                    height: sizeV * 2,
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
