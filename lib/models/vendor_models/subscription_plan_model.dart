class SubscriptionDetailModel {
  bool? status;
  String? message;
  List<SubscriptionDetail>? subscriptionDetail;
  Pagination? pagination;

  SubscriptionDetailModel({
    this.status,
    this.message,
    this.subscriptionDetail,
    this.pagination,
  });

  SubscriptionDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['subscriptionDetail'] != null) {
      subscriptionDetail = <SubscriptionDetail>[];
      json['subscriptionDetail'].forEach((v) {
        subscriptionDetail!.add(SubscriptionDetail.fromJson(v));
      });
    }
    pagination =
        json['Pagination'] != null
            ? Pagination.fromJson(json['Pagination'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (subscriptionDetail != null) {
      data['subscriptionDetail'] =
          subscriptionDetail!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['Pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class SubscriptionDetail {
  int? id;
  String? planName;
  String? description;
  String? price;
  String? duration;
  String? currencyValue;
  String? subtext;
  String? createdAt;

  SubscriptionDetail({
    this.id,
    this.planName,
    this.description,
    this.price,
    this.duration,
    this.currencyValue,
    this.subtext,
    this.createdAt,
  });

  SubscriptionDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    planName = json['plan_name'];
    description = json['description'];
    price = json['price'];
    duration = json['duration'];
    currencyValue = json['currency_value'];
    subtext = json['subtext'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['plan_name'] = planName;
    data['description'] = description;
    data['price'] = price;
    data['duration'] = duration;
    data['currency_value'] = currencyValue;
    data['subtext'] = subtext;
    data['created_at'] = createdAt;
    return data;
  }
}

class Pagination {
  int? totalPages;
  int? totalRecords;
  int? currentPage;
  int? recordsPerPage;

  Pagination({
    this.totalPages,
    this.totalRecords,
    this.currentPage,
    this.recordsPerPage,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    totalPages = json['total_pages'];
    totalRecords = json['total_records'];
    currentPage = json['current_page'];
    recordsPerPage = json['records_per_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_pages'] = totalPages;
    data['total_records'] = totalRecords;
    data['current_page'] = currentPage;
    data['records_per_page'] = recordsPerPage;
    return data;
  }
}
