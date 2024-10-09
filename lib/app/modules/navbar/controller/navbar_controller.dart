import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavbarController extends GetxController {
  late TabController tabController;

  final selectedIndex = 0.obs;
  final canExit = false.obs;

  void selectPage(int index) {
    selectedIndex.value = index;
  }
}
