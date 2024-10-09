import 'package:avianicare/utils/calculatePercentage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:avianicare/widgets/textwidget.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../cart/controller/cart_controller.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({
    super.key,
    this.title,
    this.textRating,
    this.discountPrice,
    this.currentPrice,
    this.rating,
    this.productImage,
    this.onTap,
    this.favTap,
    this.flashSale,
    this.isOffer,
    this.favColor,
    this.wishlist,
    this.reviews,
  });
  final String? productImage;
  final String? title;
  final int? textRating;
  final String? reviews;
  final String? discountPrice;
  final String? currentPrice;
  final String? rating;
  final void Function()? onTap;
  final void Function()? favTap;

  final bool? flashSale;
  final bool? isOffer;
  final String? favColor;
  final bool? wishlist;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 156.w,
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          border: Border.all(color: Color(0xFFD8D8D8)),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: productImage.toString(),
                  imageBuilder: (context, imageProvider) => Container(
                    height: 190.h,
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.r),
                        topRight: Radius.circular(12.r),
                      ),
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                ),
                Positioned(
                  left: 6.w,
                  right: 6.w,
                  top: 6.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      flashSale == true
                          ? Container(
                              height: 18.h,
                              width: 57.w,
                              decoration: BoxDecoration(
                                color: AppColor.blueColor,
                                borderRadius: BorderRadius.circular(9.r),
                              ),
                              child: Center(
                                child: TextWidget(
                                  text: 'Flash Sale'.tr,
                                  color: AppColor.whiteColor,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : const SizedBox(),
                      wishlist == false
                          ? InkWell(
                              onTap: favTap,
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColor.whiteColor,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    SvgIcon.heart,
                                    height: 18,
                                    width: 18,
                                    color: Color(0xFFA8A8A8),
                                  ),
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: favTap,
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColor.whiteColor,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    SvgIcon.filledHeart,
                                    height: 18,
                                    width: 18,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                Positioned(
                  left: 6.w,
                  right: 6.w,
                  bottom: 6.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star,
                              color: AppColor.yellowColor,
                              size: 12.sp,
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            TextWidget(
                              text: rating ?? '0',
                              color: AppColor.textColor,
                              fontWeight: FontWeight.w500,
                            ),
                            TextWidget(
                              text: " (${reviews ?? '0'})",
                              color: Color(0xFF989898),
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),

                      ),
                      InkWell(
                              onTap: (){

                              },
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColor.whiteColor,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/images/cart.svg',
                                    height: 18,
                                    width: 18,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 4.h,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: TextWidget(
                      text: title ?? '',
                      color: AppColor.textColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      maxLines: 2,
                      overflow: TextOverflow.fade,
                    ),
                  ),

                  SizedBox(
                    height: 12.h,
                  ),
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextWidget(
                          text: discountPrice ?? '0',
                          color: AppColor.textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        isOffer == true
                            ? TextWidget(
                                text: currentPrice ?? '0',
                                color: Color(0xFFA9A9A9),
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                              )
                            : const SizedBox(),
                        SizedBox(
                          width: 8.w,
                        ),
                        isOffer == true
                            ? Stack(
                          alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                    'assets/images/discounts.svg',
                                  ),
                                TextWidget(
                                  text: "${calculateDiscountPercentage(currentPrice?.replaceAll('৳', ''), discountPrice?.replaceAll('৳', ''))}%",
                                  color: AppColor.whiteColor,
                                  fontSize: 11,
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
