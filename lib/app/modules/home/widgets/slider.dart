import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_color.dart';
import '../controller/slider_controller.dart';

class SliderWidget extends StatelessWidget {
  const SliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final sliderController = Get.find<SliderController>();

    return Container(
      height: 170.h,
      width: 328.w,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        children: [
          Obx(() {
            return CarouselSlider.builder(
              itemCount: sliderController.sliderData.value.data!.length,
              itemBuilder: (context, index, _) {
                final data = sliderController.sliderData.value.data!;
                return Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: CachedNetworkImage(
                    imageUrl: data[index].image.toString(),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: 155.h,
                viewportFraction: 0.9,
                autoPlay: true,
                padEnds: false,
                enlargeCenterPage: false,
                disableCenter: true,
                onPageChanged: (index, reason) {
                  sliderController.handleSliderDots(index);
                },
              ),
            );
          }),
          SizedBox(
            height: 6,
          ),
          Obx(() {
            return DotsIndicator(
              dotsCount: sliderController.sliderData.value.data!.length,
              position: sliderController.dotIndex.value,
              decorator: DotsDecorator(
                spacing: EdgeInsets.only(left: 5.w),
                size: const Size(7, 8),
                activeSize: const Size(30, 6),
                activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                color: Colors.black.withOpacity(0.2),
                activeColor: Colors.black.withOpacity(0.5)
              ),
            );
          })
        ],
      ),
    );
  }
}
