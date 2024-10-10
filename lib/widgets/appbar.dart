import 'package:avianicare/app/modules/search/views/search_screen.dart';
import 'package:avianicare/app/modules/wishlist/views/wishlist_screen.dart';
import 'package:avianicare/config/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:avianicare/utils/svg_icon.dart';
import 'package:get/get.dart';
import '../../../../config/theme/app_color.dart';
import '../app/modules/cart/controller/cart_controller.dart';

class AppBarWidget extends StatelessWidget {
  AppBarWidget(
      {super.key,
      this.onTap,
      this.svgIcon,
      this.title,
      required this.isSearch});

  final void Function()? onTap;
  final String? svgIcon;
  final String? title;
  final bool? isSearch;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.primaryBackgroundColor,
      elevation: 0,
      toolbarHeight: 48.h,
      leading: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        child: GestureDetector(
          onTap: () {

          },
          child: SvgPicture.asset(
            'assets/icons/hamburger.svg',
          ),
        ),
      ),
      title: isSearch?? false ?
        TextField(
          onTap: (){
            Get.to(() => SearchScreen());
          },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          isDense: true,
          hintText: 'Search here',
          hintStyle: TextStyle(
            color: Color(0xFFBEBEBE),
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SvgPicture.asset(
              'assets/icons/search.svg',
              color: Color(0xFF585858),
            ),
          ),
          suffixIconConstraints: BoxConstraints(
            maxHeight: 30,
            maxWidth: 30,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF77B56D),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF77B56D),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF77B56D),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ) : Text(
        title ?? '',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColor.textColor,
        ),
      ),
      actions: [
        isSearch == true
            ? Container(
                margin: EdgeInsets.only(right: 16.w, top: 5, bottom: 5),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2),
                decoration: BoxDecoration(
                  color: Color(0xFFEDEBEB),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {
                    Get.to(() => WishlistScreen());
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: SvgPicture.asset(
                          SvgIcon.heart,
                          height: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
