import 'dart:convert';
import 'package:nlytical/utils/global.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:nlytical/auth/splash.dart';
import 'package:nlytical/models/user_models/block_model.dart';
import 'package:nlytical/models/user_models/unblock_model.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/utils/common_widgets.dart';

final ApiHelper apiHelper = ApiHelper();

class BlockContro extends GetxController {
  RxBool isblock = false.obs;
  Rx<BlockModel?> blockmodel = BlockModel().obs;

  Future<void> blockApi({String? oppsiteId}) async {
    isblock.value = true;

    try {
      var uri = Uri.parse(apiHelper.block);
      var request = http.MultipartRequest('Post', uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);

      request.fields['blockedUserId'] = oppsiteId!;

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      blockmodel.value = BlockModel.fromJson(userData);

      if (blockmodel.value!.status == true) {
        isblock.value = false;

        snackBar(languageController.textTranslate("User Blocked"));
      } else {
        isblock.value = false;
      }
    } catch (e) {
      isblock.value = false;
    } finally {
      isblock.value = false;
    }
  }

  RxBool isunblock = false.obs;
  Rx<UnBlockModel?> unblockmodel = UnBlockModel().obs;

  Future<void> unBlockApi({String? oppsiteId}) async {
    isunblock.value = true;

    try {
      var uri = Uri.parse(apiHelper.unblock);
      var request = http.MultipartRequest('Post', uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);

      request.fields['blockedUserId'] = oppsiteId!;

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      unblockmodel.value = UnBlockModel.fromJson(userData);

      if (unblockmodel.value!.status == true) {
        isunblock.value = false;

        snackBar(languageController.textTranslate("Unblock Successfully"));
      } else {
        isunblock.value = false;
      }
    } catch (e) {
      isunblock.value = false;
    } finally {
      isunblock.value = false;
    }
  }
}
