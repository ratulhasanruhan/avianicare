import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:avianicare/main.dart';
import 'package:avianicare/widgets/appbar3.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../utils/validation_rules.dart';
import '../../../../widgets/custom_form_field.dart';
import '../../../../widgets/custom_text.dart';
import '../../../../widgets/form_field_title.dart';
import '../../../../widgets/loader/loader.dart';
import '../../../../widgets/primary_button.dart';
import '../controller/auth_controler.dart';
import '../controller/swap_title_controller.dart';
import '../widgets/swap_field_title.dart';
import '../widgets/swap_form_field.dart';
import 'forgot_password.dart';
import 'sign_up.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final authController = Get.put(AuthController());
  final swapController = Get.put(SwapTitleController());

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final phoneController = TextEditingController();

  final formkey = GlobalKey<FormState>();

  bool mark = true;

  @override
  void initState() {
    super.initState();
    authController.getSetting();
    authController.getCountryCode();

    emailController.text =
        box.read('email') == null ? '' : box.read('email').toString();
    passController.text =
        box.read('password') == null ? '' : box.read('password').toString();
    phoneController.text =
        box.read('phone') == null ? '' : box.read('phone').toString();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    phoneController.dispose();
    super.dispose();
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sign In".tr,
                        style: TextStyle(
                          fontFamily: "SUSE",
                          fontSize: 30,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Form(
                        key: formkey,
                        child: Column(
                          children: [
                            const SwapFieldTitle(),
                            SizedBox(height: 4.h),
                            SwapFormField(
                              emailController: emailController,
                              emailValidator: (email) =>
                                  ValidationRules().email(email),
                              phoneController: phoneController,
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
                            SizedBox(height: 16.h),
                            TextFormField(
                              style: TextStyle(
                                fontFamily: "SUSE",
                                  color: AppColor.textColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              obscureText: authController.loginPasswordVisibility.value,
                              cursorColor: AppColor.textColor,
                              controller: passController,
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
                                      authController.loginPasswordVisibility.value = !authController.loginPasswordVisibility.value;
                                    },
                                    icon: Icon( authController.loginPasswordVisibility.value ? Icons.visibility : Icons.visibility_off,
                                      color: Color(0xFF8D8D8D)
                                      ,)
                                ),
                              ),
                              validator: (password) =>
                                  ValidationRules().password(password),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {
                                  Get.to(
                                          () => const ForgotPasswordScreen());
                                },
                                child: Text(
                                  "Forgot Password?".tr,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: "SUSE",
                                    fontSize: 16,
                                    color: Color(0xFF575353),
                                ),
                                ),
                              ),
                            ),
                            PrimaryButton(
                                text: "Sign In".tr,
                                onTap: () {
                                  if (formkey.currentState!.validate()) {
                                    if (swapController
                                        .isShowEmailField.value) {
                                      if (mark == true) {
                                        box.write(
                                            'email', emailController.text);
                                        box.write(
                                            'password', passController.text);
                                      } else if (mark == false) {
                                        box.remove('email');
                                        box.remove('password');
                                      }
                                    } else {
                                      if (mark == true) {
                                        box.write(
                                            'phone', phoneController.text);
                                        box.write('country_code',
                                            authController.countryCode);
                                        box.write(
                                            'password', passController.text);
                                      } else if (mark == false) {
                                        box.remove('phone');
                                        box.remove('country_code');
                                        box.remove('password');
                                      }
                                    }
                                    swapController.isShowEmailField.value
                                        ? authController.signInWithEmail(
                                            email: emailController.text,
                                            password: passController.text)
                                        : authController.signInWithPhone(
                                            phone: phoneController.text,
                                            countryCode:
                                                authController.countryCode,
                                            password: passController.text);
                                  } else {
                                    debugPrint("Login is failed");
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
                                      text: "New User?",
                                      color: const Color(0xFF575353),
                                      size: 16,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => const SignUpScreen());
                                    },
                                    child: Text(
                                      "Create an Account",
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
                        height: 300.h,
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
