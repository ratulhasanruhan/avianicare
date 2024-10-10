import 'package:avianicare/app/modules/cart/views/cart_screen.dart';
import 'package:avianicare/utils/api_list.dart';
import 'package:avianicare/widgets/primary_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:avianicare/app/modules/auth/controller/auth_controler.dart';
import 'package:avianicare/app/modules/auth/views/sign_in.dart';
import 'package:avianicare/app/modules/cart/controller/cart_controller.dart';
import 'package:avianicare/app/modules/category/controller/category_wise_product_controller.dart';
import 'package:avianicare/app/modules/category/model/category_wise_product.dart'
    as category_product;
import 'package:avianicare/app/modules/home/model/product_section.dart'
    as section_product;
import 'package:avianicare/app/modules/home/model/popular_product.dart'
    as Product;
import 'package:avianicare/app/modules/navbar/controller/navbar_controller.dart';
import 'package:avianicare/app/modules/navbar/views/navbar_view.dart';
import 'package:avianicare/app/modules/product/widgets/product.dart';
import 'package:avianicare/app/modules/product_details/controller/product_details_controller.dart';
import 'package:avianicare/app/modules/product_details/model/related_product.dart';
import 'package:avianicare/app/modules/promotion/model/promotion_wise_product.dart';
import 'package:avianicare/app/modules/search/model/all_product.dart';
import 'package:avianicare/app/modules/wishlist/controller/wishlist_controller.dart';
import 'package:avianicare/app/modules/wishlist/model/fav_model.dart';
import 'package:avianicare/main.dart';
import 'package:avianicare/widgets/custom_snackbar.dart';
import 'package:avianicare/widgets/custom_tabbar.dart';
import 'package:avianicare/widgets/devider.dart';
import 'package:avianicare/widgets/secondary_button.dart';
import 'package:avianicare/widgets/shimmer/product_details_shimmer.dart';
import 'package:avianicare/widgets/textwidget.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/custom_text.dart';
import '../../../../widgets/secondary_appbar.dart';
import '../../search/views/search_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen(
      {super.key,
      this.productModel,
      this.sectionModel,
      this.categoryWiseProduct,
      this.allProductModel,
      this.favoriteItem,
      this.relatedProduct,
      this.product,
      this.data,
      this.individualProduct});
  final category_product.Product? categoryWiseProduct;
  final section_product.Product? productModel;
  final section_product.Datum? sectionModel;
  final Datum? allProductModel;
  final FavoriteItem? favoriteItem;
  final RelatedProduct? relatedProduct;
  final Product.Datum? product;
  final Product.Datum? individualProduct;
  final PromotionProduct? data;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final navController = Get.put(NavbarController());
  final productDetailsController = Get.put(ProductDetailsController());
  final cartController = Get.put(CartController());
  final wishlistController = Get.put(WishlistController());
  final authController = Get.put(AuthController());
  final categoryWiseProductController =
      Get.put(CategoryWiseProductController());

  int quantity = 1;
  bool isClicked = false;
  int isSelected = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cartController.numOfItems.value = 1;
      productDetailsController.fetchProductDetails(
          slug: widget.productModel?.slug ??
              widget.categoryWiseProduct?.slug ??
              widget.allProductModel?.slug ??
              widget.favoriteItem?.slug ??
              widget.relatedProduct?.slug ??
              widget.product?.slug ??
              widget.individualProduct?.slug ??
              widget.data?.slug ??
              "");

      productDetailsController.fetchRelatedProduct(
          slug: widget.productModel?.slug ??
              widget.categoryWiseProduct?.slug ??
              widget.allProductModel?.slug ??
              widget.favoriteItem?.slug ??
              widget.product?.slug ??
              widget.individualProduct?.slug ??
              widget.data?.slug ??
              "");

      productDetailsController.fetchInitialVariation(
          productId: widget.productModel?.id.toString() ??
              widget.categoryWiseProduct?.id.toString() ??
              widget.allProductModel?.id.toString() ??
              widget.favoriteItem?.id.toString() ??
              widget.product?.id.toString() ??
              widget.individualProduct?.id.toString() ??
              widget.data?.id.toString() ??
              "0");

      authController.getSetting();
    });

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productDetailsController.resetProductState();
    });
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productDetailsController.fetchProductDetails(
          slug: widget.productModel?.slug ??
              widget.categoryWiseProduct?.slug ??
              widget.allProductModel?.slug ??
              widget.favoriteItem?.slug ??
              widget.relatedProduct?.slug ??
              widget.product?.slug ??
              widget.individualProduct?.slug ??
              widget.data?.slug ??
              "");
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
      child: GetBuilder<ProductDetailsController>(
        builder: (productDetailsController) {
          Future.delayed(Duration.zero, () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (productDetailsController.initialVariationModel.value.data !=
                      null &&
                  productDetailsController
                          .initialVariationModel.value.data!.length >
                      0) {
                productDetailsController.variationProductId.value = '';
                productDetailsController.variationProductPrice.value = '';
                productDetailsController.variationProductCurrencyPrice.value =
                    '';
                productDetailsController.variationProductOldPrice.value = '';
                productDetailsController
                    .variationProductOldCurrencyPrice.value = '';
                productDetailsController.variationsku.value = '';
                productDetailsController.variationsStock.value = -1;
              } else {
                productDetailsController.variationProductId.value =
                    productDetailsController.productModel.value.data?.id
                            .toString() ??
                        '';
                productDetailsController.variationProductPrice.value =
                    productDetailsController.productModel.value.data?.price
                            .toString() ??
                        '';
                productDetailsController.variationProductCurrencyPrice.value =
                    productDetailsController
                            .productModel.value.data?.currencyPrice
                            .toString() ??
                        '';
                productDetailsController.variationProductOldPrice.value =
                    productDetailsController.productModel.value.data?.oldPrice
                            .toString() ??
                        '';
                productDetailsController.variationProductOldCurrencyPrice
                    .value = productDetailsController
                        .productModel.value.data?.oldCurrencyPrice
                        .toString() ??
                    '';
                productDetailsController.variationsku.value =
                    productDetailsController.productModel.value.data?.sku
                            .toString() ??
                        '';
                productDetailsController.variationsStock.value =
                    productDetailsController.productModel.value.data?.stock!
                            .toInt() ??
                        -1;
              }
            });
          });
          return Scaffold(
            backgroundColor: AppColor.whiteColor,
            appBar: SecondaryAppBar(onTap: () {
              Get.to(() => const CartScreen());
            },
              title: 'Product Details'.tr,
            ),
            bottomNavigationBar: Obx(() {
                return Container(
                    height: 60.h,
                  color: AppColor.whiteColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){
                          Get.to(() => const CartScreen());
                        },
                        child: Container(
                          height: 53,
                          width: 55,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColor.blackColor,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/images/cart.svg',
                              color: AppColor.whiteColor,
                              height: 24,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 52,
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                          gradient: productDetailsController
                              .variationsStock.value >
                              0
                              ? buttonGradient
                              : LinearGradient(
                              colors: [
                                AppColor.grayColor,
                                AppColor.grayColor,
                              ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (productDetailsController
                                .initialVariationModel
                                .value
                                .data !=
                                null &&
                                productDetailsController
                                    .initialVariationModel
                                    .value
                                    .data!
                                    .length >
                                    0) {
                              if (productDetailsController
                                  .variationsStock.value >
                                  0) {
                                await productDetailsController
                                    .finalVariation(
                                    id: productDetailsController
                                        .variationProductId
                                        .toString());
                                cartController
                                    .totalIndividualProductTax =
                                0.0;
                                productDetailsController
                                    .productModel
                                    .value
                                    .data!
                                    .taxes!
                                    .map((e) {
                                  cartController
                                      .totalIndividualProductTax +=
                                      double.parse(
                                          e.taxRate.toString());
                                }).toList();

                                var taxMap =
                                productDetailsController
                                    .productModel
                                    .value
                                    .data!
                                    .taxes!
                                    .map((e) {
                                  return {
                                    "id": e.id!.toInt(),
                                    "name": e.name.toString(),
                                    "code": e.code.toString(),
                                    "tax_rate": double.tryParse(
                                        e.taxRate.toString()),
                                    'tax_amount': double.tryParse(
                                        cartController.totalTax
                                            .toString()),
                                  };
                                }).toList();

                                cartController.addItem(
                                    variationStock: productDetailsController.variationsStock.value
                                        .toInt(),
                                    product: productDetailsController
                                        .productModel.value,
                                    variationId: int.parse(productDetailsController
                                        .variationProductId
                                        .value),
                                    shippingAmount: authController.settingModel?.data?.shippingSetupMethod.toString() == "5" &&
                                        productDetailsController
                                            .productModel
                                            .value
                                            .data
                                            ?.shipping
                                            ?.shippingType
                                            .toString() ==
                                            "5"
                                        ? "0"
                                        : productDetailsController
                                        .productModel
                                        .value
                                        .data!
                                        .shipping!
                                        .shippingCost,
                                    finalVariation: productDetailsController.finalVariationString,
                                    sku: productDetailsController.variationsku.value,
                                    taxJson: taxMap,
                                    stock: productDetailsController.variationsStock.value,
                                    shipping: productDetailsController.productModel.value.data!.shipping,
                                    productVariationPrice: productDetailsController.variationProductPrice.value,
                                    productVariationOldPrice: productDetailsController.variationProductOldPrice.value,
                                    productVariationCurrencyPrice: productDetailsController.variationProductCurrencyPrice.value,
                                    productVariationOldCurrencyPrice: productDetailsController.variationProductOldCurrencyPrice.value,
                                    totalTax: cartController.totalIndividualProductTax,
                                    flatShippingCost: authController.settingModel?.data?.shippingSetupFlatRateWiseCost.toString() ?? "0");

                                cartController.calculateShippingCharge(
                                    shippingMethodStatus:
                                    authController
                                        .shippingMethod,
                                    shippingType:
                                    productDetailsController
                                        .productModel
                                        .value
                                        .data
                                        ?.shipping
                                        ?.shippingType
                                        .toString() ??
                                        "0",
                                    isProductQntyMultiply:
                                    productDetailsController
                                        .productModel
                                        .value
                                        .data
                                        ?.shipping
                                        ?.isProductQuantityMultiply
                                        .toString() ??
                                        "0",
                                    flatShippingCharge: authController
                                        .settingModel
                                        ?.data
                                        ?.shippingSetupFlatRateWiseCost);

                                customSnackbar(
                                    "SUCCESS".tr,
                                    "Product added to cart".tr,
                                    AppColor.success);
                              } else {}
                            } else {
                              if (productDetailsController
                                  .variationsStock.value >
                                  0) {
                                cartController
                                    .totalIndividualProductTax =
                                0.0;

                                productDetailsController
                                    .productModel
                                    .value
                                    .data!
                                    .taxes!
                                    .map((e) {
                                  cartController
                                      .totalIndividualProductTax +=
                                      double.parse(
                                          e.taxRate.toString());
                                }).toList();

                                var taxMap =
                                productDetailsController
                                    .productModel
                                    .value
                                    .data!
                                    .taxes!
                                    .map((e) {
                                  return {
                                    "id": e.id!.toInt(),
                                    "name": e.name.toString(),
                                    "code": e.code.toString(),
                                    "tax_rate": double.tryParse(
                                        e.taxRate.toString()),
                                    'tax_amount': double.tryParse(
                                        cartController.totalTax
                                            .toString()),
                                  };
                                }).toList();

                                cartController.addItem(
                                    variationStock: productDetailsController.variationsStock.value
                                        .toInt(),
                                    product: productDetailsController
                                        .productModel.value,
                                    variationId: int.parse(productDetailsController
                                        .variationProductId
                                        .value),
                                    shippingAmount: authController.settingModel!.data!.shippingSetupMethod.toString() == "5" &&
                                        productDetailsController
                                            .productModel
                                            .value
                                            .data
                                            ?.shipping
                                            ?.shippingType
                                            .toString() ==
                                            "5"
                                        ? "0"
                                        : productDetailsController
                                        .productModel
                                        .value
                                        .data!
                                        .shipping!
                                        .shippingCost,
                                    finalVariation: productDetailsController.finalVariationString,
                                    sku: productDetailsController.productModel.value.data!.sku,
                                    taxJson: taxMap,
                                    stock: productDetailsController.productModel.value.data!.stock,
                                    shipping: productDetailsController.productModel.value.data!.shipping,
                                    productVariationPrice: productDetailsController.productModel.value.data!.price,
                                    productVariationOldPrice: productDetailsController.productModel.value.data!.oldPrice,
                                    productVariationCurrencyPrice: productDetailsController.productModel.value.data!.currencyPrice,
                                    productVariationOldCurrencyPrice: productDetailsController.productModel.value.data!.oldCurrencyPrice,
                                    totalTax: cartController.totalIndividualProductTax,
                                    flatShippingCost: authController.settingModel?.data?.shippingSetupFlatRateWiseCost.toString() ?? "0");

                                cartController
                                    .calculateShippingCharge(
                                  shippingMethodStatus:
                                  authController
                                      .shippingMethod,
                                  shippingType:
                                  productDetailsController
                                      .productModel
                                      .value
                                      .data
                                      ?.shipping
                                      ?.shippingType
                                      .toString() ??
                                      "0",
                                  isProductQntyMultiply:
                                  productDetailsController
                                      .productModel
                                      .value
                                      .data
                                      ?.shipping
                                      ?.isProductQuantityMultiply
                                      .toString() ??
                                      "0",
                                  flatShippingCharge: authController
                                      .settingModel
                                      ?.data
                                      ?.shippingSetupFlatRateWiseCost,
                                );

                                customSnackbar(
                                    "SUCCESS".tr,
                                    "Product added to cart".tr,
                                    AppColor.success);
                              } else {}
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            minimumSize: Size(52, MediaQuery.of(context).size.width * 0.65),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'ADD TO CART',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
            ),
            body: RefreshIndicator(
              color: AppColor.primaryColor,
              onRefresh: () async {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  productDetailsController.fetchProductDetails(
                      slug: widget.productModel?.slug ??
                          widget.categoryWiseProduct?.slug ??
                          widget.allProductModel?.slug ??
                          widget.favoriteItem?.slug ??
                          widget.relatedProduct?.slug ??
                          widget.individualProduct?.slug ??
                          "");

                  productDetailsController.fetchRelatedProduct(
                      slug: widget.productModel?.slug ??
                          widget.categoryWiseProduct?.slug ??
                          widget.allProductModel?.slug ??
                          widget.favoriteItem?.slug ??
                          widget.product?.slug ??
                          widget.individualProduct?.slug ??
                          "");

                  productDetailsController.fetchInitialVariation(
                      productId: widget.productModel?.id.toString() ??
                          widget.categoryWiseProduct?.id.toString() ??
                          widget.allProductModel?.id.toString() ??
                          widget.favoriteItem?.id.toString() ??
                          widget.product?.id.toString() ??
                          widget.individualProduct?.id.toString() ??
                          "0");

                  productDetailsController.variationProductId.value = '';
                  productDetailsController.variationProductPrice.value = '';
                  productDetailsController
                      .variationProductCurrencyPrice.value = '';
                  productDetailsController.variationProductOldPrice.value =
                      '';
                  productDetailsController
                      .variationProductOldCurrencyPrice.value = '';
                  productDetailsController.variationsku.value = '';
                  productDetailsController.variationsStock.value = -1;
                });
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Obx(
                  () => productDetailsController.isLaoding.value == 1
                      ? const ProductDetailsShimmer()
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          CarouselSlider.builder(
                              itemCount: productDetailsController.productModel.value.data?.images?.length ?? 0,
                              itemBuilder: (context, index, realIndex) {
                                final image = productDetailsController.productModel.value.data?.images?[index];
                                return CachedNetworkImage(
                                  imageUrl: image!,
                                  imageBuilder: (context, imageProvider) {
                                    return Container(
                                      height: 360.h,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              options: CarouselOptions(
                                height: 360.h,
                                viewportFraction: 1,
                                enableInfiniteScroll: false,
                              ),
                          ),
                          Positioned(
                            bottom: 10,
                            child: DotsIndicator(
                              dotsCount: productDetailsController.productModel.value.data?.images?.length ?? 0,
                              decorator: DotsDecorator(
                                  spacing: EdgeInsets.only(left: 5.w),
                                  size: const Size(7, 8),
                                  activeSize: const Size(30, 6),
                                  activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                  color: Colors.white.withOpacity(0.5),
                                  activeColor: Colors.white.withOpacity(0.5)
                              ),
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 10,
                            child: Column(
                              children: [
                                Obx( () {
                                    return IconButton(
                                        onPressed: () async {
                                              if (box.read('isLogedIn') != false) {
                                                if (productDetailsController
                                                        .productModel
                                                        .value
                                                        .data!
                                                        .wishlist ==
                                                    true) {
                                                  await wishlistController
                                                      .toggleFavoriteFalse(
                                                          productDetailsController
                                                              .productModel
                                                              .value
                                                              .data!
                                                              .id!);

                                                  wishlistController.showFavorite(
                                                      productDetailsController
                                                          .productModel
                                                          .value
                                                          .data!
                                                          .id!);
                                                }
                                                if (productDetailsController
                                                        .productModel
                                                        .value
                                                        .data!
                                                        .wishlist ==
                                                    false) {
                                                  await wishlistController
                                                      .toggleFavoriteTrue(
                                                          productDetailsController
                                                              .productModel
                                                              .value
                                                              .data!
                                                              .id!);

                                                  wishlistController.showFavorite(
                                                      productDetailsController
                                                          .productModel
                                                          .value
                                                          .data!
                                                          .id!);
                                                }
                                              } else {
                                                Get.to(() => const SignInScreen());
                                              }
                                            },
                                        icon: wishlistController.favList.contains(
                                            productDetailsController
                                                .productModel
                                                .value
                                                .data!
                                                .id!) ||
                                            productDetailsController
                                                .productModel
                                                .value
                                                .data!
                                                .wishlist ==
                                                true
                                            ? Icon(Icons.favorite, color: AppColor.redColor, size: 30)
                                        : Icon(Icons.favorite_border, color: AppColor.whiteColor, size: 30)

                                    );
                                  }
                                ),
                                SizedBox(height: 10.h),
                                IconButton(
                                    onPressed: (){
                                      Share.share("${ApiList.baseUrl}/product/${productDetailsController.productModel.value.data!.slug}", subject: 'Check out this product');
                                    },
                                    icon: Icon(Icons.share_outlined, color: AppColor.whiteColor,
                                        size: 30)
                                ),

                              ],
                            ),
                          )
                        ],
                      ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    SizedBox(height: 10.h),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: AppColor.yellowColor,
                                              size: 20,
                                            ),
                                            SizedBox(
                                              width: 4.w,
                                            ),
                                            TextWidget(
                                              text: '${productDetailsController.productModel.value.data!.ratingStar.toString() == 'null' ? '0' : double.parse(productDetailsController.productModel.value.data!.ratingStar.toString()) / productDetailsController.productModel.value.data!.ratingStarCount!.toInt()}',
                                              color: AppColor.textColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            TextWidget(
                                              text:  " (${productDetailsController.productModel.value.data!.ratingStarCount} ${' Reviews'.tr})",
                                              color: Color(0xFF989898),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ],
                                        ),
                                        CustomText(
                                          textAlign: TextAlign.left,
                                          text: productDetailsController
                                              .productModel.value.data!.name,
                                          size: 21,
                                          weight: FontWeight.w700,
                                        ),
                                        SizedBox(height: 8.h),
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
                                    Divider(
                                      height: 1.h,
                                      color: const Color(0xFFEFF0F6),
                                    ),
                                    SizedBox(height: 8.h),
                                    productDetailsController.initialIndex.value ==
                                                -1 &&
                                            productDetailsController
                                                    .initialVariationModel
                                                    .value
                                                    .data ==
                                                null
                                        ? const SizedBox()
                                        : Column(
                                            children: [
                                              productDetailsController
                                                              .initialVariationModel
                                                              .value
                                                              .data !=
                                                          null &&
                                                      productDetailsController
                                                              .initialVariationModel
                                                              .value
                                                              .data!
                                                              .length >
                                                          0
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        productDetailsController
                                                                        .initialVariationModel
                                                                        .value
                                                                        .data !=
                                                                    null &&
                                                                productDetailsController
                                                                        .initialVariationModel
                                                                        .value
                                                                        .data!
                                                                        .length >
                                                                    0
                                                            ? CustomText(
                                                                text:
                                                                    '${productDetailsController.initialVariationModel.value.data?[0].productAttributeName.toString().tr}:',
                                                                size: 14.sp,
                                                                weight:
                                                                    FontWeight.w600,
                                                              )
                                                            : SizedBox(),
                                                        productDetailsController
                                                                        .initialVariationModel
                                                                        .value
                                                                        .data !=
                                                                    null &&
                                                                productDetailsController
                                                                        .initialVariationModel
                                                                        .value
                                                                        .data!
                                                                        .length >
                                                                    0
                                                            ? SizedBox(height: 8.h)
                                                            : SizedBox(),
                                                        productDetailsController
                                                                        .initialVariationModel
                                                                        .value
                                                                        .data !=
                                                                    null &&
                                                                productDetailsController
                                                                        .initialVariationModel
                                                                        .value
                                                                        .data!
                                                                        .length >
                                                                    0
                                                            ? SizedBox(
                                                                height: 32.h,
                                                                child: ListView
                                                                    .builder(
                                                                        itemCount: productDetailsController
                                                                                .initialVariationModel
                                                                                .value
                                                                                .data
                                                                                ?.length ??
                                                                            0,
                                                                        scrollDirection:
                                                                            Axis
                                                                                .horizontal,
                                                                        itemBuilder:
                                                                            (context,
                                                                                index) {
                                                                          return GestureDetector(
                                                                            onTap:
                                                                                () async {
                                                                              cartController
                                                                                  .numOfItems
                                                                                  .value = 1;

                                                                              productDetailsController
                                                                                  .selectedIndex1
                                                                                  .value = index;

                                                                              productDetailsController
                                                                                  .selectedIndex2
                                                                                  .value = -1;
                                                                              productDetailsController
                                                                                  .selectedIndex3
                                                                                  .value = -1;
                                                                              productDetailsController
                                                                                  .selectedIndex4
                                                                                  .value = -1;
                                                                              productDetailsController
                                                                                  .selectedIndex5
                                                                                  .value = -1;
                                                                              productDetailsController
                                                                                  .selectedIndex6
                                                                                  .value = -1;
                                                                              productDetailsController
                                                                                  .selectedIndex7
                                                                                  .value = -1;

                                                                              productDetailsController
                                                                                  .childrenVariationModel2
                                                                                  .value
                                                                                  .data
                                                                                  ?.clear();
                                                                              productDetailsController
                                                                                  .childrenVariationModel3
                                                                                  .value
                                                                                  .data
                                                                                  ?.clear();
                                                                              productDetailsController
                                                                                  .childrenVariationModel4
                                                                                  .value
                                                                                  .data
                                                                                  ?.clear();
                                                                              productDetailsController
                                                                                  .childrenVariationModel5
                                                                                  .value
                                                                                  .data
                                                                                  ?.clear();
                                                                              productDetailsController
                                                                                  .childrenVariationModel6
                                                                                  .value
                                                                                  .data
                                                                                  ?.clear();

                                                                              if (productDetailsController.initialVariationModel.value.data?[index].sku !=
                                                                                  null) {
                                                                                productDetailsController.variationProductId.value =
                                                                                    productDetailsController.initialVariationModel.value.data?[index].id.toString() ?? '';
                                                                                productDetailsController.variationProductPrice.value =
                                                                                    productDetailsController.initialVariationModel.value.data?[index].price.toString() ?? '';
                                                                                productDetailsController.variationProductCurrencyPrice.value =
                                                                                    productDetailsController.initialVariationModel.value.data?[index].currencyPrice.toString() ?? '';
                                                                                productDetailsController.variationProductOldPrice.value =
                                                                                    productDetailsController.initialVariationModel.value.data?[index].oldPrice.toString() ?? '';
                                                                                productDetailsController.variationProductOldCurrencyPrice.value =
                                                                                    productDetailsController.initialVariationModel.value.data?[index].oldCurrencyPrice.toString() ?? '';
                                                                                productDetailsController.variationsku.value =
                                                                                    productDetailsController.initialVariationModel.value.data?[index].sku.toString() ?? '';
                                                                                productDetailsController.variationsStock.value =
                                                                                    productDetailsController.initialVariationModel.value.data?[index].stock!.toInt() ?? 0;
                                                                              } else {
                                                                                productDetailsController.variationProductId.value =
                                                                                    '';
                                                                                productDetailsController.variationProductPrice.value =
                                                                                    '';
                                                                                productDetailsController.variationProductCurrencyPrice.value =
                                                                                    '';
                                                                                productDetailsController.variationProductOldPrice.value =
                                                                                    '';
                                                                                productDetailsController.variationProductOldCurrencyPrice.value =
                                                                                    '';
                                                                                productDetailsController.variationsku.value =
                                                                                    '';
                                                                                productDetailsController.variationsStock.value =
                                                                                    -1;
                                                                              }

                                                                              if (productDetailsController.initialVariationModel.value.data?[index].sku ==
                                                                                  null) {
                                                                                await productDetailsController.fetchChildrenVariation1(initialVariationId: productDetailsController.initialVariationModel.value.data![index].id.toString());
                                                                              }
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding:
                                                                                  EdgeInsets.only(right: 8.w),
                                                                              child:
                                                                                  Container(
                                                                                decoration:
                                                                                    BoxDecoration(
                                                                                  color: productDetailsController.selectedIndex1.value == index ? AppColor.primaryColor : AppColor.cartColor,
                                                                                  borderRadius: BorderRadius.circular(20.r),
                                                                                ),
                                                                                child:
                                                                                    Padding(
                                                                                  padding: EdgeInsets.only(left: 12.5.w, right: 12.5.w),
                                                                                  child: Center(
                                                                                    child: CustomText(
                                                                                      text: productDetailsController.initialVariationModel.value.data?[index].productAttributeOptionName ?? '',
                                                                                      color: productDetailsController.selectedIndex1.value == index ? Colors.white : Colors.black,
                                                                                      size: 12.sp,
                                                                                      weight: FontWeight.w500,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }),
                                                              )
                                                            : SizedBox(),
                                                        productDetailsController
                                                                        .initialVariationModel
                                                                        .value
                                                                        .data !=
                                                                    null &&
                                                                productDetailsController
                                                                        .initialVariationModel
                                                                        .value
                                                                        .data!
                                                                        .length >
                                                                    0
                                                            ? SizedBox(height: 24.h)
                                                            : SizedBox(),
                                                      ],
                                                    )
                                                  : SizedBox(),
                                              productDetailsController
                                                              .selectedIndex1
                                                              .value ==
                                                          -1 &&
                                                      productDetailsController
                                                              .childrenVariationModel1
                                                              .value
                                                              .data ==
                                                          null
                                                  ? const SizedBox()
                                                  : Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        productDetailsController
                                                                        .childrenVariationModel1
                                                                        .value
                                                                        .data !=
                                                                    null &&
                                                                productDetailsController
                                                                        .childrenVariationModel1
                                                                        .value
                                                                        .data!
                                                                        .length >
                                                                    0
                                                            ? CustomText(
                                                                text:
                                                                    '${productDetailsController.childrenVariationModel1.value.data?[0].productAttributeName.toString().tr}:',
                                                                size: 14.sp,
                                                                weight:
                                                                    FontWeight.w600,
                                                              )
                                                            : SizedBox(),
                                                        productDetailsController
                                                                        .childrenVariationModel1
                                                                        .value
                                                                        .data !=
                                                                    null &&
                                                                productDetailsController
                                                                        .childrenVariationModel1
                                                                        .value
                                                                        .data!
                                                                        .length >
                                                                    0
                                                            ? SizedBox(height: 8.h)
                                                            : SizedBox(),
                                                        productDetailsController
                                                                        .childrenVariationModel1
                                                                        .value
                                                                        .data !=
                                                                    null &&
                                                                productDetailsController
                                                                        .childrenVariationModel1
                                                                        .value
                                                                        .data!
                                                                        .length >
                                                                    0
                                                            ? SizedBox(
                                                                height: 32.h,
                                                                child: ListView
                                                                    .builder(
                                                                        itemCount: productDetailsController
                                                                                .childrenVariationModel1
                                                                                .value
                                                                                .data
                                                                                ?.length ??
                                                                            0,
                                                                        scrollDirection:
                                                                            Axis
                                                                                .horizontal,
                                                                        itemBuilder:
                                                                            (context,
                                                                                index) {
                                                                          return GestureDetector(
                                                                            onTap:
                                                                                () async {
                                                                              cartController
                                                                                  .numOfItems
                                                                                  .value = 1;
                                                                              productDetailsController
                                                                                  .selectedIndex2
                                                                                  .value = index;

                                                                              productDetailsController
                                                                                  .selectedIndex3
                                                                                  .value = -1;
                                                                              productDetailsController
                                                                                  .selectedIndex4
                                                                                  .value = -1;
                                                                              productDetailsController
                                                                                  .selectedIndex5
                                                                                  .value = -1;
                                                                              productDetailsController
                                                                                  .selectedIndex6
                                                                                  .value = -1;
                                                                              productDetailsController
                                                                                  .selectedIndex7
                                                                                  .value = -1;

                                                                              productDetailsController
                                                                                  .childrenVariationModel2
                                                                                  .value
                                                                                  .data
                                                                                  ?.clear();
                                                                              productDetailsController
                                                                                  .childrenVariationModel3
                                                                                  .value
                                                                                  .data
                                                                                  ?.clear();
                                                                              productDetailsController
                                                                                  .childrenVariationModel4
                                                                                  .value
                                                                                  .data
                                                                                  ?.clear();
                                                                              productDetailsController
                                                                                  .childrenVariationModel5
                                                                                  .value
                                                                                  .data
                                                                                  ?.clear();
                                                                              productDetailsController
                                                                                  .childrenVariationModel6
                                                                                  .value
                                                                                  .data
                                                                                  ?.clear();

                                                                              if (productDetailsController.childrenVariationModel1.value.data?[index].sku !=
                                                                                  null) {
                                                                                productDetailsController.variationProductId.value =
                                                                                    productDetailsController.childrenVariationModel1.value.data?[index].id.toString() ?? '';
                                                                                productDetailsController.variationProductPrice.value =
                                                                                    productDetailsController.childrenVariationModel1.value.data?[index].price.toString() ?? '';
                                                                                productDetailsController.variationProductCurrencyPrice.value =
                                                                                    productDetailsController.childrenVariationModel1.value.data?[index].currencyPrice.toString() ?? '';
                                                                                productDetailsController.variationProductOldPrice.value =
                                                                                    productDetailsController.childrenVariationModel1.value.data?[index].oldPrice.toString() ?? '';
                                                                                productDetailsController.variationProductOldCurrencyPrice.value =
                                                                                    productDetailsController.childrenVariationModel1.value.data?[index].oldCurrencyPrice.toString() ?? '';
                                                                                productDetailsController.variationsku.value =
                                                                                    productDetailsController.childrenVariationModel1.value.data?[index].sku.toString() ?? '';
                                                                                productDetailsController.variationsStock.value =
                                                                                    productDetailsController.childrenVariationModel1.value.data?[index].stock!.toInt() ?? 0;
                                                                              } else {
                                                                                productDetailsController.variationProductId.value =
                                                                                    '';
                                                                                productDetailsController.variationProductPrice.value =
                                                                                    '';
                                                                                productDetailsController.variationProductCurrencyPrice.value =
                                                                                    '';
                                                                                productDetailsController.variationProductOldPrice.value =
                                                                                    '';
                                                                                productDetailsController.variationProductOldCurrencyPrice.value =
                                                                                    '';
                                                                                productDetailsController.variationsku.value =
                                                                                    '';
                                                                                productDetailsController.variationsStock.value =
                                                                                    -1;
                                                                              }

                                                                              if (productDetailsController.childrenVariationModel1.value.data?[index].sku ==
                                                                                  null) {
                                                                                await productDetailsController.fetchChildrenVariation2(initialVariationId: productDetailsController.childrenVariationModel1.value.data![index].id.toString());
                                                                              }
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding:
                                                                                  EdgeInsets.only(right: 8.w),
                                                                              child:
                                                                                  Container(
                                                                                decoration:
                                                                                    BoxDecoration(color: productDetailsController.selectedIndex2.value == index ? AppColor.primaryColor : AppColor.cartColor, borderRadius: BorderRadius.circular(50.r)),
                                                                                child:
                                                                                    Padding(
                                                                                  padding: EdgeInsets.only(left: 12.5.w, right: 12.5.w),
                                                                                  child: Center(
                                                                                    child: CustomText(
                                                                                      text: productDetailsController.childrenVariationModel1.value.data?[index].productAttributeOptionName ?? '',
                                                                                      color: productDetailsController.selectedIndex2.value == index ? Colors.white : Colors.black,
                                                                                      size: 12.sp,
                                                                                      weight: FontWeight.w500,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }),
                                                              )
                                                            : SizedBox(),
                                                        productDetailsController
                                                                        .childrenVariationModel1
                                                                        .value
                                                                        .data !=
                                                                    null &&
                                                                productDetailsController
                                                                        .childrenVariationModel1
                                                                        .value
                                                                        .data!
                                                                        .length >
                                                                    0
                                                            ? SizedBox(height: 24.h)
                                                            : SizedBox(),
                                                      ],
                                                    ),
                                              productDetailsController
                                                              .selectedIndex2
                                                              .value ==
                                                          -1 &&
                                                      productDetailsController
                                                              .childrenVariationModel2
                                                              .value
                                                              .data ==
                                                          null
                                                  ? const SizedBox()
                                                  : Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        productDetailsController
                                                                        .childrenVariationModel2
                                                                        .value
                                                                        .data !=
                                                                    null &&
                                                                productDetailsController
                                                                        .childrenVariationModel2
                                                                        .value
                                                                        .data!
                                                                        .length >
                                                                    0
                                                            ? CustomText(
                                                                text:
                                                                    '${productDetailsController.childrenVariationModel2.value.data?[0].productAttributeName.toString().tr ?? ''}:',
                                                                size: 14.sp,
                                                                weight:
                                                                    FontWeight.w600,
                                                              )
                                                            : SizedBox(),
                                                        productDetailsController
                                                                        .childrenVariationModel2
                                                                        .value
                                                                        .data !=
                                                                    null &&
                                                                productDetailsController
                                                                        .childrenVariationModel2
                                                                        .value
                                                                        .data!
                                                                        .length >
                                                                    0
                                                            ? SizedBox(height: 8.h)
                                                            : SizedBox(),
                                                        productDetailsController
                                                                        .childrenVariationModel2
                                                                        .value
                                                                        .data !=
                                                                    null &&
                                                                productDetailsController
                                                                        .childrenVariationModel2
                                                                        .value
                                                                        .data!
                                                                        .length >
                                                                    0
                                                            ? SizedBox(
                                                                height: 32.h,
                                                                child: ListView
                                                                    .builder(
                                                                        itemCount: productDetailsController
                                                                                .childrenVariationModel2
                                                                                .value
                                                                                .data
                                                                                ?.length ??
                                                                            0,
                                                                        scrollDirection:
                                                                            Axis
                                                                                .horizontal,
                                                                        itemBuilder:
                                                                            (context,
                                                                                index) {
                                                                          return GestureDetector(
                                                                            onTap:
                                                                                () async {
                                                                              cartController
                                                                                  .numOfItems
                                                                                  .value = 1;
                                                                              productDetailsController
                                                                                  .selectedIndex3
                                                                                  .value = index;

                                                                              productDetailsController
                                                                                  .selectedIndex4
                                                                                  .value = -1;
                                                                              productDetailsController
                                                                                  .selectedIndex5
                                                                                  .value = -1;
                                                                              productDetailsController
                                                                                  .selectedIndex6
                                                                                  .value = -1;
                                                                              productDetailsController
                                                                                  .selectedIndex7
                                                                                  .value = -1;

                                                                              productDetailsController
                                                                                  .childrenVariationModel3
                                                                                  .value
                                                                                  .data
                                                                                  ?.clear();
                                                                              productDetailsController
                                                                                  .childrenVariationModel4
                                                                                  .value
                                                                                  .data
                                                                                  ?.clear();
                                                                              productDetailsController
                                                                                  .childrenVariationModel5
                                                                                  .value
                                                                                  .data
                                                                                  ?.clear();
                                                                              productDetailsController
                                                                                  .childrenVariationModel6
                                                                                  .value
                                                                                  .data
                                                                                  ?.clear();

                                                                              if (productDetailsController.childrenVariationModel2.value.data![index].sku !=
                                                                                  null) {
                                                                                productDetailsController.variationProductId.value =
                                                                                    productDetailsController.childrenVariationModel2.value.data?[index].id.toString() ?? '';
                                                                                productDetailsController.variationProductPrice.value =
                                                                                    productDetailsController.childrenVariationModel2.value.data?[index].price.toString() ?? '';
                                                                                productDetailsController.variationProductCurrencyPrice.value =
                                                                                    productDetailsController.childrenVariationModel2.value.data?[index].currencyPrice.toString() ?? '';
                                                                                productDetailsController.variationProductOldPrice.value =
                                                                                    productDetailsController.childrenVariationModel2.value.data?[index].oldPrice.toString() ?? '';
                                                                                productDetailsController.variationProductOldCurrencyPrice.value =
                                                                                    productDetailsController.childrenVariationModel2.value.data?[index].oldCurrencyPrice.toString() ?? '';
                                                                                productDetailsController.variationsku.value =
                                                                                    productDetailsController.childrenVariationModel2.value.data?[index].sku.toString() ?? '';
                                                                                productDetailsController.variationsStock.value =
                                                                                    productDetailsController.childrenVariationModel2.value.data?[index].stock!.toInt() ?? 0;
                                                                              } else {
                                                                                productDetailsController.variationProductId.value =
                                                                                    '';
                                                                                productDetailsController.variationProductPrice.value =
                                                                                    '';
                                                                                productDetailsController.variationProductCurrencyPrice.value =
                                                                                    '';
                                                                                productDetailsController.variationProductOldPrice.value =
                                                                                    '';
                                                                                productDetailsController.variationProductOldCurrencyPrice.value =
                                                                                    '';
                                                                                productDetailsController.variationsku.value =
                                                                                    '';
                                                                                productDetailsController.variationsStock.value =
                                                                                    -1;
                                                                              }

                                                                              if (productDetailsController.childrenVariationModel2.value.data![index].sku ==
                                                                                  null) {
                                                                                await productDetailsController.fetchChildrenVariation3(initialVariationId: productDetailsController.childrenVariationModel2.value.data![index].id.toString());
                                                                              }
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding:
                                                                                  EdgeInsets.only(right: 8.w),
                                                                              child:
                                                                                  Container(
                                                                                decoration:
                                                                                    BoxDecoration(color: productDetailsController.selectedIndex3.value == index ? AppColor.primaryColor : AppColor.cartColor, borderRadius: BorderRadius.circular(50.r)),
                                                                                child:
                                                                                    Padding(
                                                                                  padding: EdgeInsets.only(left: 12.5.w, right: 12.5.w),
                                                                                  child: Center(
                                                                                    child: CustomText(
                                                                                      text: productDetailsController.childrenVariationModel2.value.data?[index].productAttributeOptionName ?? '',
                                                                                      color: productDetailsController.selectedIndex3.value == index ? Colors.white : Colors.black,
                                                                                      size: 12.sp,
                                                                                      weight: FontWeight.w500,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }),
                                                              )
                                                            : SizedBox(),
                                                        productDetailsController
                                                                        .childrenVariationModel2
                                                                        .value
                                                                        .data !=
                                                                    null &&
                                                                productDetailsController
                                                                        .childrenVariationModel2
                                                                        .value
                                                                        .data!
                                                                        .length >
                                                                    0
                                                            ? SizedBox(height: 24.h)
                                                            : SizedBox(),
                                                      ],
                                                    ),
                                              productDetailsController
                                                              .selectedIndex3
                                                              .value ==
                                                          -1 &&
                                                      productDetailsController
                                                              .childrenVariationModel3
                                                              .value
                                                              .data ==
                                                          null
                                                  ? const SizedBox()
                                                  : Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        productDetailsController
                                                                        .childrenVariationModel3
                                                                        .value
                                                                        .data !=
                                                                    null &&
                                                                productDetailsController
                                                                        .childrenVariationModel3
                                                                        .value
                                                                        .data!
                                                                        .length >
                                                                    0
                                                            ? CustomText(
                                                                text:
                                                                    '${productDetailsController.childrenVariationModel3.value.data?[0].productAttributeName.toString().tr ?? ''}:',
                                                                size: 14.sp,
                                                                weight:
                                                                    FontWeight.w600,
                                                              )
                                                            : SizedBox(),
                                                        productDetailsController
                                                                        .childrenVariationModel3
                                                                        .value
                                                                        .data !=
                                                                    null &&
                                                                productDetailsController
                                                                        .childrenVariationModel3
                                                                        .value
                                                                        .data!
                                                                        .length >
                                                                    0
                                                            ? SizedBox(height: 8.h)
                                                            : SizedBox(),
                                                        productDetailsController
                                                                        .childrenVariationModel3
                                                                        .value
                                                                        .data !=
                                                                    null &&
                                                                productDetailsController
                                                                        .childrenVariationModel3
                                                                        .value
                                                                        .data!
                                                                        .length >
                                                                    0
                                                            ? SizedBox(
                                                                height: 32.h,
                                                                child: ListView
                                                                    .builder(
                                                                        itemCount: productDetailsController
                                                                                .childrenVariationModel3
                                                                                .value
                                                                                .data
                                                                                ?.length ??
                                                                            0,
                                                                        scrollDirection:
                                                                            Axis
                                                                                .horizontal,
                                                                        itemBuilder:
                                                                            (context,
                                                                                index) {
                                                                          return GestureDetector(
                                                                            onTap:
                                                                                () async {
                                                                              cartController
                                                                                  .numOfItems
                                                                                  .value = 1;
                                                                              productDetailsController
                                                                                  .selectedIndex4
                                                                                  .value = index;

                                                                              productDetailsController
                                                                                  .selectedIndex5
                                                                                  .value = -1;
                                                                              productDetailsController
                                                                                  .selectedIndex6
                                                                                  .value = -1;
                                                                              productDetailsController
                                                                                  .selectedIndex7
                                                                                  .value = -1;

                                                                              productDetailsController
                                                                                  .childrenVariationModel4
                                                                                  .value
                                                                                  .data
                                                                                  ?.clear();
                                                                              productDetailsController
                                                                                  .childrenVariationModel5
                                                                                  .value
                                                                                  .data
                                                                                  ?.clear();
                                                                              productDetailsController
                                                                                  .childrenVariationModel6
                                                                                  .value
                                                                                  .data
                                                                                  ?.clear();

                                                                              if (productDetailsController.childrenVariationModel3.value.data![index].sku !=
                                                                                  null) {
                                                                                productDetailsController.variationProductId.value =
                                                                                    productDetailsController.childrenVariationModel3.value.data?[index].id.toString() ?? '';
                                                                                productDetailsController.variationProductPrice.value =
                                                                                    productDetailsController.childrenVariationModel3.value.data?[index].price.toString() ?? '';
                                                                                productDetailsController.variationProductCurrencyPrice.value =
                                                                                    productDetailsController.childrenVariationModel3.value.data?[index].currencyPrice.toString() ?? '';
                                                                                productDetailsController.variationProductOldPrice.value =
                                                                                    productDetailsController.childrenVariationModel3.value.data?[index].oldPrice.toString() ?? '';
                                                                                productDetailsController.variationProductOldCurrencyPrice.value =
                                                                                    productDetailsController.childrenVariationModel3.value.data?[index].oldCurrencyPrice.toString() ?? '';
                                                                                productDetailsController.variationsku.value =
                                                                                    productDetailsController.childrenVariationModel3.value.data?[index].sku.toString() ?? '';
                                                                                productDetailsController.variationsStock.value =
                                                                                    productDetailsController.childrenVariationModel3.value.data?[index].stock!.toInt() ?? 0;
                                                                              } else {
                                                                                productDetailsController.variationProductId.value =
                                                                                    '';
                                                                                productDetailsController.variationProductPrice.value =
                                                                                    '';
                                                                                productDetailsController.variationProductCurrencyPrice.value =
                                                                                    '';
                                                                                productDetailsController.variationProductOldPrice.value =
                                                                                    '';
                                                                                productDetailsController.variationProductOldCurrencyPrice.value =
                                                                                    '';
                                                                                productDetailsController.variationsku.value =
                                                                                    '';
                                                                                productDetailsController.variationsStock.value =
                                                                                    -1;
                                                                              }

                                                                              if (productDetailsController.childrenVariationModel3.value.data?[index].sku ==
                                                                                  null) {
                                                                                await productDetailsController.fetchChildrenVariation4(initialVariationId: productDetailsController.childrenVariationModel3.value.data![index].id.toString());
                                                                              }
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding:
                                                                                  EdgeInsets.only(right: 8.w),
                                                                              child:
                                                                                  Container(
                                                                                decoration:
                                                                                    BoxDecoration(color: productDetailsController.selectedIndex4.value == index ? AppColor.primaryColor : AppColor.cartColor, borderRadius: BorderRadius.circular(50.r)),
                                                                                child:
                                                                                    Padding(
                                                                                  padding: EdgeInsets.only(left: 12.5.w, right: 12.5.w),
                                                                                  child: Center(
                                                                                    child: CustomText(
                                                                                      text: productDetailsController.childrenVariationModel3.value.data?[index].productAttributeOptionName ?? '',
                                                                                      color: productDetailsController.selectedIndex4.value == index ? Colors.white : Colors.black,
                                                                                      size: 12.sp,
                                                                                      weight: FontWeight.w500,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }),
                                                              )
                                                            : SizedBox(),
                                                        productDetailsController
                                                                        .childrenVariationModel3
                                                                        .value
                                                                        .data !=
                                                                    null &&
                                                                productDetailsController
                                                                        .childrenVariationModel3
                                                                        .value
                                                                        .data!
                                                                        .length >
                                                                    0
                                                            ? SizedBox(height: 24.h)
                                                            : SizedBox(),
                                                      ],
                                                    ),
                                              productDetailsController
                                                              .selectedIndex4
                                                              .value ==
                                                          -1 &&
                                                      productDetailsController
                                                              .childrenVariationModel4
                                                              .value
                                                              .data ==
                                                          null
                                                  ? const SizedBox()
                                                  : Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        productDetailsController
                                                                        .childrenVariationModel4
                                                                        .value
                                                                        .data !=
                                                                    null &&
                                                                productDetailsController
                                                                        .childrenVariationModel4
                                                                        .value
                                                                        .data!
                                                                        .length >
                                                                    0
                                                            ? CustomText(
                                                                text:
                                                                    '${productDetailsController.childrenVariationModel4.value.data?[0].productAttributeName.toString().tr ?? ''}:',
                                                                size: 14.sp,
                                                                weight:
                                                                    FontWeight.w600,
                                                              )
                                                            : SizedBox(),
                                                        productDetailsController
                                                                        .childrenVariationModel4
                                                                        .value
                                                                        .data !=
                                                                    null &&
                                                                productDetailsController
                                                                        .childrenVariationModel4
                                                                        .value
                                                                        .data!
                                                                        .length >
                                                                    0
                                                            ? SizedBox(height: 8.h)
                                                            : SizedBox(),
                                                        productDetailsController
                                                                        .childrenVariationModel4
                                                                        .value
                                                                        .data !=
                                                                    null &&
                                                                productDetailsController
                                                                        .childrenVariationModel4
                                                                        .value
                                                                        .data!
                                                                        .length >
                                                                    0
                                                            ? SizedBox(
                                                                height: 32.h,
                                                                child: ListView
                                                                    .builder(
                                                                        itemCount: productDetailsController
                                                                                .childrenVariationModel4
                                                                                .value
                                                                                .data
                                                                                ?.length ??
                                                                            0,
                                                                        scrollDirection:
                                                                            Axis
                                                                                .horizontal,
                                                                        itemBuilder:
                                                                            (context,
                                                                                index) {
                                                                          return GestureDetector(
                                                                            onTap:
                                                                                () async {
                                                                              cartController
                                                                                  .numOfItems
                                                                                  .value = 1;
                                                                              productDetailsController
                                                                                  .selectedIndex5
                                                                                  .value = index;

                                                                              productDetailsController
                                                                                  .selectedIndex6
                                                                                  .value = -1;
                                                                              productDetailsController
                                                                                  .selectedIndex7
                                                                                  .value = -1;

                                                                              productDetailsController
                                                                                  .childrenVariationModel5
                                                                                  .value
                                                                                  .data
                                                                                  ?.clear();
                                                                              productDetailsController
                                                                                  .childrenVariationModel6
                                                                                  .value
                                                                                  .data
                                                                                  ?.clear();

                                                                              if (productDetailsController.childrenVariationModel4.value.data![index].sku !=
                                                                                  null) {
                                                                                productDetailsController.variationProductId.value =
                                                                                    productDetailsController.childrenVariationModel4.value.data?[index].id.toString() ?? '';
                                                                                productDetailsController.variationProductPrice.value =
                                                                                    productDetailsController.childrenVariationModel4.value.data?[index].price.toString() ?? '';
                                                                                productDetailsController.variationProductCurrencyPrice.value =
                                                                                    productDetailsController.childrenVariationModel4.value.data?[index].currencyPrice.toString() ?? '';
                                                                                productDetailsController.variationProductOldPrice.value =
                                                                                    productDetailsController.childrenVariationModel4.value.data?[index].oldPrice.toString() ?? '';
                                                                                productDetailsController.variationProductOldCurrencyPrice.value =
                                                                                    productDetailsController.childrenVariationModel4.value.data?[index].oldCurrencyPrice.toString() ?? '';
                                                                                productDetailsController.variationsku.value =
                                                                                    productDetailsController.childrenVariationModel4.value.data?[index].sku.toString() ?? '';
                                                                                productDetailsController.variationsStock.value =
                                                                                    productDetailsController.childrenVariationModel4.value.data?[index].stock!.toInt() ?? 0;
                                                                              } else {
                                                                                productDetailsController.variationProductId.value =
                                                                                    '';
                                                                                productDetailsController.variationProductPrice.value =
                                                                                    '';
                                                                                productDetailsController.variationProductCurrencyPrice.value =
                                                                                    '';
                                                                                productDetailsController.variationProductOldPrice.value =
                                                                                    '';
                                                                                productDetailsController.variationProductOldCurrencyPrice.value =
                                                                                    '';
                                                                                productDetailsController.variationsku.value =
                                                                                    '';
                                                                                productDetailsController.variationsStock.value =
                                                                                    -1;
                                                                              }

                                                                              if (productDetailsController.childrenVariationModel4.value.data![index].sku ==
                                                                                  null) {
                                                                                await productDetailsController.fetchChildrenVariation5(initialVariationId: productDetailsController.childrenVariationModel4.value.data![index].id.toString());
                                                                              }
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding:
                                                                                  EdgeInsets.only(right: 8.w),
                                                                              child:
                                                                                  Container(
                                                                                decoration:
                                                                                    BoxDecoration(color: productDetailsController.selectedIndex5.value == index ? AppColor.primaryColor : AppColor.cartColor, borderRadius: BorderRadius.circular(50.r)),
                                                                                child:
                                                                                    Padding(
                                                                                  padding: EdgeInsets.only(left: 12.5.w, right: 12.5.w),
                                                                                  child: Center(
                                                                                    child: CustomText(
                                                                                      text: productDetailsController.childrenVariationModel4.value.data?[index].productAttributeOptionName ?? '',
                                                                                      color: productDetailsController.selectedIndex5.value == index ? Colors.white : Colors.black,
                                                                                      size: 12.sp,
                                                                                      weight: FontWeight.w500,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }),
                                                              )
                                                            : SizedBox(),
                                                        productDetailsController
                                                                        .childrenVariationModel4
                                                                        .value
                                                                        .data !=
                                                                    null &&
                                                                productDetailsController
                                                                        .childrenVariationModel4
                                                                        .value
                                                                        .data!
                                                                        .length >
                                                                    0
                                                            ? SizedBox(height: 24.h)
                                                            : SizedBox(),
                                                      ],
                                                    ),
                                              productDetailsController
                                                              .selectedIndex5
                                                              .value ==
                                                          -1 &&
                                                      productDetailsController
                                                              .childrenVariationModel5
                                                              .value
                                                              .data ==
                                                          null
                                                  ? const SizedBox()
                                                  : Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        productDetailsController
                                                                        .childrenVariationModel5
                                                                        .value
                                                                        .data !=
                                                                    null &&
                                                                productDetailsController
                                                                        .childrenVariationModel5
                                                                        .value
                                                                        .data!
                                                                        .length >
                                                                    0
                                                            ? CustomText(
                                                                text:
                                                                    '${productDetailsController.childrenVariationModel5.value.data?[0].productAttributeName.toString().tr ?? ''}:',
                                                                size: 15.sp,
                                                                weight:
                                                                    FontWeight.w600,
                                                              )
                                                            : SizedBox(),
                                                        productDetailsController
                                                                        .childrenVariationModel5
                                                                        .value
                                                                        .data !=
                                                                    null &&
                                                                productDetailsController
                                                                        .childrenVariationModel5
                                                                        .value
                                                                        .data!
                                                                        .length >
                                                                    0
                                                            ? SizedBox(height: 8.h)
                                                            : SizedBox(),
                                                        productDetailsController
                                                                        .childrenVariationModel5
                                                                        .value
                                                                        .data !=
                                                                    null &&
                                                                productDetailsController
                                                                        .childrenVariationModel5
                                                                        .value
                                                                        .data!
                                                                        .length >
                                                                    0
                                                            ? SizedBox(
                                                                height: 32.h,
                                                                child: ListView
                                                                    .builder(
                                                                        itemCount: productDetailsController
                                                                                .childrenVariationModel5
                                                                                .value
                                                                                .data
                                                                                ?.length ??
                                                                            0,
                                                                        scrollDirection:
                                                                            Axis
                                                                                .horizontal,
                                                                        itemBuilder:
                                                                            (context,
                                                                                index) {
                                                                          return GestureDetector(
                                                                            onTap:
                                                                                () async {
                                                                              cartController
                                                                                  .numOfItems
                                                                                  .value = 1;
                                                                              productDetailsController
                                                                                  .selectedIndex6
                                                                                  .value = index;

                                                                              productDetailsController
                                                                                  .selectedIndex7
                                                                                  .value = -1;

                                                                              productDetailsController
                                                                                  .childrenVariationModel6
                                                                                  .value
                                                                                  .data
                                                                                  ?.clear();

                                                                              if (productDetailsController.childrenVariationModel5.value.data![index].sku !=
                                                                                  null) {
                                                                                productDetailsController.variationProductId.value =
                                                                                    productDetailsController.childrenVariationModel5.value.data?[index].id.toString() ?? '';
                                                                                productDetailsController.variationProductPrice.value =
                                                                                    productDetailsController.childrenVariationModel5.value.data?[index].price.toString() ?? '';
                                                                                productDetailsController.variationProductCurrencyPrice.value =
                                                                                    productDetailsController.childrenVariationModel5.value.data?[index].currencyPrice.toString() ?? '';
                                                                                productDetailsController.variationProductOldPrice.value =
                                                                                    productDetailsController.childrenVariationModel5.value.data?[index].oldPrice.toString() ?? '';
                                                                                productDetailsController.variationProductOldCurrencyPrice.value =
                                                                                    productDetailsController.childrenVariationModel5.value.data?[index].oldCurrencyPrice.toString() ?? '';
                                                                                productDetailsController.variationsku.value =
                                                                                    productDetailsController.childrenVariationModel5.value.data?[index].sku.toString() ?? '';
                                                                                productDetailsController.variationsStock.value =
                                                                                    productDetailsController.childrenVariationModel5.value.data?[index].stock!.toInt() ?? 0;
                                                                              } else {
                                                                                productDetailsController.variationProductId.value =
                                                                                    '';
                                                                                productDetailsController.variationProductPrice.value =
                                                                                    '';
                                                                                productDetailsController.variationProductCurrencyPrice.value =
                                                                                    '';
                                                                                productDetailsController.variationProductOldPrice.value =
                                                                                    '';
                                                                                productDetailsController.variationProductOldCurrencyPrice.value =
                                                                                    '';
                                                                                productDetailsController.variationsku.value =
                                                                                    '';
                                                                                productDetailsController.variationsStock.value =
                                                                                    -1;
                                                                              }

                                                                              if (productDetailsController.childrenVariationModel5.value.data![index].sku ==
                                                                                  null) {
                                                                                await productDetailsController.fetchChildrenVariation6(initialVariationId: productDetailsController.childrenVariationModel5.value.data![index].id.toString());
                                                                              }
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding:
                                                                                  EdgeInsets.only(right: 8.w),
                                                                              child:
                                                                                  Container(
                                                                                decoration:
                                                                                    BoxDecoration(color: productDetailsController.selectedIndex6.value == index ? AppColor.primaryColor : AppColor.cartColor, borderRadius: BorderRadius.circular(50.r)),
                                                                                child:
                                                                                    Padding(
                                                                                  padding: EdgeInsets.only(left: 12.5.w, right: 12.5.w),
                                                                                  child: Center(
                                                                                    child: CustomText(
                                                                                      text: productDetailsController.childrenVariationModel5.value.data?[index].productAttributeOptionName ?? '',
                                                                                      color: productDetailsController.selectedIndex6.value == index ? Colors.white : Colors.black,
                                                                                      size: 12.sp,
                                                                                      weight: FontWeight.w500,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }),
                                                              )
                                                            : SizedBox(),
                                                        productDetailsController
                                                                        .childrenVariationModel5
                                                                        .value
                                                                        .data !=
                                                                    null &&
                                                                productDetailsController
                                                                        .childrenVariationModel5
                                                                        .value
                                                                        .data!
                                                                        .length >
                                                                    0
                                                            ? SizedBox(height: 24.h)
                                                            : SizedBox(),
                                                      ],
                                                    ),
                                              productDetailsController
                                                              .selectedIndex6
                                                              .value ==
                                                          -1 &&
                                                      productDetailsController
                                                              .childrenVariationModel6
                                                              .value
                                                              .data ==
                                                          null
                                                  ? const SizedBox()
                                                  : Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        productDetailsController
                                                                        .childrenVariationModel6
                                                                        .value
                                                                        .data !=
                                                                    null &&
                                                                productDetailsController
                                                                        .childrenVariationModel6
                                                                        .value
                                                                        .data!
                                                                        .length >
                                                                    0
                                                            ? CustomText(
                                                                text:
                                                                    '${productDetailsController.childrenVariationModel6.value.data?[0].productAttributeName.toString().tr ?? ''}:',
                                                                size: 14.sp,
                                                                weight:
                                                                    FontWeight.w600,
                                                              )
                                                            : SizedBox(),
                                                        productDetailsController
                                                                        .childrenVariationModel6
                                                                        .value
                                                                        .data !=
                                                                    null &&
                                                                productDetailsController
                                                                        .childrenVariationModel6
                                                                        .value
                                                                        .data!
                                                                        .length >
                                                                    0
                                                            ? SizedBox(height: 8.h)
                                                            : SizedBox(),
                                                        productDetailsController
                                                                        .childrenVariationModel6
                                                                        .value
                                                                        .data !=
                                                                    null &&
                                                                productDetailsController
                                                                        .childrenVariationModel6
                                                                        .value
                                                                        .data!
                                                                        .length >
                                                                    0
                                                            ? SizedBox(
                                                                height: 32.h,
                                                                child: ListView
                                                                    .builder(
                                                                        itemCount: productDetailsController
                                                                                .childrenVariationModel6
                                                                                .value
                                                                                .data
                                                                                ?.length ??
                                                                            0,
                                                                        scrollDirection:
                                                                            Axis
                                                                                .horizontal,
                                                                        itemBuilder:
                                                                            (context,
                                                                                index) {
                                                                          return GestureDetector(
                                                                            onTap:
                                                                                () async {
                                                                              cartController
                                                                                  .numOfItems
                                                                                  .value = 1;

                                                                              productDetailsController
                                                                                  .selectedIndex7
                                                                                  .value = index;

                                                                              if (productDetailsController.childrenVariationModel6.value.data?[index].sku !=
                                                                                  null) {
                                                                                productDetailsController.variationProductId.value =
                                                                                    productDetailsController.childrenVariationModel6.value.data?[index].id.toString() ?? '';
                                                                                productDetailsController.variationProductPrice.value =
                                                                                    productDetailsController.childrenVariationModel6.value.data?[index].price.toString() ?? '';
                                                                                productDetailsController.variationProductCurrencyPrice.value =
                                                                                    productDetailsController.childrenVariationModel6.value.data?[index].currencyPrice.toString() ?? '';
                                                                                productDetailsController.variationProductOldPrice.value =
                                                                                    productDetailsController.childrenVariationModel6.value.data?[index].oldPrice.toString() ?? '';
                                                                                productDetailsController.variationProductOldCurrencyPrice.value =
                                                                                    productDetailsController.childrenVariationModel6.value.data?[index].oldCurrencyPrice.toString() ?? '';
                                                                                productDetailsController.variationsku.value =
                                                                                    productDetailsController.childrenVariationModel6.value.data?[index].sku.toString() ?? '';
                                                                                productDetailsController.variationsStock.value =
                                                                                    productDetailsController.childrenVariationModel6.value.data?[index].stock!.toInt() ?? 0;
                                                                              } else {
                                                                                productDetailsController.variationProductId.value =
                                                                                    '';
                                                                                productDetailsController.variationProductPrice.value =
                                                                                    '';
                                                                                productDetailsController.variationProductCurrencyPrice.value =
                                                                                    '';
                                                                                productDetailsController.variationProductOldPrice.value =
                                                                                    '';
                                                                                productDetailsController.variationProductOldCurrencyPrice.value =
                                                                                    '';
                                                                                productDetailsController.variationsku.value =
                                                                                    '';
                                                                                productDetailsController.variationsStock.value =
                                                                                    -1;
                                                                              }
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding:
                                                                                  EdgeInsets.only(right: 8.w),
                                                                              child:
                                                                                  Container(
                                                                                decoration:
                                                                                    BoxDecoration(color: productDetailsController.selectedIndex7.value == index ? AppColor.primaryColor : AppColor.cartColor, borderRadius: BorderRadius.circular(50.r)),
                                                                                child:
                                                                                    Padding(
                                                                                  padding: EdgeInsets.only(left: 12.5.w, right: 12.5.w),
                                                                                  child: Center(
                                                                                    child: CustomText(
                                                                                      text: productDetailsController.childrenVariationModel5.value.data![index].productAttributeOptionName,
                                                                                      color: productDetailsController.selectedIndex7.value == index ? Colors.white : Colors.black,
                                                                                      size: 12.sp,
                                                                                      weight: FontWeight.w500,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }),
                                                              )
                                                            : SizedBox(),
                                                        productDetailsController
                                                                        .childrenVariationModel5
                                                                        .value
                                                                        .data !=
                                                                    null &&
                                                                productDetailsController
                                                                        .childrenVariationModel5
                                                                        .value
                                                                        .data!
                                                                        .length >
                                                                    0
                                                            ? SizedBox(height: 24.h)
                                                            : SizedBox(),
                                                      ],
                                                    ),
                                            ],
                                          ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              text: "PRICE",
                                              size: 14.sp,
                                            ),
                                            SizedBox(height: 12.h),
                                            Row(
                                              children: [
                                                Obx(() {
                                                  if (productDetailsController
                                                      .initialVariationModel
                                                      .value
                                                      .data !=
                                                      null) {
                                                    return CustomText(
                                                      text:
                                                      productDetailsController
                                                          .variationProductCurrencyPrice
                                                          .toString() ==
                                                          ''
                                                          ? productDetailsController
                                                          .productModel
                                                          .value
                                                          .data
                                                          ?.currencyPrice
                                                          .toString() ??
                                                          ''
                                                          : productDetailsController
                                                          .variationProductCurrencyPrice
                                                          .toString(),
                                                      size: 18.sp,
                                                      weight: FontWeight.w700,
                                                    );
                                                  }
                                                  return const SizedBox();
                                                }),
                                                SizedBox(width: 16.w),
                                                Obx(() {
                                                  if (productDetailsController
                                                      .initialVariationModel
                                                      .value
                                                      .data !=
                                                      null &&
                                                      productDetailsController
                                                          .productModel
                                                          .value
                                                          .data!
                                                          .isOffer ==
                                                          true) {
                                                    return CustomText(
                                                      text: productDetailsController
                                                          .variationProductOldCurrencyPrice
                                                          .toString() ==
                                                          ''
                                                          ? productDetailsController
                                                          .productModel
                                                          .value
                                                          .data
                                                          ?.oldCurrencyPrice
                                                          .toString()
                                                          : productDetailsController
                                                          .variationProductOldCurrencyPrice
                                                          .toString(),
                                                      textDecoration:
                                                      TextDecoration.lineThrough,
                                                      color: AppColor.grayColor,
                                                      size: 14.sp,
                                                      weight: FontWeight.w700,
                                                    );
                                                  }

                                                  return const SizedBox();
                                                })
                                              ],
                                            ),
                                          ],
                                        ),
                                        Container(),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              text: "QUANTITY",
                                              size: 14.sp,
                                            ),
                                            SizedBox(height: 8.h),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 99.w,
                                                  height: 36.h,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(20.r),
                                                    color: AppColor.cartColor,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceAround,
                                                    children: [
                                                      GestureDetector(
                                                          onTap: () {
                                                            if (productDetailsController
                                                                    .variationsStock.value <
                                                                0) {
                                                            } else {
                                                              if (cartController
                                                                      .numOfItems.value >
                                                                  1) {
                                                                cartController
                                                                    .numOfItems.value--;
                                                              } else {}
                                                            }
                                                          },
                                                          child: productDetailsController
                                                                      .variationsStock
                                                                      .value !=
                                                                  -1
                                                              ? cartController.numOfItems
                                                                              .value ==
                                                                          1 ||
                                                                      productDetailsController
                                                                              .variationsStock
                                                                              .value ==
                                                                          1
                                                                  ? SvgPicture.asset(
                                                                      SvgIcon.decrement,
                                                                      height: 25.h,
                                                                      width: 25.w)
                                                                  : SvgPicture.asset(
                                                                      SvgIcon.decrement,
                                                                      height: 25.h,
                                                                      width: 25.w)
                                                              : SvgPicture.asset(
                                                                  SvgIcon.decrement,
                                                                  height: 25.h,
                                                                  width: 25.w,)),
                                                      Obx(
                                                        () => CustomText(
                                                            text: cartController
                                                                .numOfItems.value
                                                                .toString(),
                                                            size: 18.sp,
                                                            weight: FontWeight.w600),
                                                      ),
                                                      GestureDetector(
                                                          onTap: () {
                                                            if (productDetailsController
                                                                    .variationsStock.value <
                                                                0) {
                                                            } else {
                                                              if (cartController
                                                                      .numOfItems.value <
                                                                  productDetailsController
                                                                      .variationsStock
                                                                      .value) {
                                                                cartController
                                                                    .numOfItems.value++;
                                                              } else {}
                                                            }
                                                          },
                                                          child: productDetailsController
                                                                      .variationsStock
                                                                      .value !=
                                                                  -1
                                                              ? cartController.numOfItems.value ==
                                                                          productDetailsController
                                                                              .variationsStock
                                                                              .value ||
                                                                      productDetailsController
                                                                              .variationsStock
                                                                              .value ==
                                                                          0
                                                                  ? SvgPicture.asset(
                                                                      SvgIcon.increment,
                                                                      height: 25.h,
                                                                      width: 25.w)
                                                                  : SvgPicture.asset(
                                                                      SvgIcon.increment,
                                                                      height: 25.h,
                                                                      width: 25.w)
                                                              : SvgPicture.asset(
                                                                  SvgIcon.increment,
                                                                  height: 25.h,
                                                                  width: 25.w,))
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 12.h),
                                                productDetailsController
                                                            .variationsStock.value >
                                                        0
                                                    ? Row(
                                                        children: [
                                                          TextWidget(
                                                            text: "Available:".tr,
                                                            fontSize: 14.sp,
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                          TextWidget(
                                                              text:
                                                                  " (${productDetailsController.variationsStock.value}) ",
                                                              fontSize: 16.sp,
                                                              fontWeight: FontWeight.w600),
                                                          TextWidget(
                                                            text: productDetailsController
                                                                .productModel
                                                                .value
                                                                .data
                                                                ?.unit
                                                                ?.toLowerCase(),
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 14.sp,
                                                          )
                                                        ],
                                                      )
                                                    : productDetailsController
                                                                .variationsStock.value ==
                                                            0
                                                        ? TextWidget(
                                                            text: "Stock Out".tr,
                                                            color: AppColor.redColor,
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 14.sp,
                                                          )
                                                        : SizedBox()
                                              ],
                                            ),
                                          ],
                                        ),
                                        Container()
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     SecondaryButton(
                                    //         height: 48.h,
                                    //         width: 165.w,
                                    //         icon: SvgIcon.bag,
                                    //         text: "ADD_TO_CART".tr,
                                    //         buttonColor: productDetailsController
                                    //                     .variationsStock.value >
                                    //                 0
                                    //             ? AppColor.primaryColor
                                    //             : AppColor.grayColor,
                                    //         //TODO:
                                    //         onTap: () async {
                                    //           if (productDetailsController
                                    //                       .initialVariationModel
                                    //                       .value
                                    //                       .data !=
                                    //                   null &&
                                    //               productDetailsController
                                    //                       .initialVariationModel
                                    //                       .value
                                    //                       .data!
                                    //                       .length >
                                    //                   0) {
                                    //             if (productDetailsController
                                    //                     .variationsStock.value >
                                    //                 0) {
                                    //               await productDetailsController
                                    //                   .finalVariation(
                                    //                       id: productDetailsController
                                    //                           .variationProductId
                                    //                           .toString());
                                    //               cartController
                                    //                       .totalIndividualProductTax =
                                    //                   0.0;
                                    //               productDetailsController
                                    //                   .productModel
                                    //                   .value
                                    //                   .data!
                                    //                   .taxes!
                                    //                   .map((e) {
                                    //                 cartController
                                    //                         .totalIndividualProductTax +=
                                    //                     double.parse(
                                    //                         e.taxRate.toString());
                                    //               }).toList();
                                    //
                                    //               var taxMap =
                                    //                   productDetailsController
                                    //                       .productModel
                                    //                       .value
                                    //                       .data!
                                    //                       .taxes!
                                    //                       .map((e) {
                                    //                 return {
                                    //                   "id": e.id!.toInt(),
                                    //                   "name": e.name.toString(),
                                    //                   "code": e.code.toString(),
                                    //                   "tax_rate": double.tryParse(
                                    //                       e.taxRate.toString()),
                                    //                   'tax_amount': double.tryParse(
                                    //                       cartController.totalTax
                                    //                           .toString()),
                                    //                 };
                                    //               }).toList();
                                    //
                                    //               cartController.addItem(
                                    //                   variationStock: productDetailsController.variationsStock.value
                                    //                       .toInt(),
                                    //                   product: productDetailsController
                                    //                       .productModel.value,
                                    //                   variationId: int.parse(productDetailsController
                                    //                       .variationProductId
                                    //                       .value),
                                    //                   shippingAmount: authController.settingModel?.data?.shippingSetupMethod.toString() == "5" &&
                                    //                           productDetailsController
                                    //                                   .productModel
                                    //                                   .value
                                    //                                   .data
                                    //                                   ?.shipping
                                    //                                   ?.shippingType
                                    //                                   .toString() ==
                                    //                               "5"
                                    //                       ? "0"
                                    //                       : productDetailsController
                                    //                           .productModel
                                    //                           .value
                                    //                           .data!
                                    //                           .shipping!
                                    //                           .shippingCost,
                                    //                   finalVariation: productDetailsController.finalVariationString,
                                    //                   sku: productDetailsController.variationsku.value,
                                    //                   taxJson: taxMap,
                                    //                   stock: productDetailsController.variationsStock.value,
                                    //                   shipping: productDetailsController.productModel.value.data!.shipping,
                                    //                   productVariationPrice: productDetailsController.variationProductPrice.value,
                                    //                   productVariationOldPrice: productDetailsController.variationProductOldPrice.value,
                                    //                   productVariationCurrencyPrice: productDetailsController.variationProductCurrencyPrice.value,
                                    //                   productVariationOldCurrencyPrice: productDetailsController.variationProductOldCurrencyPrice.value,
                                    //                   totalTax: cartController.totalIndividualProductTax,
                                    //                   flatShippingCost: authController.settingModel?.data?.shippingSetupFlatRateWiseCost.toString() ?? "0");
                                    //
                                    //               cartController.calculateShippingCharge(
                                    //                   shippingMethodStatus:
                                    //                       authController
                                    //                           .shippingMethod,
                                    //                   shippingType:
                                    //                       productDetailsController
                                    //                               .productModel
                                    //                               .value
                                    //                               .data
                                    //                               ?.shipping
                                    //                               ?.shippingType
                                    //                               .toString() ??
                                    //                           "0",
                                    //                   isProductQntyMultiply:
                                    //                       productDetailsController
                                    //                               .productModel
                                    //                               .value
                                    //                               .data
                                    //                               ?.shipping
                                    //                               ?.isProductQuantityMultiply
                                    //                               .toString() ??
                                    //                           "0",
                                    //                   flatShippingCharge: authController
                                    //                       .settingModel
                                    //                       ?.data
                                    //                       ?.shippingSetupFlatRateWiseCost);
                                    //
                                    //               customSnackbar(
                                    //                   "SUCCESS".tr,
                                    //                   "Product added to cart".tr,
                                    //                   AppColor.success);
                                    //             } else {}
                                    //           } else {
                                    //             if (productDetailsController
                                    //                     .variationsStock.value >
                                    //                 0) {
                                    //               cartController
                                    //                       .totalIndividualProductTax =
                                    //                   0.0;
                                    //
                                    //               productDetailsController
                                    //                   .productModel
                                    //                   .value
                                    //                   .data!
                                    //                   .taxes!
                                    //                   .map((e) {
                                    //                 cartController
                                    //                         .totalIndividualProductTax +=
                                    //                     double.parse(
                                    //                         e.taxRate.toString());
                                    //               }).toList();
                                    //
                                    //               var taxMap =
                                    //                   productDetailsController
                                    //                       .productModel
                                    //                       .value
                                    //                       .data!
                                    //                       .taxes!
                                    //                       .map((e) {
                                    //                 return {
                                    //                   "id": e.id!.toInt(),
                                    //                   "name": e.name.toString(),
                                    //                   "code": e.code.toString(),
                                    //                   "tax_rate": double.tryParse(
                                    //                       e.taxRate.toString()),
                                    //                   'tax_amount': double.tryParse(
                                    //                       cartController.totalTax
                                    //                           .toString()),
                                    //                 };
                                    //               }).toList();
                                    //
                                    //               cartController.addItem(
                                    //                   variationStock: productDetailsController.variationsStock.value
                                    //                       .toInt(),
                                    //                   product: productDetailsController
                                    //                       .productModel.value,
                                    //                   variationId: int.parse(productDetailsController
                                    //                       .variationProductId
                                    //                       .value),
                                    //                   shippingAmount: authController.settingModel!.data!.shippingSetupMethod.toString() == "5" &&
                                    //                           productDetailsController
                                    //                                   .productModel
                                    //                                   .value
                                    //                                   .data
                                    //                                   ?.shipping
                                    //                                   ?.shippingType
                                    //                                   .toString() ==
                                    //                               "5"
                                    //                       ? "0"
                                    //                       : productDetailsController
                                    //                           .productModel
                                    //                           .value
                                    //                           .data!
                                    //                           .shipping!
                                    //                           .shippingCost,
                                    //                   finalVariation: productDetailsController.finalVariationString,
                                    //                   sku: productDetailsController.productModel.value.data!.sku,
                                    //                   taxJson: taxMap,
                                    //                   stock: productDetailsController.productModel.value.data!.stock,
                                    //                   shipping: productDetailsController.productModel.value.data!.shipping,
                                    //                   productVariationPrice: productDetailsController.productModel.value.data!.price,
                                    //                   productVariationOldPrice: productDetailsController.productModel.value.data!.oldPrice,
                                    //                   productVariationCurrencyPrice: productDetailsController.productModel.value.data!.currencyPrice,
                                    //                   productVariationOldCurrencyPrice: productDetailsController.productModel.value.data!.oldCurrencyPrice,
                                    //                   totalTax: cartController.totalIndividualProductTax,
                                    //                   flatShippingCost: authController.settingModel?.data?.shippingSetupFlatRateWiseCost.toString() ?? "0");
                                    //
                                    //               cartController
                                    //                   .calculateShippingCharge(
                                    //                 shippingMethodStatus:
                                    //                     authController
                                    //                         .shippingMethod,
                                    //                 shippingType:
                                    //                     productDetailsController
                                    //                             .productModel
                                    //                             .value
                                    //                             .data
                                    //                             ?.shipping
                                    //                             ?.shippingType
                                    //                             .toString() ??
                                    //                         "0",
                                    //                 isProductQntyMultiply:
                                    //                     productDetailsController
                                    //                             .productModel
                                    //                             .value
                                    //                             .data
                                    //                             ?.shipping
                                    //                             ?.isProductQuantityMultiply
                                    //                             .toString() ??
                                    //                         "0",
                                    //                 flatShippingCharge: authController
                                    //                     .settingModel
                                    //                     ?.data
                                    //                     ?.shippingSetupFlatRateWiseCost,
                                    //               );
                                    //
                                    //               customSnackbar(
                                    //                   "SUCCESS".tr,
                                    //                   "Product added to cart".tr,
                                    //                   AppColor.success);
                                    //             } else {}
                                    //           }
                                    //         }),
                                    //     InkWell(
                                    //       onTap: () async {
                                    //         if (box.read('isLogedIn') != false) {
                                    //           if (productDetailsController
                                    //                   .productModel
                                    //                   .value
                                    //                   .data!
                                    //                   .wishlist ==
                                    //               true) {
                                    //             await wishlistController
                                    //                 .toggleFavoriteFalse(
                                    //                     productDetailsController
                                    //                         .productModel
                                    //                         .value
                                    //                         .data!
                                    //                         .id!);
                                    //
                                    //             wishlistController.showFavorite(
                                    //                 productDetailsController
                                    //                     .productModel
                                    //                     .value
                                    //                     .data!
                                    //                     .id!);
                                    //           }
                                    //           if (productDetailsController
                                    //                   .productModel
                                    //                   .value
                                    //                   .data!
                                    //                   .wishlist ==
                                    //               false) {
                                    //             await wishlistController
                                    //                 .toggleFavoriteTrue(
                                    //                     productDetailsController
                                    //                         .productModel
                                    //                         .value
                                    //                         .data!
                                    //                         .id!);
                                    //
                                    //             wishlistController.showFavorite(
                                    //                 productDetailsController
                                    //                     .productModel
                                    //                     .value
                                    //                     .data!
                                    //                     .id!);
                                    //           }
                                    //         } else {
                                    //           Get.to(() => const SignInScreen());
                                    //         }
                                    //       },
                                    //       borderRadius: BorderRadius.circular(24.r),
                                    //       child: Ink(
                                    //         height: 48.h,
                                    //         width: 139.w,
                                    //         decoration: BoxDecoration(
                                    //             borderRadius:
                                    //                 BorderRadius.circular(24.r),
                                    //             color: AppColor.whiteColor,
                                    //             boxShadow: [
                                    //               BoxShadow(
                                    //                   color: Colors.black
                                    //                       .withOpacity(0.04),
                                    //                   blurRadius: 8.r,
                                    //                   offset: const Offset(0, 4))
                                    //             ]),
                                    //         child: Row(
                                    //           mainAxisAlignment:
                                    //               MainAxisAlignment.center,
                                    //           children: [
                                    //             SvgPicture.asset(
                                    //               wishlistController.favList.contains(
                                    //                           productDetailsController
                                    //                               .productModel
                                    //                               .value
                                    //                               .data!
                                    //                               .id!) ||
                                    //                       productDetailsController
                                    //                               .productModel
                                    //                               .value
                                    //                               .data!
                                    //                               .wishlist ==
                                    //                           true
                                    //                   ? SvgIcon.filledHeart
                                    //                   : SvgIcon.heart,
                                    //               height: 24.h,
                                    //               width: 24.w,
                                    //             ),
                                    //             SizedBox(width: 8.w),
                                    //             CustomText(
                                    //               text: "FAVORITE".tr,
                                    //               size: 16.sp,
                                    //               weight: FontWeight.w700,
                                    //               color: AppColor.textColor,
                                    //             )
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     )
                                    //   ],
                                    // ),
                                    SizedBox(height: 20.h),
                                    const DeviderWidget(),
                                    SizedBox(height: 20.h),
                                    Obx(
                                      () => productDetailsController
                                                  .productModel.value.data !=
                                              null
                                          ? CustomTabBar(
                                              allProductModel:
                                                  widget.allProductModel,
                                              categoryWiseProduct:
                                                  widget.categoryWiseProduct,
                                              favoriteItem: widget.favoriteItem,
                                              productModel: widget.productModel,
                                              relatedProduct: widget.relatedProduct,
                                              sectionModel: widget.sectionModel,
                                            )
                                          : const SizedBox(),
                                    ),
                                    SizedBox(height: 30.h),
                                    CustomText(
                                      text: "RELATED_PRODUCTS".tr,
                                      size: 26.sp,
                                      weight: FontWeight.w700,
                                    ),
                                    SizedBox(height: 20.h),
                                    Obx(
                                      () => productDetailsController
                                                  .relatedProductModel.value.data ==
                                              null
                                          ? const SizedBox()
                                          : StaggeredGrid.count(
                                              crossAxisCount: 2,
                                              mainAxisSpacing: 16.h,
                                              crossAxisSpacing: 16.w,
                                              children: [
                                                for (int i = 0;
                                                    i <
                                                        productDetailsController
                                                            .relatedProductModel
                                                            .value
                                                            .data!
                                                            .length;
                                                    i++)
                                                  ProductWidget(
                                                    onTap: () async {
                                                      productDetailsController
                                                          .resetProductState();
                                                      Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProductDetailsScreen(
                                                                  relatedProduct:
                                                                      productDetailsController
                                                                          .relatedProductModel
                                                                          .value
                                                                          .data?[i]),
                                                        ),
                                                      );
                                                    },
                                                    favTap: () async {
                                                      if (box.read('isLogedIn') !=
                                                          false) {
                                                        if (productDetailsController
                                                                .relatedProductModel
                                                                .value
                                                                .data?[i]
                                                                .wishlist ==
                                                            true) {
                                                          await wishlistController
                                                              .toggleFavoriteFalse(
                                                                  productDetailsController
                                                                      .relatedProductModel
                                                                      .value
                                                                      .data![i]
                                                                      .id!);

                                                          wishlistController.showFavorite(
                                                              productDetailsController
                                                                  .relatedProductModel
                                                                  .value
                                                                  .data![i]
                                                                  .id!);
                                                        }
                                                        if (productDetailsController
                                                                .relatedProductModel
                                                                .value
                                                                .data?[i]
                                                                .wishlist ==
                                                            false) {
                                                          await wishlistController
                                                              .toggleFavoriteTrue(
                                                                  productDetailsController
                                                                      .relatedProductModel
                                                                      .value
                                                                      .data![i]
                                                                      .id!);

                                                          wishlistController.showFavorite(
                                                              productDetailsController
                                                                  .relatedProductModel
                                                                  .value
                                                                  .data![i]
                                                                  .id!);
                                                        }
                                                      } else {
                                                        Get.to(() =>
                                                            const SignInScreen());
                                                      }
                                                    },
                                                    wishlist: wishlistController
                                                                .favList
                                                                .contains(
                                                                    productDetailsController
                                                                        .relatedProductModel
                                                                        .value
                                                                        .data![i]
                                                                        .id!) ||
                                                            productDetailsController
                                                                    .relatedProductModel
                                                                    .value
                                                                    .data?[i]
                                                                    .wishlist ==
                                                                true
                                                        ? true
                                                        : false,
                                                    productImage:
                                                        productDetailsController
                                                            .relatedProductModel
                                                            .value
                                                            .data?[i]
                                                            .cover,
                                                    title: productDetailsController
                                                        .relatedProductModel
                                                        .value
                                                        .data?[i]
                                                        .name,
                                                    rating: productDetailsController
                                                        .relatedProductModel
                                                        .value
                                                        .data?[i]
                                                        .ratingStar,
                                                    currentPrice:
                                                        productDetailsController
                                                            .relatedProductModel
                                                            .value
                                                            .data?[i]
                                                            .currencyPrice,
                                                    discountPrice:
                                                        productDetailsController
                                                            .relatedProductModel
                                                            .value
                                                            .data?[i]
                                                            .discountedPrice,
                                                    textRating:
                                                        productDetailsController
                                                            .relatedProductModel
                                                            .value
                                                            .data?[i]
                                                            .ratingStarCount,
                                                    flashSale:
                                                        productDetailsController
                                                            .relatedProductModel
                                                            .value
                                                            .data![i]
                                                            .flashSale!,
                                                    isOffer:
                                                        productDetailsController
                                                            .relatedProductModel
                                                            .value
                                                            .data![i]
                                                            .isOffer!,
                                                  ),
                                                SizedBox(height: 12.h),
                                              ],
                                            ),
                                    ),
                                  ]),
                          ),
                        ],
                      ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
