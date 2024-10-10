import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../app/modules/cart/controller/cart_controller.dart';
import '../config/theme/app_color.dart';
import '../utils/svg_icon.dart';

class SecondaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  SecondaryAppBar({
    super.key,
    this.onTap,
    this.title,
  });

  final void Function()? onTap;
  final String? title;

  final cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 54.w,
      backgroundColor: AppColor.primaryBackgroundColor,
      centerTitle: true,
      title: Text(
        title ?? '',
        style: TextStyle(
          color: AppColor.titleTextColor,
        ),
      ),
      leading: Container(
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        child: GestureDetector(
          onTap: () => Get.back(),
          child: SvgPicture.asset(
            SvgIcon.back,
          ),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 16.w, top: 10, bottom: 10),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2),
          decoration: BoxDecoration(
            color: Color(0xFFEDEBEB),
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: onTap,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: SvgPicture.asset(
                    'assets/images/cart.svg',
                    height: 22,
                  ),
                ),

                Obx(() => cartController.cartItems.isNotEmpty
                    ? Row(
                  children: [
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      cartController.cartItems.length.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),
                    ),
                  ],
                )
                    : const SizedBox())
              ],
            ),
          ),
        )
      ],
      elevation: 0.0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
