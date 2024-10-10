import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/slider_controller.dart';

class SliderWidget extends StatelessWidget {
  const SliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final sliderController = Get.find<SliderController>();

    return Container(
      height: 170,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Obx(() {
            return CarouselSlider.builder(
              itemCount: sliderController.sliderData.value.data!.length ??0,
              itemBuilder: (context, index, realIndex) {
                return Container(
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        sliderController.sliderData.value.data![index].image!,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: 155,
                viewportFraction: 0.9,
                autoPlay: true,
                padEnds: false,
                enlargeCenterPage: false,
                disableCenter: true,
                enableInfiniteScroll: false,
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
                spacing: EdgeInsets.only(left: 5),
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
