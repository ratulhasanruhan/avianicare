import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/theme/app_color.dart';

// ignore: must_be_immutable
class TitleWidget extends StatelessWidget {
  TitleWidget({super.key, required this.text});
  String? text;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$text',
      style: TextStyle(
        fontFamily: "SUSE",
          color: AppColor.titleTextColor,
          fontWeight: FontWeight.w500,
          fontSize: 20.sp),
    );
  }
}
