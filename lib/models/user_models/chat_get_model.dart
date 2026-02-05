// ignore_for_file: depend_on_referenced_packages

import 'package:intl/intl.dart';

class GetMessageModel {
  bool? success;
  String? message;
  ToUserDetails? toUserDetails;
  List<ChatMessages>? chatMessages;

  GetMessageModel({
    this.success,
    this.message,
    this.toUserDetails,
    this.chatMessages,
  });

  GetMessageModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    toUserDetails = json['to_user_details'] != null
        ? ToUserDetails.fromJson(json['to_user_details'])
        : null;
    if (json['chatMessages'] != null) {
      chatMessages = <ChatMessages>[];
      json['chatMessages'].forEach((v) {
        chatMessages!.add(ChatMessages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (toUserDetails != null) {
      data['to_user_details'] = toUserDetails!.toJson();
    }
    if (chatMessages != null) {
      data['chatMessages'] = chatMessages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ToUserDetails {
  int? id;
  String? firstName;
  String? lastName;
  int? status;
  int? isOnline;
  String? image;
  String? role;
  String? updatedAt;

  ToUserDetails({
    this.id,
    this.firstName,
    this.lastName,
    this.status,
    this.isOnline,
    this.image,
    this.role,
    this.updatedAt,
  });

  ToUserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    status = json['status'];
    isOnline = json['is_online'];
    image = json['image'];
    role = json['role'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['status'] = status;
    data['is_online'] = isOnline;
    data['image'] = image;
    data['role'] = role;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class ChatMessages {
  String? date;
  List<Messages>? messages;

  ChatMessages({this.date, this.messages});

  ChatMessages.fromJson(Map<String, dynamic> json) {
    date = convertToLocalDate(json['date']);
    date = json['date'];
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    if (messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Messages {
  int? id;
  int? fromUser;
  int? toUser;
  String? message;
  String? url;
  String? type;
  String? readMessage;
  String? createdAt;
  String? firstName;
  String? lastName;
  String? role;
  int? status;
  String? profileImage;
  int? messageSeen;
  String? chatTime;

  Messages({
    this.id,
    this.fromUser,
    this.toUser,
    this.message,
    this.url,
    this.type,
    this.readMessage,
    this.createdAt,
    this.firstName,
    this.lastName,
    this.role,
    this.status,
    this.profileImage,
    this.messageSeen,
    this.chatTime,
  });

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromUser = json['from_user'];
    toUser = json['to_user'];
    message = json['message'];
    url = json['url'];
    type = json['type'];
    readMessage = json['read_message'];
    createdAt = json['created_at'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    role = json['role'];
    status = json['status'];
    profileImage = json['profile_image'];
    messageSeen = json['message_seen'];
    chatTime = json['chat_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['from_user'] = fromUser;
    data['to_user'] = toUser;
    data['message'] = message;
    data['url'] = url;
    data['type'] = type;
    data['read_message'] = readMessage;
    data['created_at'] = createdAt;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['role'] = role;
    data['status'] = status;
    data['profile_image'] = profileImage;
    data['message_seen'] = messageSeen;
    data['chat_time'] = chatTime;
    return data;
  }
}

String convertToLocalDate(String? dateString) {
  if (dateString == null || dateString.isEmpty) return "";
  final DateTime dateTime = DateTime.parse(dateString);
  final DateFormat formatter = DateFormat('dd MMMM yyyy');
  return formatter.format(dateTime);
}
