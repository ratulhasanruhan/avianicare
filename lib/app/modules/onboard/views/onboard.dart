import 'package:avianicare/app/modules/auth/views/forget_otp_screen.dart';
import 'package:avianicare/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../config/routes/app_routes.dart';
import '../controller/OnBoardController.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {

  final onBoardCon = Get.put(OnBoardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView.builder(
                itemCount: onBoardCon.demoData.length,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                controller: onBoardCon.pageController,
                onPageChanged: (int index) {
                  onBoardCon.currentPage.value = index;
                  print(index);
                },
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Image.asset(
                        onBoardCon.demoData[index].image,
                        height: MediaQuery.of(context).size.height * 0.5,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              onBoardCon.demoData[index].title,
                              style: const TextStyle(
                                fontSize: 30,
                                color: Color(0xFF000000),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              onBoardCon.demoData[index].description,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF565656),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                    ],
                  );
                },
              ),
              Positioned(
                right: 0,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 100.h),
                  child: SvgPicture.asset(
                    "assets/icons/paw.svg",
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Column(
                  children: [
                    Obx(
                          () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          onBoardCon.demoData.length,
                              (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: 4,
                            width: 28, // Adjust the size of the active dot
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: onBoardCon.currentPage.value == index
                                  ? Color(0xFF1A1A1A)
                                  : Color(0xFFD9D9D9), // Adjust active and inactive dot colors
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: buttonGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.only(top: 30, bottom: 10),
                      child: ElevatedButton(
                          onPressed: () {
                            if (onBoardCon.currentPage == onBoardCon.demoData.length - 1) {
                              Get.offNamed(Routes.navBarView);
                            } else {
                              onBoardCon.pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            minimumSize: Size(MediaQuery.of(context).size.width*0.9, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                onBoardCon.currentPage.value == onBoardCon.demoData.length - 1 ? "Get Started" : "Next",
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 15),
                              SvgPicture.asset(
                                "assets/icons/right_arrow.svg",
                              ),
                            ],
                          ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }

}
