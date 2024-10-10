import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:avianicare/app/modules/auth/controller/auth_controler.dart';
import 'package:avianicare/app/modules/auth/views/sign_in.dart';
import 'package:avianicare/utils/svg_icon.dart';
import 'package:avianicare/utils/validation_rules.dart';
import 'package:avianicare/widgets/appbar3.dart';
import 'package:avianicare/widgets/loader/loader.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../widgets/custom_form_field.dart';
import '../../../../widgets/custom_text.dart';
import '../../../../widgets/form_field_title.dart';
import '../../../../widgets/primary_button.dart';
import '../controller/swap_title_controller.dart';
import '../widgets/swap_field_title.dart';
import '../widgets/swap_form_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final authController = Get.put(AuthController());
  final swapController = Get.put(SwapTitleController());

  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    authController.getSetting();
    authController.getCountryCode();
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
      child: Obx(
        () => Stack(
          alignment: Alignment.center,
          children: [
            Scaffold(
              appBar: const AppBarWidget3(text: ''),
              backgroundColor: AppColor.primaryBackgroundColor,
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Sign Up".tr,
                        style: TextStyle(
                          fontFamily: "SUSE",
                          fontSize: 30,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      CustomText(
                          text: "Let's create your account".tr, size: 16.sp),
                      SizedBox(height: 30.h),
                      Form(
                        key: formkey,
                        child: Column(
                          children: [
                            const SwapFieldTitle(),
                            SizedBox(height: 4.h),
                            SwapFormField(
                              emailController: authController.emailController,
                              emailValidator: (email) =>
                                  ValidationRules().email(email),
                              phoneController: authController.phoneController,
                              prefix: Padding(
                                padding: EdgeInsets.only(left: 10.w),
                                child: PopupMenuButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.r),
                                    ),
                                  ),
                                  position: PopupMenuPosition.under,
                                  itemBuilder: (ctx) => List.generate(
                                      authController
                                          .countryCodeModel!.data!.length,
                                      (index) => PopupMenuItem(
                                            height: 32.h,
                                            onTap: () async {
                                              setState(() {
                                                authController.countryCode =
                                                    authController
                                                        .countryCodeModel!
                                                        .data![index]
                                                        .callingCode
                                                        .toString();
                                              });
                                            },
                                            child: Text(
                                              authController.countryCodeModel!
                                                  .data![index].callingCode
                                                  .toString(),
                                              style: TextStyle(
                                                fontFamily: "SUSE",
                                                  color: AppColor.textColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16.sp),
                                            ),
                                          )),
                                  child: Row(
                                    children: [
                                      Text(
                                        authController.countryCode,
                                        style: TextStyle(
                                          fontFamily: "SUSE",
                                            color: AppColor.textColor,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      SvgPicture.asset(SvgIcon.down)
                                    ],
                                  ),
                                ),
                              ),
                              phoneValidator: (phone) =>
                                  ValidationRules().normal(phone),
                            ),
                            SizedBox(height: 14.h),
                            CustomFormField(
                              controller: authController.nameController,
                              hintText: "Name".tr,
                              validator: (name) =>
                                  ValidationRules().normal(name),
                            ),
                            SizedBox(height: 14.h),
                            TextFormField(
                              style: TextStyle(
                                fontFamily: "SUSE",
                                  color: AppColor.textColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp),
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              obscureText: authController.registerPasswordVisibility.value,
                              cursorColor: AppColor.textColor,
                              controller: authController.passController,
                              decoration: InputDecoration(
                                prefix: SizedBox(
                                  width: 10.w,
                                ),
                                border: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Color(0xFFCECECE)),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Color(0xFFCECECE)),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Color(0xFFCECECE)),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                label: CustomText(
                                  text: "Password".tr,
                                  color: Color(0xFF747474),
                                  size: 18,
                                  weight: FontWeight.w500,
                                ),
                                suffixIcon: IconButton(
                                    onPressed: (){
                                      authController.registerPasswordVisibility.value = !authController.registerPasswordVisibility.value;
                                    },
                                    icon: Icon( authController.registerPasswordVisibility.value ? Icons.visibility : Icons.visibility_off,
                                      color: Color(0xFF8D8D8D)
                                      ,)
                                ),
                              ),
                              validator: (password) =>
                                  ValidationRules().password(password),
                            ),
                            SizedBox(height: 20.h),
                            PrimaryButton(
                                text: "Sign Up".tr,
                                onTap: () {
                                  if (formkey.currentState!.validate()) {
                                    swapController.isShowEmailField.value
                                        ? authController
                                            .registrationValidationWithEmail(
                                            name: authController
                                                .nameController.text,
                                            email: authController
                                                .emailController.text,
                                            password: authController
                                                .passController.text,
                                          )
                                        : authController
                                            .registrationValidationWithPhone(
                                                name: authController
                                                    .nameController.text,
                                                phone: authController
                                                    .phoneController.text,
                                                countryCode: authController
                                                    .countryCode,
                                                password: authController
                                                    .passController.text);
                                  } else {
                                    debugPrint("Something is wrong.");
                                  }
                                }),
                            SizedBox(
                              height: 15.h,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: "Already have account?",
                                    color: const Color(0xFF575353),
                                    size: 16,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => const SignInScreen());
                                    },
                                    child: Text(
                                      "Log In",
                                      style: TextStyle(
                                        fontFamily: "SUSE",
                                        fontSize: 16,
                                        color: Color(0xFF010101),
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 32.h,
                      ),
                      Image.asset(
                        'assets/images/dog.png',
                        height: 220.h,
                        width: MediaQuery.of(context).size.width,
                      )
                    ],
                  ),
                ),
              ),
            ),
            authController.isLoading.value
                ? const LoaderCircle()
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
