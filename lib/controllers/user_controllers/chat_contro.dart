import 'dart:async';
import 'dart:convert';
import 'package:nlytical/utils/global.dart';
import 'package:get/get.dart';
import 'package:nlytical/models/user_models/add_chat_model.dart';
import 'package:nlytical/models/user_models/chat_get_model.dart';
import 'package:nlytical/models/user_models/chat_list_model.dart';
import 'package:nlytical/models/user_models/online_model.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:http/http.dart' as http;

class ChatController extends GetxController {
  RxBool isChatListLoading = false.obs;
  Rx<ChatListModel?> chatmodel = ChatListModel().obs;
  StreamController<ChatListModel> streamController1 =
      StreamController<ChatListModel>.broadcast();

  StreamController<OnlineModel> streamControlleronline =
      StreamController<OnlineModel>.broadcast();
  RxInt chatlistIndex = (-1).obs;
  RxInt totalUnreadMessages = 0.obs;

  final ApiHelper apiHelper = ApiHelper();

  Future<void> chatApi({
    String? xyz,
    required bool issearch,
    required String userid,
  }) async {
    isChatListLoading.value = true;

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
        // chatlist.addAll(chatmodel.value!.chatList!);
        isChatListLoading.value = false;
      } else {
        isChatListLoading.value = false;
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
  RxString userROLE = ''.obs;
  Rx<GetMessageModel> getMessageModel = GetMessageModel().obs;
  StreamController<GetMessageModel> streamController =
      StreamController<GetMessageModel>.broadcast();

  Future<void> chatgetApi({
    required String toUSerID,
    required String fromUser,
  }) async {
    isgetLoading.value = true;

    try {
      var uri = Uri.parse(apiHelper.innerChat);

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': "Bearer $authToken",
      };

      Map<String, String> body = {'to_user': toUSerID};

      // Make the POST request
      var response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        var userData = json.decode(response.body);

        getMessageModel.value = GetMessageModel.fromJson(userData);

        if (getMessageModel.value.success == true) {
          isonlinestatus.value = getMessageModel.value.toUserDetails!.isOnline
              .toString();
          userROLE.value = getMessageModel.value.toUserDetails!.role.toString();
          streamController.sink.add(getMessageModel.value);
        }
      }
    } finally {
      isgetLoading.value = false;
    }
  }

  RxBool isSendMessage = false.obs;
  Rx<AddChatModel> addchatmodel = AddChatModel().obs;
  Future<bool> addChatText(
    image, {
    required String toUSerID,
    required String message,
    required String type,
    required String isLead,
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
      if (isLead.isNotEmpty) {
        request.fields['is_lead'] = isLead;
      }

      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath('url', image));
      }

      var response = await request.send();
      String responsData = await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responsData);

      addchatmodel.value = AddChatModel.fromJson(userData);

      if (chatmodel.value!.success == true) {
        isSendMessage.value = false;
        return true;
      } else {
        isSendMessage.value = false;
        return false;
      }
    } catch (e) {
      isSendMessage.value = false;
      return false;
    }
  }
}
