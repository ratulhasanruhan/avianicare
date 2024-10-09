import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme/app_color.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField(
      {super.key,
      this.controller,
      this.validator,
      this.obsecure,
      this.keyboardType,
      this.onTap,
      this.suffixIcon,
      this.isSuffixIcon = false, this.enabled,
        this.hintText});

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool? obsecure;
  final TextInputType? keyboardType;
  final void Function()? onTap;
  final Widget? suffixIcon;
  final bool isSuffixIcon;
  final bool? enabled;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        style: GoogleFonts.roboto(
            color: AppColor.textColor,
            fontWeight: FontWeight.w500,
            fontSize: 16.sp),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: obsecure ?? false,
        cursorColor: AppColor.textColor,
        controller: controller,
        keyboardType: keyboardType,
        enabled: enabled,
        decoration: InputDecoration(
          suffixIcon: isSuffixIcon ? suffixIcon : const SizedBox(),
          prefix: SizedBox(
            width: 10.w,
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFCECECE)),
            borderRadius: BorderRadius.circular(10.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFCECECE)),
            borderRadius: BorderRadius.circular(10.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFCECECE)),
            borderRadius: BorderRadius.circular(10.r),
          ),
          label: Text(
            hintText ?? '',
          ),
          labelStyle: GoogleFonts.roboto(
              color: Color(0xFF5C5C5C),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
