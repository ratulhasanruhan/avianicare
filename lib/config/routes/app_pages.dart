import 'package:get/get.dart';
import 'package:avianicare/app/modules/category/bindings/category_bindings.dart';

import 'package:avianicare/app/modules/home/bindings/home_bindings.dart';
import 'package:avianicare/app/modules/home/views/home_screen.dart';
import 'package:avianicare/app/modules/language/views/language_change_screen.dart';
import 'package:avianicare/app/modules/navbar/bindings/navbar_binding.dart';
import 'package:avianicare/app/modules/navbar/views/navbar_view.dart';
import 'package:avianicare/app/modules/splash/binding/splash_binding.dart';
import 'package:avianicare/config/routes/app_routes.dart';
import '../../app/modules/language/bindings/language_binding.dart';
import '../../app/modules/splash/views/splash_screen.dart';

class AppPages {
  AppPages._();

  static String initial = "/splash/";

  static final pages = [
    GetPage(
      name: initial,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.navBarView,
      page: () => const NavBarView(),
      bindings: [
        HomeBindings(),
        NavbarBinding(),
        CategoryTreeBindings(),
      ],
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      binding: HomeBindings(),
    ),
    GetPage(
      name: Routes.language,
      page: () => const ChangeLanguageView(),
      binding: LanguageBindings(),
    )
  ];
}
