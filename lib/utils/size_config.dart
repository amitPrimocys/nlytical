import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = Get.height;
  // 896 is the layout height that designer use
  return (inputHeight / 896.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = Get.width;
  // 414 is the layout width that designer use
  return (inputWidth / 414.0) * screenWidth;
}

sizeBoxHeight(double value) {
  return SizedBox(height: getProportionateScreenHeight(value));
}

sizeBoxWidth(double value) {
  return SizedBox(width: getProportionateScreenWidth(value));
}
