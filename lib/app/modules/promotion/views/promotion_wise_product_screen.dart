import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:avianicare/app/modules/home/controller/promotion_controller.dart';
import 'package:avianicare/app/modules/home/model/promotion_model.dart';
import 'package:avianicare/app/modules/wishlist/controller/wishlist_controller.dart';
import 'package:avianicare/utils/api_list.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../main.dart';
import '../../../../widgets/appbar4.dart';
import '../../../../widgets/shimmer/trendy_collections_shimmer.dart';
import '../../../../widgets/textwidget.dart';
import '../../auth/views/sign_in.dart';
import '../../product/widgets/product.dart';
import '../../product_details/views/product_details.dart';

class PromotionWiseProductScreen extends StatefulWidget {
  const PromotionWiseProductScreen(
      {super.key, String? slug, required this.promotion});

  final Datum promotion;

  @override
  State<PromotionWiseProductScreen> createState() =>
      _PromotionWiseProductScreenState();
}

class _PromotionWiseProductScreenState
    extends State<PromotionWiseProductScreen> {
  final promotionController = Get.put(PromotionalController());
  final wishlistController = Get.put(WishlistController());
  @override
  void initState() {
    print("promotion slug = ${widget.promotion.slug}");

    print(
        "promotionWiseProduct called = ${ApiList.promotionWiseProduct(slug: widget.promotion.slug ?? "")}");
    promotionController.fetchPromotionWiseProduct(
        promotionSlug: widget.promotion.slug ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarWidget4(text: ''),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          Obx(
            () => Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: TextWidget(
                text:
                    '${promotionController.promotionProductModel.value.data?.length ?? 0} Products Found'
                        .tr,
                color: AppColor.textColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Obx(
            () => promotionController.promotionProductLoader.value
                ? const TrendyCollectionShimmer()
                : Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: MasonryGridView.count(
                          // controller: cateWiseProductController
                          //     .scrollController,
                          crossAxisCount: 2,
                          mainAxisSpacing: 16.h,
                          crossAxisSpacing: 16.w,
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: promotionController
                              .promotionProductModel.value.data?.length,
                          itemBuilder: (context, index) {
                            // if (i ==
                            //     cateWiseProductController
                            //         .categoryWiseProductList.length) {
                            //   return Shimmer.fromColors(
                            //     baseColor: Colors.grey[200]!,
                            //     highlightColor: Colors.grey[300]!,
                            //     child: Container(
                            //       height: 207.h,
                            //       width: 156.w,
                            //       decoration: BoxDecoration(
                            //         borderRadius:
                            //             BorderRadius.circular(16.r),
                            //         color: Colors.white,
                            //         border: Border.all(
                            //             color: AppColor.borderColor),
                            //       ),
                            //     ),
                            //   );
                            // }

                            final data = promotionController
                                .promotionProductModel.value.data;
                            return GestureDetector(
                              onTap: () {
                                Get.to(() =>
                                    ProductDetailsScreen(data: data?[index]

                                        // categoryWiseProduct:
                                        // cateWiseProductController
                                        //         .categoryWiseProductList[
                                        //     i]

                                        ));
                              },
                              child: Obx(
                                () => ProductWidget(
                                  favTap: () async {
                                    if (box.read('isLogedIn') != false) {
                                      if (data?[index].wishlist == true) {
                                        await wishlistController
                                            .toggleFavoriteFalse(
                                                promotionController
                                                        .promotionProductModel
                                                        .value
                                                        .data?[index]
                                                        .id ??
                                                    -1);

                                        wishlistController.showFavorite(
                                            data?[index].id ?? -1);
                                      }
                                      if (data?[index].wishlist == false) {
                                        await wishlistController
                                            .toggleFavoriteTrue(
                                                data?[index].id ?? -1);

                                        wishlistController.showFavorite(
                                            data?[index].id ?? -1);
                                      }
                                    } else {
                                      Get.to(() => const SignInScreen());
                                    }
                                  },
                                  wishlist: wishlistController.favList
                                              .contains(data?[index].id!) ||
                                          data?[index].wishlist == true
                                      ? true
                                      : false,
                                  productImage: data?[index].cover.toString(),
                                  title: data?[index].name,
                                  currentPrice: data?[index].currencyPrice,
                                  discountPrice: data?[index].discountedPrice,
                                  rating: data?[index].ratingStar,
                                  textRating: data?[index].ratingStarCount,
                                  flashSale: data?[index].flashSale!,
                                  isOffer: data?[index].isOffer!,
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
