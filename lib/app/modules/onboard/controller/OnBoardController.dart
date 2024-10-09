import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/OnBoardModel.dart';

class OnBoardController extends GetxController {

  final pageController = PageController(initialPage: 0);
  RxInt currentPage = 0.obs;

  final List<OnBoardModel> demoData = [
    OnBoardModel(
      image: 'assets/images/onboard1.png',
      title: "Take care of your Best Friends",
      description: "Get everything for your pets",
    ),
    OnBoardModel(
      image: 'assets/images/dog.png',
      title: "Fastest Way To Book Great Musicians",
      description: "Find the perfect match",
    ),
    OnBoardModel(
      image: 'assets/images/onboard1.png',
      title: "Find Top Sessions Pros For Your Event",
      description: "Make the day remarkable.",
    ),
  ];

}