import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:avianicare/app/modules/category/views/category_wise_product_screen.dart';
import 'package:avianicare/app/modules/home/controller/category_controller.dart';
import 'package:avianicare/widgets/textwidget.dart';
import '../../../../config/theme/app_color.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.find<CategoryController>();

    return Container(
      height: 150.h,
      width: double.infinity,
      color: AppColor.whiteColor, // white hobe
      child: Obx(() {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: categoryController.categoryModel.value.data!.length,
          itemBuilder: (context, index) {
            final category = categoryController.categoryModel.value.data!;
            return Center(
              child: InkWell(
                onTap: () {
                  Get.to(
                    () => CategoryWiseProductScreen(
                        categoryModel: category[index]),
                  );
                },
                child: SizedBox(
                  height: 140.h,
                  width: 100.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl: category[index].thumb.toString(),
                        imageBuilder: (context, imageProvider) => Container(
                          height: 100.h,
                          width: 93.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextWidget(
                          text: category[index].name,
                          textAlign: TextAlign.start,
                          color: Color(0xFF464646),
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
