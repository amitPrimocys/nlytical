import 'package:get/get.dart';

class RoleController extends GetxController {
  RxBool isUser = true.obs;
  RxBool isSponsor = true.obs;

  void isUserSelected() {
    isUser.value = true;
  }

  void isVendorSelected() {
    isUser.value = false;
  }

  void isSponsorSelect() {
    isSponsor.value = true;
  }

  void isSubScribeSelect() {
    isSponsor.value = false;
  }
}
