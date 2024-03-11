import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeController extends GetxController {
  var pageController = PageController();
  var currentPage = 0.obs;

    set setPage(int value) {
    pageController.animateToPage(
      value,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
    currentPage.value = value;
  }
}
