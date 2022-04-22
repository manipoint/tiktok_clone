import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController instance = Get.find();
  late PageController pageController;
  Rx<int> currentIndex = 0.obs;
  // GlobalKey bottomNavigationKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onClose() {
    super.onClose();
    pageController.dispose();
  }
}
