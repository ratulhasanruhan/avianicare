import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            PageView.builder(
              itemCount: onBoardCon.demoData.length,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index) {
                onBoardCon.currentPage.value = index;
              },
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    const SizedBox(height: 50),
                    Image.asset(
                      onBoardCon.demoData[index].image,
                      height: 300,
                    ),
                    const SizedBox(height: 40),
                    Text(
                      onBoardCon.demoData[index].title,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      onBoardCon.demoData[index].description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                  ],
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        if (onBoardCon.currentPage.value != onBoardCon.demoData.length - 1) {
                          onBoardCon.currentPage.value = onBoardCon.demoData.length - 1;
                        } else {
                          Get.offNamed('/home');
                        }
                      },
                      child: Text(
                        onBoardCon.currentPage.value != onBoardCon.demoData.length - 1 ? 'Skip' : 'Get Started',
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: SizedBox(
                      width: 20,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Obx(
                          () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          onBoardCon.demoData.length,
                              (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: 5,
                            width: onBoardCon.currentPage.value == index ? 15 : 5, // Adjust the size of the active dot
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: onBoardCon.currentPage.value == index
                                  ? Colors.black
                                  : Colors.grey, // Adjust active and inactive dot colors
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
