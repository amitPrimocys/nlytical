class GetBudgetModel {
  bool? status;
  String? message;
  List<Data>? data;

  GetBudgetModel({this.status, this.message, this.data});

  GetBudgetModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? days;
  int? price;

  Data({this.id, this.days, this.price});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    days = json['days'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['days'] = days;
    data['price'] = price;
    return data;
  }
}
