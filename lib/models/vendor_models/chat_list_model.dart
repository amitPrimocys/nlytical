class ChatListModel {
  bool? success;
  String? message;
  List<ChatList>? chatList;

  ChatListModel({this.success, this.message, this.chatList});

  ChatListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['chat_list'] != null) {
      chatList = <ChatList>[];
      json['chat_list'].forEach((v) {
        chatList!.add(ChatList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (chatList != null) {
      data['chat_list'] = chatList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChatList {
  int? id;
  int? myId;
  int? secondId;
  String? lastMessage;
  String? url;
  String? type;
  int? userId;
  String? firstName;
  String? lastName;
  String? userRole;
  String? profilePic;
  String? time;
  String? lastSeen;
  String? unreadMessage;

  ChatList(
      {this.id,
      this.myId,
      this.secondId,
      this.lastMessage,
      this.url,
      this.type,
      this.userId,
      this.firstName,
      this.lastName,
      this.userRole,
      this.profilePic,
      this.time,
      this.lastSeen,
      this.unreadMessage});

  ChatList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    myId = json['my_id'];
    secondId = json['second_id'];
    lastMessage = json['last_message'];
    url = json['url'];
    type = json['type'];
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    userRole = json['user_role'];
    profilePic = json['profile_pic'];
    time = json['time'];
    lastSeen = json['last_seen'];
    unreadMessage = json['unread_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['my_id'] = myId;
    data['second_id'] = secondId;
    data['last_message'] = lastMessage;
    data['url'] = url;
    data['type'] = type;
    data['user_id'] = userId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['user_role'] = userRole;
    data['profile_pic'] = profilePic;
    data['time'] = time;
    data['last_seen'] = lastSeen;
    data['unread_message'] = unreadMessage;
    return data;
  }
}
