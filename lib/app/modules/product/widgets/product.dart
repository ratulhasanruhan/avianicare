import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:avianicare/widgets/textwidget.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';

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
                )
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
                    height: 4.h,
                  ),
                  RatingBarIndicator(
                    rating: double.parse(rating.toString() == 'null'
                        ? '0'
                        : (double.parse(rating.toString()) / textRating!.toInt())
                            .toString()),
                    itemSize: 10.h,
                    unratedColor: AppColor.inactiveColor,
                    itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 1.w),
                      child: SvgPicture.asset(
                        SvgIcon.star,
                        colorFilter: const ColorFilter.mode(
                            AppColor.yellowColor, BlendMode.srcIn),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  TextWidget(
                    text:
                        "${rating.toString() == 'null' ? '0' : double.parse(rating.toString()) / textRating!.toInt()} (${textRating ?? 0} ${' Reviews'.tr})",
                    color: AppColor.textColor1,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  FittedBox(
                    child: Row(
                      children: [
                        TextWidget(
                          text: discountPrice ?? '0',
                          color: AppColor.textColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        isOffer == true
                            ? TextWidget(
                                text: currentPrice ?? '0',
                                color: AppColor.redColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.lineThrough,
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
