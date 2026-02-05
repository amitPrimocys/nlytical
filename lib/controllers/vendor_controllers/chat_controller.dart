// ignore_for_file: avoid_print, strict_top_level_inference

import 'dart:async';
import 'dart:convert';
import 'package:nlytical/utils/global.dart';
import 'package:get/get.dart';
import 'package:nlytical/models/user_models/chat_list_model.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/models/vendor_models/add_chat_model.dart';
import 'package:nlytical/models/vendor_models/chat_get_model.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/models/vendor_models/online_model.dart';

class ChatControllervendor extends GetxController {
  RxBool isChatListLoading = false.obs;
  var isSearchVisible = false.obs;
  Rx<ChatListModel?> chatmodel = ChatListModel().obs;
  StreamController<ChatListModel> streamController1 =
      StreamController<ChatListModel>.broadcast();

  StreamController<OnlineModel> streamControlleronline =
      StreamController<OnlineModel>.broadcast();
  // RxList<ChatList> chatlist = <ChatList>[].obs;
  RxInt chatlistIndex = (-1).obs;

  RxInt totalUnreadMessages = 0.obs;

  final ApiHelper apiHelper = ApiHelper();

  Future<void> chatApi({String? xyz, required bool issearch}) async {
    isChatListLoading.value = true;
    (xyz);
    try {
      var uri = Uri.parse(apiHelper.chatList);
      var request = http.MultipartRequest('POST', uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);

      if (issearch) {
        request.fields['first_name'] = xyz!;
      }

      // request.headers.addAll(headers);
      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      chatmodel.value = ChatListModel.fromJson(userData);

      if (chatmodel.value!.success == true) {
        streamController1.sink.add(chatmodel.value!);
        calculateTotalUnreadMessages();

        isChatListLoading.value = false;
      } else {
        isChatListLoading.value = false;
        (chatmodel.value!.message);
      }
    } catch (e) {
      isChatListLoading.value = false;
    }
  }

  void calculateTotalUnreadMessages() {
    if (chatmodel.value?.chatList != null) {
      totalUnreadMessages.value = chatmodel.value!.chatList!.fold<int>(
        0,
        (sum, chat) => sum + (int.tryParse(chat.unreadMessage ?? '0') ?? 0),
      );
    } else {
      totalUnreadMessages.value = 0;
    }
  }

  RxBool isgetLoading = false.obs;
  RxString isonlinestatus = ''.obs;
  Rx<GetMessageModel> getMessageModel = GetMessageModel().obs;
  StreamController<GetMessageModel> streamController =
      StreamController<GetMessageModel>.broadcast();
  Future<void> chatgetApi({required String toUSerID}) async {
    isgetLoading.value = true;

    try {
      var uri = Uri.parse(apiHelper.innerchat);
      var request = http.MultipartRequest('POST', uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);

      request.fields['to_user'] = toUSerID;

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      getMessageModel.value = GetMessageModel.fromJson(userData);

      if (chatmodel.value!.success == true) {
        isonlinestatus.value = getMessageModel.value.toUserDetails!.isOnline
            .toString();

        streamController.sink.add(getMessageModel.value);
        isgetLoading.value = false;
      } else {
        isgetLoading.value = false;
        (chatmodel.value!.message);
      }
    } catch (e) {
      isgetLoading.value = false;
    }
  }

  RxBool isSendMessage = false.obs;
  Rx<AddChatModel> addchatmodel = AddChatModel().obs;
  Future<void> addChatText(
    image, {
    required String toUSerID,
    required String message,
    required String type,
  }) async {
    isSendMessage.value = true;

    try {
      var uri = Uri.parse(apiHelper.addChat);
      var request = http.MultipartRequest('POST', uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);

      request.fields['to_user'] = toUSerID;

      request.fields['message'] = message;

      request.fields['type'] = type;

      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath('url', image));
      }

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      addchatmodel.value = AddChatModel.fromJson(userData);

      if (chatmodel.value!.success == true) {
        isSendMessage.value = false;
      } else {
        isSendMessage.value = false;
      }
    } catch (e) {
      isSendMessage.value = false;
    }
  }

  RxBool isonline = false.obs;
  Rx<OnlineModel> online = OnlineModel().obs;
  Future<void> onlineuservendor({required String onlineStatus}) async {
    isonline.value = true;

    try {
      var uri = Uri.parse(apiHelper.useronline);
      var request = http.MultipartRequest('POST', uri);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      request.headers.addAll(headers);

      request.fields['status'] = onlineStatus;

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);
      online.value = OnlineModel.fromJson(userData);

      if (online.value.status == true) {
        streamControlleronline.sink.add(online.value);
      }
    } catch (e) {
      isonline.value = false;
    }
  }
}
