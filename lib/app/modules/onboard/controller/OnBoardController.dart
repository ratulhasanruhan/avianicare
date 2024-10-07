import 'package:get/get.dart';

import '../model/OnBoardModel.dart';

class OnBoardController extends GetxController {

  RxInt currentPage = 0.obs;

  final List<OnBoardModel> demoData = [
    OnBoardModel(
      image: 'assets/images/profile_picture.png',
      title: "Find Best Musicians All Around Your City",
      description: "Thousands of musicians around you are waiting to rock your event.",
    ),
    OnBoardModel(
      image: 'assets/images/profile_picture.png',
      title: "Fastest Way To Book Great Musicians",
      description: "Find the perfect match to perform for your event and make the day remarkable.",
    ),
    OnBoardModel(
      image: 'assets/images/profile_picture.png',
      title: "Find Top Sessions Pros For Your Event",
      description: "Find the perfect match to perform for your event and make the day remarkable.",
    ),
  ];

}